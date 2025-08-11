from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime

class UserCreate(BaseModel):
    email: str
    name: str
    password: str

class UserOut(BaseModel):
    id: int
    email: str
    name: str
    class Config:
        from_attributes = True

class Token(BaseModel):
    access_token: str
    token_type: str

class LoginRequest(BaseModel):
    email: str
    password: str

class ChatRequest(BaseModel):
    user_id: int
    message: str

class ChatResponse(BaseModel):
    response: str

class HistoryIn(BaseModel):
    user_id: int
    signal_name: Optional[str]
    question: str
    response: str
    timestamp: datetime

class HistoryOut(BaseModel):
    id: int
    user_id: int
    signal_name: Optional[str]
    question: str
    response: str
    timestamp: datetime
    class Config:
        from_attributes = True

class UserUpdate(BaseModel):
    email: str
    name: str
    password: Optional[str] = None