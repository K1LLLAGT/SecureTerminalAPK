#!/bin/bash
# Android Project Template Generator

PROJECT_NAME="$1"
PACKAGE_NAME="$2"

if [ -z "$PROJECT_NAME" ] || [ -z "$PACKAGE_NAME" ]; then
    echo "Usage: create-project.sh <ProjectName> <com.example.package>"
    exit 1
fi

PROJECT_DIR="$HOME/SecureTerminalAPK/mobile-projects/$PROJECT_NAME"

echo "Creating Android project: $PROJECT_NAME"
echo "Package: $PACKAGE_NAME"

mkdir -p "$PROJECT_DIR"/{src/main/{java,res,assets},gradle}

# Create package directory structure
PACKAGE_PATH=$(echo $PACKAGE_NAME | tr '.' '/')
mkdir -p "$PROJECT_DIR/src/main/java/$PACKAGE_PATH"

# Create MainActivity
cat > "$PROJECT_DIR/src/main/java/$PACKAGE_PATH/MainActivity.java" << MAINACTIVITY
package $PACKAGE_NAME;

import android.app.Activity;
import android.os.Bundle;

public class MainActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // TODO: Set content view
    }
}
MAINACTIVITY

# Create AndroidManifest.xml
cat > "$PROJECT_DIR/src/main/AndroidManifest.xml" << MANIFEST
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="$PACKAGE_NAME">
    
    <application
        android:label="$PROJECT_NAME"
        android:theme="@android:style/Theme.Material.Light">
        
        <activity android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>
MANIFEST

# Create build.gradle
cat > "$PROJECT_DIR/build.gradle" << GRADLE
apply plugin: 'com.android.application'

android {
    compileSdkVersion 33
    
    defaultConfig {
        applicationId "$PACKAGE_NAME"
        minSdkVersion 21
        targetSdkVersion 33
        versionCode 1
        versionName "1.0"
    }
}
GRADLE

echo "✓ Project created: $PROJECT_DIR"
echo ""
echo "Next steps:"
echo "  cd $PROJECT_DIR"
echo "  # Edit your code"
echo "  # Build with: build-apk.sh ."
