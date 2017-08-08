//
//  KLineTipBoardView.m
//  ChartDemo
//
//  Created by xdliu on 16/8/23.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import "KLineTipBoardView.h"

@implementation KLineTipBoardView

#pragma mark - life cycle

- (id)init {
    if (self = [super init]) {
        [self _setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self _setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _setup];
    }
    return self;
}

- (void)_setup {
    self.strockColor = kCustomRedColor;
    self.triangleWidth = 5.0;
    self.radius = 4.0;
    self.hideDuration = 2.5;
    
    self.open = @"0.0";
    self.close = @"0.0";
    self.high = @"0.0";
    self.low = @"0.0";
    
    self.openColor = [UIColor colorWithWhite:0.15 alpha:1.0];
    self.closeColor = [UIColor colorWithWhite:0.15 alpha:1.0];
    self.highColor = [UIColor colorWithWhite:0.15 alpha:1.0];
    self.lowColor = [UIColor colorWithWhite:0.15 alpha:1.0];
    
    self.font = [UIFont systemFontOfSize:8.0f];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self drawInContext];
    
    [self drawText];
}

- (void)drawText {
    NSArray *titles = @[[@"开盘价：" stringByAppendingString:self.open], [@"收盘价：" stringByAppendingString:self.close], [@"最高价：" stringByAppendingString:self.high], [@"最低价：" stringByAppendingString:self.low]];
    NSArray<UIColor *> *colors = @[self.openColor, self.closeColor, self.highColor, self.lowColor];
    
    CGFloat padding = (self.frame.size.height - 2*self.font.lineHeight) / 3.0;
    
    for (int i = 0; i < 4; i ++) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:titles[i] attributes:@{NSFontAttributeName:self.font, NSForegroundColorAttributeName:colors[i]}];
        CGFloat originY = i == 0 || i == 1 ? padding - 2 : padding*2 + 4 + self.font.lineHeight;
        CGFloat originX = i == 0 || i == 2 ? self.triangleWidth + 2 : (self.frame.size.width - self.triangleWidth - 4 - 2)/2.0 + self.triangleWidth + 2.0;
        [attString drawInRect:CGRectMake(originX, originY, self.frame.size.width, self.font.lineHeight)];
    }
}

@end
