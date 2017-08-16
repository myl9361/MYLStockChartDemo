//
//  WYUser.h
//  WYStock
//
//  Created by myl on 2017/5/26.
//  Copyright © 2017年 myl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYUser : NSObject

//--------------------------------------
/*
 记录用户个人信息的单例类
 */


/*
 记录从变横屏前面是,五档还是明细,让横屏展示的跟竖屏统一  0 五档  1 明细
 */
@property (nonatomic, assign)NSInteger           fiveType;

+ (instancetype)sharedInstance;



@end
