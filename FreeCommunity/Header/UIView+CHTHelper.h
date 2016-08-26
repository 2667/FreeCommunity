//
//  UIView+CHTHelper.h
//  yinlian
//
//  Created by risenb_mac on 16/4/29.
//  Copyright © 2016年 yinlian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CHTHelper)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;

- (void)showHUD;
- (void)hideHUD;

@end
