from fastapi import FastAPI, File, UploadFile
from fastapi.responses import JSONResponse, FileResponse
import shutil
import uuid
import os

from cattle_classification import classify_cattle
from cattle_segmentation import segment_cattle
from cattle_keypoints import get_keypoints_image

app = FastAPI()

UPLOAD_DIR = "uploads/"
OUTPUT_DIR = "outputs/"

os.makedirs(UPLOAD_DIR, exist_ok=True)
os.makedirs(OUTPUT_DIR, exist_ok=True)

@app.post("/classify")
async def classify(file: UploadFile = File(...)):
    filename = f"{UPLOAD_DIR}{uuid.uuid4()}.jpg"
    with open(filename, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    breed = classify_cattle(filename)
    return {"breed": breed}

@app.post("/segment")
async def segment(file: UploadFile = File(...)):
    filename = f"{UPLOAD_DIR}{uuid.uuid4()}.jpg"
    output_path = f"{OUTPUT_DIR}{uuid.uuid4()}.jpg"

    with open(filename, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    segment_cattle(filename, output_path)
    return FileResponse(output_path, media_type="image/jpeg")

@app.get("/keypoints")
async def keypoints():
    return FileResponse(get_keypoints_image(), media_type="image/jpeg")
