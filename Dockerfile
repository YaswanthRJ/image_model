FROM pytorch/pytorch:1.9.0-cuda10.2-cudnn7-runtime

WORKDIR /app

RUN pip install torchserve torch-model-archiver torchvision Pillow

RUN mkdir -p /app/model_store

COPY model_store/shufflenet_v2.mar /app/model_store/shufflenet_v2.mar
COPY config.properties /app/config.properties

EXPOSE 8080 8081

CMD ["torchserve", "--start", "--model-store", "/app/model_store", "--models", "shufflenet_v2=shufflenet_v2.mar"]
