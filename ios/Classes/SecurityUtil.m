//
//  NSStringccc.m
//  CocoaSecurity
//
//  Created by Wallent on 2019/12/24.
//

#import "SecurityUtil.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>

@implementation SecurityUtil

+ (NSString *) getStrCode{
    NSArray *CodeArr = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    NSMutableString* tmpStr = [[NSMutableString alloc] initWithCapacity:5];;
    for (int i = 0; i < 4; i++) {
        NSInteger index = arc4random() % (CodeArr.count-1);
        [tmpStr appendString:[CodeArr objectAtIndex:index]];
    }
    NSString *string = [NSString stringWithFormat:@"%@",tmpStr];
    return string;
}

+ (NSString *) getNowTimeTimestamp {
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return timeSp;
    
}
+ (NSString *)getExpireTimestamp {
    NSDate *currentDate = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:currentDate];
    [components setDay:([components day]+4)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    // // // //
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateday stringFromDate:beginningOfWeek];
    NSLog(@"%@",[dateday stringFromDate:beginningOfWeek]);//年月日 时分秒
    // // // //
    NSString *result =[NSString stringWithFormat:@"%ld", (long)[beginningOfWeek  timeIntervalSince1970]];//时间戳
    return result;
}

//HmacSHA1加密；
+(NSString *) hmacSha1:(NSString *)key data:(NSString *)data
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    //Sha256:
    // unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    //CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    //sha1
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC
                                          length:sizeof(cHMAC)];
    NSString *hash = [HMAC base64EncodedStringWithOptions:0];//将加密结果进行一次BASE64编码。
    return hash;
}

+(Byte *) stringToBytes:(NSString *)str
{
      NSData *testData = [str dataUsingEncoding: NSUTF8StringEncoding];
      Byte *bytes = (Byte *)[testData bytes];
      for (int i = 0; i < testData.length; i++) {
          NSLog(@"%hhu",bytes[i]);
          //字节数组转换成字符
          NSData *d1 = [NSData dataWithBytes:bytes length:i+1];
          NSString *str = [[NSString alloc] initWithData:d1 encoding:NSUTF8StringEncoding];
          NSLog(@"%@",str);
      }
   return bytes;
//   NSData *testData = [key dataUsingEncoding: NSUTF8StringEncoding];//字符串转化成 data
//   Byte* testByte = (Byte*)[testDatabytes];
//    uint8_t *bytes =malloc(sizeof(*bytes)*testData.length);
//    for(inti=0;i<[testData length];i++)
//    {
//       NSLog(@"myByte = %d\n",testByte[i]);
//       bytes[i] = testByte[i];
//    }
//    return hash;
}
@end
