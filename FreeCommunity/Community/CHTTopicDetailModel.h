//
//  CHTTopicDetailModel.h
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/26.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVObject;
@interface CHTTopicDetailModel : NSObject

@property (nonatomic, copy) NSString *userImage;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *subAnswers;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) float height;

- (instancetype)initWithObject:(AVObject *)object;

@end
