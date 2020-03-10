package com.cyberspace.safejourney;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

import com.cyberspace.cyberpaysdk.model.Booking;
import com.cyberspace.cyberpaysdk.model.Split;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodChannel;


public class MainActivity extends FlutterActivity {
    private String CHANNEL = "com.startActivity/testChannel";
    Booking booking;
    MethodChannel methodChannel;

    int RESULT_CODE = 1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        booking = new Booking();

        methodChannel = new MethodChannel(getFlutterView(), CHANNEL);
        methodChannel.setMethodCallHandler((call, result) -> {
            switch (call.method) {
                case "chargeCard":

                    Map arguments = call.arguments();

                    Map scheduleMap = (Map) arguments.get("schedule");
                    String integrationKey = (String) scheduleMap.get("integrationKey");

                    booking.setAmount((Double) arguments.get("tripAmount"));
                    booking.setCustomerEmail((String) arguments.get("passengerEmail"));
                    booking.setCustomerName((String) arguments.get("passengerName"));
                    booking.setPhoneNumber((String) arguments.get("passengerPhone"));
                    List<Split> splits = (List<Split>) scheduleMap.get("MySplit");

                    booking.setSplits(splits);

                    Intent intent = new Intent(MainActivity.this, PaymentActivity.class);
                    intent.putExtra("safejourney", booking);
                    intent.putExtra("integrationKey", integrationKey);
                    startActivityForResult(intent, RESULT_CODE);
                    //result.success("SUCCESS");

                default:
                    result.notImplemented();
            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == RESULT_CODE) {
            if (resultCode == Activity.RESULT_OK) {
                String result = data.getStringExtra("result");
                methodChannel.invokeMethod("onSuccess", result);
            }
        }
        super.onActivityResult(requestCode, resultCode, data);
    }

}



