package com.intern.finemart;
import androidx.annotation.NonNull;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.embedding.android.FlutterActivity;
import org.json.JSONObject;
import org.json.JSONException;
import com.paytm.pgsdk.PaytmOrder;
import com.paytm.pgsdk.PaytmPaymentTransactionCallback;
import com.paytm.pgsdk.TransactionManager;
import java.util.Set;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "samples.flutter.dev/payment";
    protected static final int REQ_CODE = 0;
    Result paytmResult;

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
  super.configureFlutterEngine(flutterEngine);
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
        .setMethodCallHandler(
          (call, result) -> { 
            try{
              if (call.method.equals("getPaytm")) {
                paytmResult = result;
                JSONObject info = new JSONObject(call.arguments.toString());
                PaytmOrder paytmOrder = new PaytmOrder(info.getString("orderId"),info.getString("mid"),info.getString("token"),info.getString("amount"),info.getString("callback"));
                TransactionManager transactionManager = new TransactionManager(paytmOrder, new PaytmPaymentTransactionCallback(){
                  @Override
                  public void onTransactionResponse(Bundle paramBundle) {
                    JSONObject json = new JSONObject();
                    Set<String> keys = paramBundle.keySet();
                    for (String key : keys) {
                        try {
                            // json.put(key, bundle.get(key)); see edit below
                            json.put(key, JSONObject.wrap(paramBundle.get(key)));
                        } catch(JSONException e) {
                            //Handle exception here
                        }
                    }
                    result.success(json.toString());
                  }
                  @Override
                  public void networkNotAvailable() {
                    result.success("No Network");
                  }
                  @Override
                  public void onErrorProceed(String s) {
                    result.success(s);
                  }
                  @Override
                  public void clientAuthenticationFailed(String s) {
                    result.success(s);
                  }
                  @Override
                  public void someUIErrorOccurred(String s) {
                    result.success(s);
                  }     
                  @Override
                  public void onErrorLoadingWebPage(int test1, String test2, String inFailingUrl) {
                    result.success(inFailingUrl);
                  }
                  @Override
                  public void onBackPressedCancelTransaction() {
                    result.success("TransactionCancelled");
                  }
                  @Override
                  public void onTransactionCancel(String s, Bundle bundle) {
                    result.success(s);
                  }
                });
                transactionManager.setShowPaymentUrl("https://securegw-stage.paytm.in/theia/api/v1/showPaymentPage");
                transactionManager.startTransaction(this, REQ_CODE);
              } else {
                result.notImplemented();
              }
            }
            catch(JSONException e){
                result.success(e.toString());
            }            
            }
        );
  }
  @Override
  protected void onActivityResult(int requestCode, int resultCode, Intent data) {
      super.onActivityResult(requestCode, resultCode, data);
      if (requestCode == REQ_CODE && data != null) { 
       paytmResult.success(data.getStringExtra("nativeSdkForMerchantMessage") + data.getStringExtra("response"));
    }
}
}
