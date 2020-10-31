package com.example.hackortreattest;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;

import androidx.appcompat.app.AppCompatActivity;

import io.radar.sdk.Radar;

public class FindActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_findlocation);
        Radar.initialize(this, "prj_live_pk_594c21a79f7a0e13e197c2e6eb61d08cd90250e3");

    }
    public void backHome(View view){
        Intent intent = new Intent(FindActivity.this, MainActivity.class);

        // start the activity connect to the specified class
        startActivity(intent);
    }
}
