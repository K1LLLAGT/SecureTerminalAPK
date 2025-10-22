# Mobile Development Quick Reference

## Creating New Project
```bash
new-android-project MyApp com.example.myapp
```

## Building APK
```bash
cd ~/SecureTerminalAPK/mobile-projects/MyApp
build-apk .
```

## Analyzing APK
```bash
analyze-apk my-app.apk
```

## Checking Permissions
```bash
check-permissions my-app.apk
```

## AI-Assisted Development
```bash
# Start Claude integration
python ~/claude_terminal.py interactive

# Example prompts:
# - "Help me build an Android activity"
# - "Review my MainActivity code"
# - "How do I add a button to my layout?"
# - "Explain Android lifecycle methods"
```

## Useful Commands
```bash
# Navigate to projects
cdmobile

# View logs
view-logs

# Consolidate logs
consolidate-logs
```

## Project Structure
```
mobile-projects/
├── MyApp/
│   ├── src/main/
│   │   ├── java/
│   │   ├── res/
│   │   └── AndroidManifest.xml
│   └── build.gradle
├── templates/
└── builds/
```
