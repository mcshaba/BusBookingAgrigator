package com.cyberspace.safejourney;

import androidx.appcompat.app.AppCompatActivity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.cyberspace.cyberpaysdk.CyberpaySdk;
import com.cyberspace.cyberpaysdk.TransactionCallback;
import com.cyberspace.cyberpaysdk.enums.Mode;
import com.cyberspace.cyberpaysdk.model.Booking;
import com.cyberspace.cyberpaysdk.model.Split;
import com.cyberspace.cyberpaysdk.model.Transaction;
import com.cyberspace.cyberpaysdk.utils.fonts.Bold;

import java.nio.ByteBuffer;

import io.flutter.plugin.common.MethodChannel;

public class PaymentActivity extends AppCompatActivity {

    Booking booking;
    Transaction transaction;
    MethodChannel methodChannel;

    private TextView customer_email_value;
    private TextView customer_name_value;
    private TextView customer_phone_value;
    private String CHANNEL = "com.startActivity/testChannel";

    private Button button;
    private String integrationKey;
//    private BusSchedule split;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_payment);

        customer_email_value = findViewById(R.id.customer_email_value);
        customer_name_value = findViewById(R.id.customer_name_value);
        customer_phone_value = findViewById(R.id.customer_phone_value);
        button = findViewById(R.id.make_payment);
        transaction = new Transaction();


        Intent intent = getIntent();
        if(intent.getExtras() != null){
            booking = (Booking) intent.getSerializableExtra("safejourney");
            integrationKey =  intent.getStringExtra("integrationKey");
//            split = (BusSchedule) intent.getSerializableExtra("splits");

            transaction.setAmount(booking.getAmount() * 100);
            transaction.setCustomerEmail(booking.getCustomerEmail());
            transaction.setDescription(booking.getDescription());
            transaction.setSplits(booking.getSplits());

            button.setText(String.format("%s%s", button.getText(), booking.getAmount()));
            customer_name_value.setText(String.format("%s", booking.getCustomerName()));
            customer_email_value.setText(String.format("%s", booking.getCustomerEmail()));
            customer_phone_value.setText(String.format("%s", booking.getPhoneNumber()));

        }

        CyberpaySdk.INSTANCE.initialiseSdk(integrationKey, Mode.Live);
        CyberpaySdk.INSTANCE.setMerchantLogo(getResources().getDrawable(R.drawable.ic_cyberpay_logo));

        booking = new Booking();
    }

    public void makePayment(View view) {
        CyberpaySdk.INSTANCE.checkoutTransaction(this, transaction, new TransactionCallback() {
            @Override
            public void onSuccess(Transaction transaction) {
                Log.e("RESPONSE", "SUCCESSFUL");

                Intent returnIntent = getIntent();
                returnIntent.putExtra("result", transaction.getReference());
                setResult(Activity.RESULT_OK, returnIntent);
                finish();
            }

            @Override
            public void onError(Transaction transaction, Throwable throwable) {
                Log.e("ERROR", throwable.getMessage());
            }

            @Override
            public void onValidate(Transaction transaction) {

            }
        });
    }

}
