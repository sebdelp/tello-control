
from tello_control import *
import time
import cv2

# create a tello_control object
drone = tello_control()
drone.add_file_logger('drone.log',mode='w',level='DEBUG')

# Connect to the drone (assuming the base station is connected to the drone's WIFI)
drone.connect()

# request the video stream
print('Starting video receiption')
drone.start_receiving_video(video_format='bgr24')

# start recording the video at 15fps (skip 1 frame on a 30fps stream)
print('Starting video recording')
drone.start_recording_video_to_file('demo.mkv',frame_skip=1)

# start data logging every half seconds
print('Starting data logging')
drone.start_data_logging('demo.csv',sampling_time=0.5)

# Perform takeoff and rotate clockwise
drone.takeoff()
drone.move_clockwise(20)

# Parameters
duration = 5              # duration of the video
Ts = 1/30                 # sampling period
i = 0                     # loop counter
tStart = time.time()      # current time

# main loop
while time.time()-tStart<duration:
    # Wait for next 1/30 of second
    while time.time()<tStart+i*Ts:
        time.sleep(0.001)
    
    # get a frame from the video
    img = drone.get_frame()
    
    # display the frame
    cv2.imshow('Tello drone',img)
    cv2.waitKey(1) # force cv2 to display the image now
    
    i=i+1

# Close windows
cv2.destroyAllWindows()


# Land the drone
drone.move_clockwise(0)
drone.land()

# stop recording video
drone.stop_recording_video_to_file()

# stop receiving video
drone.stop_receiving_video()

# stop data logging
drone.stop_data_logging()

# clean up
drone.quit()