package com.uni4m.flutter_vod.videoupload.impl.compute;

import android.util.Log;

import com.tencent.cos.xml.transfer.UploadService;
import com.tencent.qcloud.core.http.HttpTaskMetrics;

/**
 * 用于统计 UploadService 第一个请求耗时
 */
public class TXOnGetHttpTaskMetrics implements UploadService.OnGetHttpTaskMetrics {
    private static final String TAG = "TXOnGetHttpTaskMetrics";
    private boolean isGet;
    private double tcpConnectionTimeCost;
    private double recvRspTimeCost;

    public long getTCPConnectionTimeCost() {
        return (long) (tcpConnectionTimeCost * 1000);
    }

    public long getRecvRspTimeCost() {
        return (long) (recvRspTimeCost * 1000);
    }

    public void onGetHttpMetrics(String s, HttpTaskMetrics httpTaskMetrics) {
        if (!isGet) {//是否已经获取到过第一个请求
            isGet = true;

            recvRspTimeCost = TXHttpTaskMetrics.getRecvRspTimeCost(httpTaskMetrics);

            tcpConnectionTimeCost = TXHttpTaskMetrics.getTCPConnectionTimeCost(httpTaskMetrics);

            Log.i(TAG, "onDataReady: tcpConnectionTimeCost = " + tcpConnectionTimeCost + " recvRspTimeCost = " + recvRspTimeCost);

            Log.i(TAG, "onDataReady: " + this.toString());
        }
    }
}
