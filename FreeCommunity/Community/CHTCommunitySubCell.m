//
//  CHTCommunitySubCell.m
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/23.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import "CHTCommunitySubCell.h"
#import "CHTCommunityHeader.h"
#import "UIButton+WebCache.h"

@interface CHTCommunitySubCell ()

@property (strong, nonatomic) IBOutlet UIButton *image;
@property (strong, nonatomic) IBOutlet UILabel *categoryName;
@property (strong, nonatomic) IBOutlet UILabel *topicLabel;
@property (strong, nonatomic) IBOutlet UILabel *answeiLabel;
@property (strong, nonatomic) IBOutlet UIButton *loveBtn;

@end

@implementation CHTCommunitySubCell

- (IBAction)loveBtn:(id)sender {
    self.loveBtn.selected = !self.loveBtn.isSelected;
}

- (void)setModel:(CHTCommunitySubModel *)model {
    _model = model;
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"tiezi1"]];
    self.categoryName.text = model.subCategoryName;
    AVQuery *query = [AVQuery queryWithClassName:@"Topic"];
    [query whereKey:@"subCategoryID" equalTo:model.subCategoryID];
    [query countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
        self.topicLabel.text = [NSString stringWithFormat:@"主题帖 %ld", number];
    }];
    AVQuery *query2 = [AVQuery queryWithClassName:@"TopicAnswer"];
    [query2 whereKey:@"subCategoryID" equalTo:model.subCategoryID];
    [query2 countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
        self.answeiLabel.text = [NSString stringWithFormat:@"回帖 %ld", number];
    }];
}

- (void)awakeFromNib {
    [self.loveBtn setImage:[UIImage imageNamed:@"loved"] forState:UIControlStateSelected];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
