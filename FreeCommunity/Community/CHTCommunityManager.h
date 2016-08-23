//
//  CHTCommunityManager.h
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/23.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Block)();

@class CHTCommunityMainModel;
@class CHTCommunitySubModel;
@interface CHTCommunityManager : NSObject

+ (instancetype)shareInstance;
- (void)loadMainData:(Block)finish;
- (NSInteger)countOfMainCategory;
- (CHTCommunityMainModel *)modelOfMainCategoryAtIndex:(NSInteger)index;

- (void)loadSubDataWithMainCategoryIndex:(NSInteger)index finish:(Block)finish;
- (NSInteger)countOfSubCategoryWithMainIndex:(NSInteger)mainIndex;
- (CHTCommunitySubModel *)modelOfSubCategoryWithMainIndex:(NSInteger)mainIndex subIndex:(NSInteger)subIndex;

@end
