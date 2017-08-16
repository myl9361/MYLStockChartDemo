//
//  Common.m
//  KuaiDiJinNew
//
//  Created by xiaojiali on 2016/11/24.
//  Copyright © 2016年 xiaojiali. All rights reserved.
//

#import "Common.h"
#import <CommonCrypto/CommonCryptor.h>
//密钥
#define gkey            @"comwyj#@*8888efggg"
//偏移量
#define gIv             @"01234567"
@implementation Common

//返回控件宽度  用于适配界面和字体大小
+ (CGFloat)setWidth:(CGFloat)width {
    
    CGFloat autoSizeScale = 0.0f;
    if (kScreenWidth != 375) {
        autoSizeScale = kScreenWidth/375;
    }else{
        autoSizeScale = 1.0;
    }
    CGFloat _width=width * autoSizeScale;
    return _width;
}

+ (CGRect)getHeightOfText:(NSString *)text width:(CGFloat)width font:(UIFont *)font{
    /*
     width:设定的字符串展示的宽度
     font :字符的字体大小
     */
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    /*
     字符串对应高度
     float aHeifht = rect.size.height;
     
     字符串对应宽度
     float aWidth = rect.size.width;
     */
    
    return rect;
}
+ (NSString *)jsonStringWithObject:(id)responseObject
{
    NSError* error = nil;
    if (responseObject == nil) {
        return nil;
    }
    id result = [NSJSONSerialization dataWithJSONObject:responseObject
                                                options:kNilOptions error:&error];
    
    if (error != nil) {
        return nil;
    }
    return result;
}

#pragma mark - 3des加密方法
/*
+ (NSString*)encrypt:(NSString*)plainText {
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    size_t plainTextBufferSize = [data length];
    const void *vplainText = (const void *)[data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [gkey UTF8String];
    const void *vinitVec = (const void *) [gIv UTF8String];
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    NSString *result = [GTMBase64 stringByEncodingData:myData];
    return result;
}

// 解密方法
+ (NSString*)decrypt:(NSString*)encryptText {
    NSData *encryptData = [GTMBase64 decodeData:[encryptText dataUsingEncoding:NSUTF8StringEncoding]];
    size_t plainTextBufferSize = [encryptData length];
    const void *vplainText = [encryptData bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [gkey UTF8String];
    const void *vinitVec = (const void *) [gIv UTF8String];
    
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                     length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
    return result;
}*/


+ (NSString*)getProjectVerson {
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    return app_Version;
}

+ (NSString *)decimalProcessingWithNum:(NSString*)num {
    
    if ([num componentsSeparatedByString:@"."].count == 0) {
        
        num = [NSString stringWithFormat:@"%@.00",num];
        
    }else if ([[num componentsSeparatedByString:@"."] lastObject].length == 1)
    {
        num = [NSString stringWithFormat:@"%@0",num];
        
    }else{
        
        num = [NSString stringWithFormat:@"%.2f",[num floatValue]];

    }
    return num;
    
}

+ (NSString *)unitConversionWithNum:(NSString*)num {
    
    if ([num doubleValue]>10000&&[num doubleValue]<100000000) {
        
        //所给数据 金额多两位（如12.25元）
        num = [NSString stringWithFormat:@"%.2f万",[num doubleValue]/10000];
        
    }else if ([num doubleValue]>10000000)
    {
        num = [NSString stringWithFormat:@"%.2f亿",[num doubleValue]/100000000];

    }
     
    return num;
}

+ (NSString *)unitHKConversionWithNum:(NSString*)num {
    
    if ([num doubleValue]>10000) {
        
        //所给数据 金额多两位（如12.25元）
        num = [NSString stringWithFormat:@"%.2f亿股",[num doubleValue]/10000];
        
    }else     {
        num = [NSString stringWithFormat:@"%.2f万股",[num doubleValue]];
        
    }
    
    return num;
}

//五档图 成交量处理
+ (NSString *)fiveViewMakeWithNum:(NSString *)num {
    
    NSInteger index = [num integerValue]/100;
    
    return [NSString stringWithFormat:@"%ld",(long)index];
}



+ (NSArray*)makeStockDetailWithDic:(NSDictionary*)dict Type:(NSInteger)type {
    
    NSMutableArray *dataArr = [[NSMutableArray alloc]init];

    StockDataModel  *stock;
    if (type == 1) {
        /*
         因为分时图数据需要 日期的参数，所以最有处理的dataArr 格式为
         [@{@"2015-08-02":当天的分时总数组},@{"2015-08-03":当天的分时总数组}...]
         */
        stock = [StockDataModel mj_objectWithKeyValues:dict[@"result"][@"detail"][@"stockMarket"]];
        
        stock.timeDetailArr = dict[@"result"][@"everyTrade"];
        
        /*
         五档图的数据
         */
        stock.volsell = @[[Common fiveViewMakeWithNum:stock.sell1_n] ,
                               [Common fiveViewMakeWithNum:stock.sell2_n],
                               [Common fiveViewMakeWithNum:stock.sell3_n],
                               [Common fiveViewMakeWithNum:stock.sell4_n],
                               [Common fiveViewMakeWithNum:stock.sell5_n]];
        stock.volbuy = @[[Common fiveViewMakeWithNum:stock.buy1_n],
                              [Common fiveViewMakeWithNum:stock.buy2_n],
                              [Common fiveViewMakeWithNum:stock.buy3_n],
                              [Common fiveViewMakeWithNum:stock.buy4_n],
                              [Common fiveViewMakeWithNum:stock.buy5_n]];
       stock.pricesell = @[stock.sell1_m,stock.sell2_m,stock.sell3_m,stock.sell4_m,stock.sell5_m];
       stock.pricebuy = @[stock.buy1_m,stock.buy2_m,stock.buy3_m,stock.buy4_m,stock.buy5_m];
        
        NSArray  *timelineArr = dict[@"result"][@"timeLine"][@"dataList"];
        
        for (int i =0 ; i<timelineArr.count; i++) {
            
            NSDictionary *dataDic = [[NSMutableDictionary alloc]init];
            NSDictionary *dic = timelineArr[timelineArr.count-1-i];
            if (![dataDic.allKeys containsObject:dic[@"date"]]) {
                [dataDic setValue:dic[@"minuteList"] forKey:dic[@"date"]];
                [dataArr addObject:dataDic];
            }
           
        }
        
    }else{
        
        stock = [StockDataModel mj_objectWithKeyValues:dict[@"result"][@"detail"][@"stockMarket"]];
        NSArray  *arr = dict[@"result"][@"kline"][@"dataList"];
        [dataArr setArray:arr];
        
    }

    return @[dataArr,stock];

}




@end
