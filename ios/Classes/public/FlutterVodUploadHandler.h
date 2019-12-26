//
//  FlutterVodUploadHandler.h
//  flutter_vod
//
//  Created by Wallent on 2019/12/23.
//

#ifndef FlutterVodUploadHandler_h
#define FlutterVodUploadHandler_h

@class StringUtil;

@interface FlutterVodUploadHandler : NSObject
- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar;

- (void)handleShare:(FlutterMethodCall *)call result:(FlutterResult)result;
@end

#endif /* FlutterVodUploadHandler_h */
