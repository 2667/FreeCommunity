//
//  CHTTopicDetailViewController.m
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/26.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import "CHTTopicDetailViewController.h"
#import "CHTNewTopicViewController.h"
#import "CHTTopicDetailHeader.h"
#import "CHTNavigationController.h"

@interface CHTTopicDetailViewController ()<UITableViewDataSource, UITableViewDelegate, CHTAnswerDelegate>

@property (nonatomic, strong) CHTTopicDetailView *myView;

@end

@implementation CHTTopicDetailViewController

- (void)loadView {
    self.myView = [[CHTTopicDetailView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.myView.headerModel = self.listModel;
    self.view = self.myView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"主题帖";
    [self makeData];
    self.myView.tableView.dataSource = self;
    self.myView.tableView.delegate = self;
    self.myView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myView.tableView registerNib:[UINib nibWithNibName:@"CHTTopicDetailMainCell" bundle:nil] forCellReuseIdentifier:@"topicDetailMainCell"];
    // Do any additional setup after loading the view.
}

- (void)makeData {
    [[CHTTopicDetailManager shareInstance] loadData:self.listModel finish:^{
        [self.myView.tableView reloadData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[CHTTopicDetailManager shareInstance] countOfData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CHTTopicDetailMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topicDetailMainCell" forIndexPath:indexPath];
    cell.model = [[CHTTopicDetailManager shareInstance] modelAtIndex:indexPath];
    cell.delegate = self;
    return cell;
}

- (void)answer:(NSString *)answeredName {
    CHTNewTopicViewController *nvc = [[CHTNewTopicViewController alloc] init];
    nvc.topicID = self.listModel.topicID;
    nvc.answeredName = answeredName;
    [self.navigationController presentViewController:[[CHTNavigationController alloc] initWithRootViewController:nvc] animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CHTTopicDetailModel *model = [[CHTTopicDetailManager shareInstance] modelAtIndex:indexPath];
    if (model.height < 40) {
        model.height = [CHTTopicDetailMainCell heightWith:model.content imageCount:model.images.count];
    }
    return model.height;
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
