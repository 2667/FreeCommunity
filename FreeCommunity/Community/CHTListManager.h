//
//  CHTListManager.h
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/23.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CHTListSortedTypeCreatTime = 0,
    CHTListSortedTypeAnswerTime = 1,
    CHTListSortedTypeAnswerCount = 2,
} CHTListSortedType;

@class CHTListModel;
@interface CHTListManager : NSObject

+ (instancetype)shareInstance;

/**
 *  设置当前排序方式下，tableView的偏移量
 *
 *  @param y    偏移量
 *  @param type 排序方式
 */
- (void)setOffsetY:(CGFloat)y sortedType:(CHTListSortedType)type;

/**
 *  获取当前排序方式下table的偏移量
 *
 *  @param type 排序方式
 *
 *  @return 偏移量
 */
- (CGFloat)getOffsetYWithType:(CHTListSortedType)type;

/**
 *  选择分类后首先进行的数据请求操作
 *
 *  @param subID  分类ID
 *  @param isSubCategory 是分类还是主类
 */
- (void)loadDataWithSubCategoryID:(NSNumber *)subID type:(BOOL)isSubCategory finish:(void(^)(NSInteger count))finish;

/**
 *  刷新方法
 *
 *  @param type   刷新的排序方式
 *  @param finish 刷新完成回调
 */
//- (void)refreshData:(CHTListSortedType)type finish:(void(^)())finish;

/**
 *  加载数据方法
 *
 *  @param type   type
 *  @param add 是添加数据还是刷新数据
 *  @param finish finish
 */
- (void)requestData:(CHTListSortedType)type isAdd:(BOOL)add finish:(void(^)(NSInteger count))finish;

- (NSInteger)countOfDataType:(CHTListSortedType)type;
- (CHTListModel *)modelOfCurrentType:(CHTListSortedType)type index:(NSInteger)index;

- (void)countOfTopic:(NSNumber *)subCategoryID finish:(void(^)(NSInteger count))finish;

- (void)countOfAnswer:(NSNumber *)subCategoryID finish:(void(^)(NSInteger count))finish;

@end
