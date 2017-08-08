//
//  KLineListTransformer.m
//  ChartDemo
//
//  Created by xdliu on 16/8/12.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import "KLineListTransformer.h"

NSString *const kCandlerstickChartsContext = @"kCandlerstickChartsContext";
NSString *const kCandlerstickChartsDate    = @"kCandlerstickChartsDate";
NSString *const kCandlerstickChartsMaxHigh = @"kCandlerstickChartsMaxHigh";
NSString *const kCandlerstickChartsMinLow  = @"kCandlerstickChartsMinLow";
NSString *const kCandlerstickChartsMaxVol  = @"kCandlerstickChartsMaxVol";
NSString *const kCandlerstickChartsMinVol  = @"kCandlerstickChartsMinVol";
NSString *const kCandlerstickChartsRSI     = @"kCandlerstickChartsRSI";

@implementation KLineListTransformer{
    NSInteger _kCount;
    
    CGFloat   _kdj_k;
    CGFloat   _kdj_d;
    CGFloat   _EMA12;
    CGFloat   _EMA26;
    CGFloat   _DEA;
}


+ (instancetype)sharedInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
    });
    return instance;
}
- (id)managerTransformData:(NSArray*)data {
    _kCount = 150;
    _kdj_k = 50;
    _kdj_d = 50;
    
    // data = (NSMutableArray *)[[data reverseObjectEnumerator] allObjects];
    
    NSMutableArray *context = [NSMutableArray new];
    NSMutableArray *dates = [NSMutableArray new];
    float maxHigh = 0.0, minLow = 0.0, maxVol = 0.0, minVol = 0.0;
    for (int i = (int)(data.count - 1); i > -1; i --) {
        //arr = @["日期,开盘价,最高价,最低价,收盘价,成交量, 调整收盘价"]
        NSDictionary *dic = data[i] ;
        NSArray *arr = @[dic[@"time"],dic[@"open"],dic[@"max"],dic[@"min"],dic[@"close"],dic[@"volumn"]];

        CGFloat MA5 = [self chartMAWithData:data inRange:NSMakeRange(i, 5)];
        CGFloat MA10 = [self chartMAWithData:data inRange:NSMakeRange(i, 10)];
        CGFloat MA20 = [self chartMAWithData:data inRange:NSMakeRange(i, 20)];
        
        CGFloat RSI6 = [self chartRSIWithData:data inRange:NSMakeRange(i, 7)];
        CGFloat RSI12 = [self chartRSIWithData:data inRange:NSMakeRange(i, 13)];
        CGFloat RSI24 = [self chartRSIWithData:data inRange:NSMakeRange(i, 25)];
        
        NSArray *kdjArr = [self chartKDJWithData:data inRange:NSMakeRange(i, 9)];
        
        NSArray *macdArr = [self chartMACDWithData:data inRange:NSMakeRange(i, 1)];
        //item = @["开盘价,最高价,最低价,收盘价,成交量, MA5, MA10, MA20"]
        NSMutableArray *item = [[NSMutableArray alloc] initWithCapacity:14];
        item[0] = @([arr[1] floatValue]);
        item[1] = @([arr[2] floatValue]);
        item[2] = @([arr[3] floatValue]);
        item[3] = @([arr[4] floatValue]);
        item[4] = @([arr[5] floatValue]/10000.00);
        item[5] = @(MA5);
        item[6] = @(MA10);
        item[7] = @(MA20);
        item[8] = @(RSI6);
        item[9] = @(RSI12);
        item[10] = @(RSI24);
        item[11] = kdjArr;
    
        //取昨天的收盘价 因为十字线滑动到时候 当前日期的涨跌值需要去计算
        if (i <data.count-1) {
            item[12] =  data[i+1][@"close"];
        }else{
            item[12] =  @(0);

        }
        item[13] = macdArr;
        
        if (maxHigh < [item[1] floatValue]) {
            maxHigh = [item[1] floatValue];
        }
        
        if (minLow > [item[2] floatValue] || i == (data.count - 1)) {
            minLow = [item[2] floatValue];
        }
        
        if (maxVol < [item[4] floatValue]) {
            maxVol = [item[4] floatValue];
        }
        
        if (minVol > [item[4] floatValue] || i == (data.count - 1)) {
            minVol = [item[4] floatValue];
        }
        
        [context addObject:item];
        [dates addObject:[arr[0] componentsSeparatedByString:@" "][0]];
    }
    
    //NSLog(@"\n context：\n%@ \n\t\t\t\n\t\t\t\n dates：\n%@ \n\n/*\n maxValue：%.2f \n*/\t\t\t\n\n/*\n minValue：%.2f \n*/\t\t\t\n\n/*\n maxVol：%.2f \n*/\t\t\t\n\n/*\n minVol：%.2f \n*/", context, dates, maxHigh, minLow, maxVol, minVol);
    
    return @{kCandlerstickChartsDate:dates,
             kCandlerstickChartsContext:context,
             kCandlerstickChartsMaxHigh:@(maxHigh),
             kCandlerstickChartsMinLow:@(minLow),
             kCandlerstickChartsMaxVol:@(maxVol),
             kCandlerstickChartsMinVol:@(minVol)
             };
}

/*
 首日 EMA12 EMA26 默认为当日收盘价  MACD DEA DIF 为0
 第二日开始
 EMA12 =  前一日的EMA12*11/13 + 当日收盘价*2/13;
 EMA26 =  前一日的*25/27 + 当日收盘价*2/27;
 DIF   =  EMA12 - EMA26;
 DEA   =  前一日的DEA*8/10+DIF*2/10;
 MACD  =  2*(DIF-DEA);
 */

- (NSMutableArray*)chartMACDWithData:(NSArray *)data inRange:(NSRange)range {
    NSMutableArray *arr = [[NSMutableArray alloc]init];;
    
    if (data.count - range.location > range.length) {
        CGFloat DIF = 0;
        CGFloat MACD = 0;
        NSArray *rangeData = [data objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];

        if (range.location == data.count-2) {
            _EMA12 = [rangeData[0][@"close"] floatValue];
            _EMA26 = [rangeData[0][@"close"] floatValue];
            _DEA = 0;
            

        }else
        {
            CGFloat close = [rangeData[0][@"close"] doubleValue];
            _EMA12 = _EMA12*11/13+close*2/13;
            _EMA26 = _EMA26*25/27+close*2/27;
             DIF = _EMA12-_EMA26;
            _DEA = _DEA*8/10+DIF*2/10;
             MACD = 2*(DIF-_DEA);
        }
        
        [arr addObject:@(DIF)];
        [arr addObject:@(_DEA)];
        [arr addObject:@(MACD)];
    }else{
        [arr addObject:@(0)];
        [arr addObject:@(0)];
        [arr addObject:@(0)];
    }

    return arr;
}

/*
 KDJ 值计算  取9日为周期
 C:  为第9日的收盘价
 L9: 为9日内的最低价
 H9: 为9日内的最高价
 RSV =（C－L9）÷（H9－L9）×100
 K值 = 2/3×第8日K值+1/3×第9日RSV
 D值 = 2/3×第8日D值+1/3×第9日K值
 J值 = 3*第9日K值-2*第9日D值
 若无前一日K值与D值，则可以分别用50代替
 */
- (NSMutableArray*)chartKDJWithData:(NSArray *)data inRange:(NSRange)range {
    
    CGFloat k = 0;
    CGFloat d = 0;
    CGFloat j = 0;
    
   
    NSMutableArray *kdjArr = [[NSMutableArray alloc]init];
    
    NSMutableArray *highArr = [[NSMutableArray alloc]init];
    NSMutableArray *lowArr = [[NSMutableArray alloc]init];
    if (data.count - range.location > range.length) {
        
        NSArray *rangeData = [data objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        for (NSDictionary  *dic in rangeData) {
            [highArr addObject:dic[@"max"]];
            [lowArr addObject:dic[@"min"]];
        }
        CGFloat maxClose = [[highArr valueForKeyPath:@"@max.floatValue"]floatValue];
        CGFloat minClose = [[lowArr valueForKeyPath:@"@min.floatValue"]floatValue];
        CGFloat RSV = ([rangeData[0][@"close"] floatValue] - minClose)*100/(maxClose-minClose);
        
        k = 2*_kdj_k/3 +RSV/3;
        
        d = 2*_kdj_d/3 + k/3;
        
        j = 3*k - 2*d;
        
        _kdj_d = d;
        _kdj_k = k;
        
        [kdjArr addObject:@(k)];
        [kdjArr addObject:@(d)];
        [kdjArr addObject:@(j)];
    }else{
        [kdjArr addObject:@(0)];
        [kdjArr addObject:@(0)];
        [kdjArr addObject:@(0)];
    }
    
    
    return kdjArr;
}

/*
 
RSI值 计算
RSI(N)=A÷(A＋B)×100 
A: N日内收盘价的正数之和
B: N日内收盘价的负数之和乘以(—1)
*/

- (CGFloat)chartRSIWithData:(NSArray *)data inRange:(NSRange)range {
    CGFloat rsi = 0;
    CGFloat total = 0;
    CGFloat positive = 0;
    
    if (data.count - range.location > range.length) {
    NSArray *rangeData = [data objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        NSMutableArray *closePriceArr = [[NSMutableArray alloc]init];
        for (NSDictionary *item in rangeData) {
            
            [closePriceArr addObject:[item objectForKey:@"close"]];
        }
        for (int i = 0; i<closePriceArr.count; i++) {
            
            if (i== closePriceArr.count-1) {
                break ;
            }
            CGFloat index = [closePriceArr[i] floatValue]-[closePriceArr[i+1] floatValue];
            
            if (index>0) {
                
                positive+=index;
                total+=index;
            }else
            {
                total+=index*-1;
            }
        }
        rsi = [[NSString stringWithFormat:@"%.2f",positive*100/total] floatValue];
    }else{
        rsi = 0;
    }

    return  rsi;
}

/*
 计算 MA5 MA10  MA20 数据
 周期内的收盘价平均值
*/

- (CGFloat)chartMAWithData:(NSArray *)data inRange:(NSRange)range {
    CGFloat md = 0;
  
    if (data.count - range.location > range.length) {
         NSArray *rangeData = [data objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        for (NSDictionary *item in rangeData) {
            md += [[item objectForKey:@"close"] floatValue];
        }
        
        md = md / rangeData.count;
    }
    return md;
}

@end
