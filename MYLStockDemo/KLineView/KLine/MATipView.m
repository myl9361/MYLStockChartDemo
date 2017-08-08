//
//  MATipView.m
//  ChartDemo
//
//  Created by xdliu on 16/8/21.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import "MATipView.h"
#import <Masonry.h>


@interface MATipView ()

@property (nonatomic, strong) UILabel *minAvgPriceLbl;

@property (nonatomic, strong) UILabel *midAvgPriceLbl;

@property (nonatomic, strong) UILabel *maxAvgPriceLbl;

@end

@implementation MATipView

- (id)init {
    if (self = [super init]) {
        [self setup];
        [self addPageSubviews];
        [self layoutPageSubviews];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
        [self addPageSubviews];
        [self layoutPageSubviews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
        [self addPageSubviews];
        [self layoutPageSubviews];
    }
    return self;
}

- (void)setup {
    self.font = [UIFont systemFontOfSize:10.0f];
    
    self.minAvgPriceColor = Color_FromRGB(0x019ffd);
    self.midAvgPriceColor = Color_FromRGB(0xff9900);
    self.maxAvgPriceColor = Color_FromRGB(0xff00ff);
}

- (void)addPageSubviews {
    [self addSubview:self.minAvgPriceLbl];
    [self addSubview:self.midAvgPriceLbl];
    [self addSubview:self.maxAvgPriceLbl];
}

- (void)layoutPageSubviews {
    [self.minAvgPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@5.0f);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.midAvgPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.maxAvgPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.mas_trailing).with.offset(-5.0f);
        make.centerY.equalTo(self.mas_centerY);
    }];
}

#pragma mark - getters

- (UILabel *)minAvgPriceLbl {
    if (!_minAvgPriceLbl) {
        _minAvgPriceLbl = [UILabel new];
        _minAvgPriceLbl.font = self.font;
        _minAvgPriceLbl.textColor = self.minAvgPriceColor;
    }
    return _minAvgPriceLbl;
}

- (UILabel *)midAvgPriceLbl {
    if (!_midAvgPriceLbl) {
        _midAvgPriceLbl = [UILabel new];
        _midAvgPriceLbl.font = self.font;
        _midAvgPriceLbl.textColor = self.midAvgPriceColor;
    }
    return _midAvgPriceLbl;
}

- (UILabel *)maxAvgPriceLbl {
    if (!_maxAvgPriceLbl) {
        _maxAvgPriceLbl = [UILabel new];
        _maxAvgPriceLbl.font = self.font;
        _maxAvgPriceLbl.textColor = self.maxAvgPriceColor;
    }
    return _maxAvgPriceLbl;
}

#pragma mark - setters

- (void)setMinAvgPrice:(NSString *)minAvgPrice {
    _minAvgPriceLbl.text = minAvgPrice == nil || minAvgPrice.length == 0 ? @"MA5：0.00" : minAvgPrice;
}

- (void)setMidAvgPrice:(NSString *)midAvgPrice {
    _midAvgPriceLbl.text = midAvgPrice == nil || midAvgPrice.length == 0 ? @"MA10：0.00" : midAvgPrice;
}

- (void)setMaxAvgPrice:(NSString *)maxAvgPrice {
    _maxAvgPriceLbl.text = maxAvgPrice == nil || maxAvgPrice.length == 0 ? @"MA20：0.00" : maxAvgPrice;
}

@end
