//
//  CHTTopicDetailManager.m
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/26.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import "CHTTopicDetailManager.h"
#import "CHTTopicDetailHeader.h"

@interface CHTTopicDetailManager ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

static CHTTopicDetailManager *manager = nil;

@implementation CHTTopicDetailManager

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CHTTopicDetailManager alloc] init];
    });
    return manager;
}

- (void)loadData:(CHTListModel *)listModel finish:(void (^)())finish {
    AVObject *topicObject = [AVObject objectWithClassName:@"Topic" objectId:listModel.objectId];
    AVRelation *relation = [topicObject relationForKey:@"answers"];
    AVQuery *query = [relation query];
    query.limit = 30;
    [query orderByAscending:@"createdAt"];
    [self.dataArray removeAllObjects];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        CHTTopicDetailModel *model = [CHTTopicDetailModel new];
        model.userName = listModel.userName;
        model.userImage = listModel.userImage;
        model.date = listModel.createdAt;
        model.content = listModel.content;
        model.images = listModel.images;
        [self.dataArray addObject:model];
        for (int i = 0; i < objects.count; i++) {
            CHTTopicDetailModel *model = [[CHTTopicDetailModel alloc] initWithObject:objects[i]];
            AVRelation *relation = [objects[i] relationForKey:@"answers"];
            AVQuery *query = [relation query];
            [query orderByAscending:@"createdAt"];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                model.subAnswers = [NSMutableArray array];
                for (int i = 0; i < objects.count; i++) {
                    CHTTopicDetailModel *subModel = [[CHTTopicDetailModel alloc] initWithObject:objects[i]];
                    [model.subAnswers addObject:subModel];
                }
                finish();
            }];
            [self.dataArray addObject:model];
        }
        finish();
    }];
}

- (void)loadMoreData:(CHTListModel *)listModel skip:(NSInteger)skip finish:(void (^)())finish {
    AVObject *topicObject = [AVObject objectWithClassName:@"Topic" objectId:listModel.objectId];
    AVRelation *relation = [topicObject relationForKey:@"answers"];
    AVQuery *query = [relation query];
    query.limit = 10;
    query.skip = skip;
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (int i = 0; i < objects.count; i++) {
            CHTTopicDetailModel *model = [[CHTTopicDetailModel alloc] initWithObject:objects[i]];
            AVRelation *relation = [objects[i] relationForKey:@"answers"];
            AVQuery *query = [relation query];
            [query orderByAscending:@"createdAt"];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                model.subAnswers = [NSMutableArray array];
                for (int i = 0; i < objects.count; i++) {
                    CHTTopicDetailModel *subModel = [[CHTTopicDetailModel alloc] initWithObject:objects[i]];
                    [model.subAnswers addObject:subModel];
                }
                finish();
            }];
            [self.dataArray addObject:model];
        }
        finish();
    }];

}

- (NSArray *)getArray {
    return self.dataArray.mutableCopy;
}

- (NSInteger)countOfData {
    return self.dataArray.count;
}

- (NSInteger)countOfsubData:(NSInteger)section {
    CHTTopicDetailModel *model = self.dataArray[section];
    return model.subAnswers.count + 1;
}

- (CHTTopicDetailModel *)modelAtIndex:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.dataArray[indexPath.section];
    } else {
        CHTTopicDetailModel *model = self.dataArray[indexPath.section];
        return model.subAnswers[indexPath.row - 1];
    }
}

@end
