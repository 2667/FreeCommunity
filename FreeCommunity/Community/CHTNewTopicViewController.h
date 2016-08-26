//
//  CHTNewTopicViewController.h
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/24.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import "CHTBaseViewController.h"

@interface CHTNewTopicViewController : CHTBaseViewController

@property (nonatomic, strong) NSNumber *subCategoryID;
@property (nonatomic, copy) NSString *subCategoryName;

@property (nonatomic, strong) NSNumber *topicID;
@property (nonatomic, copy) NSString *answeredName;

@end
