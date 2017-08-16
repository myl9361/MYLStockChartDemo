//
//  WYUser.m
//  WYStock
//
//  Created by myl on 2017/5/26.
//  Copyright © 2017年 myl. All rights reserved.
//

#import "WYUser.h"

@implementation WYUser


+ (instancetype)sharedInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
    });
    return instance;
}

@end
