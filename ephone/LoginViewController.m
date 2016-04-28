//
//  ViewController.m
//  ephone-z
//
//  Created by Jian Liao on 16/3/1.
//  Copyright © 2016年 fungotech. All rights reserved.
//

#import "LoginViewController.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@implementation LoginViewController {
    BOOL loginEvent;
}

@synthesize isKeyboardShow;
@synthesize orginCenter;
@synthesize account = _account;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initViews];
}

- (void)initData {
    loginEvent = NO;
    isKeyboardShow = NO;
    orginCenter = CGPointMake(0, 0);
}

- (void)initViews {
    self.navigationController.navigationBar.hidden=YES;
    [self.view setBackgroundColor:[UIColor colorWithRed:0.1 green:0.5 blue:0.75 alpha:1]];
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.7)];
    [self.bgView setBackgroundColor:[UIColor colorWithRed:0.1 green:0.5 blue:0.75 alpha:1]];
    self.orginCenter = self.bgView.center;
    [self.view addSubview:self.bgView];
    
    UIButton *hideKeyboardButton = [[UIButton alloc] initWithFrame:self.bgView.frame];
    [hideKeyboardButton addTarget:self action:@selector(hideKeyboardEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:hideKeyboardButton];
    
    self.usernameTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.8, 45)];
    [self.usernameTF setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT*0.4)];
    [self.usernameTF setBackgroundColor:[UIColor whiteColor]];
    self.usernameTF.placeholder = @"username";
    self.usernameTF.returnKeyType = UIReturnKeyNext;
    self.usernameTF.keyboardType = UIKeyboardTypeASCIICapable;
    self.usernameTF.delegate = self;
    [self.bgView addSubview:self.usernameTF];
    
    self.passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.8, 45)];
    [self.passwordTF setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT*0.4+self.usernameTF.frame.size.height+1)];
    [self.passwordTF setBackgroundColor:[UIColor whiteColor]];
    self.passwordTF.placeholder = @"password";
    self.passwordTF.returnKeyType = UIReturnKeyDone;
    self.passwordTF.keyboardType = UIKeyboardTypeASCIICapable;
    self.passwordTF.secureTextEntry = YES;
    self.passwordTF.delegate = self;
    [self.bgView addSubview:self.passwordTF];
    
    self.loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.8, 45)];
    [self.loginBtn setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT*0.4+self.usernameTF.frame.size.height+self.passwordTF.frame.size.height+2)];
    [self.loginBtn setBackgroundColor:[UIColor whiteColor]];
    [self.loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [self.loginBtn addTarget:self action:@selector(loginEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.loginBtn setTitle:@"Login" forState:UIControlStateNormal];
    [self.bgView addSubview:self.loginBtn];
    
    self.invalidUserInfoAlertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Wrong password or username" delegate:self cancelButtonTitle:@"Forget password?" otherButtonTitles:@"Retry", nil];
    
    self.logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 184, 43)];
    [self.logoImage setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT*0.25)];
    self.logoImage.image = [UIImage imageNamed:@"logo_head.png"];
    [self.view addSubview:self.logoImage];
    
    self.loginIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.loginIndicatorView.center = self.view.center;
    [self.view addSubview:self.loginIndicatorView];
    
    ////////////////////
    self.usernameTF.text = @"101";
    self.passwordTF.text = @"000";
}

- (void)dealloc {

}

#pragma mark - Button Event Handler

- (void)loginEventHandler {
    loginEvent = YES;
    [self presentMainViewController];
    return;
    
    NSString *username = self.usernameTF.text;
    NSString *password = self.passwordTF.text;
    if([username isEqualToString:@""]) {
        UIAlertView *emptyUsernameAlert = [[UIAlertView alloc] initWithTitle:@"Reminder" message:@"Please input username" delegate:self cancelButtonTitle:@"Confirm" otherButtonTitles:nil];
        [emptyUsernameAlert show];
        return;
    }
    if([password isEqualToString:@""]) {
        NSLog(@"Please input username");
        UIAlertView *emptyPasswordAlert = [[UIAlertView alloc] initWithTitle:@"Reminder" message:@"Please input password" delegate:self cancelButtonTitle:@"Confirm" otherButtonTitles:nil];
        [emptyPasswordAlert show];
        return;
    }
    
    [self.loginIndicatorView startAnimating];
    GSAccountConfiguration *newAccount = [GSAccountConfiguration defaultConfiguration];
    newAccount.address = [[username stringByAppendingString:@"@"] stringByAppendingString:SERVER_ADDRESS];
    newAccount.username = username;
    newAccount.password = password;
    newAccount.domain = SERVER_ADDRESS;
    
    GSConfiguration *configuration = [GSConfiguration defaultConfiguration];
    configuration.account = newAccount;
    configuration.logLevel = 3;
    configuration.consoleLogLevel = 3;
    
    GSUserAgent *agent = [GSUserAgent sharedAgent];
    [agent configure:configuration];
    [agent start];
    
    _account = agent.account;
    [_account addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial context:@"accountStatusContext"];
    //_account.delegate = self;
    [_account connect];
    loginEvent = YES;
}

#pragma mark - TextFieldDelegate

- (void)hideKeyboardEventHandler {
    [self.usernameTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if (textField.returnKeyType == UIReturnKeyNext) {
        [self.passwordTF becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerCompletion:) name:@"RegisterCompletionNotification" object:nil];
}

- (void) keyboardWillShow: (NSNotification *)notif {
    float duration = (isKeyboardShow) ? 0 : 0.3;
    self.isKeyboardShow = YES;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    [self.logoImage setAlpha:0.0];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationDelegate:self];
    self.bgView.center = CGPointMake(self.orginCenter.x, self.orginCenter.y-80);
    [UIView commitAnimations];
}

- (void) keyboardWillHide: (NSNotification *)notif {
    self.isKeyboardShow = NO;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [self.logoImage setAlpha:1.0];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    CGPoint newCenter = self.bgView.center;
    newCenter.y += 100;
    self.bgView.center = self.orginCenter;
    [UIView commitAnimations];
}

- (void) registerCompletion: (NSNotification *) notif {
    //NSDictionary *theData = [notif userInfo];
    //NSString *phonenumber = [theData objectForKey:@"phonenumber"];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView == self.invalidUserInfoAlertView && buttonIndex == 0) {
        //TODO - forget password
        NSLog(@"forget password button is clicked");
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"status"])
        [self statusDidChange];
}

- (void)statusDidChange {
    switch (_account.status) {
        case GSAccountStatusOffline: {
            [self.loginBtn setEnabled:YES];
            NSLog(@"GSAccountStatusOffline");
        } break;
            
        case GSAccountStatusConnecting: {
            [self.loginBtn setEnabled:NO];
            NSLog(@"GSAccountStatusConnecting");
        } break;
            
        case GSAccountStatusConnected: {
            NSLog(@"GSAccountStatusConnected");
            [self presentMainViewController];
        } break;
            
        case GSAccountStatusDisconnecting: {
            [self.loginBtn setEnabled:NO];
            NSLog(@"GSAccountStatusDisconnecting");
        } break;
            
        case GSAccountStatusInvalid: {
            [self.loginBtn setEnabled:YES];
            NSLog(@"GSAccountStatusInvalid");
            [self.loginIndicatorView stopAnimating];
            [self.invalidUserInfoAlertView show];
            [_account removeObserver:self forKeyPath:@"status" context:@"accountStatusContext"];
            _account = nil;
            [[GSUserAgent sharedAgent] reset];
        } break;
    }
}

- (void)presentMainViewController {
    if(loginEvent == NO) return;
    MainTabBarViewController *mainTabBarViewController = [MainTabBarViewController alloc];
    mainTabBarViewController.username = self.usernameTF.text;
    mainTabBarViewController.serverAddress = SERVER_ADDRESS;
    mainTabBarViewController = [mainTabBarViewController init];
    [self.loginIndicatorView stopAnimating];
    [self presentViewController:mainTabBarViewController animated:YES completion:^{
        [self.loginBtn setEnabled:YES];
        loginEvent = NO;
    }];
}
@end