import Flutter
import UIKit


public class SwiftFlutterVodPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.uni4m/flutter_vod", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterVodPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if(call.method == "initVod"){
            //do something
            //预先解析httpdns
            initVod(result: result)
        }else if(call.method == "uploadVideo"){
            let args=call.arguments as! NSDictionary
            let tempPath=args["videoPath"]! as! String
            uploadVideo(result: result,uploadTempFilePath: tempPath)
        }else{
            result("iOS " + UIDevice.current.systemVersion)
        }
    }
    var    videoPublish:TXUGCPublish=TXUGCPublish(userID: "independence_ios");
    
    var    signature:String = "";
    
    
    
    func initVoid(result: @escaping FlutterResult){
//        TCHttpUtil.init()
    }
    
    
    func uploadVideo(result: @escaping FlutterResult,uploadTempFilePath:String){
        let delegate = AdmobIntersitialPluginDelegate()
      
        TCHttpUtil.asyncSendHttpRequest("api/v1/misc/upload/signature", httpServerAddr: kHttpUGCServerAddr, httpMethod: "GET", param: nil, handler: {
            result, resultDict in
            if result == 0 && resultDict != nil {
                let dataDict = resultDict?["data"] as? NSDictionary
                if dataDict != nil  {
                    self.signature = dataDict?["signature"] as! String
                    let publishParam = TXPublishParam()
                    publishParam.signature = self.signature
                    publishParam.coverPath = nil
                    publishParam.videoPath = uploadTempFilePath
                    
                   
//                    self.videoPublish.publishVideo(publishParam,result: result)
                }
            } else {
                NSLog("getSign Failed")
            }
        })
        
    }
    
    public func initVod(result: @escaping FlutterResult){
        TCHttpUtil.asyncSendHttpRequest("api/v1/misc/upload/signature", httpServerAddr: kHttpUGCServerAddr, httpMethod: "GET", param: nil, handler: { resultS, resultDict in
            if resultS == 0 && resultDict != nil {
                let dataDict = resultDict?["data"] as? [AnyHashable : Any]
                if dataDict != nil && self.videoPublish != nil {
                    self.signature =  dataDict?["signature"] as! String
                    NSLog(self.signature)
                    result(self.signature)
                }
            } else {
                NSLog("getSign Failed")
            }
        })
    }
    
    
    
}

class AdmobIntersitialPluginDelegate: NSObject, TXVideoPublishListener {
    
    //    let result:FlutterResult
    //    init(res: FlutterResult) {
    //        self.result = res
    //    }
    //
    
    override init() {
        
    }
    
    
    func onPublishProgress(uploadBytes:NSInteger,totalBytes:NSInteger) {
        NSLog("onPublishProgress [%ld/%ld]");
    }
    
    func onPublishComplete(_ result:TXPublishResult) {
        NSLog("onPublishComplete ret:[%d]");
    }
}
