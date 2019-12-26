//
//  UploadController.m
//  uploadtest
//
//  Created by carolsuo on 2017/12/21.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "UploadController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>
#import "TXUGCPublish.h"
#import "TXUGCPublishOptCenter.h"
#import "TCHttpUtil.h"
#include "SecurityUtil.h"
@interface UploadController ()<TXVideoPublishListener>
@property (nonatomic, strong) NSString* uploadTempFilePath;

@end

@implementation UploadController
{
    TXUGCPublish     *_videoPublish;
    NSString         *_signature;
}

NSObject <FlutterPluginRegistrar> *_fluwxRegistrar;

- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    self = [super init];
    if (self) {
        _fluwxRegistrar = registrar;
    }
    return self;
}

- (void)handleShare:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"initVod" isEqualToString:call.method]) {
        [self initVod:call result:result];
    }else if ([@"getSignature" isEqualToString:call.method]) {
        [self getSignature:call result:result];
    } else if ([@"uploadVideo" isEqualToString:call.method]) {
        [self uploadVideo:call result:result];
    }
}
- (void)initVod:(FlutterMethodCall *)call result:(FlutterResult)fResult {
    NSString *_sign =call.arguments[@"signature"];
    if(_sign==nil){
        fResult([FlutterError errorWithCode:@"invalid signature" message:@"are you sure your signature is empty? " details:@""]);
    }else{
        _signature=_sign;
        fResult(_signature);
    }
}

- (void)getSignature:(FlutterMethodCall *)call result:(FlutterResult)fResult {
    NSString *_requestUrl =call.arguments[@"requestUrl"];
    NSString *_httpServerAddr =call.arguments[@"httpServerAddr"];
    NSLog(_httpServerAddr);
    NSLog(_requestUrl);
    [TCHttpUtil asyncSendHttpRequest:_requestUrl httpServerAddr:_httpServerAddr HTTPMethod:@"GET" param:nil handler:^(int result, NSDictionary *resultDict) {
        NSLog(@"%@",resultDict);
        if (result == 0 && resultDict){
            NSDictionary *dataDict = resultDict[@"data"];
            if (dataDict) {
                _signature =  dataDict[@"signature"];
                fResult(_signature);
            }else{
                fResult([FlutterError errorWithCode:@"Get signature failed" message:@"Please check your api response,is the right format!" details:@""]);
            }
        } else{
            fResult([FlutterError errorWithCode:@"Get signature failed" message:@"Please check your api! " details:@""]);
        }
    }];
}

- (void)uploadVideo:(FlutterMethodCall *)call result:(FlutterResult)fResult {
    NSString *text = call.arguments[@"videoPath"];
    if (_videoPublish == nil) {
        _videoPublish = [[TXUGCPublish alloc] initWithUserID:@"independence_ios"];
        _videoPublish.delegate = self;
    }
    NSString *_getSignature =call.arguments[@"signature"];
    NSString *_videoPath =call.arguments[@"videoPath"];
    
    if(_getSignature == nil && _signature == nil ){
        fResult([FlutterError errorWithCode:@"Get signature failed" message:@"Please init vod plugin first!" details:@""]);
    }
    TXPublishParam *publishParam = [[TXPublishParam alloc] init];
    if(_getSignature == nil){
        publishParam.signature  = _signature;
    }else{
        publishParam.signature  = _getSignature;
    }
    
    publishParam.coverPath = nil;
    publishParam.videoPath  =   _videoPath;
    [_videoPublish publishVideo:publishParam result:fResult];
}




#pragma mark - TXVideoPublishListener
- (void)onPublishProgress:(NSInteger)uploadBytes totalBytes:(NSInteger)totalBytes {
    NSLog(@"onPublishProgress [%ld/%ld]", uploadBytes, totalBytes);
}

- (void)onPublishComplete:(TXPublishResult*)res result:(FlutterResult)result {
    NSLog(@"onPublishComplete [%d/%@]", res.retCode, res.retCode == 0? res.videoURL: res.descMsg);
    result(@{@"url": res.videoURL, @"fileId": res.videoId});
}

@end
