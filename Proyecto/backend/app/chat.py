from fastapi import APIRouter
from app.schemas import ChatRequest, ChatResponse

router = APIRouter()

@router.post("/chat", response_model=ChatResponse)
def chat_educativo(req: ChatRequest):
    # Lógica real: consulta base legal, embeddings o IA.
    # Demo: respuesta estática.
    if "PARE" in req.message.upper():
        resp = ("No respetar la señal de PARE es una infracción grave. "
                "Multa: 30% SBU y reducción de 6 puntos en la licencia.")
    else:
        resp = "Consulte el COIP para más detalles sobre esta señal."
    return ChatResponse(response=resp)
