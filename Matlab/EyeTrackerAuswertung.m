% Dieses Skript zeigt die Auswertung der Tracking Daten um den Vergleich
% mit keiner, schlechter und guter Korrekturfunktion darzustellen 
maus_x_alt= [];
maus_y_alt= [];

unkalibriert_x_alt= [];
unkalibriert_y_alt= [];

kalibriert_x_alt= [];
kalibriert_y_alt= [];

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
    maus_x_alt(i)=str2double(value_maus_x);
    maus_y_alt(i)=str2double(value_maus_y);

    unkalibriert_x_alt(i)=str2double(value_unkalibriert_x);
    unkalibriert_y_alt(i)=str2double(value_unkalibriert_y);

    kalibriert_x_alt(i)=str2double(value_kalibriert_x);
    kalibriert_y_alt(i)=str2double(value_kalibriert_y);
    i=i+1;
end

maus_x = [];
maus_y = [];

unkalibriert_x = [];
unkalibriert_y = [];

kalibriert_x = [];
kalibriert_y = [];

% Plot für x-Achse Maus & unkalibriert (alte Funktion) 
figure; 
subplot(1,2,1)
x_ideal = linspace(0,4444);
y_ideal = x_ideal; 
plot(x_ideal, y_ideal);
hold on
scatter(maus_x_alt, unkalibriert_x_alt, 'b' ,"filled");
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
scatter(maus_x_alt, kalibriert_x_alt, 'b' ,"filled");
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
scatter(maus_y_alt, unkalibriert_y_alt, "b", "filled");
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
subplot(1,3,1)
x_ideal = linspace(0,4444);
y_ideal = x_ideal; 
plot(x_ideal, y_ideal);
hold on
scatter(maus_x, unkalibriert_x, 'r', 'filled');
xlabel('Reale Blickposition');
ylabel('Unkalibrierte EyeTracker-Werte');
title('Unkalibriert');
grid on;

summe_dif = 0;
for i=1:numel(maus_x)
    dif=abs(maus_x(i)-unkalibriert_x(i));
    summe_dif = summe_dif + dif; 
end

dif_mean_unkalibriert = summe_dif/numel(maus_x);

% Standardabweichung x & y
standardabweichung_x = std(maus_x);
standardabweichung_y = std(unkalibriert_x);
% Kovarianz x & y
kovarianz_xy = cov(maus_x,unkalibriert_x);
% Korrelationskoeffizient 
r_unkalibriert = kovarianz_xy(1,2)/(standardabweichung_x*standardabweichung_y)

% Plot für x-Achse Maus & kalibriert (alte Funktion) 
subplot(1,3,2)
x_ideal = linspace(0,4444);
y_ideal = x_ideal; 
plot(x_ideal, y_ideal);
hold on
scatter(maus_x_alt, kalibriert_x_alt, 'b', 'filled');
xlabel('Reale Blickposition');
ylabel('Kalibrierte EyeTracker-Werte');
title('Kalibriert mit quadratischer Funktion');
grid on;



summe_dif = 0;
for i=1:numel(maus_x_alt)
    dif=abs(maus_x_alt(i)-kalibriert_x_alt(i));
    summe_dif = summe_dif + dif; 
end

dif_mean_alt = summe_dif/numel(maus_x_alt);



% Berechnung des Korrelationskoeffizienten 

% Standardabweichung x & y
standardabweichung_x = std(maus_x_alt);
standardabweichung_y = std(kalibriert_x_alt);
% Kovarianz x & y
kovarianz_xy = cov(maus_x_alt,kalibriert_x_alt);
% Korrelationskoeffizient 
r_alt = kovarianz_xy(1,2)/(standardabweichung_x*standardabweichung_y)





% Plot für x-Achse Maus & kalibriert (neue Funktion) 
subplot(1,3,3)
x_ideal = linspace(0,4444);
y_ideal = x_ideal; 
plot(x_ideal, y_ideal);
hold on
scatter(maus_x, kalibriert_x, 'r','filled');
xlabel('Reale Blickposition');
ylabel('Kalibrierte EyeTracker-Werte');
title('Kalibriert mit V-Funktion');
grid on;


summe_dif = 0;
for i=1:numel(maus_x)
    dif=abs(maus_x(i)-kalibriert_x(i));
    summe_dif = summe_dif + dif; 
end

dif_mean_neu = summe_dif/numel(maus_x);


% Berechnung des Korrelationskoeffizienten 

% Standardabweichung x & y
standardabweichung_x = std(maus_x);
standardabweichung_y = std(kalibriert_x);
% Kovarianz x & y
kovarianz_xy = cov(maus_x,kalibriert_x);
% Korrelationskoeffizient 
r = kovarianz_xy(1,2)/(standardabweichung_x*standardabweichung_y)





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










