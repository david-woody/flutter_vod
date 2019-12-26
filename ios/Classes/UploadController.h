//
//  ViewController.h
//  uploadtest
//
//  Created by carolsuo on 2017/12/21.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXUGCPublishListener.h"
#import <Flutter/Flutter.h>


@interface UploadController : UIControl<TXVideoPublishListener>
- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar;
- (void)handleShare:(FlutterMethodCall *)call result:(FlutterResult)result;
//+ (void)uploadVideo:(NSString*)tempPath;
//+ (NSString *) getNowTimeTimestamp;
@end

