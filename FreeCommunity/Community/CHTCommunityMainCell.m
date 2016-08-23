//
//  CHTCommunityMainCell.m
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/23.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import "CHTCommunityMainCell.h"
#import "CHTCommunityHeader.h"

@interface CHTCommunityMainCell ()

@property (nonatomic, strong) UIView *leftView;

@end

@implementation CHTCommunityMainCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, self.height)];
        self.leftView.backgroundColor = TOPIC_COLOR;
        [self.contentView addSubview:self.leftView];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.textLabel.textColor = selected ? TOPIC_COLOR : [UIColor darkTextColor];
    self.contentView.backgroundColor = selected ? BACK_COLOR : [UIColor colorWithWhite:0.95 alpha:1];
    self.leftView.hidden = !selected;
    // Configure the view for the selected state
}

@end
