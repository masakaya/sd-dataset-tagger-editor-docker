FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    git \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN git clone https://github.com/corkborg/wd14-tagger-standalone.git .

RUN pip3 install --no-cache-dir -r requirements.txt

# Install ONNX Runtime GPU
RUN pip3 install --no-cache-dir onnxruntime-gpu

ENTRYPOINT ["python3", "run.py"]
CMD ["--help"]
