% Parameterdefinition
c = 0.0035; % Korrektur-Koeffizient
k_r = 1.2; % Zusätzlicher Skalierungsfaktor für rechte Bildschirmhälfte
middle_width = 2222; % Mitte des Bildschirms in Pixel

% Wertebereich für die Tracking-Daten
x = linspace(0, 4444, 4444); % Gesamter Bildschirmbereich

% Korrekturwerte berechnen
correction_value = zeros(size(x));
% Linke Bildschirmhälfte
correction_value(x <= middle_width) = ...
    exp(c*(middle_width-x(x <= middle_width)));
% Rechte Bildschirmhälfte
x_right = x(x > middle_width);
x_spiegel_verschoben = 2 * middle_width - x_right;  % Spiegelung
correction_value(x > middle_width) = ...
    exp(c * (middle_width - x_spiegel_verschoben)) * k_r;

% Plot der gesamten Funktion mit Trennlinie in der Mitte
figure;
plot(x, correction_value, 'r-', 'LineWidth', 2);
hold on;
v_line = xline(middle_width, '--k', 'LineWidth', 1.5); % Vertikale Linie zur Markierung der Leinwandmitte
xlabel('Horizontale Pixel Leinwand');
ylabel('Korrekturwert');
title('Korrekturwertfunktion basierend auf e-Funktion');
grid on;
legend('Korrekturwert','Leinwandmmitte');




% Parameterdefinition
c = 0.012;              % Korrektur-Koeffizient
k_r = 1.2;              % Skalierungsfaktor für rechte Bildschirmhälfte
middle_width = 2222;    % Bildschirmmitte in Pixel
x = linspace(0, 4444, 4444);  % gesamter Bereich

% Initialisierung der Korrekturwerte
correction_value = zeros(size(x));

% Linke Bildschirmhälfte
x_links = x(x <= middle_width);
correction_value(x <= middle_width) = (c * (middle_width - x_links)).^2;

% Rechte Bildschirmhälfte (gespiegelt um Mitte)
x_rechts = x(x > middle_width);
x_spiegel_verschoben = 2 * middle_width - x_rechts;
correction_value(x > middle_width) = ...
    (c * (middle_width - x_spiegel_verschoben)).^2 * k_r;

% Plot der Funktion mit Trennlinie in der Mitte
figure;
plot(x, correction_value, 'r-', 'LineWidth', 2);
hold on;
v_line = xline(middle_width, '--k', 'LineWidth', 1.5); % Vertikale Linie zur Markierung der Leinwandmitte
xlabel('Horizontale Pixel Leinwand');
ylabel('Korrekturwert');
title('Korrekturwertfunktion basierend auf quadratischer Funktion');
grid on;
legend('Korrekturwert','Leinwandmmitte');




% Parameterdefinition
c = 0.03; % Korrektur-Koeffizient für linke Seite
middle_width = 2222; % Bildschirmmitte in Pixel
k_r = 1; % Verstärkungsfaktor links
gamma = 0.0005; % Dämpfung links
d = 100; % Offset links
p = 1.4; % Exponent links

% Parameter für rechte Bildschirmhälfte
k_r2 = 1;
c2 = 0.013;
d2 = 100;
p2 = 1.5;
gamma2 = 0.0012;

% Wertebereich für den gesamten Bildschirm
x = linspace(0, 4444, 4444);

% Initialisierung
correction_value = zeros(size(x));

% Linke Bildschirmhälfte
x_links = x(x <= middle_width);
correction_value(x <= middle_width) = ...
    k_r * (c * abs(middle_width - x_links) + d).^p .* ...
    (1 - exp(-gamma * abs(middle_width - x_links)));

% Rechte Bildschirmhälfte (gespiegelt)
x_rechts = x(x > middle_width);
x_spiegel = 2 * middle_width - x_rechts;
correction_value(x > middle_width) = ...
    k_r2 * (c2 * abs(middle_width - x_spiegel) + d2).^p2 .* ...
    (1 - exp(-gamma2 * abs(middle_width - x_spiegel)));

% Plot
figure;
plot(x, correction_value, 'r-', 'LineWidth', 2);
hold on;
v_line = xline(middle_width, '--k', 'LineWidth', 1.5); % Vertikale Linie zur Markierung der Leinwandmitte
xlabel('Horizontale Pixel Leinwand');
ylabel('Korrekturwert');
title('Korrekturwertfunktion basierend auf V-Funktion');
grid on;
legend('Korrekturwert','Leinwandmmitte');
