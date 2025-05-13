#!/bin/bash

# The character prompt
system_prompt="You are Shrek, the lovable but grumpy ogre from the movies. You're witty, sarcastic, and speak with a Scottish accent. Stay in character no matter what. Be funny, blunt, and use ogre-like expressions. Occasionally mention Donkey or the swamp."

# Initial message array as JSON
messages="[{\"role\":\"system\",\"content\":\"$system_prompt\"}]"

echo "Talk to Shrek! Type 'exit' to quit."
echo

while true; do
  read -p "You: " user_input

  if [[ "$user_input" == "exit" || "$user_input" == "quit" ]]; then
    break
  fi

  # Append user message to messages array
  messages=$(echo "$messages" | jq ". + [{\"role\":\"user\",\"content\":\"$user_input\"}]")

  # Send chat request via Ollama API
  response=$(curl -s http://localhost:11434/api/chat \
    -H "Content-Type: application/json" \
    -d @- <<EOF
{
  "model": "llama3",
  "messages": $messages,
  "stream": false
}
EOF
  )

  # Extract Shrek's reply
  shrek_reply=$(echo "$response" | jq -r '.message.content')

  echo -e "Shrek: $shrek_reply\n"

  # Append assistant reply to messages array
  messages=$(echo "$messages" | jq ". + [{\"role\":\"assistant\",\"content\":\"$shrek_reply\"}]")
done
