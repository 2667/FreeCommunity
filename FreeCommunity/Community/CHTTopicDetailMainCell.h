//
//  CHTTopicDetailMainCell.h
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/26.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CHTAnswerDelegate <NSObject>

- (void)answer:(NSString *)answeredName;

@end

@class CHTTopicDetailModel;
@interface CHTTopicDetailMainCell : UITableViewCell

@property (nonatomic, strong) CHTTopicDetailModel *model;

@property (nonatomic, assign) id delegate;

+ (float)heightWith:(NSString *)content imageCount:(NSInteger)count;

@end
