# Actualización del Backend - FastAPI

Para que tu aplicación funcione correctamente con las nuevas funcionalidades, actualiza tu archivo FastAPI con el siguiente código:

```python
from fastapi import FastAPI
from pydantic import BaseModel
import google.generativeai as genai
import os
from typing import Optional

# 🔐 Configura tu clave API aquí
GOOGLE_API_KEY = "AIzaSyCOZuAp-t-l9IIDRNZwdujv1CbIlIshnTA"
genai.configure(api_key=GOOGLE_API_KEY)

# 🔧 Inicializa el modelo Gemini-Pro
model = genai.GenerativeModel('gemini-pro')

# 🛠 FastAPI app
app = FastAPI()

class ChatInput(BaseModel):
    signal: Optional[str] = None  # Puede ser None si no hay señal detectada
    question: str

@app.post("/chatbot")
async def chatbot(input: ChatInput):
    if input.signal:
        prompt = f"""Estás actuando como un experto en señales de tránsito del Ecuador. 
        La señal detectada es: {input.signal}. El usuario pregunta: {input.question}.
        
        Proporciona información detallada sobre:
        1. Qué significa esta señal
        2. Regulaciones del Ecuador o COIP relacionadas
        3. Multas por no respetarla (si aplica)
        4. Recomendaciones de seguridad
        
        Responde de manera clara y educativa.
        """
    else:
        prompt = f"""Estás actuando como un experto en señales de tránsito del Ecuador. 
        El usuario pregunta: {input.question}.
        
        Responde según la normativa de tránsito del Ecuador o el COIP cuando sea posible.
        Proporciona información clara, educativa y útil sobre señales de tráfico, 
        regulaciones viales y temas relacionados con la seguridad en el tránsito.
        """
    
    try:
        response = model.generate_content(prompt)
        return {"answer": response.text}
    except Exception as e:
        return {"answer": f"Lo siento, hubo un error al procesar tu consulta: {str(e)}"}

# Agregar CORS si es necesario para desarrollo
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # En producción, especifica los dominios permitidos
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
```

## Cambios implementados:

1. **Campo `signal` opcional**: El campo `signal` ahora puede ser `None` cuando el usuario accede al chat directamente sin detectar una señal.

2. **Prompts dinámicos**: El sistema ahora genera prompts diferentes dependiendo de si hay una señal detectada o no.

3. **Manejo de errores**: Se agregó manejo básico de errores para respuestas más robustas.

4. **CORS configurado**: Para permitir solicitudes desde tu app Flutter.

## Cómo funciona ahora:

### Con señal detectada:
- El usuario detecta una señal
- Aparece un modal preguntando si quiere más información
- Si acepta, navega al chat con la señal como contexto
- El bot proporciona información específica sobre esa señal

### Sin señal detectada:
- El usuario accede al chat desde el menú principal
- Puede preguntar sobre cualquier señal o tema de tránsito
- El bot responde con información general

### Ejemplo de uso:
```dart
// Con señal detectada
await BackendService().preguntarMulta(
  "¿Cuál es la multa por no respetar esta señal?", 
  signal: "STOP"
);

// Sin señal detectada
await BackendService().preguntarMulta(
  "¿Qué significa una señal de PARE?"
);
```

Asegúrate de actualizar tu archivo FastAPI en Render con este código para que la aplicación funcione correctamente.
