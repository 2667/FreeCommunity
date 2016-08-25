//
//  CHTCommunityViewController.m
//  FreeCommunity
//
//  Created by risenb_mac on 16/8/22.
//  Copyright © 2016年 risenb_mac. All rights reserved.
//

#import "CHTCommunityViewController.h"
#import "CHTCommunityHeader.h"
#import "CHTListViewController.h"

@interface CHTCommunityViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSInteger currentMainIndex;

@end

@implementation CHTCommunityViewController

- (void)loadView {
    self.myView = [[CHTCommunityView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.myView;
    self.myView.mainTableView.delegate = self;
    self.myView.mainTableView.dataSource = self;
    self.myView.subTableView.delegate = self;
    self.myView.subTableView.dataSource = self;
    [self.myView.subTableView registerNib:[UINib nibWithNibName:@"CHTCommunitySubCell" bundle:nil] forCellReuseIdentifier:@"subCommunityCell"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"自由论坛";
    [self makeData];
    // Do any additional setup after loadingthe view.
}

- (void)makeData {
    [[CHTCommunityManager shareInstance] loadMainData:^{
        [self.myView.mainTableView reloadData];
        if ([[CHTCommunityManager shareInstance] countOfMainCategory]) {
            [self.myView.mainTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
            [self tableView:self.myView.mainTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.myView.mainTableView]) {
        return [[CHTCommunityManager shareInstance] countOfMainCategory];
    } else {
        if ([[CHTCommunityManager shareInstance] countOfMainCategory]) {
            return [[CHTCommunityManager shareInstance] countOfSubCategoryWithMainIndex:self.currentMainIndex];
        }
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.myView.mainTableView]) {
        CHTCommunityMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCommunityCell"];
        if (!cell) {
            cell = [[CHTCommunityMainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mainCommunityCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        CHTCommunityMainModel *model = [[CHTCommunityManager shareInstance] modelOfMainCategoryAtIndex:indexPath.row];
        cell.textLabel.text = model.mainCategoryName;
        cell.selected = model.isSelected;
        return cell;
    } else {
        CHTCommunitySubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subCommunityCell" forIndexPath:indexPath];
        CHTCommunitySubModel *model = [[CHTCommunityManager shareInstance] modelOfSubCategoryWithMainIndex:self.currentMainIndex subIndex:indexPath.row];
        cell.model = model;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.myView.mainTableView]) {
        self.currentMainIndex = indexPath.row;
        [[CHTCommunityManager shareInstance] loadSubDataWithMainCategoryIndex:indexPath.row finish:^{
            [self.myView.subTableView reloadData];
        }];
    } else {
        CHTCommunitySubModel *model = [[CHTCommunityManager shareInstance] modelOfSubCategoryWithMainIndex:self.currentMainIndex subIndex:indexPath.row];
        CHTListViewController *lvc = [[CHTListViewController alloc] init];
        lvc.hidesBottomBarWhenPushed = YES;
        lvc.subCategoryID = model.subCategoryID;
        lvc.categoryName = model.subCategoryName;
        [self.navigationController pushViewController:lvc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.myView.mainTableView]) {
        return 44;
    } else {
        return 60;
    }
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
