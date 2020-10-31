package com.example.hackortreattest;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.widget.EditText;
import android.widget.TextView;
import android.view.View;

import io.radar.sdk.Radar;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Radar.initialize(this, "prj_live_pk_594c21a79f7a0e13e197c2e6eb61d08cd90250e3");

    }

    public void findScreen(View view){
        Intent intent = new Intent(MainActivity.this, FindActivity.class);

        // start the activity connect to the specified class
        startActivity(intent);
    }
    public void inputScreen(View view){
        Intent intent = new Intent(MainActivity.this, InputActivity.class);

        // start the activity connect to the specified class
        startActivity(intent);
    }


}