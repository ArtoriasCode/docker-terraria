#!/bin/bash

# Define the screen session name
SESSION="terraria"

# Copy the config file if it exists
echo "Copying config..."
if [ -f /data/serverconfig.txt ]; then
    cp /data/serverconfig.txt /opt/terraria/serverconfig.txt
else
    echo "No serverconfig.txt found in /data"
    exit 1
fi

# Function to gracefully stop the server using screen
function stop_server() {
    echo "Stopping server gracefully..."
    # Send the 'exit' command to the Terraria screen session
    screen -S "$SESSION" -p 0 -X stuff "exit$(printf \\r)"
    sleep 5

    # Wait until the screen session fully exits
    while screen -list | grep -q "$SESSION"; do
        sleep 1
    done

    echo "Server stopped."
    exit 0
}

# Trap SIGINT and SIGTERM signals to run graceful shutdown
trap stop_server SIGINT SIGTERM

# Start the Terraria server inside a detached screen session
echo "Starting Terraria server in screen session '$SESSION'..."
screen -dmS "$SESSION" /opt/terraria/TerrariaServer.bin.x86_64 -config /opt/terraria/serverconfig.txt

# Wait until the screen session ends
while screen -list | grep -q "$SESSION"; do
    sleep 5
done

echo "Server process ended."
