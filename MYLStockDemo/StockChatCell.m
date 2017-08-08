//
//  StockChatCell.m
//  MYLStockDemo
//
//  Created by myl on 2017/8/8.
//  Copyright © 2017年 myl. All rights reserved.
//

#import "StockChatCell.h"
#import "KLineChartView.h"
#import "KLineListTransformer.h"
#import "WYHorScreenView.h"
@interface StockChatCell ()<YKLineChartViewDelegate>

@property (nonatomic, strong) KLineListTransformer *lineListTransformer;
@property (nonatomic, strong) KLineChartView       *kLineChartView;

@property (nonatomic, strong)YKTimeLineView          *timeLineView;
@property (nonatomic, strong)YKTimeDataset           *timeSet;
@property (nonatomic, strong)UIButton                *showHorControl;
@property (nonatomic, assign)CGFloat                 viewHeight;
@end
@implementation StockChatCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
         self.viewHeight =  WH_SCALE(240);
        
        /*
         点击横屏
         */
        self.showHorControl = [[UIButton alloc]init];
        self.showHorControl.backgroundColor = [UIColor clearColor];
        self.showHorControl .frame = CGRectMake(0, 0, kScreenWidth,_viewHeight);
        [self.showHorControl addTarget:self action:@selector(showHorScreen) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.showHorControl];
    }
    return self;
}

//添加k线数据
- (void)addDataWithKIineDataArr:(NSMutableArray *)kIineDataArr {
    
    NSMutableArray *candlestickData = [[NSMutableArray alloc] init];
    if (self.selecIndex == 0 || self.selecIndex == 1) {
        
        /*
         分时数据 解析 
         因为分时图数据需要 日期的参数，所以传回处理的dataArr 格式为
         [@{@"2015-08-02":当天的分时总数组},@{"2015-08-03":当天的分时总数组}...]
         */
        [self.kLineChartView removeFromSuperview];
        [self initTimeLineView];
        NSMutableArray *dateArr = [[NSMutableArray alloc]init];
        NSMutableArray *dateListArr = [[NSMutableArray alloc]init];
        
        for (NSDictionary *dic in kIineDataArr) {
            [dateArr addObject:dic.allKeys[0]];
            [dateListArr addObjectsFromArray:dic[dic.allKeys[0]]];

        }
        for(int i = 0;i<dateListArr.count;i++){
            NSDictionary *dataArr = dateListArr[i];
            
            YKTimeLineEntity * e = [[YKTimeLineEntity alloc]init];
            e.currtTime = [NSString stringWithFormat:@"%@:%@",[(NSString*)dataArr[@"time"] substringWithRange:NSMakeRange(0, 2)],[(NSString*)dataArr[@"time"] substringWithRange:NSMakeRange(2, 2)]];
            e.lastPirce = [dataArr[@"nowPrice"] doubleValue];
            e.avgPirce = [dataArr[@"avgPrice"] doubleValue];
            e.preClosePx = [self.stock.yestodayClosePrice doubleValue];
            e.volume = [dataArr[@"volume"] longLongValue];
            e.rate = [NSString stringWithFormat:@"%%%2.f",(e.lastPirce-e.preClosePx)/e.preClosePx];
            [candlestickData addObject:e];
            
        }
        
        /*若每天开盘前没有数据 则给一组默认值*/
        if (kIineDataArr.count==0||kIineDataArr==nil) {
            YKTimeLineEntity * e = [[YKTimeLineEntity alloc]init];
            e.currtTime =@"";
            e.lastPirce = 1565;
            e.avgPirce = 0;
            e.preClosePx =0;
            e.volume = 0;
            e.rate = @"0.2";
            [candlestickData addObject:e];
        }
        
        self.timeSet.data = candlestickData;
        self.timeSet.dateArr = dateArr;
        [self.timeLineView setupData:self.timeSet];
        
    }else
    {
        
        /*
         k线数据 解析
         */
        [self.timeLineView removeFromSuperview];
        [self initKineView];
        
        self.kLineChartView.showRSIChart = NO;
        self.kLineChartView.showBarChart = YES;
        NSDictionary *dic =   [[KLineListTransformer sharedInstance] managerTransformData:[kIineDataArr copy]];
        [self.kLineChartView drawChartWithData:dic];
    }
    
}

#pragma mark ====== k线图 ===========
- (void)initKineView {
    
    if (!_kLineChartView) {
        _kLineChartView = [[KLineChartView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 10.0f,_viewHeight-10)];
    }
    _kLineChartView.backgroundColor = [UIColor whiteColor];
    _kLineChartView.topMargin = 10.0f;
    _kLineChartView.rightMargin = 1.0;
    _kLineChartView.bottomMargin = _viewHeight/3.0;
    _kLineChartView.kLineWidth = 4;
    
    //是否支持手势  只有横屏才会支持
    _kLineChartView.supportGesture = NO;
    _kLineChartView.scrollEnable = NO;
    _kLineChartView.zoomEnable = NO;
    
    [self.contentView addSubview:self.kLineChartView];
    [self setupAutoHeightWithBottomView:self.timeLineView bottomMargin:5];
    //添加点击全屏手势
    [self.contentView bringSubviewToFront:self.showHorControl];
}

#pragma mark ====== 分时图 ===========

- (void)initTimeLineView {
    
    if (!self.timeLineView) {
        self.timeLineView = [[YKTimeLineView alloc]init];
    }
    self.timeLineView.gridBackgroundColor = [UIColor whiteColor];
    self.timeLineView.borderColor = [UIColor colorWithRed:203/255.0 green:215/255.0 blue:224/255.0 alpha:1.0];
    self.timeLineView.borderWidth = .5;
    self.timeLineView.uperChartHeightScale = 0.6;
    self.timeLineView.xAxisHeitht = 25;
    
    /*
     注意 分时为242和坐标点   五日为 242*5个坐标点
     */
    self.timeLineView.countOfTimes =242*(self.selecIndex==0?1:5);
    
    self.timeLineView.endPointShowEnabled = NO;
    self.timeLineView.isDrawAvgEnabled = YES;
    
    if (!self.timeSet) {
        self.timeSet   = [[YKTimeDataset alloc]init];
    }
    
    _timeSet.avgLineCorlor = [UIColor colorWithRed:253/255.0 green:179/255.0 blue:8/255.0 alpha:1.0];
    _timeSet.priceLineCorlor = [UIColor colorWithRed:24/255.0 green:96/255.0 blue:254/255.0 alpha:1.0];
    _timeSet.lineWidth = 1.f;
    _timeSet.highlightLineWidth = .8f;
    _timeSet.highlightLineColor = [UIColor colorWithRed:60/255.0 green:76/255.0 blue:109/255.0 alpha:1.0];
    
    _timeSet.volumeTieColor = [UIColor grayColor];
    _timeSet.volumeRiseColor = [UIColor colorWithRed:233/255.0 green:47/255.0 blue:68/255.0 alpha:1.0];
    _timeSet.volumeFallColor = [UIColor colorWithRed:33/255.0 green:179/255.0 blue:77/255.0 alpha:1.0];
    
    _timeSet.fillStartColor = [UIColor colorWithRed:24/255.0 green:96/255.0 blue:254/255.0 alpha:1.0];
    _timeSet.fillStopColor = [UIColor whiteColor];
    _timeSet.fillAlpha = .5f;
    _timeSet.drawFilledEnabled = YES;
    
    self.timeLineView.delegate = self;
    self.timeLineView.highlightLineShowEnabled = YES;
    self.timeLineView.leftYAxisIsInChart = YES;
    self.timeLineView.rightYAxisDrawEnabled = YES;
    [self.contentView addSubview:self.timeLineView];
    
    
    self.timeLineView.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView,10)
    .heightIs(_viewHeight-20);
    
    [self setupAutoHeightWithBottomView:self.timeLineView bottomMargin:5];
    
    //添加点击全屏手势
    [self.contentView bringSubviewToFront:self.showHorControl];
    
}

#pragma mark ====== 横屏展示 ===========
- (void)showHorScreen {
    
    WYHorScreenView *horScreenView = [[WYHorScreenView alloc]initWithFrame:CGRectMake(0, 0, kScreenHeight, kScreenWidth) SelecIndex:self.selecIndex];
    horScreenView.stock = self.stock;
    [horScreenView getDataWithSelectIndex:_selecIndex];
    horScreenView.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].delegate.window addSubview:horScreenView];
 
    /*
     横屏翻转
     */
    horScreenView.center = [UIApplication sharedApplication].delegate.window.center;
    [UIView beginAnimations:nil context:nil];
    horScreenView.transform = CGAffineTransformMakeRotation(M_PI/2);
    [UIView setAnimationDuration:2];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[UIApplication sharedApplication].delegate.window cache:NO];
    [UIView commitAnimations];
    
    
    //隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
}



@end
