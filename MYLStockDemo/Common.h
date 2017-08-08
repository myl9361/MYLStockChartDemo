//
//  Common.h
//  KuaiDiJinNew
//
//  Created by xiaojiali on 2016/11/24.
//  Copyright © 2016年 xiaojiali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StockDataModel.h"

typedef void(^loginOutSuccessBlock)();
typedef void(^loginFailBlock)(NSString *errCode);

@interface Common : NSObject


+ (NSString*)encrypt:(NSString*)plainText;

+ (NSString*)decrypt:(NSString*)encryptText;

+ (NSString*)getProjectVerson;

//Layout
+ (CGFloat)setWidth:(CGFloat)width;

+ (CGRect)getHeightOfText:(NSString *)text width:(CGFloat)width font:(UIFont *)font;

//处理股票详情数据

+ (NSArray*)makeStockDetailWithDic:(NSDictionary*)dict Type:(NSInteger)type;

//json处理
+ (NSString *)jsonStringWithObject:(id)responseObject;

//小数点后始终保持两位 不足补0
+ (NSString *)decimalProcessingWithNum:(NSString*)num;

//亿 万 的单位换算
+ (NSString *)unitConversionWithNum:(NSString*)num;

//港股成交量换算
+ (NSString *)unitHKConversionWithNum:(NSString*)num;

//五档图 成交量处理
+ (NSString *)fiveViewMakeWithNum:(NSString *)num;


@end
