import shutil
import os

# Define the source and destination paths
desktop_path = os.path.expanduser("~/Desktop")
destination_path = os.path.expanduser("images")

# Create the destination folder if it doesn't exist
if not os.path.exists(destination_path):
    os.makedirs(destination_path)

# Loop through all files on the desktop
for filename in os.listdir(desktop_path):
    if filename.startswith("Screenshot"):
        # Move the file to the destination folder
        shutil.move(os.path.join(desktop_path, filename), os.path.join(destination_path, filename))
        print(f"Moved {filename} to {destination_path}")
