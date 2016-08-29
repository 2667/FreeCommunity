//
//  CHTTopicDetailManager.h
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/26.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CHTListModel;
@class CHTTopicDetailModel;
@interface CHTTopicDetailManager : NSObject

+ (instancetype)shareInstance;

- (void)loadData:(CHTListModel *)listModel finish:(void(^)())finish;
- (void)loadMoreData:(CHTListModel *)listModel skip:(NSInteger)skip finish:(void(^)())finish;

- (NSInteger)countOfData;
- (NSInteger)countOfsubData:(NSInteger)section;
- (CHTTopicDetailModel *)modelAtIndex:(NSIndexPath *)indexPath;

- (NSArray *)getArray;

@end
