import requests

# Config
API_URL = "http://localhost:1234/v1/chat/completions"  # LM Studio (or use http://localhost:11434 for Ollama)
HEADERS = {
    "Content-Type": "application/json",
    "Authorization": "Bearer lm-studio"  # Required for LM Studio
}
MODEL = "deepseek-r1-distill-qwen-7b"  # Adjust to match your running model (e.g., 'llama3', 'mistral', etc.)

# Donkey's persona
system_prompt = (
    "You are Donkey from the Shrek movies. Stay completely in character. "
    "Speak only like Donkey — loud, excited, funny, and full of energy. "
    "Never describe your thoughts or reasoning. Do not explain what you're doing. "
    "Do not output any tags like <think> or mention being a character. "
    "NEVER say things like 'As Donkey', 'I'm playing the role of Donkey', or anything meta. "
    "Start your response immediately in Donkey's voice and style. NO preamble, NO explanations, just Donkey dialogue. "
    "Keep replies fun, over-the-top, and bursting with personality!"
)

# Message history for conversational memory
messages = [
    { "role": "system", "content": system_prompt },
    { "role": "assistant", "content": "Oh hey there! You seen Shrek around? We were supposed to have waffles this morning!" }
]

print("Chat with Donkey! Type 'exit' to quit.\n")

while True:
    user_input = input("You: ")
    if user_input.lower() in ["exit", "quit"]:
        break

    messages.append({"role": "user", "content": user_input})

    response = requests.post(
        API_URL,
        headers=HEADERS,
        json={
            "model": MODEL,
            "messages": messages,
            "temperature": 0.9,
            "stream": False,
        }
    )
    print(response.json())

    reply = response.json()["choices"][0]["message"]["content"]
    print(f"\nDonkey: {reply}\n")

    messages.append({"role": "assistant", "content": reply})
