# zip2app_android

## What is zip2app?

zip2app_android is a simple installer for Android Termux applications.

It automatically installs applications downloaded from GitHub ZIP files and creates shortcuts for use with the Termux Widget.

Once configured, most applications can be launched directly from the Termux Widget or from dedicated 1x1 widget shortcuts without manually entering commands in Termux.

---

## Complete Installation

1. Install Termux.

2. Copy:

zip2app.sh

to the root of your internal storage.

3. Open Termux and run:

termux-setup-storage

Allow storage access when prompted.

Then run:

bash ~/storage/shared/zip2app.sh

zip2app will automatically create its working folders and install its own shortcut.

4. Run Setup

From the zip2app menu select:

9 = First-time Setup / Update Setup

This step is required before installing applications.

The setup will:

- Update Termux packages
- Upgrade installed packages
- Install required dependencies
- Refresh application shortcuts

5. Add the Termux Widget

Add the Termux Widget to your Android home screen.

zip2app and future applications will appear in the widget menu.

From this point on, most applications can be launched directly from the widget without manually entering commands in Termux.

---

## Termux Widget Shortcuts

Termux Widget can be used in two ways:

- As a list widget showing all available shortcuts
- As a 1x1 widget shortcut for launching one specific application

Before creating a 1x1 widget shortcut, the application shortcut must already be installed.

To do this, install the application with zip2app and make sure the shortcut has been created.

When adding a 1x1 Termux Widget to the Android home screen, Android will ask which shortcut should be assigned to it.

Select the application shortcut you want to launch.

A separate 1x1 widget must be created for each application shortcut you want on the home screen.

This allows applications installed through zip2app to be launched directly from the Android home screen with a single tap, similar to a traditional Android application.

---

## Installing Applications

Applications are installed directly from GitHub ZIP downloads.

On GitHub:

Code → Download ZIP

Copy downloaded ZIP files into:

zip2app_android/zip_files

located in the root of your internal storage.

Examples:

push2git_android-main.zip

yt2mp3_android-main.zip

wilbrand2bomb_android-main.zip

Then launch zip2app and select:

1 = Install apps from zip files

zip2app will automatically:

- Extract the ZIP
- Install the application
- Replace any previous version
- Create or update shortcuts
- Remove the processed ZIP file

No manual extraction is required.

---

## Updating Applications

To update an application:

1. Download the latest ZIP from GitHub.
2. Copy it into:

zip2app_android/zip_files

3. Run:

1 = Install apps from zip files

The previous installation will automatically be replaced.

---

## Menu

1 = Install apps from zip files

9 = First-time Setup / Update Setup

0 = Exit

---

## Automatic Maintenance

Every time zip2app starts, it automatically:

- Repairs its folder structure
- Updates shortcuts
- Removes obsolete shortcut entries
- Cleans temporary files
- Cleans invalid files from zip_files

Only valid ZIP files should remain inside:

zip2app_android/zip_files

---

## Folder Structure

zip2app_android/

---- zip2app.sh

---- zip2app_termuxshortcut.sh

---- zip_files/

-------- push2git_android-main.zip

-------- yt2mp3_android-main.zip

---

## Notes

Applications installed through zip2app automatically appear as Termux Widget shortcuts.

The same shortcut can be used from:

- The Termux Widget list
- A dedicated 1x1 widget shortcut

zip2app is designed to minimize manual Termux usage after the initial setup.

Most applications can be installed, updated and launched without manually navigating project folders or entering commands.

---

## Credits

Uses:

- Termux
- Termux Widget
- GitHub
- unzip

zip2app_android provides a simple installation and update system for Android Termux applications distributed through GitHub ZIP downloads.
