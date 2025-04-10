import random

def recommend_outfit(upper_body_path, lower_body_path):
    """
    Generates random outfit recommendations based on dummy logic.
    """
    colors = ["red", "blue", "green", "yellow", "black", "white"]
    upper_color = random.choice(colors)
    lower_color = random.choice(colors)
    
    return [
        {"upper_body": upper_body_path, "color": upper_color},
        {"lower_body": lower_body_path, "color": lower_color},
    ]
