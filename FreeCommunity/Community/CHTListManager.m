
//
//  CHTListManager.m
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/23.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import "CHTListManager.h"
#import "CHTListHeader.h"

static CHTListManager *manager = nil;

@interface CHTListManager ()

@property (nonatomic, copy) NSString *isSubCategory;
@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *dataArray;
@property (nonatomic, strong) NSNumber *currentCategoryID;
@property (nonatomic, strong) NSMutableArray *offsetYArray;

@end

@implementation CHTListManager

- (NSMutableArray<NSMutableArray *> *)dataArray {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dataArray = [NSMutableArray arrayWithObjects:[NSMutableArray array], [NSMutableArray array], [NSMutableArray array], nil];
    });
    return _dataArray;
}

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CHTListManager alloc] init];
    });
    return manager;
}

- (void)setOffsetY:(CGFloat)y sortedType:(CHTListSortedType)type {
    [self.offsetYArray replaceObjectAtIndex:type withObject:@(y)];
}

- (CGFloat)getOffsetYWithType:(CHTListSortedType)type {
    return [self.offsetYArray[type] floatValue];
}

- (void)loadDataWithSubCategoryID:(NSNumber *)subID type:(BOOL)isSubCategory finish:(void (^)())finish {
    if (isSubCategory) {
        self.isSubCategory = @"subCategoryID";
    } else {
        self.isSubCategory = @"superCategoryID";
    }
    if ([self.currentCategoryID isEqualToNumber:subID] && self.dataArray.firstObject.count) {
        finish();
        return;
    }
    self.currentCategoryID = subID;
    self.offsetYArray = @[@0, @0, @0].mutableCopy;
    _dataArray = [NSMutableArray arrayWithObjects:[NSMutableArray array], [NSMutableArray array], [NSMutableArray array], nil];
    
    [self requestData:CHTListSortedTypeCreatTime isAdd:NO finish:^{
        finish();
    }];
}

/*
- (void)refreshData:(CHTListSortedType)type finish:(void(^)())finish {
    AVQuery *query = [AVQuery queryWithClassName:@"Topic"];
    [query whereKey:self.isSubCategory equalTo:self.currentCategoryID];
    switch (type) {
        case CHTListSortedTypeCreatTime:
            [query orderByDescending:@"createdAt"];
            break;
        case CHTListSortedTypeAnswerTime:
            [query orderByDescending:@"answerTime"];
            break;
        case CHTListSortedTypeAnswerCount:
            [query orderByDescending:@"answerCount"];
            break;
            
        default:
            break;
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self.dataArray[type] removeAllObjects];
        for (int i = 0; i < objects.count; i++) {
            AVObject *object = objects[i];
            CHTListModel *model = [[CHTListModel alloc] initWithObject:object];
            [self.dataArray[type] addObject:model];
        }
        finish();
    }];
}
 */

- (void)requestData:(CHTListSortedType)type isAdd:(BOOL)add finish:(void(^)())finish {
    AVQuery *query = [AVQuery queryWithClassName:@"Topic"];
    query.limit = 20;
    NSArray *array = @[@"createdAt", @"answerTime", @"answerCount"];
    if (add && self.dataArray[type].count) {
        NSMutableArray *idArray = [NSMutableArray array];
        for (CHTListModel *model in self.dataArray[type]) {
            [idArray addObject:model.topicID];
        }
        [query whereKey:@"topicID" notContainedIn:idArray];
        CHTListModel *model = self.dataArray[type].lastObject;
        [query whereKey:array[type] lessThanOrEqualTo:[model valueForKey:array[type]]];
    }
    [query orderByDescending:array[type]];
    [query whereKey:self.isSubCategory equalTo:self.currentCategoryID];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!add) {
            [self.dataArray[type] removeAllObjects];
        }
        for (int i = 0; i < objects.count; i++) {
            AVObject *object = objects[i];
            CHTListModel *model = [[CHTListModel alloc] initWithObject:object];
            [self.dataArray[type] addObject:model];
        }
        finish();
    }];
}

- (NSInteger)countOfDataType:(CHTListSortedType)type {
    return self.dataArray[type].count;
}

- (CHTListModel *)modelOfCurrentType:(CHTListSortedType)type index:(NSInteger)index {
    return self.dataArray[type][index];
}

- (void)countOfTopic:(NSNumber *)subCategoryID finish:(void (^)(NSInteger count))finish {
    AVQuery *query = [AVQuery queryWithClassName:@"Topic"];
    [query whereKey:@"subCategoryID" equalTo:subCategoryID];
    [query countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
        finish(number);
    }];
}

@end
