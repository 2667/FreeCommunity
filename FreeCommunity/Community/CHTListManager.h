//
//  CHTListManager.h
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/23.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    CHTListSortedTypeCreatTime = 0,
    CHTListSortedTypeAnswerTime = 1,
    CHTListSortedTypeAnswerCount = 2,
} CHTListSortedType;

@class CHTListModel;
@interface CHTListManager : NSObject

+ (instancetype)shareInstance;

- (void)loadDataWithSubCategoryID:(NSNumber *)subID sortType:(CHTListSortedType)type page:(NSInteger)page finish:(void(^)())finish;
- (NSInteger)countOfDataType:(CHTListSortedType)type;
- (CHTListModel *)modelOfCurrentType:(CHTListSortedType)type index:(NSInteger)index;

@end
