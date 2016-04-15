//
//  SignupViewController.m
//  ephone-z
//
//  Created by Jian Liao on 16/3/4.
//  Copyright © 2016年 fungotech. All rights reserved.
//

#import "SignupViewController.h"

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"text field sholud return");
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)save:(id)sender {
    [self.usernameTF resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSDictionary *dataDict = [NSDictionary dictionaryWithObjects:self.usernameTF.text forKeys:@"phonenumber"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RegisterCompletionNotification" object:nil userInfo:dataDict];
    }];
}

- (IBAction)cancel:(id)sender {
    [self.usernameTF resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
