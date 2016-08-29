//
//  CHTImageLookViewController.m
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/29.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import "CHTImageLookViewController.h"
#import "CHTImageLookView.h"

@interface CHTImageLookViewController ()

@property (nonatomic, strong) CHTImageLookView *myView;

@end

@implementation CHTImageLookViewController

- (void)loadView {
    self.myView = [[CHTImageLookView alloc] initWithFrame:[UIScreen mainScreen].bounds images:self.imagesArray index:self.index];
    self.view = self.myView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
    // Do any additional setup after loading the view.
}

- (void)tapAction {
    [self dismissViewControllerAnimated:NO completion:nil];
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
