#!/data/data/com.termux/files/usr/bin/bash

# Ensure storage is available before doing anything
if [ ! -d "$HOME/storage/shared" ]; then
    echo "Setting up storage..."
    termux-setup-storage
fi

BOOTSTRAP_DIR="$HOME/storage/shared/zip2app_android"
BOOTSTRAP_SCRIPT="$BOOTSTRAP_DIR/zip2app.sh"
SHORTCUT_SCRIPT="$BOOTSTRAP_DIR/zip2app_termuxshortcut.sh"

# Bootstrap installation / repair
if [ "$(realpath "$0")" != "$(realpath "$BOOTSTRAP_SCRIPT" 2>/dev/null)" ]; then

    mkdir -p "$BOOTSTRAP_DIR"

    # Keep zip_files only, remove everything else
    find "$BOOTSTRAP_DIR" -mindepth 1 -maxdepth 1 ! -name zip_files -exec rm -rf {} +

    mkdir -p "$BOOTSTRAP_DIR/zip_files"
    mkdir -p "$BOOTSTRAP_DIR/tmp_extract"

    cp "$0" "$BOOTSTRAP_SCRIPT"
    chmod +x "$BOOTSTRAP_SCRIPT"

    cat > "$SHORTCUT_SCRIPT" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash

bash ~/storage/shared/zip2app_android/zip2app.sh
EOF

    chmod +x "$SHORTCUT_SCRIPT"

    echo
    echo "zip2app_android installed."
    echo

    exec bash "$BOOTSTRAP_SCRIPT"
fi

cd "$(dirname "$0")" || exit 1

mkdir -p zip_files
mkdir -p tmp_extract

# Always refresh shortcuts when zip2app starts
update_shortcuts() {
    mkdir -p ~/.shortcuts

    rm -f ~/.shortcuts/*_android.sh

    find ~/storage/shared/*_android/ -type f -name "*_termuxshortcut.sh" | while read -r file; do
        project="$(basename "$(dirname "$file")")"
        name="$project.sh"

        cp "$file" ~/.shortcuts/"$name"
        chmod +x ~/.shortcuts/"$name"

        echo "Installed shortcut: $name"
    done
}

update_shortcuts >/dev/null 2>&1

while true; do
    clear

    echo
    echo "zip2app_android"
    echo
    echo "1) Install apps from zip files"
    echo "9) First-time Setup"
    echo "0) Exit"
    echo

    read -p "Choose what to do: " choice

    case "$choice" in

        1)
            clear

            echo "Install apps from zip files"
            echo

            # Keep only zip files
            find zip_files/ -mindepth 1 ! -iname "*.zip" -exec rm -rf {} +

            found_zip=0

            for zipfile in zip_files/*.zip; do
                [ -f "$zipfile" ] || continue

                found_zip=1

                echo "Processing: $(basename "$zipfile")"

                rm -rf tmp_extract/*
                unzip -q "$zipfile" -d tmp_extract

                app_dir="$(find tmp_extract/ -type d -name "*_android" | head -n 1)"

                if [ -z "$app_dir" ]; then
                    echo "No *_android folder found. Skipped."
                    echo
                    rm -f "$zipfile"
                    continue
                fi

                app_name="$(basename "$app_dir")"

                echo "Found app: $app_name"

                rm -rf ~/storage/shared/"$app_name"
                cp -r "$app_dir" ~/storage/shared/

                rm -f "$zipfile"

                echo "Installed: $app_name"
                echo
            done

            rm -rf tmp_extract/*

            if [ "$found_zip" = "0" ]; then
                echo "No zip files found in zip_files folder."
                echo
            fi

            echo "Updating Termux shortcuts..."
            echo

            update_shortcuts

            echo
            echo "Shortcuts updated."
            echo
            echo "Done."
            echo
            read -p "Press Enter to continue..."
            ;;

        9)
            clear

            echo "First-time Setup"
            echo

            if [ ! -d "$HOME/storage/shared" ]; then
                echo "Setting up storage..."
                termux-setup-storage
            else
                echo "Storage is already configured."
            fi

            echo
            echo "Updating Termux..."
            pkg update -y
            pkg upgrade -y

            echo
            echo "Installing dependencies..."
            pkg install unzip -y

            mkdir -p zip_files
            mkdir -p tmp_extract

            if [ ! -f zip2app_termuxshortcut.sh ]; then
                cat > zip2app_termuxshortcut.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash

bash ~/storage/shared/zip2app_android/zip2app.sh
EOF
                chmod +x zip2app_termuxshortcut.sh
            fi

            update_shortcuts >/dev/null 2>&1

            echo
            echo "Setup completed."
            echo
            read -p "Press Enter to continue..."
            ;;

        0)
            clear
            exit 0
            ;;

        *)
            echo
            echo "Invalid choice."
            sleep 1
            ;;
    esac
done