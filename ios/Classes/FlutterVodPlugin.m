#import "FlutterVodPlugin.h"
#import "UploadController.h"

@implementation FlutterVodPlugin

UploadController *_flutterUploadHandler;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
               methodChannelWithName:@"com.uni4m/flutter_vod"
                     binaryMessenger:[registrar messenger]];

       FlutterVodPlugin *instance = [[FlutterVodPlugin alloc] initWithRegistrar:registrar methodChannel:channel];
       [registrar addMethodCallDelegate:instance channel:channel];
       [registrar addApplicationDelegate:instance];

}


- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar methodChannel:(FlutterMethodChannel *)flutterMethodChannel {
    self = [super init];
    if (self) {
       _flutterUploadHandler = [[UploadController alloc] initWithRegistrar:registrar];
    }
    return self;
}


- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    [_flutterUploadHandler handleShare:call result:result];
//    if ([call.method hasPrefix:@"share"]) {
//
//    } else {
//        result(FlutterMethodNotImplemented);
//    }
}

@end
