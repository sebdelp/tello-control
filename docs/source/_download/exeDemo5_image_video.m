clearvars
close all
clc

% Working with images & recording video
% with the Tello Drone
% Author : S. Delprat - INSA Hauts de France




% Prepare virtual environement
setupDroneEnv;

% Get a drone object
drone=getTelloDrone();

% Connect the drone object
drone.connect();

% Request video stream from the drone
drone.start_receiving_video()

% Récupère 2 images
img1=uint8(drone.get_frame());
pause(0.1);
img2=uint8(drone.get_frame());
pause(0.1);

% Display
figure;imshow(imtile({img1,img2}));

% Record a video file at 10 Hz (we record one frame, then skip 2 frames, from the 30Hz stream)
drone.start_recording_video_to_file('demoVideo.mkv',frame_skip=int8(2));

pause(1);

% Stop recording to file
drone.stop_recording_video_to_file();

% Stop decoding the video stream
drone.stop_receiving_video();
