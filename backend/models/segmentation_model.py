from PIL import Image
import os

def segment_image(image_path):
    """
    Dummy function to simulate image segmentation.
    """
    upper_path = image_path.replace(".jpg", "_upper.jpg")
    lower_path = image_path.replace(".jpg", "_lower.jpg")
    
    # Simulate saving segmented parts
    Image.open(image_path).crop((0, 0, 200, 200)).save(upper_path)  # Dummy upper segment
    Image.open(image_path).crop((0, 200, 200, 400)).save(lower_path)  # Dummy lower segment
    
    return upper_path, lower_path
