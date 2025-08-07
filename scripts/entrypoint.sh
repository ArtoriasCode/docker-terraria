#!/bin/bash

SESSION="terraria"
CONFIG_PATH="/opt/terraria/serverconfig.txt"
MODS_PATH="/root/.local/share/Terraria/tModLoader/Mods"
MODS_LIST="/data/mods.txt"
STEAMCMD="/opt/steamcmd/steamcmd.sh"
TML_APPID=1281930

# Copy the config file if it exists
echo "Copying config..."
if [ -f /data/serverconfig.txt ]; then
    cp /data/serverconfig.txt "$CONFIG_PATH"
else
    echo "No serverconfig.txt found in /data"
    exit 1
fi

# Download mods via SteamCMD (anonymously)
if [ -f "$MODS_LIST" ]; then
    echo "Installing mods via SteamCMD from $MODS_LIST..."
    mkdir -p "$MODS_PATH"

    WORKSHOP_DIR="/root/Steam/steamapps/workshop/content/$TML_APPID"
    mkdir -p "$WORKSHOP_DIR"

    while IFS= read -r mod_id || [ -n "$mod_id" ]; do
        if [[ -n "$mod_id" ]]; then
            mod_dir="$WORKSHOP_DIR/$mod_id"

            if [ -d "$mod_dir" ] && find "$mod_dir" -type f -name "*.tmod" | grep -q .; then
                echo "Mod ID $mod_id already exists. Skipping download."
            else
                echo "Downloading mod ID $mod_id..."

                "$STEAMCMD" +login anonymous \
                    +workshop_download_item "$TML_APPID" "$mod_id" validate \
                    +quit
            fi
        fi
    done < "$MODS_LIST"

    # Generating enabled.json from mods in the workshop
    enabled_mods=$(find "$WORKSHOP_DIR" -type f -name "*.tmod" | \
        xargs -n1 basename | sed 's/\.tmod$//' | sort -u | awk '{print "\"" $0 "\"" }' | paste -sd ",")

    echo "[$enabled_mods]" > "$MODS_PATH/enabled.json"
    echo "enabled.json created with: [$enabled_mods]"
else
    echo "No mods.txt found — skipping mod installation."
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
echo "Starting tModLoader server in screen session '$SESSION'..."
screen -dmS "$SESSION" /opt/terraria/start-tModLoaderServer.sh -nosteam -tmlsavedirectory "/root/.local/share/Terraria/tModLoader" -steamworkshopfolder "/root/Steam/steamapps/workshop" -config "$CONFIG_PATH"

# Wait until the screen session ends
while screen -list | grep -q "$SESSION"; do
    sleep 5
done

echo "Server process ended."
