import os
from dotenv import load_dotenv
import gradio as gr
from huggingface_hub import InferenceClient

# Carrega o token da Hugging Face
load_dotenv()
HUGGINGFACE_TOKEN = os.getenv("HUGGINGFACE_TOKEN")
#print("Chave: "+HUGGINGFACE_TOKEN)

# Verificação simples do token
if not HUGGINGFACE_TOKEN:
    raise ValueError("Token Hugging Face não encontrado.")

# Modelo compatível com chat_completion
client = InferenceClient(
    model="HuggingFaceH4/zephyr-7b-beta",
    token=HUGGINGFACE_TOKEN
)

# Função de resposta para o chat
def respond(message, history, system_message, max_tokens, temperature, top_p):
    messages = [{"role": "system", "content": system_message.strip()}]

    for user_msg, bot_msg in history:
        if user_msg:
            messages.append({"role": "user", "content": user_msg})
        if bot_msg:
            messages.append({"role": "assistant", "content": bot_msg})

    messages.append({"role": "user", "content": message})

    try:
        response = client.chat_completion(
            messages=messages,
            max_tokens=max_tokens,
            temperature=temperature,
            top_p=top_p
        )
        return response.choices[0].message.content.strip()
    except Exception as e:
        return f"❌ Erro ao gerar resposta: {type(e).__name__}: {str(e)}"

# Interface com Gradio
demo = gr.ChatInterface(
    fn=respond,
    additional_inputs=[
        gr.Textbox(
            label="System message",
            value=(
                "You are an expert in careers and technical recruitment."
                "You will receive information about the candidate and the vacancy, analyze it briefly, and respond to the strengths and weaknesses."
                "Generate a percentage of compatibility between the candidate's profile and the vacancy description."
            ),
            lines=6
        ),
        gr.Slider(128, 1024, value=512, step=1, label="Max new tokens"),
        gr.Slider(0.1, 2.0, value=0.7, step=0.1, label="Temperature"),
        gr.Slider(0.1, 1.0, value=0.95, step=0.05, label="Top-p"),
    ],
    title="Análise de Currículo vs Vaga",
    description="Ferramenta para comparar o perfil do candidato com uma vaga de emprego."
)

if __name__ == "__main__":
    demo.launch()

