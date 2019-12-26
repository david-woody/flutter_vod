package com.uni4m.flutter_vod;

import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import android.util.Log;

import com.uni4m.flutter_vod.videoupload.Signature;
import com.uni4m.flutter_vod.videoupload.impl.RequestClient;
import com.uni4m.flutter_vod.videoupload.impl.UGCClient;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.Random;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.Response;

/**
 * FlutterVodPlugin
 */
public class FlutterVodPlugin implements MethodCallHandler {
    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "com.uni4m/flutter_vod");
        channel.setMethodCallHandler(new FlutterVodPlugin(registrar, channel));
    }

    private final String TAG = "FlutterVodPlugin";

    private Registrar registrar;
    private MethodChannel channel;
    private Handler mainHandler;
    public FlutterVodPlugin(Registrar registrar, MethodChannel channel) {
        this.registrar = registrar;
        this.channel = channel;
        flutterVodUploadHandler.setRegistrar(registrar);
        flutterVodUploadHandler.setChannel(channel);
        mainHandler = new Handler(Looper.getMainLooper());
    }



    private FlutterVodUploadHandler flutterVodUploadHandler = new FlutterVodUploadHandler();
    private String mSignature = "";

    @Override
    public void onMethodCall(MethodCall methodCall, final Result result) {
        if (methodCall.method.equals("getSignature")) {
            String requestUrl = methodCall.argument("requestUrl");
            String httpServerAddr = methodCall.argument("httpServerAddr");
            RequestClient.getInstance(httpServerAddr, requestUrl, 2000).getSignature(new Callback() {
                @Override
                public void onFailure(Call call, IOException e) {
                    result.error("Get signature failed","Please check your api!",null);
                }

                @Override
                public void onResponse(Call call, Response response) throws IOException {
                    Log.i("FlutterVodPlugin", "getSignature resp:" + response.message());
                    if (response.isSuccessful()) {
                        parseGetSignatureRsp(response.body().string(),result);
                    }else{
                        result.error("Get signature failed","Please check your api!",null);
                    }
                }
            });


        } else if (methodCall.method.equals("initVod")) {
            String signature = methodCall.argument("signature");
            if (TextUtils.isEmpty(signature)) {
                result.error("invalid signature", "are you sure your signature is empty?", null);
            } else {
                mSignature = signature;
            }
            result.success(mSignature);
        } else if (methodCall.method.equals("uploadVideo")) {
            flutterVodUploadHandler.setSignature(mSignature);
            flutterVodUploadHandler.uploadVideo(methodCall, result);
        } else {
            result.notImplemented();
        }
    }

    private void parseGetSignatureRsp(String rspString, final Result result) {
        Log.i(TAG, "parseGetSignatureRsp->response is " + rspString);
        if (TextUtils.isEmpty(rspString)){
            result.error("Get signature failed","Please check your api response,is the right format!!",null);
            return;
        }
        try {
            JSONObject jsonRsp = new JSONObject(rspString);
            int code = jsonRsp.optInt("code", -1);
            if (0 != code) {
                result.error("Get signature failed","Please check your api response,is the right format!!",null);
                return;
            }
            JSONObject dataRsp = jsonRsp.getJSONObject("data");
            final String signature = dataRsp.optString("signature", "");
            mainHandler.post(new Runnable() {
                @Override
                public void run() {
                    result.success(signature);
                }
            });
        } catch (JSONException e) {
            Log.e(TAG, e.toString());
            mainHandler.post(new Runnable() {
                @Override
                public void run() {
                    result.error("Get signature failed","Please check your api response,is the right format!!",null);
                }
            });
            return;
        }
    }
}
