//
//  WYFigureFiveView.m
//  WYStock
//
//  Created by myl on 2017/5/16.
//  Copyright © 2017年 myl. All rights reserved.
//

#import "WYFigureFiveView.h"
#define FIG_TAG 6654
@interface WYFigureFiveView ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong)UIView  *figTopView;

@property (nonatomic,strong)UIView  *figbottomView;
@property (nonatomic,strong)UIView  *lineView;

@property (nonatomic,assign)NSInteger       lastSelect;

@property (nonatomic,strong)UIView      *figFiveView;

@property (nonatomic,strong)UITableView *detailTableView;

@property (nonatomic,assign)NSInteger     pageNum;

@property (nonatomic,strong)UIScrollView  *bgScrollView;

@property (nonatomic,strong)UIButton        *figFiveBtn;
@property (nonatomic,strong)UIButton        *detailBtn;
@property (nonatomic,strong)NSMutableArray  *timeDetailArr;

@end
@implementation WYFigureFiveView


- (void)setFrame:(CGRect)frame {

    [super setFrame:frame];
    
    if (!self.timeDetailArr) {
        self.timeDetailArr = [[NSMutableArray alloc]init];
    }
    
    self.bgScrollView.frame = CGRectMake(0, 0, self.width, self.height-30);
    self.bgScrollView.contentSize = CGSizeMake(self.width*2, self.height-30);
    self.bgScrollView.backgroundColor = [UIColor clearColor];
    self.bgScrollView.scrollEnabled = NO;
    [self creatFigFiveView];
    [self creatDetailViews];
    [self creatFigFiveBtn];
}

- (UIScrollView*)bgScrollView {
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc]init];
        [self addSubview:_bgScrollView];
    }
    return _bgScrollView;
}

- (void)setStock:(StockDataModel *)stock {
    
    _stock = stock;
    //卖 五档
    [_figTopView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self makeFiveFigViewWithSuperView:_figTopView];
    
    //买  五档
    [_figbottomView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self makeFiveFigViewWithSuperView:_figbottomView];
    
    [self getPriceDetail];
    
    [self creatFigFiveBtn];
    
    /*
     记录竖屏是展示的五档还是明细  保持横屏统一
     */
    if ([WYUser sharedInstance].fiveType == 0) {
       
        _bgScrollView.contentOffset = CGPointMake(0, 0);
    }else
    {
        _bgScrollView.contentOffset = CGPointMake(self.width, 0);
    }
  
}
#pragma mark---------五档图--------
- (void)creatFigFiveView {
    
    //五档 页面创建
    if (!self.figFiveView) {
        self.figFiveView = [[UIView alloc]init];
        self.figFiveView.backgroundColor = [UIColor clearColor];
        [self.bgScrollView addSubview:self.figFiveView];

    }
    
    if (!self.figTopView) {
        self.figTopView = [[UIView alloc]init];
        self.figTopView.backgroundColor = [UIColor clearColor];
        [self.figFiveView addSubview: self.figTopView];
    }
    
    if (!self.lineView) {
        self.lineView  = [[UIView alloc]init];
        self.lineView.backgroundColor = [UIColor lightGrayColor];
        [self.figFiveView addSubview:self.lineView];
    }
    
    
    if (!self.figbottomView) {
        self.figbottomView = [[UIView alloc]init];
        self.figbottomView.backgroundColor = [UIColor clearColor];
        [self.figFiveView addSubview:self.figbottomView];

    }
    
    //五档图 布局
    self.figFiveView.frame = CGRectMake(0, 0, self.width, self.height-30);

    
    self.figTopView.sd_layout
    .leftSpaceToView(self.figFiveView, 0)
    .topSpaceToView(self.figFiveView, 0)
    .rightSpaceToView(self.figFiveView, 0)
    .autoHeightRatio(0.8);
    
    self.lineView.sd_layout
    .leftSpaceToView(self.figFiveView, 10)
    .rightSpaceToView(self.figFiveView, 10)
    .topSpaceToView(self.figTopView, 7)
    .heightIs(0.5);
    
    
    self.figbottomView.sd_layout
    .leftSpaceToView(self.figFiveView, 0)
    .topSpaceToView(self.lineView, 7)
    .rightSpaceToView(self.figFiveView, 0)
    .autoHeightRatio(0.8);
    


}

/*
 //五档图 的 卖、买 （1 2 3 4 5）数据label赋值
 */
- (void)makeFiveFigViewWithSuperView:(UIView*)contentView {
    if (self.stock == nil) {
        return;
    }
    
    NSMutableArray *sellArr = [[NSMutableArray alloc]initWithCapacity:5];
    for (int y = 0; y<5; y++) {
        UIView *bgview = [[UIView alloc]init];
        bgview.backgroundColor =[UIColor clearColor];
        [contentView addSubview:bgview];
        
        NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:3];
        
        //没横条创建三个 label
        for (int i = 0; i<3; i++) {
            UILabel *label = [[UILabel alloc]init];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = WYFONT_SIZED(10);
            label.textColor = [UIColor grayColor];
            if (i == 0) {
                if (contentView == self.figTopView) {
                    label.text = [NSString stringWithFormat:@"卖%d",5-y];
                }else{
                    label.text = [NSString stringWithFormat:@"买%d",y+1];
                }
                
            }
            if (i == 1) {
                
                if (contentView == self.figTopView) {
                    [self makeLableColorWithLabel:label Price:self.stock.pricesell[4-y]  OtherPrice:self.stock.yestodayClosePrice];
                    label.text =[NSString stringWithFormat:@"%.2f",[self.stock.pricesell[4-y] floatValue]];
                }else{
                    
                    [self makeLableColorWithLabel:label Price:self.stock.pricebuy[y] OtherPrice:self.stock.yestodayClosePrice ];
                    label.text = [NSString stringWithFormat:@"%.2f",[self.stock.pricebuy[y] floatValue]];
                }
            }
            if (i == 2){
                if (contentView == self.figTopView) {
                    label.text = self.stock.volsell[4-y];
                }else{
                    label.text = self.stock.volbuy[y];
                }
            }
            [bgview addSubview:label];
            
            label.sd_layout
            .autoHeightRatio(0.43);
            
            [arr addObject:label];
        }
        
        [bgview setupAutoWidthFlowItems:arr withPerRowItemsCount:3 verticalMargin:0 horizontalMargin:1 verticalEdgeInset:0 horizontalEdgeInset:0];
        
        bgview.sd_layout
        .autoHeightRatio(0.14);
        [sellArr addObject:bgview];
    }
    
    [contentView setupAutoWidthFlowItems:sellArr withPerRowItemsCount:1 verticalMargin:2 horizontalMargin:0 verticalEdgeInset:0 horizontalEdgeInset:0];
    
}

/*
 五档图的价格颜色 对比昨日的收盘价 更改
 */
- (void)makeLableColorWithLabel:(UILabel*)label Price:(NSString*)price OtherPrice:(NSString*)otherPrice {
    

    if ([price compare: otherPrice]==NSOrderedDescending) {
        
        label.textColor = Color_FromRGB(0xe43337);
        
    }else if ([price compare: otherPrice ]==NSOrderedAscending){
        
        label.textColor = kCustomBlueColor;
        
    }else{
        
        label.textColor = Color_FromRGB(0x999999);
    }

}

#pragma mark ------- 明细视图------
- (void)creatDetailViews {
    
    if (!self.detailTableView) {
        self.detailTableView = [[UITableView alloc]init];
        [self.bgScrollView addSubview:self.detailTableView];
    }
    self.detailTableView.frame = CGRectMake(self.width, 0, self.width, self.height-32);
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
    self.detailTableView.backgroundColor = [UIColor clearColor];
    
    self.detailTableView.separatorStyle =NO;
    
    self.pageNum = 1;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNum = 1;
        [self getPriceDetail];
       
    }];
    
    header.lastUpdatedTimeLabel .hidden = YES;
    header.stateLabel.hidden = YES;
    self.detailTableView.mj_header = header;

    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNum++;
        [self getPriceDetail];
    
    }];
   
    footer.stateLabel.font = WYFONT_SIZED(10);

    self.detailTableView.mj_footer = footer;

    
}

#pragma mark  ----------明细的数据 -----------
/*
 数据里面的type 字段
 type:  代表明细成交量的颜色，是阿里云直接返回的  能跟颜色挂钩判断，别问为什么 我也不知道，只知道 拿type判断改变颜色能跟其他股票软件的明细对的上 +_+
 另外几个字段 不做解释，应该都能看懂
 */
- (void)getPriceDetail {
    
    [self.detailTableView.mj_header endRefreshing];
    [self.detailTableView.mj_footer endRefreshing];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"detail" ofType:@"plist"];
    NSMutableDictionary *detailDic = [[NSMutableDictionary alloc ] initWithContentsOfFile:path];
    [self.timeDetailArr setArray:detailDic[@"detailData"][@"result"]];
   [self.detailTableView reloadData];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,16)];
    bgview.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:3];
    
    //没横条创建三个 label
    for (int i = 0; i<3; i++) {
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = WYFONT_SIZED(10);
        label.textColor = Color_FromRGB(0x999999);
        [bgview addSubview:label];
        
        if (i == 0) {
            label.text = @"时间";
        }
        if (i == 1) {
            label.text =  @"成交价";
        }
        if (i == 2) {
            label.text = @"成交量";
        }
        
        label.sd_layout
        .autoHeightRatio(0.5);
        
        [arr addObject:label];
    }
    
    [bgview setupAutoWidthFlowItems:arr withPerRowItemsCount:3 verticalMargin:0 horizontalMargin:1 verticalEdgeInset:0 horizontalEdgeInset:0];
    
    return  bgview;
}

#pragma mark----------明细tableview -----
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 16;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.timeDetailArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString  *detailCell = @"detailCellIdentif";
    
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:detailCell];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIView *bgview = [[UIView alloc]init];
    bgview.backgroundColor =[UIColor clearColor];
    [cell.contentView addSubview:bgview];
    
    NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:3];
    
    //没横条创建三个 label
    for (int i = 0; i<3; i++) {
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = WYFONT_SIZED(10);
        label.textColor = Color_FromRGB(0x999999);
        [bgview addSubview:label];
        
        if (i == 0) {
            label.text = [self.timeDetailArr[indexPath.row][@"time"] substringWithRange:NSMakeRange(0, 5)];
            
        }
        if (i == 1) {
            
            label.text = [NSString stringWithFormat:@"%.2f",[self.timeDetailArr[indexPath.row][@"price"] floatValue]];
            
        }
        
        if (i == 2) {
            NSInteger num = [self.timeDetailArr[indexPath.row][@"tradeNum"] integerValue];
            label.text = [NSString stringWithFormat:@"%ld",(long)num];
            
            if ([self.timeDetailArr[indexPath.row][@"type"] isEqualToString:@"B"]) {
                label.textColor = kCustomRedColor;
                
            }else{
                label.textColor = kCustomBlueColor;
            }
        }
        
        label.sd_layout
        .autoHeightRatio(0.5);
        
        [arr addObject:label];
    }
    
    bgview.sd_layout
    .leftSpaceToView(cell.contentView, 0)
    .rightSpaceToView(cell.contentView, 0)
    .widthIs(tableView.frame.size.width);

  
    [bgview setupAutoWidthFlowItems:arr withPerRowItemsCount:3 verticalMargin:0 horizontalMargin:1 verticalEdgeInset:0 horizontalEdgeInset:0];
    [cell  setupAutoHeightWithBottomView:bgview bottomMargin:0];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:kScreenWidth tableView:tableView];
    
}

#pragma mark-----------五档 明细按钮----------
- (void)creatFigFiveBtn {
    
    if (!self.figFiveBtn) {
        self.figFiveBtn = [[UIButton alloc]init];
        [self addSubview:self.figFiveBtn];
    }
    
   
    [self.figFiveBtn setTitle:@"五档" forState:UIControlStateSelected];
    [self.figFiveBtn setTitle:@"五档" forState:UIControlStateNormal];
    [self.figFiveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.figFiveBtn setTitleColor:kCustomRedColor forState:UIControlStateNormal];
    self.figFiveBtn.layer.borderColor  = kCustomRedColor.CGColor;
    self.figFiveBtn.layer.borderWidth =  0.7;
    [self.figFiveBtn setBackgroundColor:[UIColor whiteColor]];
    self.figFiveBtn.selected = NO;
    self.figFiveBtn.titleLabel.font = WYFONT_SIZED(10);
   
    self.figFiveBtn.tag = FIG_TAG;
    if (!self.lastSelect) {
        self.lastSelect = FIG_TAG;
    }
    [self.figFiveBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (!self.detailBtn) {
        self.detailBtn = [[UIButton alloc]init];
        [self addSubview:self.detailBtn];
    }
    
    self.detailBtn.backgroundColor = [UIColor whiteColor];
    [self.detailBtn setTitle:@"明细" forState:UIControlStateSelected];
    [self.detailBtn setTitle:@"明细" forState:UIControlStateNormal];
    [self.detailBtn setBackgroundColor:[UIColor whiteColor]];
    [self.detailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.detailBtn setTitleColor:kCustomRedColor forState:UIControlStateNormal];
    self.detailBtn.layer.borderColor  = kCustomRedColor.CGColor;
    self.detailBtn.layer.borderWidth =  0.7;
    self.detailBtn.selected = NO;
    self.detailBtn.titleLabel.font = WYFONT_SIZED(10);
    [self.detailBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.detailBtn.tag = 1+FIG_TAG;
    
    if ([WYUser sharedInstance].fiveType == 0) {
        [self.detailBtn setBackgroundColor:[UIColor whiteColor]];
        [self.figFiveBtn setBackgroundColor:kCustomRedColor];
        self.figFiveBtn.selected = YES;
    }else if([WYUser sharedInstance].fiveType == 1){
        [self.detailBtn setBackgroundColor:kCustomRedColor];
        self.detailBtn.selected = YES;
        [self.figFiveBtn setBackgroundColor:[UIColor whiteColor]];
    }
    
    
    self.figFiveBtn.sd_layout
    .bottomSpaceToView(self, 5)
    .widthIs(WH_SCALE(50))
    .heightIs(WH_SCALE(20))
    .centerXIs(self.width/2-WH_SCALE(25));
    
    self.detailBtn.sd_layout
    .leftSpaceToView(self.figFiveBtn, 0)
    .bottomSpaceToView(self, 5)
    .widthIs(WH_SCALE(50))
    .heightIs(WH_SCALE(20));

    
}


- (void)btnClick:(UIButton*)sender {
    
    if (self.lastSelect == sender.tag)return;
    
    if (sender.tag == FIG_TAG) {
        self.bgScrollView.contentOffset = CGPointMake(0, 0);
        [WYUser sharedInstance].fiveType = 0;

    }else
    {
        [self creatDetailViews];
        [WYUser sharedInstance].fiveType = 1;
        self.bgScrollView.contentOffset = CGPointMake(self.width, 0);
    }
    
    sender.selected = !sender.selected;
    sender.backgroundColor =kCustomRedColor;
    
    UIButton *otherBtn = [self viewWithTag:self.lastSelect];
    otherBtn.backgroundColor =[UIColor whiteColor];
    otherBtn.selected = !otherBtn.selected;

    
    self.lastSelect = sender.tag;
}



@end
