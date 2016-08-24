//
//  CHTNavigationController.m
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/22.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import "CHTNavigationController.h"
#import "Header.h"

@interface CHTNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation CHTNavigationController

+ (void)initialize {
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.barTintColor = TOPIC_COLOR;
    bar.tintColor = [UIColor whiteColor];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:20 weight:UIFontWeightRegular]}];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.interactivePopGestureRecognizer.delegate = self;
    // Do any additional setup after loading the view.
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.childViewControllers.count > 1) {
        return YES;
    }
    return NO;
}

- (void)clickAction {
    [self popViewControllerAnimated:YES];
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
