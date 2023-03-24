#use open cv to extract green areas on a satellite image

import cv2
import numpy as np 
import matplotlib.pyplot as plt

img = cv2.imread('st.png')

hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)

lower_green = np.array([40,50,50])
upper_green = np.array([80,255,255])

mask = cv2.inRange(hsv, lower_green, upper_green)

res = cv2.bitwise_and(img,img, mask= mask)

cv2.imshow('image',img)
cv2.imshow('mask',mask)
cv2.imshow('res',res)
cv2.waitKey(0)
cv2.destroyAllWindows()


area = 130 * 130 * 0.000247105 * np.sum(mask == 255) / 10000 #in acres
print(area)






