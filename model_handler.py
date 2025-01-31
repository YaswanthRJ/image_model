from ts.torch_handler.base_handler import BaseHandler
import torch
import torchvision.transforms as transforms
from PIL import Image
import io
import torch.nn.functional as F

class ModelHandler(BaseHandler):
    def __init__(self):
        super().__init__()
        self.model = None
        self.transform = transforms.Compose([
            transforms.Resize((224, 224)),
            transforms.ToTensor(),
            transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),  # Standard ImageNet Normalization
        ])

    def initialize(self, context):
        # Load the TorchScript model
        self.model = torch.jit.load("shufflenet_v2_traced.pt")  # Make sure this is the correct model path
        self.model.eval()

    def preprocess(self, data):
        # Convert input bytes to image and apply transformations
        image = Image.open(io.BytesIO(data[0]["data"]))
        return self.transform(image).unsqueeze(0)  # Add batch dimension

    def inference(self, inputs):
        with torch.no_grad():
            # Run inference on the input image
            output = self.model(inputs)
        return output.tolist()

    def postprocess(self, outputs):
        # Postprocess to get the predicted class (optional: if classification task)
        predictions = torch.tensor(outputs)
        _, predicted_class = torch.max(predictions, 1)  # Get the class with the highest score
        return {"prediction": predicted_class.item()}  # Return the class index as the result
