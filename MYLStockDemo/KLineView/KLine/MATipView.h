//
//  MATipView.h
//  ChartDemo
//
//  Created by xdliu on 16/8/21.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MATipView : UIView

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) UIColor *minAvgPriceColor;

@property (nonatomic, strong) UIColor *midAvgPriceColor;

@property (nonatomic, strong) UIColor *maxAvgPriceColor;

@property (nonatomic, copy) NSString *minAvgPrice;

@property (nonatomic, copy) NSString *midAvgPrice;

@property (nonatomic, copy) NSString *maxAvgPrice;

@end
