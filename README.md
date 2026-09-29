# Macnim

![Macnim app preview](./Docs/images/appPreview.png)

Macnim is a macOS app that lets you set animated video wallpapers on your desktop displays. It supports multiple monitors, per-display configuration, and a simple library of wallpapers that can be managed from the app.

## How the app works

At startup, the app initializes three core components:

- AppSettings: stores the app's preferences such as appearance and launch-at-login behavior.
- WallpaperRepository: manages the wallpaper library and saved display assignments in the user's Application Support directory.
- WallpaperScreenManager: discovers each connected display and attaches a wallpaper layer for that screen.

Once those services are ready, the app synchronizes saved wallpaper setups across the active displays. Each monitor can display a chosen video, with settings for:

- fit style
- playback speed
- volume
- wallpaper assignment per display

The app UI is organized into a few main sections:

- Wallpapers: browse available wallpapers and assign them to screens
- Favourites: keep a quick-access list of preferred wallpapers
- Displays: manage monitor-level wallpaper settings and display-specific behavior
- Settings: control app appearance and startup preferences

The repository also loads bundled default wallpapers on first launch if no wallpapers have been created yet, so the app has content ready to use immediately.

## Installation

1. Go to the latest release on GitHub.
2. Download the .dmg file for the app.
3. Open the downloaded .dmg.
4. Drag the Macnim app into your Applications folder.
5. Open the app from Applications.

## If macOS says the app cannot be verified

If you get a message saying the app cannot be verified or is blocked by macOS security:

1. Open System Settings.
2. Go to Privacy & Security.
3. Scroll to the security warning for Macnim.
4. Click Open Anyway.
5. Confirm the prompt to allow the app to launch.

After that, you should be able to open the app normally.

## Notes

Macnim stores wallpaper data under the user's Application Support folder so your wallpaper library and display preferences persist between launches.

This app is designed for macOS and is intended to run as a desktop wallpaper manager for one or more screens.
