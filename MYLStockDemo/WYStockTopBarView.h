//
//  WYStockTopBarView.h
//  WYStock
//
//  Created by myl on 2017/4/14.
//  Copyright © 2017年 myl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYStockTopBarView : UIView

typedef void(^block)(NSInteger index);

@property (nonatomic ,strong)block clickBlock;
@property (nonatomic ,assign)NSInteger lastTag;

- (instancetype)initWithFrame:(CGRect)frame SelecIndex:(NSInteger)selectIndex titleArr:(NSArray*)titleArr;

- (void)selectClick:(block)block;

- (void)btnClick:(UIButton*)sender;

@end
