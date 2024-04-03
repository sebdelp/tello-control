clearvars
close all
clc

% A basic manual control loop
% Author : S. Delprat - INSA Hauts de France

% Setup the drone programming environement
setupDroneEnv;

% Get a drone object
drone=getTelloDrone();

% Connect the drone object to the physical drone via Wifi
drone.connect();

% Get battery state
batt=uint8(drone.get_battery());
fprintf('Battery : %i\n',batt)

% Try to take off
drone.takeoff();
% Bip when take off is done
bip;


% Create a figure to catch key pressed events
figure;
startManualControl; % Set the keypress callback

% Main control loop
tStartGlobal=tic; % Start time
Ts=0.1; % Sampling period (second)
ended=false;
while  ~ended
    % Synchronization of the control loop
    while toc(tStartGlobal)<Ts*i
       pause(0.001);
    end
    % Get user command
    keypressed=evalin('base','globalKeypressed');
    manu=evalin('base','manu');

    % Control the drone 
    drone.send_rc_control(0+manu.LR, 0+manu.FB, 0+manu.UD, 0+manu.Yaw);

    % Stop ?
    ended= keypressed=="q";
    drawnow;
    i=i+1;
end

% Stop receiving key press events
stopManualControl()

bip;

% Land the drone
drone.land();

% Clearn up
drone.quit();