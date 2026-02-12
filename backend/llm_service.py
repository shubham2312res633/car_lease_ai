import os
from dotenv import load_dotenv
from groq import Groq

load_dotenv()

GROQ_API_KEY = os.getenv("GROQ_API_KEY")
if not GROQ_API_KEY:
    raise RuntimeError("❌ GROQ_API_KEY not found in .env")

client = Groq(api_key=GROQ_API_KEY)

def generate_summary(clauses: dict) -> str:
    try:
        prompt = f"""
You are a car lease contract expert.

Given the following extracted contract clauses:
{clauses}

1. Give a simple summary
2. List red flags
3. Suggest negotiation tips

Respond in bullet points.
"""
        response = client.chat.completions.create(
            model="llama-3.1-8b-instant",
            messages=[
                {"role": "system", "content": "You are a helpful legal assistant."},
                {"role": "user", "content": prompt}
            ],
            temperature=0.3,
            max_tokens=600
        )
        return response.choices[0].message.content

    except Exception as e:
        return f"⚠️ LLM summary unavailable: {str(e)}"


def negotiation_chat(clauses: dict, user_query: str) -> str:
    try:
        prompt = f"""
You are an expert car lease negotiation assistant.

Contract clauses:
{clauses}

User question:
"{user_query}"

Respond in short bullet points.
"""
        response = client.chat.completions.create(
            model="llama-3.1-8b-instant",
            messages=[
                {"role": "system", "content": "You help users negotiate contracts."},
                {"role": "user", "content": prompt}
            ],
            temperature=0.3,
            max_tokens=400
        )
        return response.choices[0].message.content

    except Exception as e:
        return f"⚠️ LLM negotiation unavailable: {str(e)}"
