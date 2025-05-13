#!/bin/bash

# ==== CONFIG ====
API_URL="http://localhost:1234/v1/chat/completions"  # For LM Studio
AUTH_HEADER="Authorization: Bearer lm-studio"        # For LM Studio
MODEL="deepseek-r1-distill-qwen-7b"                  # Change to match your model
# =================

# Requires: jq
if ! command -v jq >/dev/null; then
  echo "'jq' is required but not installed. Install it and try again."
  exit 1
fi

# System prompt to make the model behave like Donkey
system_prompt="You are Donkey from the Shrek movies. You're energetic, talkative, funny, and always overly enthusiastic. You love waffles, dragons, and talking about your best friend Shrek. Always stay in character and make your answers animated!"

# Initialize message history
messages=$(jq -n --arg content "$system_prompt" '[{"role": "system", "content": $content}]')

echo "Chat with Donkey! Type 'exit' to quit."
echo

while true; do
  read -p "You: " user_input

  if [[ "$user_input" == "exit" || "$user_input" == "quit" ]]; then
    break
  fi

  # Append user input
  messages=$(echo "$messages" | jq --arg content "$user_input" '. + [{"role":"user","content":$content}]')

  # Send to API
  response=$(curl -s "$API_URL" \
    -H "Content-Type: application/json" \
    -H "$AUTH_HEADER" \
    -d @- <<EOF
{
  "model": "$MODEL",
  "messages": $messages,
  "temperature": 0.9,
  "stream": false
}
EOF
)

  # Extract reply
  reply=$(echo "$response" | jq -r '.choices[0].message.content')
  echo -e "\nDonkey: $reply\n"

  # Append assistant reply to message history
  messages=$(echo "$messages" | jq --arg content "$reply" '. + [{"role":"assistant","content":$content}]')
done
