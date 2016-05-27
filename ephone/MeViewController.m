//
//  MeViewController.m
//  ephone-z
//
//  Created by Jian Liao on 16/3/8.
//  Copyright © 2016年 fungotech. All rights reserved.
//

#import "MeViewController.h"

@implementation MeViewController {
    //MainTabBarViewController *tabBarController;
}

@synthesize myAccount = _myAccount;
@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initViews];
}

- (void)initData {
    
}

- (void)initViews {
    UILabel *myAccountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.9, SCREEN_HEIGHT*0.1)];
    [myAccountLabel setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
    myAccountLabel.center = CGPointMake(self.view.center.x, self.view.center.y*0.35);
    myAccountLabel.text = @"Account";
    myAccountLabel.font = [UIFont fontWithName:@"Arial" size:20];
    myAccountLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:myAccountLabel];
    
    UILabel *userInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(myAccountLabel.frame.origin.x, myAccountLabel.frame.origin.y+myAccountLabel.frame.size.height, SCREEN_WIDTH*0.9, SCREEN_HEIGHT*0.1)];
    [userInfoLabel setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
    userInfoLabel.text = (NSString*)_myAccount;
    userInfoLabel.font = [UIFont fontWithName:@"Arial" size:20];
    userInfoLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:userInfoLabel];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(userInfoLabel.frame.origin.x, userInfoLabel.frame.origin.y+userInfoLabel.frame.size.height, SCREEN_WIDTH*0.9, SCREEN_HEIGHT*0.6)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath row]) {
        case 0:{
            //TODO
            [self settingsEventHandler];
        } break;
        case 1:{
            //TODO
            [self abountEventHandler];
        } break;
        case 2:{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:self];
        } break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [CustomTableViewCell new];
    [cell initViews];
    switch ([indexPath row]) {
        case 0:
            cell.myLabel.text = @"Settings";
            cell.myImageView.image = [UIImage imageNamed:@"toc.png"];
            break;
        case 1:
            cell.myLabel.text = @"About";
            cell.myImageView.image = [UIImage imageNamed:@"info_outline.png"];
            break;
        case 2:
            cell.myLabel.text = @"Log Out";
            cell.myImageView.image = [UIImage imageNamed:@"settings_power.png"];
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - table cell is selected

- (void)settingsEventHandler {
    NSLog(@"Settings Clicked!");
}

- (void)abountEventHandler {
    NSLog(@"About Clicked!");
}

@end
