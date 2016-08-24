//
//  CHTNewTopicView.h
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/24.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHTListModel;
@interface CHTNewTopicView : UIView

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *label;

- (void)showKeyboard:(CGFloat)keyboardHeight;
- (void)hideKeyboard;

- (CHTListModel *)setTopicModel:(CHTListModel *)model;

- (void)addImage:(UIImage *)image;

- (NSInteger)countOfImages;

@end