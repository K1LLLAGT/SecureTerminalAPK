package com.example.SecureTerminalAPK;

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;
import android.widget.LinearLayout;
import android.widget.Button;
import android.graphics.Color;
import android.view.Gravity;

public class MainActivity extends Activity {
    private String currentMode = "Research";
    private TextView statusView;
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        LinearLayout layout = new LinearLayout(this);
        layout.setOrientation(LinearLayout.VERTICAL);
        layout.setGravity(Gravity.CENTER);
        layout.setPadding(40, 40, 40, 40);
        layout.setBackgroundColor(Color.parseColor("#F5F5F5"));

        // Title
        TextView titleView = new TextView(this);
        titleView.setText("SecureTerminalAPK\nVersion 1.0");
        titleView.setTextSize(28);
        titleView.setTextColor(Color.parseColor("#2E7D32"));
        titleView.setGravity(Gravity.CENTER);
        titleView.setPadding(0, 0, 0, 40);
        layout.addView(titleView);

        // Status Display
        statusView = new TextView(this);
        updateStatus();
        statusView.setTextSize(18);
        statusView.setTextColor(Color.parseColor("#424242"));
        statusView.setGravity(Gravity.CENTER);
        statusView.setPadding(0, 0, 0, 40);
        layout.addView(statusView);

        // Mode Buttons
        addModeButton(layout, "Research Mode");
        addModeButton(layout, "Development Mode");
        addModeButton(layout, "Production Mode");
        addModeButton(layout, "Training Mode");
        addModeButton(layout, "Monitoring Mode");
        addModeButton(layout, "Debug Mode");
        addModeButton(layout, "Secure Mode");
        addModeButton(layout, "Testing Mode");

        setContentView(layout);
    }

    private void addModeButton(LinearLayout layout, String modeName) {
        Button button = new Button(this);
        button.setText(modeName);
        button.setTextColor(Color.WHITE);
        button.setBackgroundColor(Color.parseColor("#2E7D32"));
        button.setPadding(20, 20, 20, 20);
        
        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            LinearLayout.LayoutParams.WRAP_CONTENT
        );
        params.setMargins(0, 10, 0, 10);
        button.setLayoutParams(params);

        button.setOnClickListener(v -> {
            currentMode = modeName.replace(" Mode", "");
            updateStatus();
        });

        layout.addView(button);
    }

    private void updateStatus() {
        statusView.setText("Status: Active\nCurrent Mode: " + currentMode + "\nLogging: Enabled");
    }
}
