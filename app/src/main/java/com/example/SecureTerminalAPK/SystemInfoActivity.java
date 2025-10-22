package com.example.SecureTerminalAPK;

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.graphics.Color;
import android.graphics.Typeface;
import android.view.Gravity;
import android.os.Build;
import java.io.BufferedReader;
import java.io.InputStreamReader;

public class SystemInfoActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        ScrollView scrollView = new ScrollView(this);
        LinearLayout layout = new LinearLayout(this);
        layout.setOrientation(LinearLayout.VERTICAL);
        layout.setBackgroundColor(Color.parseColor("#1E1E1E"));
        layout.setPadding(40, 40, 40, 40);

        // Header
        TextView header = new TextView(this);
        header.setText("📊 System Information");
        header.setTextSize(24);
        header.setTextColor(Color.parseColor("#FF9800"));
        header.setTypeface(null, Typeface.BOLD);
        header.setGravity(Gravity.CENTER);
        header.setPadding(0, 20, 0, 40);
        layout.addView(header);

        // Device Info
        addInfoCard(layout, "📱 DEVICE INFO");
        addInfoRow(layout, "Device", Build.DEVICE);
        addInfoRow(layout, "Model", Build.MODEL);
        addInfoRow(layout, "Manufacturer", Build.MANUFACTURER);
        addInfoRow(layout, "Brand", Build.BRAND);

        addSpace(layout, 20);

        // Android Info
        addInfoCard(layout, "🤖 ANDROID INFO");
        addInfoRow(layout, "Version", Build.VERSION.RELEASE);
        addInfoRow(layout, "SDK", String.valueOf(Build.VERSION.SDK_INT));
        addInfoRow(layout, "Build ID", Build.ID);

        addSpace(layout, 20);

        // Hardware Info
        addInfoCard(layout, "⚙️ HARDWARE");
        addInfoRow(layout, "CPU ABI", Build.SUPPORTED_ABIS[0]);
        addInfoRow(layout, "Board", Build.BOARD);
        addInfoRow(layout, "Hardware", Build.HARDWARE);

        addSpace(layout, 20);

        // Memory Info
        addInfoCard(layout, "💾 MEMORY");
        Runtime runtime = Runtime.getRuntime();
        long maxMemory = runtime.maxMemory() / 1024 / 1024;
        long totalMemory = runtime.totalMemory() / 1024 / 1024;
        long freeMemory = runtime.freeMemory() / 1024 / 1024;
        addInfoRow(layout, "Max Memory", maxMemory + " MB");
        addInfoRow(layout, "Total Memory", totalMemory + " MB");
        addInfoRow(layout, "Free Memory", freeMemory + " MB");

        // Back button
        addSpace(layout, 40);
        Button backButton = new Button(this);
        backButton.setText("← Back");
        backButton.setTextColor(Color.WHITE);
        backButton.setBackgroundColor(Color.parseColor("#607D8B"));
        backButton.setPadding(20, 30, 20, 30);
        backButton.setOnClickListener(v -> finish());
        layout.addView(backButton);

        scrollView.addView(layout);
        setContentView(scrollView);
    }

    private void addInfoCard(LinearLayout layout, String title) {
        TextView cardTitle = new TextView(this);
        cardTitle.setText(title);
        cardTitle.setTextSize(18);
        cardTitle.setTextColor(Color.parseColor("#FF9800"));
        cardTitle.setTypeface(null, Typeface.BOLD);
        cardTitle.setPadding(10, 10, 10, 20);
        layout.addView(cardTitle);
    }

    private void addInfoRow(LinearLayout layout, String label, String value) {
        LinearLayout row = new LinearLayout(this);
        row.setOrientation(LinearLayout.HORIZONTAL);
        row.setPadding(20, 10, 20, 10);
        row.setBackgroundColor(Color.parseColor("#263238"));
        
        LinearLayout.LayoutParams rowParams = new LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            LinearLayout.LayoutParams.WRAP_CONTENT
        );
        rowParams.setMargins(0, 5, 0, 5);
        row.setLayoutParams(rowParams);

        TextView labelView = new TextView(this);
        labelView.setText(label + ":");
        labelView.setTextSize(14);
        labelView.setTextColor(Color.parseColor("#B0BEC5"));
        labelView.setPadding(0, 0, 20, 0);
        
        LinearLayout.LayoutParams labelParams = new LinearLayout.LayoutParams(
            0,
            LinearLayout.LayoutParams.WRAP_CONTENT,
            0.4f
        );
        labelView.setLayoutParams(labelParams);
        row.addView(labelView);

        TextView valueView = new TextView(this);
        valueView.setText(value);
        valueView.setTextSize(14);
        valueView.setTextColor(Color.parseColor("#E0E0E0"));
        valueView.setTypeface(Typeface.MONOSPACE);
        
        LinearLayout.LayoutParams valueParams = new LinearLayout.LayoutParams(
            0,
            LinearLayout.LayoutParams.WRAP_CONTENT,
            0.6f
        );
        valueView.setLayoutParams(valueParams);
        row.addView(valueView);

        layout.addView(row);
    }

    private void addSpace(LinearLayout layout, int height) {
        TextView space = new TextView(this);
        space.setHeight(height);
        layout.addView(space);
    }
}
