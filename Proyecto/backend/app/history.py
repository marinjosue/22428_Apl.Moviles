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

@router.get("/history", response_model=list[schemas.HistoryOut])
def get_history(user_id: int, db: Session = Depends(get_db)):
    records = db.query(models.History).filter(models.History.user_id == user_id).all()
    return records

@router.post("/history", response_model=schemas.HistoryOut)
def add_history(item: schemas.HistoryIn, db: Session = Depends(get_db)):
    new_history = models.History(
        user_id=item.user_id,
        signal_name=item.signal_name,
        question=item.question,
        response=item.response,
        timestamp=item.timestamp,
    )
    db.add(new_history)
    db.commit()
    db.refresh(new_history)
    return new_history
