//
//  YKLineDataSet.h
//  YKLineChartView
//
//  Created by chenyk on 15/12/9.
//  Copyright © 2015年 chenyk. All rights reserved.
//  https://github.com/chenyk0317/YKLineChartView

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YKTimeDataset : NSObject
@property (nonatomic,strong)NSMutableArray * data;
@property (nonatomic,strong)NSMutableArray * dateArr;
@property (nonatomic,assign)CGFloat highlightLineWidth;
@property (nonatomic,strong)UIColor  * highlightLineColor;
@property (nonatomic,assign)CGFloat  lineWidth;
@property (nonatomic,strong)UIColor * priceLineCorlor;
@property (nonatomic,strong)UIColor * avgLineCorlor;

@property (nonatomic,strong)UIColor * volumeRiseColor;
@property (nonatomic,strong)UIColor * volumeFallColor;
@property (nonatomic,strong)UIColor * volumeTieColor;

@property (nonatomic,assign)BOOL drawFilledEnabled;
@property (nonatomic,strong)UIColor * fillStartColor;
@property (nonatomic,strong)UIColor * fillStopColor;
@property (nonatomic,assign)CGFloat fillAlpha;


@end
