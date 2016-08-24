//
//  CHTListModel.m
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/23.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import "CHTListModel.h"
#import <objc/runtime.h>

@implementation CHTListModel

- (NSDictionary *)dictOfModel {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    unsigned int count = 0;
    objc_property_t *list = class_copyPropertyList([CHTListModel class], &count);
    for (int i = 0; i < count; i++) {
        const char *name = property_getName(list[i]);
        NSString *propertyName = [NSString stringWithFormat:@"%s", name];
        if ([self valueForKey:propertyName]) {
            [dict setObject:[self valueForKey:propertyName] forKey:propertyName];
        }
    }
    return dict;
}

- (instancetype)initAsNewModel {
    self = [super init];
    if (self) {
        self.seeCount = @"0";
        self.answerCount = @"0";
    }
    return self;
}

@end
