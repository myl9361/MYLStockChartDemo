//
//  WYHorScreenView.m
//  WYStock
//
//  Created by myl on 2017/5/11.
//  Copyright © 2017年 myl. All rights reserved.
//

#import "WYHorScreenView.h"
#import "WYStockTopBarView.h"
#import "KLineChartView.h"
#import "KLineListTransformer.h"
#import "WYFigureFiveView.h"
#define BTN_TAG  4785474
@interface WYHorScreenView ()<YKLineChartViewDelegate,KLineChartViewdelegate>

@property(nonatomic, assign)NSInteger   selectIndex;

@property(nonatomic, strong)NSMutableArray     *KineDataArr;

@property (nonatomic, strong) KLineListTransformer *lineListTransformer;
@property (nonatomic, strong) KLineChartView *kLineChartView;

@property (nonatomic,strong)YKTimeLineView *timeLineView;
@property (nonatomic,strong)YKTimeDataset  *timeSet;

@property (nonatomic,strong)WYStockTopBarView  *topBarView;

@property (nonatomic,strong)NSMutableArray     *topViewArr;

@property (nonatomic,strong)UIView             *bottomView;

@property (nonatomic,assign)NSInteger          lastSelect;

@property (nonatomic,strong)UILabel            *topTimeLabel;

@property (nonatomic,strong)WYFigureFiveView   *figFiveView;

@end

@implementation WYHorScreenView


- (id)initWithFrame:(CGRect)frame SelecIndex:(NSInteger)selectIndex{
    if (self = [super initWithFrame:frame]) {
        [self initBottomView];
        
        _figFiveView = [[WYFigureFiveView alloc]init];
        _figFiveView.backgroundColor = [UIColor clearColor];
        [self addSubview:_figFiveView];
        
        if (!_KineDataArr) {
            _KineDataArr = [[NSMutableArray alloc]init];
           
        }
        if (!_KineDataArr) {
            _topViewArr  =  [[NSMutableArray alloc]init];
        }
        
        if (!_topViewArr) {
            _topViewArr  =  [[NSMutableArray alloc]init];
        }
        self.selectIndex = selectIndex;
         [self setup];
     }
    return self;
}


/*
 创建选择的TopBar 分时/五日/日k/周k/月k
 */
- (void)setup {
    
     WYStockTopBarView  *view = [[WYStockTopBarView alloc]initWithFrame:
                                 CGRectMake(0, WH_SCALE(50), kScreenHeight, WH_SCALE(35))
                                    SelecIndex:self.selectIndex
                                    titleArr:@[@"分时",@"五日",@"日K",@"周K",@"月K"]];
    [view selectClick:^(NSInteger index) {
        
        self.selectIndex = index;
        [self getDataWithSelectIndex:index];
    }];

    [self addSubview:view];
    self.topBarView = view;
    
    
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor clearColor];
    [self addSubview:topView];
    
  
    for (int i =0; i < 8; i++) {
        
        UILabel *label = [UILabel  new];
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 2;
        label.textColor = [UIColor lightGrayColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = WYFONT_SIZED(13);
        [topView addSubview:label];
        
        label.sd_layout.autoHeightRatio(WH_SCALE(25)/((kScreenHeight-WH_SCALE(210))/4));
        [self.topViewArr addObject:label];
    }
    topView.sd_layout
    .leftSpaceToView(self, 0)
    .topSpaceToView(self, 0)
    .heightIs(WH_SCALE(50))
    .widthIs(kScreenHeight-WH_SCALE(210));
    
    [topView setupAutoWidthFlowItems:self.topViewArr withPerRowItemsCount:4 verticalMargin:0 horizontalMargin:15 verticalEdgeInset:1 horizontalEdgeInset:15];
    
    
    UIButton *removeBtn = [[UIButton alloc]init];
    removeBtn.backgroundColor = [UIColor whiteColor];
    [removeBtn setImage:WYIMAGE(@"icon_close") forState:UIControlStateNormal];
    [removeBtn addTarget:self action:@selector(removeHorView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:removeBtn];
    
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.font  = WYFONT_SIZED(12);
    timeLabel.textColor = [UIColor lightGrayColor];
    timeLabel.text = @"2017-06-05 11:29";
    [self addSubview:timeLabel];
    self.topTimeLabel = timeLabel;
    
    UIView *timeLineView = [[UIView alloc]init];
    timeLineView.backgroundColor = [UIColor blueColor];
    [self addSubview:timeLineView];
    
    UILabel *timeLineLabel = [[UILabel alloc]init];
    timeLineLabel.font  =  WYFONT_SIZED(12);
    timeLineLabel.text  = @"分时";
    timeLineLabel.textColor = [UIColor blueColor];
    [self addSubview:timeLineLabel];
    
    UIView *avgLineView = [[UIView alloc]init];
    avgLineView.backgroundColor = [UIColor orangeColor];
    [self addSubview:avgLineView];
    
    UILabel *avgLineLabel = [[UILabel alloc]init];
    avgLineLabel.font  =  WYFONT_SIZED(12);
    avgLineLabel.text  = @"分时";
    avgLineLabel.textColor =  [UIColor orangeColor];
    [self addSubview:avgLineLabel];
    
    timeLabel.sd_layout
    .topSpaceToView(self.topBarView, 0)
    .leftSpaceToView(self, 30)
    .heightIs(WH_SCALE(27))
    .widthIs(150);
    
    timeLineView.sd_layout
    .leftSpaceToView(self, kScreenHeight/2+30)
    .topSpaceToView(self.topBarView, WH_SCALE(27)/2)
    .heightIs(1)
    .widthIs(15);
    
    timeLineLabel.sd_layout
    .leftSpaceToView(timeLineView, 3)
    .topEqualToView(timeLabel)
    .heightIs(WH_SCALE(27))
    .widthIs(30);

    avgLineView.sd_layout
    .leftSpaceToView(timeLineLabel,25)
    .topSpaceToView(self.topBarView, WH_SCALE(27)/2)
    .heightIs(1)
    .widthIs(15);
    
    avgLineLabel.sd_layout
    .leftSpaceToView(avgLineView, 3)
    .topEqualToView(timeLabel)
    .heightIs(WH_SCALE(27))
    .widthIs(30);

    
    removeBtn.sd_layout
    .topSpaceToView(self, 7)
    .leftSpaceToView(self, kScreenHeight-35)
    .widthIs(25)
    .heightIs(25);
    

}



//移除该横屏页面
- (void)removeHorView {
    
    //显示状态栏
   [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self removeFromSuperview];
}

//添加k线数据
- (void)addDataWithKIineDataArr:(NSMutableArray *)kIineDataArr StockDataModel:(StockDataModel*)stock{
    
    
    if (kIineDataArr.count != 0) {
        
        NSMutableArray *candlestickData = [[NSMutableArray alloc] init];
        
        if (self.selectIndex == 0 || self.selectIndex == 1) {
            
            _bottomView .frame = CGRectMake(32, kScreenWidth-WH_SCALE(35)+100, kScreenHeight - 52, WH_SCALE(30));
            
            [self.kLineChartView removeFromSuperview];
            [self initTimeLineViewWithStockDataModel:stock];
            self.stock = stock;
            

            NSMutableArray *dateArr = [[NSMutableArray alloc]init];
            NSMutableArray *dateListArr = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in kIineDataArr) {
                [dateArr addObject:dic.allKeys[0]];
                [dateListArr addObjectsFromArray:dic[dic.allKeys[0]]];
            }
            YKTimeLineEntity *lastEntity;
            for(int i = 0;i<dateListArr.count;i++){
                NSDictionary *datadic = dateListArr[i];
                
                YKTimeLineEntity * e = [[YKTimeLineEntity alloc]init];
                e.currtTime = [NSString stringWithFormat:@"%@:%@",[(NSString*)datadic[@"time"] substringWithRange:NSMakeRange(0, 2)],[(NSString*)datadic[@"time"] substringWithRange:NSMakeRange(2, 2)]];
                e.lastPirce = [datadic[@"nowPrice"] doubleValue];
                e.avgPirce = [datadic[@"avgPrice"] doubleValue];
                e.preClosePx = [self.stock.yestodayClosePrice doubleValue];
                e.volume = [datadic[@"volume"] longLongValue];
                e.rate = [NSString stringWithFormat:@"%%%2.f",(e.lastPirce-e.preClosePx)/e.preClosePx];
                [candlestickData addObject:e];
                if (i == dateListArr.count-1) {
                    lastEntity = e;
                }
                
            }

            NSString *timeStr = [NSString stringWithFormat:@"%@ %@",dateArr[dateArr.count-1],lastEntity.currtTime];
            NSMutableString *str = [[NSMutableString alloc]initWithString:timeStr];
            [str insertString:@"-" atIndex:4];
            [str insertString:@"-" atIndex:7];
            _topTimeLabel.text = str;
            
            self.timeSet.data = candlestickData;
            self.timeSet.dateArr = dateArr;
            [self.timeLineView setupData:self.timeSet];
            
        }else
        {
            //移除打牌屏幕外面
              _figFiveView.frame = CGRectMake(kScreenHeight+100, 0, 0, 0);
            
            [self.timeLineView removeFromSuperview];
            [self initKineView];
            
           _bottomView .frame = CGRectMake(32, kScreenWidth-WH_SCALE(35), kScreenHeight - 52, WH_SCALE(30));
           
            NSDictionary *dic =   [[KLineListTransformer sharedInstance] managerTransformData:[kIineDataArr copy]];
            [self.kLineChartView drawChartWithData:dic];
        }
        
    }
    
}


#pragma mark ====== k线图 ===========

- (void)initKineView {
    
    if (!_kLineChartView) {
        _kLineChartView = [[KLineChartView alloc] initWithFrame:CGRectMake(10,WH_SCALE(85), kScreenHeight - 20.0f,kScreenWidth-WH_SCALE(95+35))];
    }
    _kLineChartView.backgroundColor = [UIColor whiteColor];
    _kLineChartView.topMargin = WH_SCALE(27);
    _kLineChartView.rightMargin = 10.0;
    _kLineChartView.bottomMargin = 85.0f;
    _kLineChartView.timeAxisHeight = 30;
    _kLineChartView.kLineWidth = 4;
    _kLineChartView.delegate = self;
    // YES表示：Y坐标的值根据视图中呈现的k线图的最大值最小值变化而变化；NO表示：Y坐标是所有数据中的最大值最小值，不管k线图呈现如何都不会变化。默认YES
    //_kLineChartView.yAxisTitleIsChange = NO;
    
    // 及时更新k线图
    //_kLineChartView.dynamicUpdateIsNew = YES;
    
    //是否支持手势
    _kLineChartView.supportGesture = YES;
    
    [self  addSubview:self.kLineChartView];
    
}



- (void)initBottomView {
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(32, kScreenWidth-WH_SCALE(35)+100, kScreenHeight - 52, WH_SCALE(30))];
    _bottomView.backgroundColor = [UIColor clearColor];
   [self addSubview:_bottomView];
    NSMutableArray  *btnArr = [[NSMutableArray alloc]init];
    NSArray   *titleArr = @[@"VOL",@"MACD",@"KDJ",@"RSI"];
    
    for (int i = 0; i<4; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:Color_FromRGB(0x019FFD) forState:UIControlStateSelected];
        btn.tag = BTN_TAG+i+50;
        [btn addTarget:self action:@selector(bottomSelectClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:btn];
        [btnArr addObject:btn];
        if (i == 0){
           btn.selected = YES;
           self.lastSelect = BTN_TAG+50;
        }
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:0.3].CGColor;
        btn.sd_layout
        .autoHeightRatio(WH_SCALE(30)/(_bottomView.width/4));
    }
    
    [_bottomView setupAutoWidthFlowItems:btnArr withPerRowItemsCount:4 verticalMargin:0 horizontalMargin:0 verticalEdgeInset:0 horizontalEdgeInset:0];

    
}

- (void)bottomSelectClick:(UIButton*)sender {
    
    if (sender.tag == self.lastSelect) {
        
        return;
    }
    
    if (sender.tag == BTN_TAG+50) {
        
        _kLineChartView.showBarChart = YES;
        _kLineChartView.showKDJChart = NO;
        _kLineChartView.showRSIChart = NO;
        _kLineChartView.showMACDChart = NO;
        
    }else if (sender.tag == BTN_TAG+51){
        
        _kLineChartView.showMACDChart = YES;
        _kLineChartView.showKDJChart = NO;
        _kLineChartView.showBarChart = NO;
        _kLineChartView.showRSIChart = NO;
     
        
    }else if (sender.tag == BTN_TAG+52){
        
        _kLineChartView.showKDJChart = YES;
        
        _kLineChartView.showBarChart = NO;
        _kLineChartView.showRSIChart = NO;
        _kLineChartView.showMACDChart = NO;
        
    }else{
        
        _kLineChartView.showRSIChart = YES;
        _kLineChartView.showBarChart = NO;
        _kLineChartView.showKDJChart = NO;
        _kLineChartView.showMACDChart = NO;
    }
    
    sender.selected = !sender.selected;
    
    UIButton *lastBtn = [self viewWithTag:self.lastSelect];
    lastBtn.selected = !lastBtn.selected;
    
    self.lastSelect = sender.tag;
}

#pragma mark ====== 分时图 ===========

- (void)initTimeLineViewWithStockDataModel:(StockDataModel*)stock {
    
    if (!self.timeLineView) {
        self.timeLineView = [[YKTimeLineView alloc]init];
    }
    self.timeLineView.frame = CGRectMake(10, WH_SCALE(85+27), kScreenHeight - 20.0f-(self.isHaveFigFive&&self.selectIndex==0?WH_SCALE(130):10),kScreenWidth-WH_SCALE(95+27));
    
    self.timeLineView.gridBackgroundColor = [UIColor whiteColor];
    self.timeLineView.borderColor = [UIColor colorWithRed:203/255.0 green:215/255.0 blue:224/255.0 alpha:1.0];
    self.timeLineView.borderWidth = .5;
    self.timeLineView.uperChartHeightScale = 0.6;
    self.timeLineView.xAxisHeitht = 25;
   self.timeLineView.countOfTimes =242*(self.selectIndex==0?1:5);
    self.timeLineView.endPointShowEnabled = NO;
    self.timeLineView.isDrawAvgEnabled = YES;
    
    YKTimeDataset * set  = [[YKTimeDataset alloc]init];
    set.avgLineCorlor = [UIColor colorWithRed:253/255.0 green:179/255.0 blue:8/255.0 alpha:1.0];
    set.priceLineCorlor = [UIColor colorWithRed:24/255.0 green:96/255.0 blue:254/255.0 alpha:1.0];
    set.lineWidth = 1.f;
    set.highlightLineWidth = .8f;
    set.highlightLineColor = [UIColor colorWithRed:60/255.0 green:76/255.0 blue:109/255.0 alpha:1.0];
    
    set.volumeTieColor = [UIColor grayColor];
    set.volumeRiseColor = [UIColor colorWithRed:233/255.0 green:47/255.0 blue:68/255.0 alpha:1.0];
    set.volumeFallColor = [UIColor colorWithRed:33/255.0 green:179/255.0 blue:77/255.0 alpha:1.0];
    
    set.fillStartColor = [UIColor colorWithRed:24/255.0 green:96/255.0 blue:254/255.0 alpha:1.0];
    set.fillStopColor = [UIColor whiteColor];
    set.fillAlpha = .5f;
    set.drawFilledEnabled = YES;
    self.timeLineView.delegate = self;
    self.timeLineView.highlightLineShowEnabled = YES;
    self.timeLineView.leftYAxisIsInChart = YES;
    self.timeLineView.rightYAxisDrawEnabled = YES;
    self.timeLineView.isShowHorScreen = YES;
    [self  addSubview:self.timeLineView];
    self.timeSet = set;
    [self.timeLineView setupData:self.timeSet];
    
    //五档图
    if (self.isHaveFigFive) {
        _figFiveView.frame = CGRectMake(kScreenHeight-WH_SCALE(130)-10, WH_SCALE(85+27), WH_SCALE(130),kScreenWidth-WH_SCALE(95+27));
        _figFiveView.stock = self.stock;
        
    }else{
        _figFiveView.frame = CGRectMake(kScreenHeight+100, 0, 0, 0);
    }
    
}

#pragma mark --------k线delegate

/*
 十字线滑动
 */
-(void)chartValueSelected:(YKViewBase *)chartView entry:(id)entry entryIndex:(NSInteger)entryIndex
{
 
    YKTimeLineEntity *entrys = (YKTimeLineEntity*)entry ;
    [(UILabel*)[self.topViewArr objectAtIndex:1] setText:[NSString stringWithFormat:@"%.2f",entrys.lastPirce]];
    
    
    [(UILabel*)[self.topViewArr objectAtIndex:3] setText:[NSString stringWithFormat:@"成交:%@",[Common unitConversionWithNum:[NSString stringWithFormat:@"%.0f",entrys.volume]]]];
  
    NSString   *addsub = [NSString stringWithFormat:@"%@%.2f",entrys.lastPirce-entrys.preClosePx>0?@"+":@"",entrys.lastPirce-entrys.preClosePx];
    NSString   *Proportion = [NSString stringWithFormat:@"%@%.2f%%",entrys.lastPirce-entrys.preClosePx>0?@"+":@"",(entrys.lastPirce-entrys.preClosePx)*100/entrys.preClosePx];
    [(UILabel*)[self.topViewArr objectAtIndex:5] setText:[NSString stringWithFormat:@"%@ %@    ",addsub,Proportion]];
    
    if ([addsub containsString:@"+"]) {
        [(UILabel*)[self.topViewArr objectAtIndex:1] setTextColor:kCustomRedColor];
        [(UILabel*)[self.topViewArr objectAtIndex:5] setTextColor:kCustomRedColor];
    }else
    {
        [(UILabel*)[self.topViewArr objectAtIndex:5] setTextColor:kCustomBlueColor];
        [(UILabel*)[self.topViewArr objectAtIndex:1] setTextColor:kCustomBlueColor];
    }

}
/*
 十字线消失
 */
- (void)chartValueNothingSelected:(YKViewBase *)chartView
{
    
    [self fillTopViewWithStockDataModel:self.stock];
}

/*
 滑动到最左边
 */
- (void)chartKlineScrollLeft:(YKViewBase *)chartView
{
    //可做处理
}

/*
 获取数据 等同于请求数据 
 */
- (void)getDataWithSelectIndex:(NSInteger)selectIndex {
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"dataSource" ofType:@"plist"];
    NSMutableDictionary *usersDic = [[NSMutableDictionary alloc ] initWithContentsOfFile:path];
    NSArray *resultArr ;
    if (selectIndex == 0||selectIndex==1) {
        //数据解析  1 为 分时
        resultArr =  [Common makeStockDetailWithDic:selectIndex==0?usersDic[@"timeData"]:usersDic[@"fiveTimeData"] Type:1];
    }else{
        
        //数据解析  0 为 k线
        
        if (selectIndex == 2) {
            resultArr =  [Common makeStockDetailWithDic:usersDic[@"klineData"] Type:0];
        }else if (selectIndex == 3){
            resultArr =  [Common makeStockDetailWithDic:usersDic[@"weekKlineData"] Type:0];
        }else{
            resultArr =  [Common makeStockDetailWithDic:usersDic[@"yearKlineData"] Type:0];
        }
    }
    
    //dataArr 划线的数据    stock 股票的其他数据
    self.KineDataArr  = [resultArr firstObject];
    self.stock = [resultArr lastObject];
    
    //顶部 视图
    [self fillTopViewWithStockDataModel:self.stock ];
    [self addDataWithKIineDataArr:[_KineDataArr copy] StockDataModel:self.stock];

}

#pragma mark ------  分时delegate -----
/*
 分时十字线滑动的时候调用
 */
- (void)moveToPointWithKLineChartView:(KLineChartView *)chartView lineArr:(NSArray *)arr {
    
    [(UILabel*)[self.topViewArr objectAtIndex:1] setText:[NSString stringWithFormat:@"%@    ",[Common decimalProcessingWithNum:[arr[3] stringValue]]]];
    [(UILabel*)[self.topViewArr objectAtIndex:2] setText:[NSString stringWithFormat:@"今开:%@",[Common decimalProcessingWithNum:[arr[0] stringValue]]]];
    
    NSString  *num =  [NSString stringWithFormat:@"%f",[arr[5] doubleValue]*10000.0];
    
    [(UILabel*)[self.topViewArr objectAtIndex:3] setText:[NSString stringWithFormat:@"成交:%@",[Common unitConversionWithNum:num]]];
    
    [(UILabel*)[self.topViewArr objectAtIndex:6] setText:[NSString stringWithFormat:@"最高:%@",[Common decimalProcessingWithNum:[arr[1] stringValue]]]];
    [(UILabel*)[self.topViewArr objectAtIndex:7] setText:[NSString stringWithFormat:@"最低:%@",[Common decimalProcessingWithNum:[arr[2] stringValue]]]];
    
    NSString   *addsub = [NSString stringWithFormat:@"%@%.2f",[arr[3] floatValue]-[arr[12] floatValue]>0?@"+":@"",[arr[3] floatValue]-[arr[12] floatValue]];
    NSString   *Proportion = [NSString stringWithFormat:@"%@%.2f%%",[arr[3] floatValue]-[arr[12] floatValue]>0?@"+":@"",([arr[3] floatValue]-[arr[12] floatValue])*100/[arr[12] floatValue]];
    [(UILabel*)[self.topViewArr objectAtIndex:5] setText:[NSString stringWithFormat:@"%@ %@    ",addsub,Proportion]];
    
    if ([addsub containsString:@"+"]) {
        [(UILabel*)[self.topViewArr objectAtIndex:1] setTextColor:kCustomRedColor];
        [(UILabel*)[self.topViewArr objectAtIndex:5] setTextColor:kCustomRedColor];
    }else if([addsub floatValue]==0){
        
        [(UILabel*)[self.topViewArr objectAtIndex:1] setTextColor:Color_FromRGB(0x999999)];
        [(UILabel*)[self.topViewArr objectAtIndex:5] setTextColor:Color_FromRGB(0x999999)];
        
    }else
    {
        [(UILabel*)[self.topViewArr objectAtIndex:5] setTextColor:kCustomBlueColor];
        [(UILabel*)[self.topViewArr objectAtIndex:1] setTextColor:kCustomBlueColor];
    }
}
/*
 分时十字线消失的时候调用
 */
- (void)endToPointWithKLineChartView:(KLineChartView *)chartView lineArr:(NSArray *)arr {
    
    [self fillTopViewWithStockDataModel:self.stock];
}

#pragma mark------------当十字线消失的时候 需要填充最新的stock数据
/*
 当十字线消失的时候 需要填充最新的stock数据
 */
- (void)fillTopViewWithStockDataModel:(StockDataModel*)stock {
    
    [(UILabel*)[self.topViewArr objectAtIndex:0] setText:[NSString stringWithFormat:@"   %@",stock.name]];
    
    [(UILabel*)[self.topViewArr objectAtIndex:1] setText:[NSString stringWithFormat:@"%@    ",[Common decimalProcessingWithNum:stock.nowPrice]]];
    [(UILabel*)[self.topViewArr objectAtIndex:1] setTextAlignment:NSTextAlignmentCenter];

    [(UILabel*)[self.topViewArr objectAtIndex:2] setText:[NSString stringWithFormat:@"今开:%@",[Common decimalProcessingWithNum:stock.openPrice]]];
    
    
    
    if (self.stock.code.length>5) {
        [(UILabel*)[self.topViewArr objectAtIndex:3] setText:[NSString stringWithFormat:@"成交:%@",[Common unitConversionWithNum:[NSString stringWithFormat:@"%.2f",[stock.tradeNum floatValue]/100.0]]]];
    }else{
       [(UILabel*)[self.topViewArr objectAtIndex:3] setText:[NSString stringWithFormat:@"成交:%@",[Common unitHKConversionWithNum:[NSString stringWithFormat:@"%.2f",[stock.tradeNum floatValue]/100.0]]]];
    }
    
    [(UILabel*)[self.topViewArr objectAtIndex:4] setText:[NSString stringWithFormat:@"   %@",stock.code]];
    
    
    NSString   *addsub = [NSString stringWithFormat:@"%@%.2f",[stock.nowPrice floatValue]-[stock.yestodayClosePrice floatValue]>0?@"+":@"",[stock.nowPrice floatValue]-[stock.yestodayClosePrice floatValue]];
    NSString   *Proportion = [NSString stringWithFormat:@"%@%.2f%%",[stock.nowPrice floatValue]-[stock.yestodayClosePrice floatValue]>0?@"+":@"",([stock.nowPrice floatValue]-[stock.yestodayClosePrice floatValue])*100/[stock.yestodayClosePrice floatValue]];

    [(UILabel*)[self.topViewArr objectAtIndex:5] setText:[NSString stringWithFormat:@"%@     %@",addsub,Proportion]];
    [(UILabel*)[self.topViewArr objectAtIndex:5] setTextAlignment:NSTextAlignmentCenter];
    
    
    
    [(UILabel*)[self.topViewArr objectAtIndex:6] setText:[NSString stringWithFormat:@"最高:%@",[Common decimalProcessingWithNum:stock.todayMax]]];
    [(UILabel*)[self.topViewArr objectAtIndex:7] setText:[NSString stringWithFormat:@"最低:%@",[Common decimalProcessingWithNum:stock.todayMin]]];
    
    if ([addsub containsString:@"+"]) {
        [(UILabel*)[self.topViewArr objectAtIndex:1] setTextColor:kCustomRedColor];
        [(UILabel*)[self.topViewArr objectAtIndex:5] setTextColor:kCustomRedColor];
    }else if([addsub floatValue]==0){
        
        [(UILabel*)[self.topViewArr objectAtIndex:1] setTextColor:Color_FromRGB(0x999999)];
        [(UILabel*)[self.topViewArr objectAtIndex:5] setTextColor:Color_FromRGB(0x999999)];
        
    }else
    {
        [(UILabel*)[self.topViewArr objectAtIndex:5] setTextColor:kCustomBlueColor];
        [(UILabel*)[self.topViewArr objectAtIndex:1] setTextColor:kCustomBlueColor];
    }
    
}


@end
