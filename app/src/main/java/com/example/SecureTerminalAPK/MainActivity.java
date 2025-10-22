package com.example.SecureTerminalAPK;

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;
import android.widget.LinearLayout;
import android.widget.Button;
import android.widget.ScrollView;
import android.graphics.Color;
import android.view.Gravity;
import android.content.Intent;
import android.graphics.Typeface;

public class MainActivity extends Activity {
    private String currentMode = "Research";
    private TextView statusView;
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        ScrollView scrollView = new ScrollView(this);
        LinearLayout layout = new LinearLayout(this);
        layout.setOrientation(LinearLayout.VERTICAL);
        layout.setGravity(Gravity.CENTER);
        layout.setPadding(40, 40, 40, 40);
        layout.setBackgroundColor(Color.parseColor("#1E1E1E"));

        // App Title
        TextView titleView = new TextView(this);
        titleView.setText("🔐 SecureTerminalAPK");
        titleView.setTextSize(32);
        titleView.setTextColor(Color.parseColor("#00E676"));
        titleView.setGravity(Gravity.CENTER);
        titleView.setTypeface(null, Typeface.BOLD);
        titleView.setPadding(0, 0, 0, 20);
        layout.addView(titleView);

        // Version
        TextView versionView = new TextView(this);
        versionView.setText("Version 2.0 - Enhanced Edition");
        versionView.setTextSize(14);
        versionView.setTextColor(Color.parseColor("#B0BEC5"));
        versionView.setGravity(Gravity.CENTER);
        versionView.setPadding(0, 0, 0, 40);
        layout.addView(versionView);

        // Status Display
        statusView = new TextView(this);
        updateStatus();
        statusView.setTextSize(16);
        statusView.setTextColor(Color.parseColor("#E0E0E0"));
        statusView.setGravity(Gravity.CENTER);
        statusView.setPadding(20, 20, 20, 20);
        statusView.setBackgroundColor(Color.parseColor("#263238"));
        layout.addView(statusView);

        // Spacing
        addSpace(layout, 30);

        // Section: Main Features
        addSectionHeader(layout, "🚀 MAIN FEATURES");
        
        addFeatureButton(layout, "🖥️ Terminal", "#00E676", () -> {
            Intent intent = new Intent(MainActivity.this, TerminalActivity.class);
            startActivity(intent);
        });

        addFeatureButton(layout, "⚙️ Settings", "#2196F3", () -> {
            Intent intent = new Intent(MainActivity.this, SettingsActivity.class);
            startActivity(intent);
        });

        addFeatureButton(layout, "📊 System Info", "#FF9800", () -> {
            Intent intent = new Intent(MainActivity.this, SystemInfoActivity.class);
            startActivity(intent);
        });

        // Spacing
        addSpace(layout, 30);

        // Section: Operation Modes
        addSectionHeader(layout, "🎯 OPERATION MODES");
        
        addModeButton(layout, "Research Mode", "#4CAF50");
        addModeButton(layout, "Development Mode", "#2196F3");
        addModeButton(layout, "Production Mode", "#F44336");
        addModeButton(layout, "Training Mode", "#FF9800");
        addModeButton(layout, "Monitoring Mode", "#9C27B0");
        addModeButton(layout, "Debug Mode", "#FF5722");
        addModeButton(layout, "Secure Mode", "#00BCD4");
        addModeButton(layout, "Testing Mode", "#CDDC39");

        scrollView.addView(layout);
        setContentView(scrollView);
    }

    private void addSectionHeader(LinearLayout layout, String text) {
        TextView header = new TextView(this);
        header.setText(text);
        header.setTextSize(18);
        header.setTextColor(Color.parseColor("#00E676"));
        header.setTypeface(null, Typeface.BOLD);
        header.setPadding(0, 10, 0, 20);
        layout.addView(header);
    }

    private void addSpace(LinearLayout layout, int height) {
        TextView space = new TextView(this);
        space.setHeight(height);
        layout.addView(space);
    }

    private void addFeatureButton(LinearLayout layout, String text, String color, Runnable action) {
        Button button = new Button(this);
        button.setText(text);
        button.setTextColor(Color.WHITE);
        button.setTextSize(18);
        button.setBackgroundColor(Color.parseColor(color));
        button.setPadding(20, 30, 20, 30);
        button.setTypeface(null, Typeface.BOLD);
        
        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            LinearLayout.LayoutParams.WRAP_CONTENT
        );
        params.setMargins(0, 10, 0, 10);
        button.setLayoutParams(params);

        button.setOnClickListener(v -> action.run());
        layout.addView(button);
    }

    private void addModeButton(LinearLayout layout, String modeName, String color) {
        Button button = new Button(this);
        button.setText(modeName);
        button.setTextColor(Color.WHITE);
        button.setBackgroundColor(Color.parseColor(color));
        button.setPadding(20, 20, 20, 20);
        
        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            LinearLayout.LayoutParams.WRAP_CONTENT
        );
        params.setMargins(0, 8, 0, 8);
        button.setLayoutParams(params);

        button.setOnClickListener(v -> {
            currentMode = modeName.replace(" Mode", "");
            updateStatus();
        });

        layout.addView(button);
    }

    private void updateStatus() {
        statusView.setText("🟢 Status: Active\n💼 Mode: " + currentMode + "\n📝 Logging: Enabled");
    }
}
