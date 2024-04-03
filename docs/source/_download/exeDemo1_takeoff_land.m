clearvars
close all
clc


% Basic drone demo
% Autor : S. Delprat - INSA Hauts de France

% Prepare virtual environement
setupDroneEnv;

% Get a drone object
drone=getTelloDrone();

% Connect the drone object
drone.connect();

% Get the battery state as an uint8 variable
batt=uint8(drone.get_battery());
fprintf('Battery : %i\n',batt)

% Start the takeoff procedure
drone.takeoff();

% Bip when takeoff is done
bip;
pause(2);

% Land
drone.land();

% Bip when landing is over
bip;

% Clean up
drone.quit()




