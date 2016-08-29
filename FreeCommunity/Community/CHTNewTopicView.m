//
//  CHTNewTopicView.m
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/24.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import "CHTNewTopicView.h"
#import "CHTNewTopicHeader.h"

@interface CHTNewTopicView ()<UITextViewDelegate>

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIScrollView *imageScrollView;

@property (nonatomic, strong) NSMutableAttributedString *placeString;

@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) UILabel *imageCountLabel;

@end

@implementation CHTNewTopicView

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

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
    self.textField = [[UITextField alloc] init];
    [self addSubview:self.textField];
    self.textField.font = [UIFont systemFontOfSize:16];
    self.textField.placeholder = @"标题";
    self.textField.canMove = NO;
    self.textField.clearButtonMode = UITextFieldViewModeAlways;
    
    UIView *line = [[UIView alloc] init];
    [self addSubview:line];
    line.backgroundColor = [UIColor colorWithWhite:0.700 alpha:1.000];
    
    self.textView = [[UITextView alloc] init];
    [self addSubview:self.textView];
    self.textView.font = [UIFont systemFontOfSize:15];
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.delegate = self;
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self addSubview:self.bottomView];
    
    self.imageScrollView = [[UIScrollView alloc] init];
    [self.bottomView addSubview:self.imageScrollView];
    self.imageScrollView.showsHorizontalScrollIndicator = NO;
    
    self.addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addImageBtn.frame = CGRectMake(20, 20, 60, 60);
    self.addImageBtn.center = CGPointMake(self.width / 2, 50);
    self.addImageBtn.layer.cornerRadius = 5;
    self.addImageBtn.layer.masksToBounds = YES;
    [self.addImageBtn setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [self.addImageBtn addTarget:self action:@selector(addImageAction) forControlEvents:UIControlEventTouchUpInside];
    [self.imageScrollView addSubview:self.addImageBtn];

    self.photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.photoBtn setImage:[UIImage imageNamed:@"camare"] forState:UIControlStateNormal];
    [self.photoBtn setImage:[UIImage imageNamed:@"keyboard"] forState:UIControlStateSelected];
    [self.photoBtn setImage:[UIImage imageNamed:@"camare_selected"] forState:UIControlStateHighlighted];
    [self.photoBtn setImage:[UIImage imageNamed:@"keyboard_selected"] forState:UIControlStateHighlighted | UIControlStateSelected];

    [self.photoBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.photoBtn];
    
    UIView *line2 = [[UIView alloc] init];
    [self addSubview:line2];
    line2.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
    
    self.label = [[UILabel alloc] init];
    [self addSubview:self.label];
    self.label.font = [UIFont systemFontOfSize:14];
    self.label.textColor = [UIColor colorWithWhite:0.7 alpha:1];
    
    self.imageCountLabel = [[UILabel alloc] init];
    self.imageCountLabel.font = [UIFont systemFontOfSize:13];
    self.imageCountLabel.textColor = [UIColor grayColor];
    [self setImageCount];
    [self.bottomView addSubview:self.imageCountLabel];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@120);
    }];
    
    [self.imageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bottomView);
    }];
    [self.imageCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomView);
        make.bottom.equalTo(self.bottomView).offset(-10);
    }];
    
    [self.photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView.mas_top).offset(-5);
        make.height.equalTo(@30);
        make.width.equalTo(@30);
        make.left.equalTo(self).offset(10);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.photoBtn);
        make.right.equalTo(self).offset(-5);
    }];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);
        make.bottom.equalTo(self.photoBtn.mas_top).offset(-5);
        make.height.equalTo(@0.5);
    }];

    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(7);
        make.right.equalTo(self).offset(-5);
        make.height.equalTo(@30);
        make.top.equalTo(self).offset(64 + 2);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom).offset(2);
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);
        make.height.equalTo(@0.5);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(2);
        make.left.equalTo(line).offset(-2);
        make.right.equalTo(line);
        make.bottom.equalTo(line2.mas_top);
    }];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length) {
        if (self.placeString) {
            self.placeString = nil;
            [self setNeedsDisplay];
        }
    } else {
        self.placeString = [[NSMutableAttributedString alloc] initWithString:self.placeHolder];
        [self.placeString addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithWhite:0.7 alpha:1], NSFontAttributeName : [UIFont systemFontOfSize:15]} range:NSMakeRange(0, self.placeString.length)];
        [self setNeedsDisplay];
    }
}

- (void)showKeyboard:(CGFloat)keyboardHeight {
    self.photoBtn.selected = NO;
    [UIView animateWithDuration:0.25 animations:^{
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(keyboardHeight));
        }];
        [self layoutIfNeeded];
    }];
}

- (void)hideKeyboard {
    self.photoBtn.selected = YES;
    [UIView animateWithDuration:0.25 animations:^{
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(120));
        }];
        [self layoutIfNeeded];
    }];
}

- (void)clickAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        [self endEditing:YES];
        if (self.imageArray.count) {
            return;
        }
        [self addImageAction];
    } else {
        [self.textField becomeFirstResponder];
    }
}

- (void)addImage:(UIImage *)image {
    CGFloat x = 20 + 80 * self.imageArray.count;
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageBtn.frame = CGRectMake(x, 20, 60, 60);
    imageBtn.layer.cornerRadius = 3;
//    imageBtn.layer.masksToBounds = YES;
    [self.imageScrollView addSubview:imageBtn];
    [imageBtn setBackgroundImage:image forState:UIControlStateNormal];
    [self.imageArray addObject:image];
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(x + 50, 10, 20, 20);
    [deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [self.imageScrollView addSubview:deleteBtn];

    CGFloat width = 80 * self.imageArray.count + 100;
    if (self.imageArray.count < 9) {
        self.imageScrollView.contentSize = CGSizeMake(width, 120);
        self.addImageBtn.center = CGPointMake(width - 50, 50);
    } else {
        self.imageScrollView.contentSize = CGSizeMake(width - 80, 120);
        self.addImageBtn.center = CGPointMake(width - 50, 50);
        self.addImageBtn.hidden = YES;
    }
    CGFloat offsetX = self.imageScrollView.contentSize.width - self.width;
    self.imageScrollView.contentOffset = CGPointMake(offsetX > 0 ? offsetX : 0, 0);
    [self setImageCount];
}

- (void)addImageAction {
    if ([[self nextResponder] respondsToSelector:@selector(addImageAction)]) {
        [[self nextResponder] performSelector:@selector(addImageAction) withObject:@(self.imageArray.count)];
    }
}

- (void)deleteAction:(UIButton *)sender {
    self.addImageBtn.hidden = NO;
    NSInteger index = (sender.center.x - 10) / 80;
    [self.imageArray removeObjectAtIndex:index];
    [UIView animateWithDuration:0.5 animations:^{
        for (UIButton *button in self.imageScrollView.subviews) {
            NSInteger btnIndex = (button.center.x - 10) / 80;
            if (btnIndex == index) {
                [button removeFromSuperview];
            } else if (btnIndex > index) {
                button.center = CGPointMake(button.center.x - 80, button.center.y);
            }
        }
        if (self.imageArray.count == 0) {
            self.addImageBtn.center = CGPointMake(self.imageScrollView.width / 2, 50);
        }
        CGFloat width = self.imageArray.count * 80 + 100;
        self.imageScrollView.contentSize = CGSizeMake(width > self.width ? width : self.width, 120);
    }];
    [self setImageCount];
}

- (void)setImageCount {
    self.imageCountLabel.text = [NSString stringWithFormat:@"已选%ld/9", self.imageArray.count];
}

- (CHTListModel *)setTopicModel:(CHTListModel *)model {
    model.images = self.imageArray;
    model.title = self.textField.text;
    model.content = self.textView.text;
    return model;
}

- (NSInteger)countOfImages {
    return self.imageArray.count;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self.placeString drawAtPoint:CGPointMake(6, 109)];
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    self.placeString = [[NSMutableAttributedString alloc] initWithString:self.placeHolder];
    [self.placeString addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithWhite:0.7 alpha:1], NSFontAttributeName : [UIFont systemFontOfSize:15]} range:NSMakeRange(0, self.placeString.length)];
    [self setNeedsDisplay];
}

@end
