package com.example.hackortreattest;

import android.content.Intent;
import android.location.Location;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import io.radar.sdk.Radar;
import io.radar.sdk.model.RadarAddress;
import io.radar.sdk.model.RadarEvent;
import io.radar.sdk.model.RadarUser;

public class InputActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_setlocation);
        Radar.initialize(this, "prj_live_pk_594c21a79f7a0e13e197c2e6eb61d08cd90250e3");

    }
    public void backHome(View view){
        Intent intent = new Intent(InputActivity.this, MainActivity.class);

        // start the activity connect to the specified class
        startActivity(intent);
    }
    public void getLocation(View view){
        EditText input = findViewById(R.id.enterText);
        TextView locText = findViewById(R.id.location);
        System.out.println("clicked");
//        Radar.trackOnce(new Radar.RadarLocationCallback() {
//            @Override
//            public void onComplete(Radar.RadarStatus status, Location location, RadarEvent[] events, RadarUser user) {
//                // do something with location, events, user
//            }
//        });
//        Radar.ipGeocode((status, address) -> {
//            locText.setText(address.getState());
//        });
    }
}
