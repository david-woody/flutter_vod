package com.uni4m.flutter_vod;


import com.uni4m.flutter_vod.videoupload.impl.TXUGCPublish;
import com.uni4m.flutter_vod.videoupload.impl.TXUGCPublishTypeDef;

import java.util.HashMap;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class FlutterVodUploadHandler {
    public FlutterVodUploadHandler() {
    }

    private String mSignature = "";


    public void setSignature(String signature) {
        this.mSignature = signature;
    }

    public PluginRegistry.Registrar registrar = null;


    public void setRegistrar(PluginRegistry.Registrar registrar) {
        this.registrar = registrar;
    }


    public MethodChannel channel = null;

    public MethodChannel getChannel() {
        return channel;
    }

    public void setChannel(MethodChannel channel) {
        this.channel = channel;
    }

    public void uploadVideo(MethodCall call, final MethodChannel.Result result) {
        TXUGCPublish mVideoPublish = new TXUGCPublish(registrar.context(), "independence_android");
        // mVideoPublish.setAppId(123456);
        mVideoPublish.setListener(new TXUGCPublishTypeDef.ITXVideoPublishListener() {
            @Override
            public void onPublishProgress(long uploadBytes, long totalBytes) {
                System.out.println("uploadBytes="+uploadBytes+"  ** totalBytes="+totalBytes);
            }

            @Override
            public void onPublishComplete(TXUGCPublishTypeDef.TXPublishResult publishResult) {
                System.out.println("Success");
                System.out.println(publishResult.videoURL);
                HashMap map = new HashMap();
                map.put("url", publishResult.videoURL);
                map.put("fileId", publishResult.videoId);
                result.success(map);
            }
        });

        TXUGCPublishTypeDef.TXPublishParam param = new TXUGCPublishTypeDef.TXPublishParam();
        param.signature = mSignature;
        String mVideoPath = call.argument("videoPath");
        param.videoPath = mVideoPath;
        param.coverPath="";
        System.out.println("Upload Signature=" + mSignature);
        System.out.println("Upload VideoPath=" + mVideoPath);

        int publishCode = mVideoPublish.publishVideo(param);
        if (publishCode != 0) {
            result.error("FlutterVodUploadHandler", "发布失败，错误码：" + publishCode, null);
            System.out.println("Error");
        }

    }

}
