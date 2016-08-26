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
    AVQuery *query = [AVQuery queryWithClassName:@"TopicAnswer"];
    [query whereKey:@"topicID" equalTo:listModel.topicID];
    [query orderByDescending:@"createdAt"];
    [self.dataArray removeAllObjects];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        CHTTopicDetailModel *model = [CHTTopicDetailModel new];
        model.userName = listModel.userName;
        model.userImage = listModel.userImage;
        model.date = listModel.createdAt;
        model.content = listModel.content;
        model.images = listModel.images;
        model.section = self.dataArray.count;
        [self.dataArray addObject:model];
        for (int i = 0; i < objects.count; i++) {
            CHTTopicDetailModel *model = [[CHTTopicDetailModel alloc] initWithObject:objects[i]];
            model.section = self.dataArray.count;
            [self.dataArray addObject:model];
        }
        finish();
    }];
}

- (NSInteger)countOfData {
    return self.dataArray.count;
}

- (id)modelAtIndex:(NSIndexPath *)indexPath {
    return self.dataArray[indexPath.section];
}

@end
