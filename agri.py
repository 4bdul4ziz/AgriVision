import cv2
import numpy as np 
import os

# Define the path to the folder where the screenshots are moved
folder_path = os.path.expanduser("images")

# Loop through all files in the folder
for filename in os.listdir(folder_path):
    # Check if the file is a PNG image
    if filename.endswith(".png"):
        # Read the image
        img = cv2.imread(os.path.join(folder_path, filename))

        # Convert to HSV color space
        hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)

        # Define the lower and upper bounds of the green color
        lower_green = np.array([40,50,50])
        upper_green = np.array([80,255,255])

        # Create a mask to select only the green areas
        mask = cv2.inRange(hsv, lower_green, upper_green)

        # Apply the mask to the original image
        res = cv2.bitwise_and(img, img, mask=mask)

        # Calculate the green area in acres
        area = 130 * 130 * 0.000247105 * np.sum(mask == 255) / 10000

        # save the three images
        cv2.imwrite("original.png", img)
        cv2.imwrite("mask.png", mask)
        cv2.imwrite("result.png", res)

        # Display the calculated green area
        print(f"The green area in {filename} is {area} acres.")



