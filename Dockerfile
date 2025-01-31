FROM pytorch/pytorch:1.9.0-cuda10.2-cudnn7-runtime

WORKDIR /app

RUN apt-get update && apt-get install -y openjdk-11-jdk

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin

RUN pip install torchserve torch-model-archiver torchvision Pillow

RUN mkdir -p /app/model_store

COPY model_store/shufflenet_v2_model.mar /app/model_store/
COPY config.properties /app/config.properties

EXPOSE 8080 8081

CMD ["torchserve", "--start", "--model-store", "/app/model_store", "--models", "shufflenet_v2=shufflenet_v2_model.mar", "--ts-config", "/app/config.properties", "--inference-address", "0.0.0.0:8080", "--management-address", "0.0.0.0:8081"]
