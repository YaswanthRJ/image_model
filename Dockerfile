# Use a PyTorch image
FROM pytorch/pytorch:1.9.0-cuda10.2-cudnn7-runtime

# Install dependencies
RUN pip install torchserve torch-model-archiver

# Set the working directory
WORKDIR /app

# ✅ Ensure /model_store exists before copying files
RUN mkdir -p /app/model_store

# Copy all model files into the container
COPY model_store /app/model_store

# Expose the TorchServe port
EXPOSE 8080

# Start TorchServe and load multiple models
CMD ["torchserve", "--start", "--model-store", "/app/model_store", "--models", "shufflenet_v2=shufflenet_v2_model.mar"]
