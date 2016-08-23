
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

@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *dataArray;

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

- (void)loadDataWithSubCategoryID:(NSNumber *)subID sortType:(CHTListSortedType)type page:(NSInteger)page finish:(void (^)())finish {
    if (page == 1) {
        [self.dataArray[type] removeAllObjects];
    }
    AVQuery *query = [AVQuery queryWithClassName:@"Topic"];
    [query whereKey:@"subCategoryID" equalTo:subID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (int i = 0; i < objects.count; i++) {
            AVObject *object = objects[i];
            CHTListModel *model = [CHTListModel new];
            model.title = object[@"title"];
            model.content = object[@"content"];
            model.topicID = object[@"topicID"];
            model.answerCount = object[@"answerCount"];
            model.seeCount = object[@"seeCount"];
            model.images = object[@"images"];
            model.userName = object[@"userName"];
            model.userImage = object[@"userImage"];
            model.creatTime = object.createdAt;
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

@end
