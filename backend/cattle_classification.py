import torch
from torchvision import transforms, models
from PIL import Image

# Path to model checkpoint
MODEL_PATH = "models/cattle_classification_model.pth"

# Load checkpoint
checkpoint = torch.load(MODEL_PATH, map_location="cpu")

# Define model (ResNet18 with updated final layer)
model = models.resnet18(weights=None)  # no pretrained weights
num_ftrs = model.fc.in_features
model.fc = torch.nn.Linear(num_ftrs, len(checkpoint["classes"]))
model.load_state_dict(checkpoint["model_state"])
model.eval()

# Classes (same as training dataset)
classes = checkpoint["classes"]

# Transform (must match training preprocessing)
transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize([0.485, 0.456, 0.406], 
                         [0.229, 0.224, 0.225])
])

def classify_cattle(image_path: str) -> str:
    """Classify cattle image and return predicted breed/variety"""
    img = Image.open(image_path).convert("RGB")
    img_t = transform(img).unsqueeze(0)

    with torch.no_grad():
        outputs = model(img_t)
        _, predicted = outputs.max(1)

    return classes[predicted.item()]
