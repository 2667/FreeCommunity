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
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
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

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self.childViewControllers count]) {
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_image"] style:UIBarButtonItemStyleDone target:self action:@selector(clickAction)];
        left.tintColor = [UIColor whiteColor];
        viewController.navigationItem.leftBarButtonItem = left;
    }
    [super pushViewController:viewController animated:animated];
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
