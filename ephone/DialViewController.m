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
    //是否在搜索模式
    BOOL isSearchMode;
    //被选中通话记录行的下标
    long selectedIndex;
    //拨号小键盘输入的内容dddhj
    NSMutableString * _numlockStr;
    //拨号小键盘视图
    UIView *contentView;
    //拨号输入框
    UITextField *inputTF;
    //拨号小键盘是否弹出
    BOOL isKeyBoardShow;
    //是否开启热点视图
    BOOL isHotPointOn;
    // Current Call Record
    CallRecordModel *expandedCallRecord;
    // DBUtil
    DBUtil *dbUtil;
    
    NSTimer *refreshTimer;
    BOOL isReloading;
}

@synthesize delegate = _delegate;
@synthesize phonePadView = _phonePadView;
@synthesize recordTableView = _recordTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initViews];
}

- (void)initData {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(refreshData:)
               name:@"refresh"
             object:nil];
    dbUtil = [DBUtil sharedManager];
    selectedIndex = -1;
    dataArr = [NSMutableArray new];
    expandedCallRecord = nil;
    isReloading = NO;
    
    dataArr=[dbUtil findAllRecentContactsRecordByLoginMobNum:(NSString*)self.myAccount];
}

- (void)initViews{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // init noRecordView
    self.noRecordView = [[UIView alloc] initWithFrame:self.view.frame];
    UIImageView *noRecordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    noRecordImageView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-40);
    noRecordImageView.image = [UIImage imageNamed:@"bg_no_call.png"];
    [self.noRecordView addSubview:noRecordImageView];
    
    UILabel *noRecordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 20)];
    noRecordLabel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 40 + noRecordImageView.frame.size.height);
    noRecordLabel.text = @"No Record";
    noRecordLabel.textAlignment = NSTextAlignmentCenter;
    noRecordLabel.textColor = [UIColor lightGrayColor];
    [self.noRecordView addSubview:noRecordLabel];
    [self.view addSubview:self.noRecordView];
    
    // init SearchBar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(SCREEN_ORIGIN_X, SCREEN_ORIGIN_Y+32,
                                                                   SCREEN_WIDTH, 32)];
    self.searchBar.delegate = self;
    self.searchBar.showsScopeBar = NO;
    [self.searchBar sizeToFit];
    [self.view addSubview:self.searchBar];
    
    // init TableView
    self.recordTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_ORIGIN_X, SCREEN_ORIGIN_Y+self.searchBar.frame.size.height+32, SCREEN_WIDTH, SCREEN_HEIGHT-196) style:UITableViewStylePlain];
    self.recordTableView.delegate=self;
    self.recordTableView.dataSource=self;
    [self.recordTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.recordTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.recordTableView];
    
    contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 380)];
    _phonePadView = [[PhonePadView alloc]initWithView:contentView parentView:self.view];
    [_phonePadView.dialBtn addTarget:self action:@selector(dialBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_phonePadView.backsapceBtn addTarget:self action:@selector(makeBackspace) forControlEvents:UIControlEventTouchUpInside];
    [_phonePadView setBackgroundColor:[UIColor whiteColor]];
    [self initKeyboard];
    [self.view addSubview:_phonePadView];
}

#pragma mark - Search Bar Delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self filterContentForSearchText:searchBar.text];
    [self.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(nonnull NSString *)searchText {
    [self filterContentForSearchText:searchBar.text];
    if([searchText length] == 0) {
        [searchBar performSelector: @selector(resignFirstResponder)
                        withObject: nil
                        afterDelay: 0.1];
    }
}

- (void)filterContentForSearchText:(NSString *)searchText {
    if([searchText length] == 0) {
        // search all
        dataArr=[dbUtil findAllRecentContactsRecordByLoginMobNum:(NSString*)self.myAccount];
    } else {
        // condition search
        dataArr = [dbUtil findRecentContactsRecordsByLoginSearchBarContent:searchText withAccount:(NSString*)self.myAccount];
    }
    if([dataArr count]) {
        [_recordTableView setHidden:NO];
        [_recordTableView reloadData];
    } else {
        [_recordTableView setHidden:YES];
    }
}

#pragma mark UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([dataArr count]) { //没有通话记录
        [self.view bringSubviewToFront: self.recordTableView];
    }else{
        [self.view bringSubviewToFront: self.noRecordView];
    }
    [self.view bringSubviewToFront: self.phonePadView];
    return [dataArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //选中之后的cell的高度
    if (selectedIndex == indexPath.row){
        return 120;
    }
    else
        return 60;
}

//选中Cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (selectedIndex==indexPath.row) {//点击自身则收起来
        selectedIndex=-1;
    }else{
        selectedIndex=indexPath.row;
    }
    [self.recordTableView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (selectedIndex==indexPath.row) {//展开的Cell
        expandedCallRecord=dataArr[indexPath.row];
        ExpandedCallTableViewCell *expCallCell = [[ExpandedCallTableViewCell alloc] initWithCallRecordModel:expandedCallRecord];
        [expCallCell.callBtn addTarget:self action:@selector(recordCallBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [expCallCell.deleteBtn addTarget:self action:@selector(recordDeleteBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [expCallCell.saveBtn addTarget:self action:@selector(recordSaveBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        return expCallCell;
    }else{//没有展开的Cell
        CallRecordModel *crm =dataArr[indexPath.row];
        CallTableViewCell *callCell = [[CallTableViewCell alloc] initWithCallRecordModel:crm];
        return callCell;
    }
    return [UITableViewCell new];
}

- (void)refreshData:(id)sender{
    if(self.searchBar.text.length) {
        dataArr = [dbUtil findRecentContactsRecordsByLoginSearchBarContent:self.searchBar.text withAccount:(NSString*)self.myAccount];
    } else {
        dataArr = [dbUtil findAllRecentContactsRecordByLoginMobNum:(NSString*)self.myAccount];
    }
    [_recordTableView reloadData];
}

#pragma mark 通话记录拨号按钮点击
- (void)recordCallBtnClicked {
    //    long index=btn.titleLabel.tag;
    if(expandedCallRecord.networkType == SIP){}
    NSString *sipUri;
    if(_delegate) {
        switch (expandedCallRecord.networkType) {
            case SIP:
                sipUri = [[expandedCallRecord.account stringByAppendingString:@"@"] stringByAppendingString:expandedCallRecord.domain];
                [_delegate makeSipCall:sipUri];
                break;
            case PSTN:
                NSLog(@"Unsupported network type currently");
                break;
            default:
                NSLog(@"Unknown network type");
                break;
        }
    }
}

#pragma mark 通话记录删除按钮点击
- (void)recordDeleteBtnClicked {
    //    long index=btn.titleLabel.tag;
    NSLog(@"Record Delete");
    [dbUtil deleteRecentContactRecordById:expandedCallRecord.dbId];
}
#pragma mark 保存联系人按钮点击
- (void)recordSaveBtnClicked {
    //    long index=btn.titleLabel.tag;
    NSLog(@"Record Save");
    
}

- (void)initKeyboard {

    _w = contentView.frame.size.width/3;
    _h = SCREEN_HEIGHT*0.08;

    //设置输入框
    inputTF = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, contentView.frame.size.width, SCREEN_HEIGHT*0.08)];
    inputTF.userInteractionEnabled = NO;
    inputTF.delegate = self;
    inputTF.textAlignment = 1;
    inputTF.placeholder = @"请输入电话号码";
    inputTF.delegate = self;
    [contentView addSubview:inputTF];
    
    _numlockStr = [[NSMutableString alloc] init];
    [self initNumLockKeyboard];
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

#pragma mark - Dial Button is clicked
- (void)dialBtnClicked {
    if(![inputTF.text isEqualToString:@""] && _delegate) {
        NSString *sipUri = [[inputTF.text stringByAppendingString:@"@"] stringByAppendingString:SERVER_ADDRESS];
        [_delegate makeSipCall:sipUri];
    }
}

- (void)makeBackspace {
    if (inputTF.text.length > 0) {
        inputTF.text = [inputTF.text substringToIndex:(inputTF.text.length - 1)];
        _numlockStr = [NSMutableString stringWithFormat:@"%@",[_numlockStr substringToIndex:(inputTF.text.length)]];
    }
}

@end