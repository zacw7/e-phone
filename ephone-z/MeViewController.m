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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initViews];
}

- (void)initData {
    //tabBarController = (MainTabBarViewController*)self.tabBarController;
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"me" ofType:@"plist"];
    self.listMe = [[NSArray alloc] initWithContentsOfFile:plistPath];
}

- (void) initViews {
    UILabel *userInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth*0.9, self.screenHeight*0.2)];
    [userInfoLabel setBackgroundColor:[UIColor lightGrayColor]];
    userInfoLabel.center = CGPointMake(self.view.center.x, self.view.center.y*0.4);
    //userInfoLabel.text = tabBarController.username;
    userInfoLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:userInfoLabel];
    
    [self.view addSubview:self.tableView];
    
    /////////////////////
    UIButton *exit = [[UIButton alloc] initWithFrame:CGRectMake(0, self.screenHeight*0.3, self.screenWidth*0.2, self.screenHeight*0.1)];
    [exit setBackgroundColor:[UIColor redColor]];
    [exit addTarget:self.tabBarController action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [exit setTitle:@"Log Out" forState:UIControlStateNormal];
    [self.view addSubview:exit];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listMe count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index: %d", (int)[indexPath row]);
    switch ([indexPath row]) {
        case 0:{
            //TODO
            NSLog(@"Settings Clicked!");
        } break;
        case 1:{
            //TODO
            NSLog(@"About Clicked!");
        } break;
        case 2:{
            [self exitEventHandler];
        } break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CustomCell";
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSInteger row = [indexPath row];
    NSDictionary *rowDict = [self.listMe objectAtIndex:row];
    
    cell.myLabel.text = [rowDict objectForKey:@"name"];
    
    NSString *imagePath = [rowDict objectForKey:@"image"];
    imagePath = [imagePath stringByAppendingString:@".png"];
    cell.myImageView.image = [UIImage imageNamed:imagePath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - table cell is selected

- (void)exitEventHandler {
//    LoginViewController *loginViewController= [LoginViewController new];
//    GSUserAgent *agent = [GSUserAgent sharedAgent];
//    [agent.account disconnect];
//    [self presentViewController:loginViewController animated:YES completion:^{
//        [loginViewController.account removeObserver:loginViewController forKeyPath:@"status" context:@"accountStatusContext"];
//        [[GSUserAgent sharedAgent] reset];
//    }];
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
