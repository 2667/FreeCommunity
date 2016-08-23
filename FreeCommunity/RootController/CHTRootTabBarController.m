//
//  CHTRootTabBarController.m
//  Free Community
//
//  Created by risenb_mac on 16/8/22.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import "CHTRootTabBarController.h"
#import "Header.h"
#import "CHTNavigationController.h"
#import "CHTCommunityViewController.h"

@interface CHTRootTabBarController ()

@end

@implementation CHTRootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self addViewController:[[CHTCommunityViewController alloc] init] withTitle:@"论坛" image:@"TabBarImage_03"];
    [self addViewController:[[UIViewController alloc] init] withTitle:@"我的" image:@"TabBarImage_02"];
    
    self.tabBar.barTintColor = [UIColor colorWithWhite:0.95 alpha:1];
    self.tabBar.tintColor = TOPIC_COLOR;
    
    // Do any additional setup after loading the view.
}

- (void)addViewController:(UIViewController *)controller withTitle:(NSString *)title image:(NSString *)imageName {
    UITabBarItem *item = [[UITabBarItem alloc] init];
    item.image = [UIImage imageNamed:imageName];
    item.title = title;
    CHTNavigationController *nvc = [[CHTNavigationController alloc] initWithRootViewController:controller];
    nvc.tabBarItem = item;
    [self addChildViewController:nvc];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
