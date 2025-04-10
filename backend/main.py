from fastapi import FastAPI, File, UploadFile, HTTPException
from pathlib import Path
import uuid
from models.segmentation_model import segment_image
from utils.recommend import recommend_outfit

app = FastAPI()

# Directory for storing uploaded images
UPLOAD_DIR = Path("./storage/uploads")
UPLOAD_DIR.mkdir(parents=True, exist_ok=True)

@app.post("/upload")
async def upload_image(image: UploadFile = File(...)):
    """
    Uploads an image to the server and saves it in the storage/uploads directory.
    """
    if not image.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="File must be an image")
    
    unique_filename = f"{uuid.uuid4()}.jpg"
    file_path = UPLOAD_DIR / unique_filename

    with file_path.open("wb") as buffer:
        buffer.write(await image.read())
    
    return {"message": "Image uploaded successfully", "file_path": str(file_path)}

@app.post("/segment")
async def segment_uploaded_image(file_path: str):
    """
    Segments the uploaded image into upper and lower body apparel.
    """
    try:
        upper_path, lower_path = segment_image(file_path)
        return {"upper_body": upper_path, "lower_body": lower_path}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/recommend")
async def recommend_outfit_api(upper_body: str, lower_body: str):
    """
    Generates outfit recommendations based on segmented images.
    """
    try:
        outfit_suggestions = recommend_outfit(upper_body, lower_body)
        return {"recommendations": outfit_suggestions}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
