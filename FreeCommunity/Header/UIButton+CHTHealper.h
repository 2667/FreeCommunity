//
//  UIButton+CHTHealper.h
//  CHTButtonHealper
//
//  Created by risenb_mac on 16/8/22.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CHTButtonEdgeInsetsStyleTop,
    CHTButtonEdgeInsetsStyleLeft,
    CHTButtonEdgeInsetsStyleRight,
    CHTButtonEdgeInsetsStyleBottom,
} CHTButtonEdgeInsetsStyle;

@interface UIButton (CHTHealper)

- (void)layoutButtonWithEdgeInsetsStyle:(CHTButtonEdgeInsetsStyle)style imageTitleSpace:(CGFloat)space;

@end
