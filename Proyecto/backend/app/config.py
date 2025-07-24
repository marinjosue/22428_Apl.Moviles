import os
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")
SECRET_KEY = os.getenv("SECRET_KEY", "supersecret")
ALGORITHM = os.getenv("ALGORITHM", "HS256")
ACCESS_TOKEN_EXPIRE_MINUTES = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", 60))
PORT = int(os.getenv("PORT", 8000))
DOCS_PATH = os.getenv("DOCS_PATH", "data/legal_docs")
ALLOWED_ORIGINS = os.getenv("ALLOWED_ORIGINS", "*")
