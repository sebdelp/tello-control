from tello_control import *
import time
import cv2

# create a tello_control object
drone = tello_control()

# Connect to the drone (assuming the base station is connected to the drone's WIFI)
drone.connect()

# request the video stream
print('Starting video receiption')
drone.start_receiving_video(video_format='bgr24')

# Perform takeoff and rotate clockwise
drone.takeoff()
drone.move_clockwise(20)

# Parameters
duration = 2              # duration of the video
Ts = 1/30                 # sampling period
i = 0                     # loop counter
tStart = time.time()      # current time

# main loop
while time.time()-tStart<duration:
	# Wait for next 1/30 of second
	while time.time()<tStart+i*Ts:
		time.sleep(0.001)
        
    # get a frame from the video
	img=drone.get_frame()
    
    # display the frame
	cv2.imshow('Tello drone',img)
	cv2.waitKey(1) # force cv2 to display the image now

    # Next iteration
	i=i+1 
    
# Close windows
cv2.destroyAllWindows()


# Land the drone
drone.move_clockwise(0)
drone.land()

# stop receiving video
drone.stop_receiving_video()

# clean up
drone.quit()