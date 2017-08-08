//
//  StockChatCell.h
//  MYLStockDemo
//
//  Created by myl on 2017/8/8.
//  Copyright © 2017年 myl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StockChatCell : UITableViewCell

@property (nonatomic ,assign)NSInteger  selecIndex;//topbar的索引

@property (nonatomic, strong)NSMutableArray *kIineDataArr;

@property (nonatomic, strong)StockDataModel *stock;

//添加数据
- (void)addDataWithKIineDataArr:(NSMutableArray *)kIineDataArr;

@end
