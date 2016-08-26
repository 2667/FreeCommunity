//
//  CHTTopicDetailView.h
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/26.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHTListModel;
@interface CHTTopicDetailView : UIView

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) CHTListModel *headerModel;

@end
