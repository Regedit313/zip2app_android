# zip2app_android

## What is zip2app?

zip2app_android is a simple installer for Android Termux applications.

It automatically installs applications downloaded from GitHub ZIP files and creates shortcuts for use with the Termux Widget.

Once configured, most applications can be launched directly from the widget without manually entering commands in Termux.

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

4. From the menu select:

9 = First-time Setup / Update Setup

This step is required before installing applications.

The setup will:

- Update Termux packages
- Upgrade installed packages
- Install required dependencies
- Refresh application shortcuts

5. Add the Termux Widget to your Android home screen.

zip2app and future applications will appear in the widget menu.

From this point on, most applications can be launched directly from the widget without manually entering commands in Termux.

---

## Menu

When started, zip2app.sh provides the following options:

1 = Install apps from zip files

9 = First-time Setup / Update Setup

0 = Exit

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

- Extract the ZIP file
- Locate the application folder
- Install the application
- Replace any previous version
- Create or update shortcuts
- Remove the processed ZIP file
- Refresh Termux Widget shortcuts

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

## Termux Widget

Applications installed through zip2app automatically create shortcuts for the Termux Widget.

If a newly installed application does not appear immediately:

Refresh the widget.

The shortcut will then become available.

---

## Folder Structure

### Folder Structure After First Launch

zip2app_android/

---- zip2app.sh

---- zip2app_termuxshortcut.sh

---- zip_files/

Place downloaded ZIP files inside:

zip2app_android/zip_files

---

## Automatic Maintenance

Every time zip2app starts, it automatically:

- Repairs its folder structure
- Updates Termux Widget shortcuts
- Removes obsolete shortcut entries
- Removes temporary extraction files
- Cleans invalid files from zip_files
- Recreates missing folders if required

Only valid ZIP files should remain inside:

zip2app_android/zip_files

Temporary extraction folders are automatically created only when needed and automatically removed when processing is finished.

---

## Notes

zip2app automatically installs itself into:

zip2app_android/

during the first launch.

A Termux Widget shortcut for zip2app is automatically created and updated.

Applications distributed as GitHub ZIP downloads can be installed without manually extracting archives.

Installed applications can provide their own Termux Widget shortcuts, which are automatically detected and refreshed by zip2app.

The setup option can safely be run again at any time to update packages, reinstall dependencies, or refresh shortcuts.

---

## Credits

Uses:

- Termux
- Termux Widget
- GitHub
- unzip

zip2app_android provides a simple installation and update system for Android Termux applications distributed through GitHub ZIP downloads.
