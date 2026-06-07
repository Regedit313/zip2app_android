#!/data/data/com.termux/files/usr/bin/bash

cd "$(dirname "$0")" || exit 1

mkdir -p apps
mkdir -p tmp_extract

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

            found_zip=0

            for zipfile in apps/*.zip; do
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
                echo "No zip files found in apps folder."
                echo
            fi

            echo "Done."
            echo
            read -p "Press Enter to continue..."
            ;;

        9)
            clear

            echo "First-time Setup"
            echo

            if [ ! -d ~/storage/shared ]; then
                echo "Setting up storage..."
                termux-setup-storage
            else
                echo "Storage is already configured."
            fi

            echo
            echo "Installing dependencies..."
            pkg update -y
            pkg install unzip -y

            mkdir -p apps
            mkdir -p tmp_extract

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