//
//  CHTListModel.h
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/23.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CHTListModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *topicID;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userImage;
@property (nonatomic, copy) NSString *seeCount;
@property (nonatomic, copy) NSString *answerCount;
@property (nonatomic, strong) NSDate *creatTime;

@property (nonatomic, strong) NSArray *images;

- (NSDictionary *)dictOfModel;
- (instancetype)initAsNewModel;

@end
