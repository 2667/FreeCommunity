//
//  CHTListCell.m
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/23.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import "CHTListCell.h"
#import "CHTListHeader.h"

@interface CHTListCell ()

@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *imagesBackView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *answerCount;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;

@end

@implementation CHTListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(CHTListModel *)model {
    _model = model;
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:model.userImage] placeholderImage:[UIImage imageNamed:@"TabBarImage_02"]];
    self.titleLabel.text = model.title;
    self.userName.text = model.userName;
    if ([model.images count] == 0) {
        self.viewHeightConstraint.constant = -self.contentView.width / 3;
        self.imagesBackView.hidden = YES;
    } else {
        self.viewHeightConstraint.constant = 0;
        self.imagesBackView.hidden = NO;
        for (UIView *view in self.imagesBackView.subviews) {
            [view removeFromSuperview];
        }
        CGFloat width = self.width / 3 - 10;
        for (int i = 0; i < (model.images.count > 3 ? 3 : model.images.count); i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((width + 5 ) * i, 10, width, width)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[[AVFile fileWithURL:model.images[i]] getThumbnailURLWithScaleToFit:NO width:width height:width]] placeholderImage:[UIImage imageNamed:@"TabBarImage_02"]];
            [self.imagesBackView addSubview:imageView];
        }
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    self.timeLabel.text = [formatter stringFromDate:model.createdAt];
//    AVObject *object = [AVObject objectWithClassName:@"Topic" objectId:model.objectId];
//    AVQuery *query = [AVQuery queryWithClassName:@"TopicAnswer"];
//    [query whereKey:@"topicID" equalTo:model.topicID];
//    [query countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
//        self.answerCount.text = [NSString stringWithFormat:@"%ld", number];
//        model.answerCount = [NSNumber numberWithInteger:number];
//        [object setObject:@(number) forKey:@"answerCount"];
//        [object saveInBackground];
//    }];
    self.answerCount.text = [NSString stringWithFormat:@"%@", model.answerCount];
    [self layoutIfNeeded];
}

+ (CGFloat)heightWith:(NSString *)title image:(BOOL)image {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat labelHeight = [title boundingRectWithSize:CGSizeMake(width - 30, 100) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:15]} context:nil].size.height;
    return labelHeight + 50 + 45 + (image ? width / 3 : 0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
