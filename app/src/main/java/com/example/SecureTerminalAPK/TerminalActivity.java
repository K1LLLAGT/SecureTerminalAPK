package com.example.SecureTerminalAPK;

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;
import android.widget.EditText;
import android.widget.Button;
import android.widget.ScrollView;
import android.widget.LinearLayout;
import android.graphics.Color;
import android.graphics.Typeface;
import android.view.Gravity;
import java.io.BufferedReader;
import java.io.InputStreamReader;

public class TerminalActivity extends Activity {
    private TextView outputView;
    private EditText commandInput;
    private StringBuilder outputText = new StringBuilder();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        LinearLayout mainLayout = new LinearLayout(this);
        mainLayout.setOrientation(LinearLayout.VERTICAL);
        mainLayout.setBackgroundColor(Color.parseColor("#1E1E1E"));
        mainLayout.setPadding(20, 20, 20, 20);

        // Header
        TextView header = new TextView(this);
        header.setText("🖥️ SecureTerminal");
        header.setTextSize(24);
        header.setTextColor(Color.parseColor("#00E676"));
        header.setTypeface(null, Typeface.BOLD);
        header.setGravity(Gravity.CENTER);
        header.setPadding(0, 20, 0, 30);
        mainLayout.addView(header);

        // Output area
        ScrollView scrollView = new ScrollView(this);
        outputView = new TextView(this);
        outputView.setText("SecureTerminal v2.0\nType commands below...\n\n");
        outputView.setTextSize(14);
        outputView.setTextColor(Color.parseColor("#00E676"));
        outputView.setBackgroundColor(Color.parseColor("#0D0D0D"));
        outputView.setPadding(20, 20, 20, 20);
        outputView.setTypeface(Typeface.MONOSPACE);
        
        LinearLayout.LayoutParams scrollParams = new LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            0,
            1.0f
        );
        scrollView.setLayoutParams(scrollParams);
        scrollView.addView(outputView);
        mainLayout.addView(scrollView);

        // Command input area
        LinearLayout inputLayout = new LinearLayout(this);
        inputLayout.setOrientation(LinearLayout.HORIZONTAL);
        inputLayout.setPadding(0, 20, 0, 0);

        commandInput = new EditText(this);
        commandInput.setHint("Enter command...");
        commandInput.setTextColor(Color.parseColor("#E0E0E0"));
        commandInput.setHintTextColor(Color.parseColor("#757575"));
        commandInput.setBackgroundColor(Color.parseColor("#263238"));
        commandInput.setPadding(20, 20, 20, 20);
        commandInput.setTypeface(Typeface.MONOSPACE);
        
        LinearLayout.LayoutParams inputParams = new LinearLayout.LayoutParams(
            0,
            LinearLayout.LayoutParams.WRAP_CONTENT,
            1.0f
        );
        commandInput.setLayoutParams(inputParams);
        inputLayout.addView(commandInput);

        // Execute button
        Button execButton = new Button(this);
        execButton.setText("▶");
        execButton.setTextSize(20);
        execButton.setTextColor(Color.WHITE);
        execButton.setBackgroundColor(Color.parseColor("#00E676"));
        execButton.setPadding(40, 20, 40, 20);
        execButton.setOnClickListener(v -> executeCommand());
        inputLayout.addView(execButton);

        mainLayout.addView(inputLayout);

        // Button row
        LinearLayout buttonRow = new LinearLayout(this);
        buttonRow.setOrientation(LinearLayout.HORIZONTAL);
        buttonRow.setPadding(0, 10, 0, 0);

        Button clearButton = new Button(this);
        clearButton.setText("Clear");
        clearButton.setTextColor(Color.WHITE);
        clearButton.setBackgroundColor(Color.parseColor("#FF5722"));
        clearButton.setLayoutParams(new LinearLayout.LayoutParams(
            0,
            LinearLayout.LayoutParams.WRAP_CONTENT,
            1.0f
        ));
        clearButton.setOnClickListener(v -> clearOutput());
        buttonRow.addView(clearButton);

        Button backButton = new Button(this);
        backButton.setText("← Back");
        backButton.setTextColor(Color.WHITE);
        backButton.setBackgroundColor(Color.parseColor("#607D8B"));
        backButton.setLayoutParams(new LinearLayout.LayoutParams(
            0,
            LinearLayout.LayoutParams.WRAP_CONTENT,
            1.0f
        ));
        backButton.setOnClickListener(v -> finish());
        buttonRow.addView(backButton);

        mainLayout.addView(buttonRow);
        setContentView(mainLayout);
    }

    private void executeCommand() {
        String command = commandInput.getText().toString().trim();
        if (command.isEmpty()) return;

        appendOutput("$ " + command + "\n");
        commandInput.setText("");

        try {
            Process process = Runtime.getRuntime().exec(command);
            BufferedReader reader = new BufferedReader(
                new InputStreamReader(process.getInputStream()));
            BufferedReader errorReader = new BufferedReader(
                new InputStreamReader(process.getErrorStream()));

            String line;
            while ((line = reader.readLine()) != null) {
                appendOutput(line + "\n");
            }
            while ((line = errorReader.readLine()) != null) {
                appendOutput("ERROR: " + line + "\n");
            }

            int exitCode = process.waitFor();
            if (exitCode != 0) {
                appendOutput("Exit code: " + exitCode + "\n");
            }
            appendOutput("\n");
        } catch (Exception e) {
            appendOutput("Error: " + e.getMessage() + "\n\n");
        }
    }

    private void appendOutput(String text) {
        outputText.append(text);
        outputView.setText(outputText.toString());
    }

    private void clearOutput() {
        outputText = new StringBuilder();
        outputView.setText("Output cleared.\n\n");
    }
}
