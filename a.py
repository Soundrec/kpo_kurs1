import numpy as np
import cv2

video = cv2.VideoCapture("http://91.233.230.14/axis-cgi/jpg/image.cgi?resolution=640x480")

ret, frame1 = video.read()
ret, frame2 = video.read()

while video.isOpened():

    difference = cv2.absdiff(frame1, frame2)
    gray = cv2.cvtColor(difference, cv2.COLOR_BGR2GRAY)
    blur = cv2.GaussianBlur(gray, (5,5), 0)
    _, threshold = cv2.threshold(blur, 20, 255, 
cv2.THRESH_BINARY)
    dilate = cv2.dilate(threshold, None, iterations=3)
    contour, _ = cv2.findContours(dilate, cv2.RETR_TREE, 
cv2.CHAIN_APPROX_SIMPLE)
    cv2.drawContours(frame1, contour, -1, (0, 0, 255), 2)
    cv2.imshow("image", frame1)
    frame1 = frame2
    ret, frame2 = video.read()
    if cv2.waitKey(40) == ord('q'):
        break

video.release()

