//
//  CHTTopicDetailManager.h
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/26.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CHTListModel;
@interface CHTTopicDetailManager : NSObject

+ (instancetype)shareInstance;

- (void)loadData:(CHTListModel *)listModel finish:(void(^)())finish;

- (NSInteger)countOfData;
- (id)modelAtIndex:(NSIndexPath *)indexPath;

@end
