# Use a smaller base image with CPU support for PyTorch
FROM pytorch/pytorch:1.9.0-cpu

# Install dependencies and Java
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Set Java environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin

# Install TorchServe and other necessary Python dependencies
RUN pip install --no-cache-dir torchserve torch-model-archiver torchvision Pillow

# Create and set the working directory
WORKDIR /app

# Copy the model files and handler
COPY model_store /app/model_store
COPY model_handler.py /app/model_handler.py
COPY config.properties /app/config.properties
COPY requirements.txt /app/requirements.txt
COPY Dockerfile /app/Dockerfile

# Expose the ports for inference and management
EXPOSE 8080 8081

# Command to start TorchServe with the model
CMD ["torchserve", "--start", "--model-store", "/app/model_store", "--models", "shufflenet_v2_model=/app/model_store/shufflenet_v2_model.mar", "--ts-config", "/app/config.properties"]
