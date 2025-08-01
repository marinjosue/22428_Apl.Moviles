from fastapi import APIRouter
from pydantic import BaseModel
import google.generativeai as genai
import os

GOOGLE_API_KEY = "AIzaSyCOZuAp-t-l9IIDRNZwdujv1CbIlIshnTA"
genai.configure(api_key=GOOGLE_API_KEY)
model = genai.GenerativeModel('gemini-2.5-flash') 

router = APIRouter()

class ChatInput(BaseModel):
    signal: str = None
    question: str

@router.post("/chatbot")
async def chatbot(input: ChatInput):
    if input.signal:
        prompt = f"""Estás actuando como un experto en señales de tránsito. 
        La señal detectada es: {input.signal}. El usuario pregunta: {input.question}.
        Responde según la normativa de tránsito del Ecuador o el COIP si es posible.
        """
    else:
        prompt = f"""Estás actuando como un experto en señales de tránsito. 
        El usuario pregunta: {input.question}.
        Responde según la normativa de tránsito del Ecuador o el COIP si es posible.
        """
    
    try:
        response = model.generate_content(prompt)
        return {"answer": response.text}
    except Exception as e:
        return {"error": f"Error al generar respuesta: {str(e)}"}