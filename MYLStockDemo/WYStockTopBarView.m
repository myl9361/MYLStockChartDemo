//
//  WYStockTopBarView.m
//  WYStock
//
//  Created by myl on 2017/4/14.
//  Copyright © 2017年 myl. All rights reserved.
//

#import "WYStockTopBarView.h"

#define LINE_TAG 47854
#define BTN_TAG  4785474
@implementation WYStockTopBarView


- (instancetype)initWithFrame:(CGRect)frame SelecIndex:(NSInteger)selectIndex titleArr:(NSArray*)titleArr{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *bgView = [[UIView alloc]init];
        bgView.backgroundColor = [UIColor clearColor];
        [self addSubview:bgView];
        
    
        NSMutableArray  *temp = [[NSMutableArray alloc]init];
        
        for (int i = 0; i<titleArr.count; i++) {
            
            UIButton *btn = [[UIButton alloc]init];
            btn.backgroundColor = [UIColor clearColor];
            [btn setTitleColor:Color_FromRGB(0x666666) forState:UIControlStateNormal];
            [btn setTitle:titleArr[i] forState:UIControlStateNormal];
            btn.titleLabel.font = WYFONT_SIZED(14);
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = BTN_TAG+i;
            [bgView addSubview:btn];
            
            UIView *lineBottomView = [[UIView alloc]init];
            lineBottomView.backgroundColor = Color_FromRGB(0xdedede);
            [btn addSubview:lineBottomView];
            
       
            UIView *lineView = [[UIView alloc]init];
            lineView.tag = LINE_TAG+i;
            
            
            /*顶部红色线条*/
            if (i == selectIndex) {
                lineView.backgroundColor = kCustomRedColor;
                [btn setTitleColor:Color_FromRGB(0xe43337) forState:UIControlStateNormal];
                _lastTag = BTN_TAG+i;
            }
            [btn addSubview:lineView];
            
            
            btn.sd_layout.heightIs(WH_SCALE(35));
            
            lineBottomView.sd_layout
            .leftSpaceToView(btn, 0)
            .rightSpaceToView(btn, 0)
            .bottomSpaceToView(btn, 0)
            .heightIs(1);
            
            lineView.sd_layout
            .leftSpaceToView(btn, (self.width/titleArr.count-WH_SCALE(46))/2)
            .rightSpaceToView(btn, (self.width/titleArr.count-WH_SCALE(46))/2)
            .bottomSpaceToView(btn, 0)
            .heightIs(2);
            
            [temp addObject:btn];
        }
        
        bgView.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(self, 0)
        .bottomSpaceToView(self, 0);
        
        
        [bgView setupAutoWidthFlowItems:[temp copy] withPerRowItemsCount:titleArr.count verticalMargin:0 horizontalMargin:0 verticalEdgeInset:0 horizontalEdgeInset:0 ];
        
    }
    
    
    return self;
}

- (void)selectClick:(block)block {
    
    self.clickBlock = block;
}

- (void)btnClick:(UIButton*)sender {
    
    if (_lastTag == sender.tag) return;
    
    UIButton *lastbtn = [self viewWithTag:_lastTag];
    lastbtn.backgroundColor = Color_FromRGB(0xffffff);
    [lastbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    UIView *lastlineView = [self viewWithTag:_lastTag-BTN_TAG+LINE_TAG];
    lastlineView.backgroundColor = [UIColor clearColor];
    
    [sender setTitleColor:Color_FromRGB(0xe43337) forState:UIControlStateNormal];
    
    UIView *lineView = [self viewWithTag:sender.tag-BTN_TAG+LINE_TAG];
    lineView.backgroundColor = Color_FromRGB(0xe43337);
    
    _lastTag = sender.tag;
    
    self.clickBlock(sender.tag-BTN_TAG);
    
}

@end
