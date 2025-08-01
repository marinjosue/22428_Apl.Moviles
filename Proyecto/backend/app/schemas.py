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

class SignalQuery(BaseModel):
    name: str

class SignalOut(BaseModel):
    id: int
    name: str
    type: str
    description: Optional[str]
    image_url: Optional[str]
    legal_info: Optional[str]
    penalty: Optional[str]
    class Config:
        from_attributes = True

class ChatRequest(BaseModel):
    user_id: int
    message: str

class ChatResponse(BaseModel):
    response: str

class HistoryOut(BaseModel):
    id: int
    signal: Optional[SignalOut]
    question: str
    response: str
    timestamp: datetime
    class Config:
        from_attributes = True