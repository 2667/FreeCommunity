//
//  CHTTopicDetailMainCell.h
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/26.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHTTopicDetailModel;
@interface CHTTopicDetailMainCell : UITableViewCell

@property (nonatomic, strong) CHTTopicDetailModel *model;

+ (float)heightWith:(NSString *)content imageCount:(NSInteger)count;

@end
