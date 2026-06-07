#!/data/data/com.termux/files/usr/bin/bash

if [ ! -d "$HOME/storage/shared" ]; then
    echo "Setting up storage..."
    termux-setup-storage
fi

ROOT_DIR="$HOME/storage/shared"
ROOT_SCRIPT="$ROOT_DIR/zip2app.sh"
APP_DIR="$ROOT_DIR/zip2app_android"
APP_SCRIPT="$APP_DIR/zip2app.sh"
SHORTCUT_SCRIPT="$APP_DIR/zip2app_termuxshortcut.sh"

CURRENT_SCRIPT="$(realpath "$0")"
ROOT_SCRIPT_REAL="$(realpath "$ROOT_SCRIPT" 2>/dev/null)"
APP_SCRIPT_REAL="$(realpath "$APP_SCRIPT" 2>/dev/null)"

mkdir -p "$APP_DIR"
mkdir -p "$APP_DIR/zip_files"

if [ "$CURRENT_SCRIPT" != "$ROOT_SCRIPT_REAL" ]; then
    cp "$CURRENT_SCRIPT" "$ROOT_SCRIPT"
fi

if [ "$CURRENT_SCRIPT" != "$APP_SCRIPT_REAL" ]; then
    cp "$CURRENT_SCRIPT" "$APP_SCRIPT"
fi

chmod +x "$ROOT_SCRIPT"
chmod +x "$APP_SCRIPT"

find "$APP_DIR" -mindepth 1 -maxdepth 1 \
    ! -name zip_files \
    ! -name zip2app.sh \
    -exec rm -rf {} +

find "$APP_DIR/zip_files" -mindepth 1 ! -iname "*.zip" -exec rm -rf {} +

cat > "$SHORTCUT_SCRIPT" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash

bash ~/storage/shared/zip2app_android/zip2app.sh
EOF

chmod +x "$SHORTCUT_SCRIPT"

cd "$APP_DIR" || exit 1

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

echo
echo "Updating Termux shortcuts..."
echo

update_shortcuts

echo
echo "Shortcuts updated."
echo
read -p "Press Enter to continue..."

while true; do
    clear

    echo
    echo "zip2app_android"
    echo
    echo "1) Install apps from zip files"
    echo "9) First-time Setup / Update Setup"
    echo "0) Exit"
    echo

    read -p "Choose what to do: " choice

    case "$choice" in

        1)
            clear

            echo "Install apps from zip files"
            echo

            found_zip=0

            mkdir -p tmp_extract

            for zipfile in zip_files/*.zip; do
                [ -f "$zipfile" ] || continue

                found_zip=1

                echo "Processing: $(basename "$zipfile")"

                rm -rf tmp_extract
                mkdir -p tmp_extract

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

                rm -rf "$ROOT_DIR/$app_name"
                cp -r "$app_dir" "$ROOT_DIR/"

                rm -f "$zipfile"

                echo "Installed: $app_name"
                echo
            done

            rm -rf tmp_extract

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

            echo "First-time Setup / Update Setup"
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

            update_shortcuts

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
