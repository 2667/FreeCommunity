//
//  CHTTopicDetailModel.m
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/26.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import "CHTTopicDetailModel.h"
#import <AVObject.h>

@implementation CHTTopicDetailModel

- (instancetype)initWithObject:(AVObject *)object {
    self = [super init];
    if (self) {
        self.userImage = object[@"userImage"];
        self.userName = object[@"userName"];
        self.date = object.createdAt;
        self.content = object[@"content"];
        self.images = object[@"images"];
        self.objectId = object.objectId;
    }
    return self;
}

@end
