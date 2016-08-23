//
//  CHTCommunityModel.h
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/23.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CHTCommunitySubModel;
@interface CHTCommunityMainModel : NSObject

@property (nonatomic, copy) NSString *mainCategoryName;
@property (nonatomic, strong) NSNumber *mainCategoryID;
@property (nonatomic, strong) NSArray<CHTCommunitySubModel *> *subCategories;
@property (nonatomic, assign) BOOL isSelected;

@end

@interface CHTCommunitySubModel : NSObject

@property (nonatomic, strong) NSNumber *subCategoryID;
@property (nonatomic, strong) NSNumber *superCategoryID;
@property (nonatomic, copy) NSString *subCategoryName;

@end
