//
//  CHTCommunityManager.m
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/23.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import "CHTCommunityManager.h"
#import "CHTCommunityHeader.h"

static CHTCommunityManager *manager = nil;

@interface CHTCommunityManager ()

@property (nonatomic, strong) NSMutableArray<CHTCommunityMainModel *> *mainDataArray;
@property (nonatomic, strong) NSMutableArray *subDataArray;

@end

@implementation CHTCommunityManager

- (NSMutableArray *)mainDataArray {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _mainDataArray = [NSMutableArray array];
    });
    return _mainDataArray;
}

- (NSMutableArray *)subDataArray {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _subDataArray = [NSMutableArray array];
    });
    return _subDataArray;
}

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [CHTCommunityManager new];
    });
    return manager;
}

- (void)loadMainData:(Block)finish {
    AVQuery *query = [AVQuery queryWithClassName:@"MainCategory"];
    [query orderByAscending:@"mainCategoryID"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self.mainDataArray removeAllObjects];
        finish();
        for (AVObject *object in objects) {
            CHTCommunityMainModel *model = [CHTCommunityMainModel new];
            model.mainCategoryName = object[@"mainCategoryName"];
            model.mainCategoryID = object[@"mainCategoryID"];
            [self.mainDataArray addObject:model];
        }
        finish();
    }];
}

- (void)loadSubDataWithMainCategoryIndex:(NSInteger)index finish:(Block)finish {
    [self.subDataArray removeAllObjects];
    CHTCommunityMainModel *model = self.mainDataArray[index];
    if (model.subCategories) {
        finish();
    }
    AVQuery *query = [AVQuery queryWithClassName:@"subCategory"];
    [query orderByAscending:@"subCategoryID"];
    [query whereKey:@"superCategoryID" equalTo:model.mainCategoryID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (AVObject *object in objects) {
            CHTCommunitySubModel *model = [CHTCommunitySubModel new];
            model.superCategoryID = object[@"superCategoryID"];
            model.subCategoryID = object[@"subCategoryID"];
            model.subCategoryName = object[@"subCategoryName"];
            model.imageUrl = object[@"imageUrl"];
            [self.subDataArray addObject:model];
        }
        model.subCategories = self.subDataArray;
        finish();
    }];
}

- (NSInteger)countOfMainCategory {
    return self.mainDataArray.count;
}

- (CHTCommunityMainModel *)modelOfMainCategoryAtIndex:(NSInteger)index {
    return self.mainDataArray[index];
}

- (NSInteger)countOfSubCategoryWithMainIndex:(NSInteger)mainIndex {
    return self.mainDataArray[mainIndex].subCategories.count;
}

- (CHTCommunitySubModel *)modelOfSubCategoryWithMainIndex:(NSInteger)mainIndex subIndex:(NSInteger)subIndex {
    return self.mainDataArray[mainIndex].subCategories[subIndex];
}

@end
