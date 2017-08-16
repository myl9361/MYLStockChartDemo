//
//  PublicDefine.h
//  HXCamouflageCalculator
//
//  Created by 黄轩 on 16/10/17.
//  Copyright © 2016年 黄轩. All rights reserved.
//

#ifndef PublicDefine_h
#define PublicDefine_h

#import <UIKit/UIKit.h>
#import "Common.h"
#import "StockDataModel.h"
#import "YKLineChart.h"
#import "MJExtension.h"
#import "SDAutoLayout.h"
#import "MJRefresh.h"
#import "WYUser.h"
#define WEAKSELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define STOCK_NUM @"600004"

//返回安全的字符串
#define kSafeString(str) str.length > 0 ? str : @""

//状态栏高度
#define STATUS_BAR_HEIGHT 20
//NavBar高度
#define NAVIGATION_BAR_HEIGHT 44
//状态栏 ＋ 导航栏 高度
#define STATUS_AND_NAVIGATION_HEIGHT ((STATUS_BAR_HEIGHT) + (NAVIGATION_BAR_HEIGHT))

//屏幕 rect
#define SCREEN_RECT ([UIScreen mainScreen].bounds)

#define CONTENT_HEIGHT (kScreenHeight - NAVIGATION_BAR_HEIGHT - STATUS_BAR_HEIGHT)

#define WH_SCALE(a) [Common setWidth:a]

//屏幕分辨率
#define SCREEN_RESOLUTION (kScreenWidth * kScreenHeight * ([UIScreen mainScreen].scale))

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([[UIScreen mainScreen] bounds].size.height)

#define UIColorFromHexA(hexValue, a)     [UIColor colorWithRed:(((hexValue & 0xFF0000) >> 16))/255.0f green:(((hexValue & 0xFF00) >> 8))/255.0f blue:((hexValue & 0xFF))/255.0f alpha:a]
#define UIColorFromHex(hexValue)        UIColorFromHexA(hexValue, 1.0f)

#define Color_FromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define Color(r,g,b)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

//NSUserDefaults
#define DefaultsObjectAndKey(object,key)  [[NSUserDefaults standardUserDefaults] setObject:object forKey:key]
#define Defaults_ObjectKey(key)  [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define DefaultsRemoveKey(key)  [[NSUserDefaults standardUserDefaults] removeObjectForKey:key]
#define DefaultSynchronize  [[NSUserDefaults standardUserDefaults] synchronize]

// Image
#define WYIMAGE(bundleResourceName)       [UIImage imageNamed:(bundleResourceName)]

// Font
#define WYFONT_NAMED(fontName, fontSize)  [UIFont fontWithName:fontName size:fontSize]
#define WYFONT_SIZED(fontSize)            [UIFont systemFontOfSize:fontSize*(kScreenWidth / 375)]
#define WYFONT_BOLD_SIZE(fontSize)        [UIFont boldSystemFontOfSize:fontSize*(kScreenWidth / 375)]



#define kCustomRedColor Color_FromRGB(0xe43337)

#define kCustomBlueColor Color_FromRGB(0x58ca69)

#define kCustomBlackColor Color_FromRGB(0x333333)



#endif /* PublicDefine_h */
