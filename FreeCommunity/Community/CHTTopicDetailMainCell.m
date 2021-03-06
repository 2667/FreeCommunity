//
//  CHTTopicDetailMainCell.m
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/26.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import "CHTTopicDetailMainCell.h"
#import "CHTTopicDetailHeader.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface CHTTopicDetailMainCell ()

@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *floorLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UIView *imageBackView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *backViewHeight;

@end

@implementation CHTTopicDetailMainCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(CHTTopicDetailModel *)model {
    
    _model = model;
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:model.userImage] placeholderImage:[UIImage imageNamed:@"TabBarImage_02"]];
    self.userNameLabel.text = model.userName;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd"];
    NSString *modelDate = [dateFormatter stringFromDate:model.date];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    if ([modelDate isEqualToString:currentDate]) {
        modelDate = @"今天";
    }
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm"];
    NSString *modelTime = [timeFormatter stringFromDate:model.date];
    self.dateLabel.text = [NSString stringWithFormat:@"%@ %@", modelDate, modelTime];
    self.contentLabel.text = model.content;
    self.floorLabel.text = [NSString stringWithFormat:@"%ld楼", self.indexPath.section];
    if (self.indexPath.section == 0) {
        self.floorLabel.text = @"楼主";
    }
    [self setImages:model.images];
    
    if (self.indexPath.row) {
        self.contentLabel.font = [UIFont systemFontOfSize:13];
        self.floorLabel.hidden = YES;
        [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userNameLabel);
            make.centerY.equalTo(self.floorLabel);
        }];
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(50);
            make.right.equalTo(self);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
        }];
    } else {
        self.floorLabel.hidden = NO;
        self.contentLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.floorLabel.mas_right).offset(10);
            make.centerY.equalTo(self.floorLabel);
        }];
    }
}

- (void)setImages:(NSArray *)images {
    CGFloat width = (ScreenWidth - 25) / 2;
    CGFloat height = width * 3 / 2;
    for (int i = 0; i < images.count; i++) {
        AVFile *file = [AVFile fileWithURL:images[i]];
        NSString *imageUrl = [file getThumbnailURLWithScaleToFit:YES width:width height:height];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((width + 5) * (i % 2), (height + 5) * (i / 2), width, height)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"holder"]];
        imageView.userInteractionEnabled = YES;
        imageView.tag = 100 + i;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
        [self.imageBackView addSubview:imageView];
    }
    self.backViewHeight.constant = images.count ? (images.count + 1)/2 * height : 0;
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    [_delegate clickImage:sender.view.tag - 100 images:self.model.images];
}

+ (float)heightWith:(NSString *)content imageCount:(NSInteger)count fontSize:(CGFloat)size labelWidth:(CGFloat)width {
    CGFloat labelHeight = [content boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:size]} context:nil].size.height;
//    CGFloat imageHeight = (width / 2 - 12.5)
    CGFloat imagesHeight = (((ScreenWidth - 25) / 2) * 3 / 2 + 5) * ((count + 1) / 2);
    imagesHeight = imagesHeight ? imagesHeight + 5 : 0;
    return imagesHeight + labelHeight + 70;
}

- (IBAction)replayAction:(UIButton *)sender {
    [_delegate answer:self.indexPath];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
