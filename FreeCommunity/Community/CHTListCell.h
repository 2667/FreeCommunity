//
//  CHTListCell.h
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/23.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHTListModel;
@interface CHTListCell : UITableViewCell

+ (CGFloat)heightWith:(NSString *)title image:(BOOL)image;

@property (nonatomic, strong) CHTListModel *model;

@end
