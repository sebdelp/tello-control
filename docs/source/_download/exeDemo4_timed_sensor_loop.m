clearvars
close all
clc


% Sample program to record data with a fixed sampling time
% Auteur : S. Delprat - INSA Hauts de France


% Setup the drone programming environement
setupDroneEnv;

% Get a drone object
drone=getTelloDrone();

% Connect to the drone through WIFI
drone.connect();

% Try to takeoff
drone.takeoff()

% Get the number of available sensors
List=string(drone.get_sensor_list());
nSensor=length(List);


% Number of samples
duration=5;Ts=0.1;
n=ceil(duration/Ts);


% Préallocation
data=NaN(nSensor,n);

t=NaN(1,60);
i=1;tStart=tic;
while i<n 
    % Attend fin de la période d'éch
    while toc(tStart)<i*Ts
	pause(0.001);
    end
    t(i)=toc(tStart);
    data(:,i)=double(drone.get_sensor_values_by_name());
    i=i+1;
end
drone.land()

% Retrieve some signal index
iPosX=double(drone.get_sensors_idx('posX'));
iPosY=double(drone.get_sensors_idx('posY'));
iPosZ=double(drone.get_sensors_idx('posZ'));

% Display curves
figure;
plot3(data(iPosX,:),data(iPosY,:),data(iPosZ,:));
grid on
xlabel('X');ylabel('Y');zlabel('Z')
axis equal



