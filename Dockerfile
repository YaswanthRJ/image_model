FROM pytorch/pytorch:1.9.0-cuda10.2-cudnn7-runtime

WORKDIR /app

# Install Java (required for TorchServe)
RUN apt-get update && apt-get install -y openjdk-11-jdk

# Set Java environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin

# Install required Python packages
RUN pip install torchserve torch-model-archiver torchvision Pillow

# Create the model store directory
RUN mkdir -p /app/model_store

# Copy the model and config file into the container
COPY model_store/shufflenet_v2_model.mar /app/model_store/
COPY config.properties /app/config.properties

# Expose TorchServe ports
EXPOSE 8080 8081

CMD ["torchserve", "--start", "--model-store", "/app/model_store", "--models", "shufflenet_v2=shufflenet_v2_model.mar", "--ts-config", "/app/config.properties"]
