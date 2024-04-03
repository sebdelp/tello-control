clearvars
close all
clc


% Basic program to demonstrate how to access drone data
% Author: S. Delprat - INSA Hauts de France

% Setup the drone programming environement
setupDroneEnv;

% Get a drone object
drone=getTelloDrone();

% Connect to the drone through WIFI
drone.connect();

% Try to takeoff
drone.takeoff()

% Get one sample of data
data1=double(drone.get_position());
data2=double(drone.get_gyros());
data3=double(drone.get_accelerometer());
data4=double(drone.get_drone_velocity());
data5=double(drone.get_battery);
data6=double(drone.get_euler_angle());

% Get the list of all available data
list=string(drone.get_sensor_list());

% Get all the values, in the order indicated by get_sensor_list
data7 = double(drone.get_sensor_values_by_name());

% Get a specified list of sensor values
data8 = double(drone.get_sensor_values_by_name({'posX','velY','fly_mode'}));

% atterissage
drone.land()


% Clean up
drone.quit()