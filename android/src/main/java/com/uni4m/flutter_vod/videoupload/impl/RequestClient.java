package com.uni4m.flutter_vod.videoupload.impl;

import android.text.TextUtils;
import android.util.Log;

import com.uni4m.flutter_vod.videoupload.impl.compute.TXOkHTTPEventListener;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.IOException;
import java.net.InetAddress;
import java.util.concurrent.TimeUnit;

import okhttp3.Callback;
import okhttp3.Interceptor;
import okhttp3.MediaType;
import okhttp3.MultipartBody;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;


/**
 * UGC Client
 */
public class RequestClient {
    private final static String TAG = "RequestClient";

    private OkHttpClient okHttpClient;
    private String httpServerAddr;
    private String requestUrl;


    private static RequestClient ourInstance;

    public static RequestClient getInstance(String httpServerAddr, String requestUrl, int iTimeOut) {
        synchronized (RequestClient.class) {
            if (ourInstance == null) {
                ourInstance = new RequestClient(httpServerAddr, requestUrl, iTimeOut);
            } else if (requestUrl != null && !TextUtils.isEmpty(requestUrl)) {
                ourInstance.updateUrl(httpServerAddr, requestUrl);
            }
        }

        return ourInstance;
    }

    public void updateUrl(String httpServerAddr, String requestUrl) {
        this.httpServerAddr = httpServerAddr;
        this.requestUrl = requestUrl;
    }


    private RequestClient(String httpServerAddr, String requestUrl, int iTimeOut) {
        this.httpServerAddr = httpServerAddr;
        this.requestUrl = requestUrl;
        okHttpClient = new OkHttpClient().newBuilder()
                .dns(new HttpDNS())
                .connectTimeout(iTimeOut, TimeUnit.SECONDS)    // 设置超时时间
                .readTimeout(iTimeOut, TimeUnit.SECONDS)       // 设置读取超时时间
                .writeTimeout(iTimeOut, TimeUnit.SECONDS)      // 设置写入超时时间
                .addNetworkInterceptor(new LoggingInterceptor())
                .build();
    }


    /**
     * 获取签名接口
     *
     * @param callback 回调
     */
    public void getSignature(Callback callback) {
        String reqUrl = httpServerAddr +"/"+ requestUrl;
        Log.d(TAG, "GetSignature->request url:" + reqUrl);
        Request request = new Request.Builder()
                .url(reqUrl)
                .get()
                .build();
        okHttpClient.newCall(request).enqueue(callback);
    }


    private class LoggingInterceptor implements Interceptor {
        @Override
        public Response intercept(Chain chain) throws IOException {
            Request request = chain.request();
            Log.d(TAG, "Sending request " + request.url() + " on " + chain.connection() + "\n" + request.headers());
            Response response = chain.proceed(request);
            return response;
        }
    }
}
