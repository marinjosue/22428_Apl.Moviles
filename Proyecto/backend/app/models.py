from sqlalchemy import Column, Integer, String, DateTime, Text, ForeignKey
from sqlalchemy.orm import relationship
from app.database import Base
from datetime import datetime

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=False)
    name = Column(String, nullable=False)
    hashed_password = Column(String, nullable=False)
    histories = relationship("History", back_populates="user")

class Signal(Base):
    __tablename__ = "signals"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, unique=True, nullable=False)
    type = Column(String, nullable=False)
    description = Column(Text)
    image_url = Column(String)
    legal_info = Column(Text)
    penalty = Column(Text)

class History(Base):
    __tablename__ = "histories"
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    signal_id = Column(Integer, ForeignKey("signals.id"))
    question = Column(Text)
    response = Column(Text)
    timestamp = Column(DateTime, default=datetime.utcnow)
    user = relationship("User", back_populates="histories")
    signal = relationship("Signal")
