package com.example.SecureTerminalAPK;

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;
import android.widget.Switch;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.graphics.Color;
import android.graphics.Typeface;
import android.view.Gravity;
import android.content.SharedPreferences;

public class SettingsActivity extends Activity {
    private SharedPreferences prefs;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        prefs = getSharedPreferences("SecureTerminalPrefs", MODE_PRIVATE);

        ScrollView scrollView = new ScrollView(this);
        LinearLayout layout = new LinearLayout(this);
        layout.setOrientation(LinearLayout.VERTICAL);
        layout.setBackgroundColor(Color.parseColor("#1E1E1E"));
        layout.setPadding(40, 40, 40, 40);

        // Header
        TextView header = new TextView(this);
        header.setText("⚙️ Settings");
        header.setTextSize(28);
        header.setTextColor(Color.parseColor("#2196F3"));
        header.setTypeface(null, Typeface.BOLD);
        header.setGravity(Gravity.CENTER);
        header.setPadding(0, 20, 0, 40);
        layout.addView(header);

        // Settings options
        addSettingSwitch(layout, "Enable Logging", "logging_enabled", true);
        addSettingSwitch(layout, "Dark Theme", "dark_theme", true);
        addSettingSwitch(layout, "Auto-Save Commands", "auto_save", false);
        addSettingSwitch(layout, "Show Notifications", "notifications", true);
        addSettingSwitch(layout, "Debug Mode", "debug_mode", false);
        addSettingSwitch(layout, "Secure Mode", "secure_mode", false);

        // Info section
        addSpace(layout, 40);
        addInfoSection(layout, "App Version", "2.0");
        addInfoSection(layout, "Build Type", "Debug");
        addInfoSection(layout, "Package", "com.example.SecureTerminalAPK");

        // Back button
        addSpace(layout, 40);
        Button backButton = new Button(this);
        backButton.setText("← Back to Main");
        backButton.setTextColor(Color.WHITE);
        backButton.setBackgroundColor(Color.parseColor("#607D8B"));
        backButton.setPadding(20, 30, 20, 30);
        backButton.setOnClickListener(v -> finish());
        layout.addView(backButton);

        scrollView.addView(layout);
        setContentView(scrollView);
    }

    private void addSettingSwitch(LinearLayout layout, String label, String key, boolean defaultValue) {
        LinearLayout row = new LinearLayout(this);
        row.setOrientation(LinearLayout.HORIZONTAL);
        row.setPadding(0, 15, 0, 15);
        row.setBackgroundColor(Color.parseColor("#263238"));
        
        LinearLayout.LayoutParams rowParams = new LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            LinearLayout.LayoutParams.WRAP_CONTENT
        );
        rowParams.setMargins(0, 10, 0, 10);
        row.setLayoutParams(rowParams);

        TextView labelView = new TextView(this);
        labelView.setText(label);
        labelView.setTextSize(16);
        labelView.setTextColor(Color.parseColor("#E0E0E0"));
        labelView.setPadding(20, 10, 20, 10);
        
        LinearLayout.LayoutParams labelParams = new LinearLayout.LayoutParams(
            0,
            LinearLayout.LayoutParams.WRAP_CONTENT,
            1.0f
        );
        labelView.setLayoutParams(labelParams);
        row.addView(labelView);

        Switch switchView = new Switch(this);
        switchView.setChecked(prefs.getBoolean(key, defaultValue));
        switchView.setPadding(20, 10, 20, 10);
        switchView.setOnCheckedChangeListener((buttonView, isChecked) -> {
            prefs.edit().putBoolean(key, isChecked).apply();
        });
        row.addView(switchView);

        layout.addView(row);
    }

    private void addInfoSection(LinearLayout layout, String label, String value) {
        LinearLayout row = new LinearLayout(this);
        row.setOrientation(LinearLayout.HORIZONTAL);
        row.setPadding(20, 10, 20, 10);

        TextView labelView = new TextView(this);
        labelView.setText(label + ": ");
        labelView.setTextSize(14);
        labelView.setTextColor(Color.parseColor("#B0BEC5"));
        row.addView(labelView);

        TextView valueView = new TextView(this);
        valueView.setText(value);
        valueView.setTextSize(14);
        valueView.setTextColor(Color.parseColor("#00E676"));
        valueView.setTypeface(null, Typeface.BOLD);
        row.addView(valueView);

        layout.addView(row);
    }

    private void addSpace(LinearLayout layout, int height) {
        TextView space = new TextView(this);
        space.setHeight(height);
        layout.addView(space);
    }
}
