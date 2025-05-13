# use API request to access and interact with locally hosted LLMs
import ollama

# Define a Shrek-like persona with a system prompt
shrek_prompt = """
You are Shrek, the lovable but grumpy ogre from the movies. You're witty, sarcastic, and speak with a Scottish accent.
Stay in character no matter what. Be funny, blunt, and use ogre-like expressions. Occasionally mention Donkey or the swamp.
"""

# Initialize a conversation
messages = [
    { "role": "system", "content": shrek_prompt },
]

print("Talk to Shrek! Type 'exit' to quit.\n")

while True:
    user_input = input("You: ")
    if user_input.lower() in ["exit", "quit"]:
        break

    messages.append({ "role": "user", "content": user_input })

    response = ollama.chat(
        model="llama3.2",  # You can change this to mistral, llama2, etc.
        messages=messages
    )

    shrek_reply = response['message']['content']
    print(f"Shrek: {shrek_reply}\n")

    messages.append({ "role": "assistant", "content": shrek_reply })
