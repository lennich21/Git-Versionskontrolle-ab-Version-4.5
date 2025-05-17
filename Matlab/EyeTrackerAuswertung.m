% Parameterdefinition
c = 0.012; % Korrektur-Koeffizient
k_r = 1; % Zusätzlicher Skalierungsfaktor für rechte Bildschirmhälfte
middle_width = 2222; % Mitte des Bildschrims in Pixel


% Wertebereich für Tracking_Data_list[4]
x1 = linspace(0, 4444, 4444); % Beispielbereich
x2 = linspace(0, 4444, 4444); % Beispielbereich

% Berechnung der Korrekturwerte für linke Bildschirmhälfte
correction_value_1 = (c * (middle_width - x1)).^2;

% Berechnung der Korrekturwerte für rechte Bildschirmhälfte
correction_value_2 = (c * (middle_width - x2)).^2 * k_r;

% Plot für die erste Funktion
figure;
plot(x1, correction_value_1, 'b-', 'LineWidth', 2);
xlabel('Rohdaten EyeTracker');
ylabel('Korrekturwert');
title('Visualisierung der quadratischen Korrekturfunktion');
grid on;

% Plot für die zweite Funktion
%figure;
%plot(x2, correction_value_2, 'r-', 'LineWidth', 2);
%xlabel('Tracking Data (Tracking\_Data\_list[4])');
%ylabel('Correction Value');
%title('Visualisierung der zweiten Korrekturfunktion');
%grid on;



% Parameterdefinition
c = 0.03; % Korrektur-Koeffizient
middle_width = 2222; % Mitte des Bildschirms in Pixel
k_r = 1; % Verstärkungsfaktor für die Korrektur
gamma = 0.0005; % Kontrolliert die Begrenzung der Exponentialverstärkung
d = 100; % Basis-Offset für stärkeren Startanstieg
p = 1.4; % Verstärkt den Anstieg der Kurve

% Wertebereich für Tracking_Data_list[4]
x = linspace(0, 4444, 4444); % Beispielbereich

% Modifizierte Korrekturfunktion mit stärkerem Anstieg in der Mitte
correction_value = k_r * (c * abs(middle_width - x) + d).^p .* (1 - exp(-gamma * abs(middle_width - x)));
k_r2=1
c2=0.013
d2=100
p2=1.5
gamma2=0.0012
correction_value2 = k_r2 * (c2 * abs(middle_width - x) + d2).^p2 .* (1 - exp(-gamma2 * abs(middle_width - x)));

% Plot der Funktion
figure;
subplot(1,2,1)
plot(x, correction_value, 'r-', 'LineWidth', 2);
xlabel('Rohdaten EyeTracker');
ylabel('Korrekturwert');
title('Korrekturfunktion linke Bildschirmhälfte');
grid on;


subplot(1,2,2)
plot(x, correction_value2, 'r-', 'LineWidth', 2);
xlabel('Rohdaten EyeTracker');
ylabel('Korrekturwert');
title('Korrekturfunktion rechte Bildschirmhälfte');
grid on;

maus_x= [];
maus_y= [];

unkalibriert_x= [];
unkalibriert_y= [];

kalibriert_x= [];
kalibriert_y= [];

filename = "x_y_Track_old_clean.txt";
str = readlines(filename);
start="(";
fin=")";
for i=1:length(str)
    str_current = str(i);
    start="(";
    fin=")";
    values = extractBetween(str_current,start,fin);
    % Matlab beginnt bei 1 und nicht bei 0
    values_maus = values(1);
    values_unkalibriert = values(2);
    values_kalibriert = values(3);
    start="";
    fin=",";
    value_maus_x = extractBetween(values_maus,start,fin);
    value_maus_y = extractAfter(values_maus, ", ");
    value_unkalibriert_x = extractBetween(values_unkalibriert,start,fin);
    value_unkalibriert_y = extractAfter(values_unkalibriert, ", ");
    value_kalibriert_x = extractBetween(values_kalibriert,start,fin);
    value_kalibriert_y = extractAfter(values_kalibriert, ", ");
    maus_x(i)=str2double(value_maus_x);
    maus_y(i)=str2double(value_maus_y);

    unkalibriert_x(i)=str2double(value_unkalibriert_x);
    unkalibriert_y(i)=str2double(value_unkalibriert_y);

    kalibriert_x(i)=str2double(value_kalibriert_x);
    kalibriert_y(i)=str2double(value_kalibriert_y);
    i=i+1;
end

maus_x
maus_y

unkalibriert_x
unkalibriert_y

kalibriert_x
kalibriert_y

% Plot für x-Achse Maus & unkalibriert (alte Funktion) 
figure; 
subplot(1,2,1)
x_ideal = linspace(0,4444);
y_ideal = x_ideal; 
plot(x_ideal, y_ideal);
hold on
scatter(maus_x, unkalibriert_x, 'b' ,"filled");
xlabel('Reale Blickposition');
ylabel('Unkalibrierte EyeTracker-Werte');
title('Gegenüberstellung reale Blickposition und unkalibrierte EyeTracker-Werte');
grid on;


% Plot für x-Achse Maus & kalibriert (alte Funktion) 

subplot(1,2,2)
x_ideal = linspace(0,4444);
y_ideal = x_ideal; 
plot(x_ideal, y_ideal);
hold on
scatter(maus_x, kalibriert_x, 'b' ,"filled");
xlabel('Reale Blickposition');
ylabel('Kalibrierte EyeTracker-Werte');
title('Gegenüberstellung reale Blickposition und kalibrierte EyeTracker-Werte');
grid on;


% Plot für y-Achse Maus & kalibriert 

figure;
x_ideal = linspace(0,1080);
y_ideal = x_ideal; 
plot(x_ideal, y_ideal);
hold on
scatter(maus_y, unkalibriert_y, "b", "filled");
xlabel('Reale Blickposition');
ylabel('Kalibrierte, geschätzte Blickposition Eye-Tracker');
title('Reale Blickposition vs. kalibrierte geschätzte Blickposition y-Achse (alte Funktion)');
grid on;



% Für die erhobenen Daten mit der neuen Funktion vom 03.03

maus_x= [];
maus_y= [];

unkalibriert_x= [];
unkalibriert_y= [];

kalibriert_x= [];
kalibriert_y= [];

filename = "x_y_Track_new_clean.csv";
str = readlines(filename);
start="(";
fin=")";
for i=1:length(str)
    str_current = str(i);
    start="";
    fin=",";
    values = extractBetween(str_current,start,fin)
    % Matlab beginnt bei 1 und nicht bei 0
    value_maus_x = values(1);
    value_maus_y = values(2);
    value_unkalibriert_x = values(3);
    value_unkalibriert_y = values(4);
    value_kalibriert_x = values(5);
    value_kalibriert_y = values(6);
    maus_x(i)=str2double(value_maus_x);
    maus_y(i)=str2double(value_maus_y);

    unkalibriert_x(i)=str2double(value_unkalibriert_x);
    unkalibriert_y(i)=str2double(value_unkalibriert_y);

    kalibriert_x(i)=str2double(value_kalibriert_x);
    kalibriert_y(i)=str2double(value_kalibriert_y);
    i=i+1;
end


% Plot für x-Achse Maus & unkalibriert (neue Funktion) 
figure;
subplot(1,2,1)
x_ideal = linspace(0,4444);
y_ideal = x_ideal; 
plot(x_ideal, y_ideal);
hold on
scatter(maus_x, unkalibriert_x, 'r', 'filled');
xlabel('Reale Blickposition');
ylabel('Unkalibrierte EyeTracker-Werte');
title('Reale Blickposition vs. unkalibrierte geschätzte Blickposition x-Achse(neue Funktion)');
grid on;


% Plot für x-Achse Maus & kalibriert (neue Funktion) 

subplot(1,2,2)
x_ideal = linspace(0,4444);
y_ideal = x_ideal; 
plot(x_ideal, y_ideal);
hold on
scatter(maus_x, kalibriert_x, 'r','filled');
xlabel('Reale Blickposition');
ylabel('Kalibrierte EyeTracker-Werte');
title('Reale Blickposition vs. kalibrierte geschätzte Blickposition x-Achse (neue Funktion)');
grid on;




% Plot für y-Achse Maus & kalibriert 

figure;
x_ideal = linspace(0,1080);
y_ideal = x_ideal; 
plot(x_ideal, y_ideal);
hold on
scatter(maus_y, unkalibriert_y, "r", "filled");
xlabel('Reale Blickposition');
ylabel('Kalibrierte, geschätzte Blickposition Eye-Tracker');
title('Reale Blickposition vs. kalibrierte geschätzte Blickposition y-Achse (neue Funktion)');
grid on;










