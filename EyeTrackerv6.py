import tkinter as tk
from eyeware.client import TrackerClient, TrackingConfidence
import time
import numpy as np
import ctypes
import carla
import cv2
import math
import pyautogui
import csv

class EyeTracker:
    def __init__(self):
        self.tracker = TrackerClient()  # Import the API for the Beam Eye-Tracker
        
        # Define colors for the confidence output
        self.green = "#00FF00"
        self.yellow = "#FFFF00"
        self.orange = "#FF8000"
        self.red = "#FF0000"
        self.gray = "#D9D9D9"


    def get_trackingdata(self):
        if self.tracker.connected:  # Checks the connection to the Beam Eye-Tracker 
            screen_gaze = self.tracker.get_screen_gaze_info()   # Reads Screen-Gaze info given from Eye-Tracker

            # Determines the color based on the confidence value:
            confi_col = {
                    TrackingConfidence.HIGH: self.green,
                    TrackingConfidence.MEDIUM: self.yellow,
                    TrackingConfidence.LOW: self.orange,
                    TrackingConfidence.UNRELIABLE: self.red
            }.get(screen_gaze.confidence, self.gray)

            return ["Tracker connected", screen_gaze.is_lost, screen_gaze.confidence, confi_col, screen_gaze.x, screen_gaze.y]
        else:
            return ["Tracker not connected", "Null", "Null", "Null", "Null", "Null"]
        
class Calibration:
    def __init__(self):
        pass

    def calibration(self):
        tracker = TrackerClient() # Import the API for the Beam Eye-Tracker
        
        user32 = ctypes.windll.user32   # Reads out current resolution
        screen_width = user32.GetSystemMetrics(0)
        screen_height = user32.GetSystemMetrics(1)
        middle_width = screen_width/2
        middle_height = screen_height/2

        calibration = tk.Tk() # Creates window for calibration
        calibration.title("Calibration")
        calibration.configure(bg="white")

        # Calibration Window Size
        calibration_window_x = 3000
        calibration_window_y = 700
        calibration_window_x_position = int(middle_width) - int(calibration_window_x/2)
        calibration_window_y_position = int(middle_height) - int(calibration_window_y/2)
        calibration_window_geometry_string = str(calibration_window_x)+"x"+str(calibration_window_y)+"+"+str(calibration_window_x_position)+"+"+str(calibration_window_y_position)
        
        calibration.geometry(calibration_window_geometry_string)
        calibration.overrideredirect(True)
        
        # The offset of the buttons relative the calibration screen borders
        offset_x = round(calibration_window_x*0.1)
        offset_y = round(calibration_window_y*0.1)

        # Creates button positions
        button_positions = [(offset_x, offset_y), (calibration_window_x - offset_x - 80, offset_y), (calibration_window_x - offset_x - 80, calibration_window_y - offset_y - 30), (offset_x, calibration_window_y - offset_y - 30), (round(calibration_window_x/2)-80/2, round(calibration_window_y/2)-30/2)]
        self.positions = [
            (offset_x+80/2, offset_y+30/2),
            (calibration_window_x-offset_x-80+80/2, offset_y + 30/2),
            (calibration_window_x - offset_x -80 + 80/2, calibration_window_y-offset_y-30+30/2),
            (offset_x+80/2, calibration_window_y-offset_y-30+30/2),
            (middle_width, middle_height)
        ]

        self.x = [0] * 5
        self.y = [0] * 5

        # Creates button to save screen gaze data from Eye Tracker
        self.button = tk.Button(None, 
            text="Look Here", 
            font=("Helvetica", 11, "bold"), 
            bg="red", 
            fg="white", 
            activebackground="green", 
            activeforeground="white", 
            command=lambda: set_xy(0)
        )
        self.button.place(x=button_positions[0][0], y=button_positions[0][1], width=80, height=30)
        
        # Saves screen gaze data until all buttons have been pushed and terminates the calibration window
        def set_xy(i):
            screen_gaze = tracker.get_screen_gaze_info()
            self.x[i], self.y[i] = screen_gaze.x, screen_gaze.y
            if i < 4:
                self.button.place(x=button_positions[i+1][0], y=button_positions[i+1][1])
                self.button.config(command=lambda: set_xy(i+1))
            else:
                calibration.destroy()

        if tracker.connected:
            calibration.mainloop()
            self.calculate_offset()
            return self.positions, self.x, self.y
        else:
            return "Tracker not connected"
        
    # Calculates hard offset of Eye Tracker data and button position
    def calculate_offset(self):
        
        difference_x_1 = self.x[0] - self.positions[0][0]
        difference_x_2 = self.x[1] - self.positions[1][0]
        difference_x_3 = self.x[2] - self.positions[2][0]
        difference_x_4 = self.x[3] - self.positions[3][0]
        difference_x_5 = self.x[4] - self.positions[4][0]

        difference_y_1 = self.y[0] - self.positions[0][1]
        difference_y_2 = self.y[1] - self.positions[1][1]
        difference_y_3 = self.y[2] - self.positions[2][1]
        difference_y_4 = self.y[3] - self.positions[3][1]
        difference_y_5 = self.y[4] - self.positions[4][1]

        #print(difference_x_1, difference_x_2, difference_x_3, difference_x_4, difference_x_5)

        self.average_difference_x = (difference_x_1 + difference_x_2 + difference_x_3 + difference_x_4 + difference_x_5) / 5
        self.average_difference_y = (difference_y_1 + difference_y_2 + difference_y_3 + difference_y_4 + difference_y_5) / 5
    
    # Applies offset to Eye Tracker data
    def add_offset(self,tracking_data):
        
        if(tracking_data[4]!="Null"):
            tracking_data[4] = tracking_data[4] - round(self.average_difference_x)
        
        if(tracking_data[5]!="Null"):
            tracking_data[5] = tracking_data[5] - round(self.average_difference_y)
        
        return tracking_data
    

class CorrectCurvature:
    def __init__(self):

        #self.k_r=1 # additional correction coefficient for right screen half for quadratic function (not used in V-function)

        self.c=0.03
        self.d=100
        self.p=1.4
        self.gamma=0.0005

        self.c2=0.013
        self.d2=100
        self.p2=1.5
        self.gamma2=0.0012

        user32 = ctypes.windll.user32   # Reads out current resolution
        self.screen_width = user32.GetSystemMetrics(0)
        self.middle_width = self.screen_width/2

    def correct(self, tracking_data):
        if(tracking_data[4]!="Null"):
            # Checks if left or right correction is used 
            # Left side
            if tracking_data[4]<=self.middle_width:
                #correction_value = pow((self.c*(self.middle_width-tracking_data[4])),2) # quadratic function with power 2
                #correction_value = pow((self.c*(self.middle_width-tracking_data[4])),4) # quadratic function with power 4
                correction_value = (pow((self.c*abs(self.middle_width-tracking_data[4])+self.d),self.p))*(1-math.exp(-self.gamma*abs(self.middle_width-tracking_data[4]))) # V-function
                tracking_data[4]=round(tracking_data[4]+correction_value)

            # Right side
            else:
                #correction_value = pow((self.c*(self.middle_width-tracking_data[4])),2)*self.k_r # quadratic function with power 2
                #correction_value = pow((self.c*(self.middle_width-tracking_data[4])),4)*self.k_r # quadratic function with power 4
                correction_value = (pow((self.c2*abs(self.middle_width-tracking_data[4])+self.d2),self.p2))*(1-math.exp(-self.gamma2*abs(self.middle_width-tracking_data[4]))) # V-function
                tracking_data[4]=round(tracking_data[4]-correction_value)
                
        return tracking_data

class LookDirection:
    def __init__(self):
        user32 = ctypes.windll.user32   # Reads out current resolution
        self.screen_width = user32.GetSystemMetrics(0)
        self.screen_height = user32.GetSystemMetrics(1)

        # Defines roughly the looking direction:
        self.lookdir = {
            0: "Looks Left & Looks Up",
            1: "Looks Right & Looks Up",
            2: "Looks Left & Looks Down",
            3: "Looks Right & Looks Down"
        }

    # Selects based on Eye-Tracker data, where one is looking
    def look_direction_rough(self, tracking_data):
        if tracking_data[0] == "Tracker connected":
            if tracking_data[4] < self.screen_width/2 and tracking_data[5] < self.screen_height/2:
                lookdir = self.lookdir.get(0, "Unknown")
            elif tracking_data[4] > self.screen_width/2 and tracking_data[5] < self.screen_height/2:
                lookdir = self.lookdir.get(1, "Unknown")
            elif tracking_data[4] < self.screen_width/2 and tracking_data[5] > self.screen_height/2:
                lookdir = self.lookdir.get(2, "Unknown")
            else:
                lookdir = self.lookdir.get(3, "Unknown")
            return lookdir

    # Further specifies, where one is looking
    def look_direction_coordinates(self, tracking_data, section_amount):
        if tracking_data[0] == "Tracker connected":
            section_amount_x = int(section_amount ** 0.5)
            section_amount_y = int(section_amount ** 0.5)
            section_width = self.screen_width / section_amount_x
            section_height = self.screen_height / section_amount_y
            coordinate_x = int(tracking_data[4] // section_width)
            coordinate_y = int(tracking_data[5] // section_height)
            coordinate_x = min(coordinate_x, section_amount_x-1)
            coordinate_y = min(coordinate_y, section_amount_y-1)
            
            return coordinate_x, coordinate_y

class TextManager:
    def __init__(self):
        self.canvas = tk.Canvas(root, width=700, height=400) # Creates a canvas inside the window
        self.canvas.pack()

    # Creates text output to be displayed on the canvas inside the window
    def update_text(self, tracking_data, look_direction_rough, coordinates):
        if tracking_data[0] == "Tracker connected":
            self.text_content = [
                "Beam Eye-Tracker connection state: " + tracking_data[0],
                "Screen Gaze lost state: " + str(tracking_data[1]),
                "Confidence: " + str(tracking_data[2]),
                "Coordinates: x = " + str(tracking_data[4]) + " px & y = " + str(tracking_data[5]) + " px",
                "Confidence color: " + tracking_data[3],
                "Looking direction: " + look_direction_rough,
                "Screen quadrant: " + str(coordinates),
                "Tag: " + tag,
                "Instance ID: " + instance_id
            ]
        else:
            self.text_content = ["Tracker not connected"]
            
        self.canvas.delete("all")

        # Adds a text line based on self.text_content
        y_position = 20  # Text starting location inside canvas
        for line in self.text_content:
            self.canvas.create_text(350, y_position, text=line, font=("Helvetica", 16), fill="black")
            y_position += 30  # Line spacing
        
        self.canvas.create_text(350, y_position+30, text="Confidence:", font=("Helvetica", 16), fill="black")
        self.canvas.create_oval(325, y_position+40, 375, y_position+90, fill=tracking_data[3])

class CarlaClient:
    def __init__(self):
        pass

    def connect_to_server(self,server_address):
        # Connect to server
        client = carla.Client(server_address, 2000)
        self.world = client.get_world()
        self.spawn_points = self.world.get_map().get_spawn_points()

    def example_situation(self):
        # Delete all sensors
        all_sensor_actors = self.world.get_actors().filter('sensor.*')

        for sensor in all_sensor_actors:
            sensor.destroy()
        
        # Delete all vehicles
        all_vehicle_actors = self.world.get_actors().filter('vehicle.*')

        for vehicle in all_vehicle_actors:
            vehicle.destroy()

        # Spawn vehicles
        vehicle_bp = self.world.get_blueprint_library().filter("vehicle.mercedes.sprinter")
        start_point = self.spawn_points[0]
        vehicle = self.world.try_spawn_actor(vehicle_bp[0], start_point)

        # Add camera sensor instace segmentation
        CAMERA_POS_Z=3.5
        CAMERA_POS_X=2.5

        user32 = ctypes.windll.user32
        # Resolution of Instance Segmentation Sensor Image Output is reduced by factor 10 to save performance
        screen_size_x_scaled = user32.GetSystemMetrics(0)/10
        screen_size_y_scaled = user32.GetSystemMetrics(1)/10

        camera_bp = self.world.get_blueprint_library().find('sensor.camera.instance_segmentation')
        camera_bp.set_attribute('image_size_x', str(screen_size_x_scaled))
        camera_bp.set_attribute('image_size_y', str(screen_size_y_scaled))
        camera_bp.set_attribute('sensor_tick', '0.02')
        camera_bp.set_attribute('fov', '80')

        transform = carla.Transform(carla.Location(x=1.1, y=-0.5, z=5.8))
        sensor = self.world.try_spawn_actor(camera_bp, transform, attach_to = vehicle)


        camera_rgb = self.world.get_blueprint_library().find('sensor.camera.rgb')
        camera_rgb.set_attribute('image_size_x', str(user32.GetSystemMetrics(0)))
        camera_rgb.set_attribute('image_size_y', str(user32.GetSystemMetrics(1)))
        camera_rgb.set_attribute('sensor_tick', '0.02')
        camera_rgb.set_attribute('fov', '80')

        transform_rgb = carla.Transform(carla.Location(x=1.1, y=-0.5, z=2.8))
        sensor_rgb = self.world.try_spawn_actor(camera_rgb, transform_rgb, attach_to = vehicle)  

        vehicle.set_autopilot(True)

        return sensor, sensor_rgb
        
    def process_segmentation_image(self, image, tracking_data): # Read out the instance based on looking coordinate
         if tracking_data[0] == "Tracker connected":

            global tag
            global instance_id

            x = tracking_data[4]
            y = tracking_data[5]

            x_scaled = x/10
            x_scaled = math.ceil(x_scaled)
            y_scaled = y/10
            y_scaled = math.ceil(y_scaled)

            
            array = np.frombuffer(image.raw_data, dtype=np.uint8)
            array = np.reshape(array, (image.height, image.width, 4)) 
            

            cv2.imshow("Kameraausgabe", array)
            cv2.waitKey(1)  

            b, g, r, a = array[y_scaled-1, x_scaled-1, 0], array[y_scaled-1, x_scaled-1, 1], array[y_scaled-1, x_scaled-1, 2], array[y_scaled-1, x_scaled-1, 3] # for BGRA image 

            red_to_tag_mapping = {
                0: "Unlabeled",
                1: "Roads",
                2: "SideWalks",
                3: "Building",
                4: "Wall",
                5: "Fence",
                6: "Pole",
                7: "TrafficLight",
                8: "TrafficSign",
                9: "Vegetation",
                10: "Terrain",
                11: "Sky",
                12: "Pedestrian",
                13: "Rider",
                14: "Car",
                15: "Truck",
                16: "Bus",
                17: "Train",
                18: "Motorcycle",
                19: "Bicycle",
                20: "Static",
                21: "Dynamic",
                22: "Other", 
                23: "Water",
                24: "RoadLine",
                25: "Ground",
                26: "Bridge",
                27: "RailTrack",
                28: "GuardRail"
            }

            tag = red_to_tag_mapping.get(r, "Unknown")  
            instance_id = str(g) + "-" + str(b)

    # This Method is for showing the rgb image
    def process_rgb_image(self, image):
        array = np.frombuffer(image.raw_data, dtype=np.uint8)
        array = np.reshape(array, (image.height, image.width, 4)) 
 
        cv2.imshow("Kameraausgabe_rgb", array)
        cv2.waitKey(1)  

class csv_Logger:
    def __init__(self):
        timestamp = time.strftime("%Y%m%d_%H%M%S")
        self.filename = f"Eye_Track_Log_{timestamp}.csv"

        with open(self.filename, mode="w", newline="") as file:
            writer = csv.writer(file)
            writer.writerow(["Cursor x", "Cursor y", "Beam Eye Pos. x", "Beam Eye Pos. y", "Adjusted x", "Adjusted y"])

    def log_data(self, data):
        with open(self.filename, mode="a", newline="") as file:
            writer = csv.writer(file)
            writer.writerow(data)

# Define inital value basic variables
tag = "Null"
instance_id = "Null"
tracking_data = "Null", "Null", "Null", "Null", "Null", "Null"
section_amount = 16

# Runs calibration and returns pixel of the buttons and the tracker values
#calibration = Calibration()
#calibration_txt = calibration.calibration()

# Logging
logger = csv_Logger()

# Window to show canvas and black marker for eye position
user32 = ctypes.windll.user32
screen_width = user32.GetSystemMetrics(0)
screen_height = user32.GetSystemMetrics(1)
root = tk.Tk()
root.title("Eye Tracker")
root.geometry(f"{screen_width}x{screen_height}+0+0")
root.attributes('-alpha', 0.3)
marker = tk.Button(None, 
    text="", 
    font=("Helvetica", 11, "bold"), 
    bg="black", 
    fg="white", 
    activebackground="green", 
    activeforeground="white", 
    )

# Determine refresh rate of Eye Tracker readout
start_time = time.time()
frame_interval = 1/30 # 30 Hz refresh rate

# Start required classes
eye_tracker = EyeTracker()
look_direction = LookDirection()
text_manager = TextManager()
carla_client = CarlaClient()
correct_curvature = CorrectCurvature()

# Start CARLA simulation as client
carla_client.connect_to_server("localhost")
sensor = carla_client.example_situation()
# Callback function to acquire instances of the segmentation
sensor[0].listen(lambda image: carla_client.process_segmentation_image(image, tracking_data))

# Callback function to acquire instances of the segmentation
sensor[1].listen(lambda image: carla_client.process_rgb_image(image))

while True:
    current_time = time.time()
    if current_time - start_time >= frame_interval:
        start_time = current_time

        x_cur, y_cur = pyautogui.position() # Reads out cursor position -> Use it to know where you looked

        tracking_data_unadjusted = eye_tracker.get_trackingdata()
        x_1 = tracking_data_unadjusted[4]
        y_1 = tracking_data_unadjusted[5]

        # Calibration & Curvature Correction
        tracking_data_adjusted = correct_curvature.correct(tracking_data_unadjusted)
        #tracking_data_cal_adjusted = calibration.add_offset(tracking_data_adjusted) # Calibration is deactivated since curvature correction works better

        # For testing the original calibration is not done anymore. Only curvature calibration is done.
        # If calibration needs to be implemented again the curvature correction also needs to applied in line 96 where the calibration takes place.
        # Curvature Correciton must be done before screen calibration!!
        
        tracking_data = tracking_data_adjusted
        x_2 = tracking_data[4]
        y_2 = tracking_data[5]

        look_dir= look_direction.look_direction_rough(tracking_data)
        look_coord = look_direction.look_direction_coordinates(tracking_data, section_amount)
        text_manager.update_text(tracking_data, look_dir, look_coord)

        marker.place(x=tracking_data[4]-50/2, y=tracking_data[5]-50/2, width=50, height=50)
        tk.Misc.lift(marker)

        data = [x_cur, y_cur, x_1, y_1, x_2, y_2]
        logger.log_data(data)

        root.update()
        time.sleep(0.1)