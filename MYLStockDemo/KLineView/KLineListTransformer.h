//
//  KLineListTransformer.h
//  ChartDemo
//
//  Created by xdliu on 16/8/12.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString *const kCandlerstickChartsContext;
extern NSString *const kCandlerstickChartsDate;
extern NSString *const kCandlerstickChartsMaxHigh;
extern NSString *const kCandlerstickChartsMinLow;
extern NSString *const kCandlerstickChartsMaxVol;
extern NSString *const kCandlerstickChartsMinVol;
extern NSString *const kCandlerstickChartsRSI;
/**
 *  extern key 可修改为Entity
 */
@interface KLineListTransformer : NSObject

+ (instancetype)sharedInstance;

- (id)managerTransformData:(NSArray*)data;

@end
