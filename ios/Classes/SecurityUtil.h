//
//  NSStringccc.h
//  CocoaSecurity
//
//  Created by Wallent on 2019/12/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SecurityUtil : NSObject
+ (NSString *) getStrCode;
+ (NSString *) getNowTimeTimestamp;
+ (NSString *)getExpireTimestamp;
+(NSString *) hmacSha1:(NSString *)key data:(NSString *)data;
+(Byte *) stringToBytes:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
