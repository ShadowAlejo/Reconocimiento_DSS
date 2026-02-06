FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt .

RUN apt-get update && apt-get install -y --no-install-recommends \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    libgl1 \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir -r requirements.txt

RUN pip show mediapipe

RUN python -c "import mediapipe as mp; print('file', mp.__file__); print('version', getattr(mp,'__version__',None)); print('has_solutions', hasattr(mp,'solutions'))"

RUN python -c "import mediapipe, pkgutil; print(mediapipe.__file__); print([m.name for m in pkgutil.iter_modules(mediapipe.__path__)][:50])"

COPY . .

CMD ["sh", "-c", "uvicorn main_websocket:app --host 0.0.0.0 --port ${PORT:-8080}"]
