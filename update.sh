#!/bin/bash
cat <<EOT
- * - * - * - * - * - * - * - * - * - * - * -
- *           ViaUpdater v1.0.0           * -
- *        Powered by CrystaWorld.        * -
- * - * - * - * - * - * - * - * - * - * - * -
EOT
if [ "`whoami`" != "root" ]; then
  echo "[ERROR] This program must be run with administrator privileges. Please try again using the sudo command."
  exit 1
fi
echo "[INFO] Getting the latest ViaVersion and ViaBackwards release data..."

viaversion_url=$(curl -s https://api.github.com/repos/ViaVersion/ViaVersion/releases/latest | grep "browser_download_url.*\\.jar" | cut -d : -f 2,3 | tr -d \")
viaversion_file=$(basename $viaversion_url)


viabackwards_url=$(curl -s https://api.github.com/repos/ViaVersion/ViaBackwards/releases/latest | grep "browser_download_url.*\\.jar" | cut -d : -f 2,3 | tr -d \")
viabackwards_file=$(basename $viabackwards_url)


if [ -f "plugins/$viaversion_file" ] && [ -f "plugins/$viabackwards_file" ]; then
    echo "[INFO] Latest ViaVersion and ViaBackwards found. No update required."
else
    read -p "Latest release available. Do you want to update? (y/n): " answer
    if [ "$answer" = "y" ]; then
        if [ -f "plugins/ViaVersion-"*.jar ] && [ ! -f "plugins/$viaversion_file" ]; then
            echo "[INFO] An old ViaVersion was found. Delete and update."
            sudo rm -f "plugins/ViaVersion-"*.jar
            echo "[INFO] Downloading latest ViaVersion..."
            curl -sL $viaversion_url -o "plugins/$viaversion_file"
            echo "[INFO] ViaVersion update completed successfully."
        fi

        if [ -f "plugins/ViaBackwards-"*.jar ] && [ ! -f "plugins/$viabackwards_file" ]; then
            echo "[INFO] An old ViaBackwards was found. Delete and update."
            sudo rm -f "plugins/ViaBackwards-"*.jar
            echo "[INFO] Downloading latest ViaBackwards..."
            curl -sL $viabackwards_url -o "plugins/$viabackwards_file"
            echo "[INFO] ViaBackwards update completed successfully."
        else
            echo "[INFO] Downloading latest ViaVersion..."
            curl -sL $viaversion_url -o "plugins/$viaversion_file"
            echo "[INFO] ViaVersion update completed successfully."
            echo "[INFO] Downloading latest ViaBackwards..."
            curl -sL $viabackwards_url -o "plugins/$viabackwards_file"
            echo "[INFO] ViaBackwards update completed successfully."
        fi
        echo "[INFO] All updates completed."
    else
        echo "[INFO] Update canceled."
    fi
fi

exit 0
