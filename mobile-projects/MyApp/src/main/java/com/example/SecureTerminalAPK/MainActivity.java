package com.example.SecureTerminalAPK;

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;

public class MainActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        // Create a simple text view
        TextView textView = new TextView(this);
        textView.setText("Hello from MyApp!");
        textView.setTextSize(24);
        setContentView(textView);
    }
}
