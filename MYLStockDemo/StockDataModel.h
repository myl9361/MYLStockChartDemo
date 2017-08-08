//
//  MIDataModel.h
//  MIKLine
//
//  Created by maia on 16/9/9.
//  Copyright © 2016年 Maia. All rights reserved.
//

#import <Foundation/Foundation.h>
enum StockType{
    StockTypeHS = 0, // 深沪
    StockTypeHK  = 1, // 港股
};
@interface StockDataModel : NSObject

//--------阿里云----------
@property (nonatomic,strong)NSArray        * pricesell;//卖盘价1、2、3、4、5
@property (nonatomic,strong)NSArray        * volsell;//卖盘量1、2、3、4、5
@property (nonatomic,strong)NSArray       * pricebuy;//买盘价1、2、3、4、5.
@property (nonatomic,strong)NSArray       * volbuy;//买盘量1、2、3、4、5
@property (nonatomic,strong)NSMutableArray       *timeDetailArr;//明细数组


@property (nonatomic,strong)NSString       *todayMax;//今日最高价
@property (nonatomic,strong)NSString       *highLimit;//涨停价
@property (nonatomic,strong)NSString       *buy5_n;//买五
@property (nonatomic,strong)NSString       *buy2_n;//买二
@property (nonatomic,strong)NSString       *tradeNum;//成交量(股，不是手)
@property (nonatomic,strong)NSString       *buy2_m;//买二报价
@property (nonatomic,strong)NSString       *buy5_m;//买五报价
@property (nonatomic,strong)NSString       *currcapital;
@property (nonatomic,strong)NSString       *sell3_m;//卖三报价
@property (nonatomic,strong)NSString       *openPrice;//今日开盘价
@property (nonatomic,strong)NSString       *buy3_m;//买三报价
@property (nonatomic,strong)NSString       *buy4_m;//买四报价
@property (nonatomic,strong)NSString       *circulation_value;//流通市值，亿元
@property (nonatomic,strong)NSString       *buy4_n;//买四
@property (nonatomic,strong)NSString       *date;//日期
@property (nonatomic,strong)NSString       *sell5_n;//卖五
@property (nonatomic,strong)NSString       *buy3_n;//买三
@property (nonatomic,strong)NSString       *all_value;//总市值，亿元
@property (nonatomic,strong)NSString       *sell5_m;//卖五报价
@property (nonatomic,strong)NSString       *time;//刷新时间
@property (nonatomic,strong)NSString       *turnover;//换手率
@property (nonatomic,strong)NSString       *sell3_n;//卖三
@property (nonatomic,strong)NSString       *name;//上证指数
@property (nonatomic,strong)NSString       *sell4_n;//卖四
@property (nonatomic,strong)NSString       *downLimit;//跌停价
@property (nonatomic,strong)NSString       *sell4_m;//卖四报价
@property (nonatomic,strong)NSString       *tradeAmount;//成交金额（元）
@property (nonatomic,strong)NSString       *swing;//振幅
@property (nonatomic,strong)NSString       *totalcapital;//总股本，万股
@property (nonatomic,strong)NSString       *diff_rate;//涨跌幅度
@property (nonatomic,strong)NSString       *yestodayClosePrice;//昨日收盘价
@property (nonatomic,strong)NSString       *sell1_n;//卖一
@property (nonatomic,strong)NSString       *todayMin;//今日最低价
@property (nonatomic,strong)NSString       *sell1_m;//卖一报价
@property (nonatomic,strong)NSString       *max52;//52周最高价
@property (nonatomic,strong)NSString       *diff_money;//涨跌金额
@property (nonatomic,strong)NSString       *code;//sh000001
@property (nonatomic,strong)NSString       *nowPrice;//当前价
@property (nonatomic,strong)NSString       *nowprice;//自选 当前价
@property (nonatomic,strong)NSString       *sell2_m;//卖二
@property (nonatomic,strong)NSString       *min52;//52周最低价
@property (nonatomic,strong)NSString       *sell2_n;//卖二
@property (nonatomic,strong)NSString       *buy1_m;//买一报价（金额，元）
@property (nonatomic,strong)NSString       *pe;//市盈率(TTM,动态)
@property (nonatomic,strong)NSString       *buy1_n;//买一数量（股）
@property (nonatomic,strong)NSString       *market;
@property (nonatomic,strong)NSString       *pb;//市净率
@property (nonatomic,strong)NSString       *remark;//市净率

@end
