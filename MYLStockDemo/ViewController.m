//
//  ViewController.m
//  MYLStockDemo
//
//  Created by myl on 2017/8/8.
//  Copyright © 2017年 myl. All rights reserved.
//

#import "ViewController.h"
#import "StockChatCell.h"
#import "WYStockTopBarView.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView    *tableView;

@property (nonatomic, strong)NSMutableArray *dataArr;

@property (nonatomic ,strong)StockDataModel  *stock;//股票model

@property (nonatomic ,assign)NSInteger       selectIndex;//顶部topbar的点击索引(分时、五日...)


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     1、项目是在另外的第三方基础的上修改完成
     2、项目的分时、k线视图 每次滑动topbar的时候为移除视图重新添加，可能会损耗app性能，如有需要可做成scrollview添加到不同contentOffset上,自行修改吧 ...
     3、项目的k线数据暂且为一次性加载全部当前k线(日k or 周k or 月k  比如一次加载2010-01-01年到今天的数据)的数据，但只会画当前页k线，大图拖动的时候会根据拖动的距离重新从所请求到的数据源取数据重新绘制 (没有每次滑动到最左边才会在请求数据的数据分页功能)
     4、rsi的值 可能不是国际算法,只能跟 牛股王 对的上，可自行修改
     5、model的 属性名称为阿里云 股票接口返回的数据的名称
     */
    
    self.dataArr = [[NSMutableArray alloc]init];
    [self.view addSubview:self.tableView];
    [self getDataWithSelectIndex:0];
}

/*
 获取数据  等同于数据请求
 */
- (void)getDataWithSelectIndex:(NSInteger)selectIndex {
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"dataSource" ofType:@"plist"];
    NSMutableDictionary *usersDic = [[NSMutableDictionary alloc ] initWithContentsOfFile:path];
    NSArray *resultArr ;
    if (selectIndex == 0||selectIndex==1) {
        //数据解析  1 为 分时
        resultArr =  [Common makeStockDetailWithDic:selectIndex==0?usersDic[@"timeData"]:usersDic[@"fiveTimeData"] Type:1];
    }else{
        
        //数据解析  0 为 k
        
        if (selectIndex == 2) {
            resultArr =  [Common makeStockDetailWithDic:usersDic[@"klineData"] Type:0];
        }else if (selectIndex == 3){
            resultArr =  [Common makeStockDetailWithDic:usersDic[@"weekKlineData"] Type:0];
        }else{
            resultArr =  [Common makeStockDetailWithDic:usersDic[@"yearKlineData"] Type:0];
        }
    }
    
    //dataArr 划线的数据    stock 股票的其他数据
    self.dataArr  = [resultArr firstObject];
    self.stock = [resultArr lastObject];
    [self.tableView reloadData];
}

#pragma mark ------- tableView delegate  -----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return WH_SCALE(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    return WH_SCALE(240);

}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *sectionView = [[UIView alloc]init];
    sectionView.frame = CGRectMake(0, 0, kScreenWidth, WH_SCALE(50));
    sectionView.backgroundColor = Color_FromRGB(0xf5f5f5);
    
    
    WYStockTopBarView  *view = [[WYStockTopBarView alloc]initWithFrame:
                                CGRectMake(0, WH_SCALE(15), kScreenWidth, WH_SCALE(35)) SelecIndex: self.selectIndex
                                                              titleArr:@[@"分时",@"五日",@"日K",@"周K",@"月K"]];
    
    [view selectClick:^(NSInteger index) {
        
      
        self.selectIndex = index;
        [self getDataWithSelectIndex:self.selectIndex];
        
    }];
    
    [sectionView addSubview:view];
    
    return sectionView;

}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString       *identCell =  @"StockChatCell";
    
    StockChatCell *cell = [tableView dequeueReusableCellWithIdentifier:identCell];
    
    if (!cell) {
        cell = [[StockChatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.selecIndex = self.selectIndex;
    cell.stock = self.stock;
    if (self.dataArr.count!=0) {
        [cell addDataWithKIineDataArr:self.dataArr];
    }

    return cell;
}


- (UITableView*)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 200, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    }
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    return _tableView;
}



@end
