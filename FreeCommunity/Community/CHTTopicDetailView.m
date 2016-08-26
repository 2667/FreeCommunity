//
//  CHTTopicDetailView.m
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/26.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import "CHTTopicDetailView.h"
#import "CHTTopicDetailHeader.h"

@implementation CHTTopicDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.width, self.height - 64 - 30) style:UITableViewStylePlain];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.tableView];
}

- (void)setHeaderModel:(CHTListModel *)headerModel {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 100)];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 2;
    [view addSubview:titleLabel];
    titleLabel.text = headerModel.title;
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(15);
        make.top.equalTo(view).offset(15);
        make.right.equalTo(view).offset(-15);
    }];
    
    UIImageView *seeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"see"]];
    [view addSubview:seeImage];
    [seeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
        make.left.equalTo(titleLabel);
        make.height.equalTo(@15);
        make.width.equalTo(@20);
    }];
    
    UILabel *seeLabel = [[UILabel alloc] init];
    [self setupLabel:seeLabel];
    seeLabel.text = [NSString stringWithFormat:@"%@", headerModel.seeCount];
    [view addSubview:seeLabel];
    [seeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(seeImage);
        make.left.equalTo(seeImage.mas_right).offset(5);
    }];
    
    UIImageView *answerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"answer"]];
    [view addSubview:answerImage];
    [answerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(seeImage);
        make.left.equalTo(seeLabel.mas_right).offset(20);
        make.height.equalTo(seeImage);
        make.width.equalTo(seeImage);
    }];
    
    UILabel *answerLabel = [[UILabel alloc] init];
    [self setupLabel:answerLabel];
    answerLabel.text = [NSString stringWithFormat:@"%@", headerModel.answerCount];
    [view addSubview:answerLabel];
    [answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(answerImage);
        make.left.equalTo(answerImage.mas_right).offset(5);
    }];
    
    [seeImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view).offset(-15);
    }];
    
    CGFloat height = [headerModel.title boundingRectWithSize:CGSizeMake(self.width - 30, 100) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:17]} context:nil].size.height;
    height = height < 50 ? height : 50;
    [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
    view.height = height + 60;
    
    self.tableView.tableHeaderView = view;
}

- (void)setupLabel:(UILabel *)label {
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:12];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
