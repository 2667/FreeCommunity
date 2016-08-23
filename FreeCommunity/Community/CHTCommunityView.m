//
//  CHTCommunityView.m
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/23.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import "CHTCommunityView.h"
#import "CHTCommunityHeader.h"

@implementation CHTCommunityView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BACK_COLOR;
        [self setup];
    }
    return self;
}

- (void)setup {
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 100, self.height - 64 - 49) style:UITableViewStylePlain];
    self.mainTableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    self.mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.mainTableView];
    
    self.subTableView = [[UITableView alloc] initWithFrame:CGRectMake(100, 64, self.width - 100, self.height - 64 - 49) style:UITableViewStylePlain];
    self.subTableView.backgroundColor = BACK_COLOR;
    self.subTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.subTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.subTableView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
