from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database import SessionLocal
from app import models, schemas

router = APIRouter()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/signals/query", response_model=schemas.SignalOut)
def query_signal(query: schemas.SignalQuery, db: Session = Depends(get_db)):
    signal = db.query(models.Signal).filter(models.Signal.name.ilike(query.name)).first()
    if not signal:
        raise HTTPException(status_code=404, detail="Señal no encontrada")
    return signal
