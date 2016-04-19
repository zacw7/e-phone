//
//  DialViewController.m
//  ephone-z
//
//  Created by Jian Liao on 16/3/11.
//  Copyright © 2016年 fungotech. All rights reserved.
//

#import "DialViewController.h"

@implementation DialViewController {
    //通话记录数组
    NSMutableArray *dataArr;
    //模糊搜索后的通话记录数组
    NSMutableArray *searchArr;
    //是否在搜索模式
    BOOL isSearchMode;
    //被选中通话记录行的下标
    long selectedIndex;
    //拨号小键盘输入的内容
    NSString *strNum;
    NSMutableString * _numlockStr;
    //拨号小键盘视图
    UIView *contentView;
    //拨号输入框
    UITextField *inputTF;
    //拨号小键盘是否弹出
    BOOL isKeyBoardShow;
    //是否开启热点视图
    BOOL isHotPointOn;
    // Call
    //GSCall *call;
    
    UILabel *callStatusLabel;
}

@synthesize delegate = _delegate;
@synthesize phonePadView = _phonePadView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initViews];
}

- (void)initData {

}

- (void)initViews{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    callStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth*0.8, self.screenHeight*0.1)];
    callStatusLabel.center = CGPointMake(self.view.center.x, self.view.center.y*0.2);
    [callStatusLabel setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:callStatusLabel];
    
    callStatusLabel.text = @"initial";
    
    UIImageView *noRecordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    noRecordImageView.center = CGPointMake(self.screenWidth/2, self.screenHeight/2-40);
    noRecordImageView.image = [UIImage imageNamed:@"bg_no_call.png"];
    [self.view addSubview:noRecordImageView];
    
    UILabel *noRecordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 20)];
    noRecordLabel.center = CGPointMake(self.screenWidth/2, self.screenHeight/2 - 40 + noRecordImageView.frame.size.height);
    noRecordLabel.text = @"No Record";
    noRecordLabel.textAlignment = NSTextAlignmentCenter;
    noRecordLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:noRecordLabel];
    
    contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 380)];
    _phonePadView = [[PhonePadView alloc]initWithView:contentView parentView:self.view];
    [_phonePadView.dialBtn addTarget:self action:@selector(dialBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_phonePadView.backsapceBtn addTarget:self action:@selector(makeBackspace) forControlEvents:UIControlEventTouchUpInside];
    [_phonePadView setBackgroundColor:[UIColor whiteColor]];
    [self initKeyboard];
    [self.view addSubview:_phonePadView];
}

- (void)initKeyboard {
    int keyboardHeight=300;
    if (self.screenHeight==568) {
        keyboardHeight=300;
    }else if (self.screenHeight==667){
        keyboardHeight=320;
    }else if (self.screenHeight==736){
        keyboardHeight=360;
    }else{
        keyboardHeight=240;
    }
    
    float btnHeight = keyboardHeight/6.5;
    float btnWidth = contentView.frame.size.width/3;
    _w = btnWidth;
    _h = btnHeight;
//    for (int i = 0; i < 6; i++) {
//        UIView *view1 = [[UIView alloc]init];
//        view1.frame = CGRectMake(0, 0.5 + contentView.frame.size.height /6 * i, 500,0.5);
//        view1.backgroundColor = [UIColor grayColor];
//        view1.alpha = 0.3;
//        [contentView addSubview:view1];
//    }
    //设置输入框
    inputTF = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, contentView.frame.size.width, btnHeight)];
    inputTF.delegate = self;
    inputTF.textAlignment = 1;
    inputTF.placeholder = @"请输入电话号码";
    inputTF.delegate = self;
    [contentView addSubview:inputTF];
    
    _numlockStr = [[NSMutableString alloc] init];
    [self initNumLockKeyboard];
    //[self initPhoneLockKeyboard];
    isKeyBoardShow=YES;
    
}

//添加拨号键盘键按钮
- (void)initNumLockKeyboard {
    for (int i = 0; i < 12; i++) {
        NumberButton * numBu;
        if (i == 0) {
            numBu = [[NumberButton alloc] initWithNumber:i letters:@""];
            [numBu setImage:[UIImage imageNamed:@"icon_keyboard_0"] forState:0];
            [numBu setFrame:CGRectMake(_w, _h * 4 , _w, _h)];
        } else if (i == 10) {
            numBu = [[NumberButton alloc] initWithNumber:i letters:@""];
            [numBu setImage:[UIImage imageNamed:@"icon_keyboard_xing"] forState:0];
            [numBu setFrame:CGRectMake(0, _h * 4 , _w, _h)];
        } else if (i == 11) {
            numBu = [[NumberButton alloc] initWithNumber:i letters:@""];
            [numBu setImage:[UIImage imageNamed:@"icon_keyboard_jing"] forState:0];
            [numBu setFrame:CGRectMake(_w * 2, _h * 4 , _w, _h)];
        } else {
            numBu = [[NumberButton alloc] initWithNumber:i letters:[self lettersForNum:i]];
            [numBu setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_keyboard_%d",i]] forState:0];
            [numBu setFrame:CGRectMake((i-1)%3*_w,_h + (i-1)/3*_h, _w, _h)];
        }
        numBu.tag = 1000 + i;
        [numBu addTarget:self action:@selector(numButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:numBu];
    }
}

- (void)numButtonPressed:(UIButton *)sender{
    
    if (_numlockStr.length < 20)
    {
        if (sender.tag <= 1009) {
            [_numlockStr appendFormat:@"%@",[NSString stringWithFormat:@"%lu",(sender.tag - 1000)]];
            inputTF.text = [NSString stringWithFormat:@"%@",_numlockStr];
            if (sender.tag - 1000==0) {
                //                [self playSoundForKey:11];
            }else{
                //                [self playSoundForKey:(int)(sender.tag - 1000)];
            }
        }
        else if(sender.tag == 1010){
            [_numlockStr appendFormat:@"*"];
            inputTF.text = [NSString stringWithFormat:@"%@",_numlockStr];
            //            [self playSoundForKey:10];
        }
        else if(sender.tag == 1011){
            [_numlockStr appendFormat:@"#"];
            inputTF.text = [NSString stringWithFormat:@"%@",_numlockStr];
            //            [self playSoundForKey:12];
        }
    }
    
    //    [[SearchCoreManager share]Reset];
    ////    [self loadRecordData];
    //    [[SearchCoreManager share] Search:numField.text searchArray:nil nameMatch:searchByName phoneMatch:nil];
    //    
    //    [self.PhoneTabView reloadData];
}

- (NSString *)lettersForNum:(NSUInteger)num
{
    switch (num)
    {
        case 1:
        {
            return @" ";
            break;
        }
        case 2:
        {
            return @"";
            break;
        }
        case 3:
        {
            return @"";
            break;
        }
        case 4:
        {
            return @"";
            break;
        }
        case 5:
        {
            return @"";
            break;
        }
        case 6:
        {
            return @"";
            break;
        }
        case 7:
        {
            return @"";
            break;
        }
        case 8:
        {
            return @"";
            break;
        }
        case 9:
        {
            return @"";
            break;
        }
        default:
        {
            return @"";
        }
            
    }
    return nil;
}

- (void)keyboardWillShow: (NSNotification *)notif {
    NSLog(@"hide");
    //[inputTF resignFirstResponder];
}

#pragma mark - Dial Button is clicked
- (void)dialBtnClicked {
    if (![inputTF.text isEqualToString:@""] && _delegate) {
        [_delegate makeDial:inputTF.text];
    }
}

- (void)makeBackspace {
    if (inputTF.text.length > 0) {
        inputTF.text = [inputTF.text substringToIndex:(inputTF.text.length - 1)];
        _numlockStr = [NSMutableString stringWithFormat:@"%@",[_numlockStr substringToIndex:(inputTF.text.length)]];
    }
}

@end