import os

files_to_remove = ["mask.png", "original.png", "result.png"]

for file in files_to_remove:
    if os.path.exists(file):
        os.remove(file)
