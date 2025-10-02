import cv2

def segment_cattle(image_path, output_path):
    image = cv2.imread(image_path)
    mask = cv2.Canny(image, 100, 200)  # placeholder segmentation
    cv2.imwrite(output_path, mask)
