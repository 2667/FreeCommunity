//
//  CHTListModel.h
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/23.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AVObject;
@interface CHTListModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userImage;
@property (nonatomic, copy) NSString *objectId;
@property (nonatomic, strong) NSNumber *topicID;
@property (nonatomic, strong) NSNumber *seeCount;
@property (nonatomic, strong) NSNumber *answerCount;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *answerTime;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) NSArray *images;

- (NSDictionary *)dictOfModel;
- (instancetype)initAsNewModel;
- (instancetype)initWithObject:(AVObject *)object;

@end
