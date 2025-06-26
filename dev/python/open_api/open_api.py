import os
from dotenv import load_dotenv
import gradio as gr
from huggingface_hub import InferenceClient

load_dotenv()
HUGGINGFACE_TOKEN = os.getenv("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")

client = InferenceClient(
    model="tiiuae/falcon-7b-instruct",
    token=HUGGINGFACE_TOKEN
)

def respond(message, history, system_message, max_tokens, temperature, top_p):
    prompt = f"{system_message.strip()}\n"

    for user_msg, bot_msg in history:
        prompt += f"\nUser: {user_msg}\nAssistant: {bot_msg}"

    prompt += f"\nUser: {message}\nAssistant:"

    try:
        print("\n🟡 Prompt enviado:\n", prompt[:1000], "\n...")
        response = client.text_generation(
            prompt=prompt,
            max_new_tokens=max_tokens,
            temperature=temperature,
            top_p=top_p,
            stop=["User:", "user:"]
        )
        print("\n🟢 Resposta bruta:\n", response)
        return response.strip() if response else "❌ A resposta veio vazia."
    except Exception as e:
        import traceback
        traceback.print_exc()
        return f"❌ Erro ao gerar resposta: {type(e).__name__}: {str(e)}"

demo = gr.ChatInterface(
    fn=respond,
    additional_inputs=[
        gr.Textbox(
            label="System message",
            value="You are a career and recruitment expert. Avoid small talk. First, ask the user to provide their skills and experience. After receiving that, ask for the job description and requirements. Then, compare the job description with the candidate's profile. Based on this comparison, respond with suggestions to improve the resume and align it with the job, missing keywords, and an example of a professional summary tailored to the job.",
            lines=5
        ),
        gr.Slider(1, 2048, value=512, step=1, label="Max new tokens"),
        gr.Slider(0.1, 2.0, value=0.7, step=0.1, label="Temperature"),
        gr.Slider(0.1, 1.0, value=0.95, step=0.05, label="Top-p"),
    ],
)

if __name__ == "__main__":
    demo.launch()
