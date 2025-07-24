from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.config import ALLOWED_ORIGINS, PORT
from app.auth import router as auth_router
from app.signals import router as signals_router
from app.chat import router as chat_router
from app.history import router as history_router
from app.database import Base, engine

app = FastAPI(title="Backend IA Educación Vial", version="1.0.0")

# Crear las tablas
Base.metadata.create_all(bind=engine)

# CORS para Flutter/mobile
app.add_middleware(
    CORSMiddleware,
    allow_origins=[ALLOWED_ORIGINS] if ALLOWED_ORIGINS != '*' else ["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# Rutas
app.include_router(auth_router)
app.include_router(signals_router)
app.include_router(chat_router)
app.include_router(history_router)


@app.get("/")
@app.head("/")
def read_root():
    return {"message": "Bienvenido a la API de Educación Vial"}

if __name__ == "__main__":
    import uvicorn
    import os
    port = int(os.environ["PORT"])  # Render SIEMPRE define PORT
    uvicorn.run("main:app", host="0.0.0.0", port=port)
