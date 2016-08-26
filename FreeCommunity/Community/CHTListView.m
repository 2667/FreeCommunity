//
//  CHTListView.m
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/23.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import "CHTListView.h"
#import "CHTListHeader.h"

@interface CHTListView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *topicLabel;
@property (nonatomic, strong) UIButton *btn;

@end

@implementation CHTListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = BACK_COLOR;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.width, self.height - 64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 70)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tiezi1"]];
    self.imageView.backgroundColor = [UIColor colorWithRed:0.134 green:0.745 blue:1.000 alpha:1.000];
    [headerView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(10);
        make.top.equalTo(headerView).offset(10);
        make.bottom.equalTo(headerView).offset(-10);
        make.width.equalTo(self.imageView.mas_height);
    }];
    
    self.topicLabel = [[UILabel alloc] init];
    self.topicLabel.font = [UIFont systemFontOfSize:14];
    self.topicLabel.textColor = [UIColor grayColor];
    self.topicLabel.text = @"主题帖 0";
    [headerView addSubview:self.topicLabel];
    [self.topicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(10);
        make.centerY.equalTo(self.imageView);
    }];
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn.backgroundColor = TOPIC_COLOR;
    self.btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.btn setTitle:@"收藏" forState:UIControlStateNormal];
    [headerView addSubview:self.btn];
    self.btn.layer.cornerRadius = 5;
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView).offset(-10);
        make.centerY.equalTo(self.imageView);
        make.height.equalTo(@25);
        make.width.equalTo(@50);
    }];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.height - 0.5, headerView.width, 0.5)];
    line.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [headerView addSubview:line];
    
    self.tableView.tableHeaderView = headerView;
    
}

- (void)setTopicCount:(NSInteger)count {
    self.topicLabel.text = [NSString stringWithFormat:@"主题帖 %ld", count];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
