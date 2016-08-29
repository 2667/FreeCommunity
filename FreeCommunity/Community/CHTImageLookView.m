//
//  CHTImageLookView.m
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/29.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import "CHTImageLookView.h"
#import "Header.h"

@interface CHTImageLookView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UIScrollView *backScrollView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation CHTImageLookView

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images index:(NSInteger)index
{
    self = [super initWithFrame:frame];
    if (self) {
        _array = images;
        self.backgroundColor = [UIColor whiteColor];
        [self setup:images index:index];
    }
    return self;
}

- (void)setup:(NSArray *)images index:(NSInteger)index {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, self.width, self.height - 120)];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    self.imageArray = [NSMutableArray array];
    for (int i = 0; i < images.count; i++) {
        UIScrollView *sub = [[UIScrollView alloc] initWithFrame:CGRectMake(self.width * i, 0, self.width, self.height - 120)];
        sub.delegate = self;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        imageView.center = CGPointMake(sub.width / 2, sub.height / 2);
        [sub addSubview:imageView];
        if (i == index) {
            [self showHUD];
            [imageView sd_setImageWithURL:[NSURL URLWithString:images[i]] placeholderImage:[UIImage imageNamed:@"holder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [self hideHUD];
                imageView.width = self.width;
                imageView.height = imageView.width * (image.size.height / image.size.width);
                imageView.center = CGPointMake(sub.width / 2, sub.height / 2);
            }];
        }
        sub.maximumZoomScale = 2;
        sub.minimumZoomScale = 1;
        [self.imageArray addObject:imageView];
        [scrollView addSubview:sub];
    }
    scrollView.contentSize = CGSizeMake(self.width * images.count, self.height - 120);
    scrollView.contentOffset = CGPointMake(self.width * index, 0);
    self.backScrollView = scrollView;
    [self addSubview:scrollView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.width, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"图片浏览";
    [self addSubview:label];
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height - 60, self.width, 60)];
    self.label.text = [NSString stringWithFormat:@"%ld/%ld", index + 1, images.count];
    [self addSubview:self.label];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont systemFontOfSize:13];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (![scrollView isEqual:self.backScrollView]) {
        return;
    }
    NSInteger index = scrollView.contentOffset.x / self.width;
    for (UIView *view in scrollView.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)view).zoomScale = 1;
        }
    }
    [self showHUD];
    UIImageView *imageView = self.imageArray[index];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.array[index]] placeholderImage:[UIImage imageNamed:@"holder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self hideHUD];
        imageView.width = self.width;
        imageView.height = imageView.width * (image.size.height / image.size.width);
        imageView.center = CGPointMake(imageView.superview.width / 2, imageView.superview.height / 2);
    }];
    self.label.text = [NSString stringWithFormat:@"%ld/%ld", index + 1, self.imageArray.count];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    NSInteger index = self.backScrollView.contentOffset.x / self.width;
    return self.imageArray[index];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    CGFloat height = scrollView.height / 2 - view.height / 2;
    view.y = height > 0 ? height : 0;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
