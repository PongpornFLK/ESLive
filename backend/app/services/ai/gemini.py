from google import genai
from app.core.config import settings

def getGemini(prompt:str):

    client = genai.Client(api_key=settings.gemini_api_key)

    interaction = client.interactions.create(
        model="gemini-3.5-flash-lite",
        input=prompt,
    )

    # print(interaction.output_text)
    return interaction.output_text


