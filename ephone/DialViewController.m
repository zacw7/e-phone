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
@synthesize recordTableView = _recordTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initViews];
}

- (void)initData {
    selectedIndex = -1;
    dataArr = [NSMutableArray new];
    
    //模拟通话记录数据
    CallRecordModel *prm1=[[CallRecordModel alloc]init];
    prm1.name=@"马云";
    prm1.phoneNum=@"13568818032";
    prm1.address=@"四川成都移动";
    prm1.call_time=@"2015-10-26 19:42:32";
    prm1.duration=@"00:12:11";
    prm1.type=INCOMING;
    prm1.myPhoneNum=@"17717644206";
    prm1.endTime=@"2015-10-26 19:45:32";
    prm1.isPlatUpload=@"0";
    prm1.isItmsUpload=@"0";
    prm1.currentLocation=@"成都";
    [dataArr addObject:prm1];
    
    CallRecordModel *prm2=[[CallRecordModel alloc]init];
    prm2.name=@"马化腾";
    prm2.phoneNum=@"13568818099";
    prm2.address=@"四川成都移动";
    prm2.call_time=@"2015-10-16 12:42:32";
    prm2.duration=@"--:--:--";
    prm2.type=FAILED;
    prm2.myPhoneNum=@"17717644206";
    prm2.endTime=@"2015-10-16 14:45:32";
    prm2.isPlatUpload=@"0";
    prm2.isItmsUpload=@"0";
    prm2.currentLocation=@"成都";
    [dataArr addObject:prm2];
    
    CallRecordModel *prm3=[[CallRecordModel alloc]init];
    prm3.name=@"";
    prm3.phoneNum=@"13568818095";
    prm3.address=@"sip:121.42.43.237";
    prm3.call_time=@"2015-10-26 09:42:32";
    prm3.duration=@"00:01:22";
    prm3.type=OUTCOMING;
    prm3.myPhoneNum=@"17717644206";
    prm3.endTime=@"2015-10-26 10:02:10";
    prm3.isPlatUpload=@"0";
    prm3.isItmsUpload=@"0";
    prm3.currentLocation=@"成都";
    [dataArr addObject:prm3];
    
    //dataArr=[util findAllRecentContactsRecordByLoginMobNum:@"17717644206"];
    
}

- (void)initViews{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // init SearchBar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(SCREEN_ORIGIN_X+16, SCREEN_ORIGIN_Y+32,
                                                                   SCREEN_WIDTH-32, 32)];
    self.searchBar.delegate = self;
    self.searchBar.showsScopeBar = NO;
    [self.searchBar sizeToFit];
    [self.view addSubview:self.searchBar];
    
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
    
    // init TableView
    self.recordTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_ORIGIN_X+16, SCREEN_ORIGIN_Y+self.searchBar.frame.size.height+32, SCREEN_WIDTH-32, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
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

#pragma mark UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (isSearchMode) { //模糊匹配状态
        return [searchArr count];
    }else{ //一般状态
        if ([dataArr count]) { //没有通话记录
            [self.view bringSubviewToFront: self.recordTableView];
        }else{
            [self.view bringSubviewToFront: self.noRecordView];
        }
        [self.view bringSubviewToFront: self.phonePadView];
        return [dataArr count];
    }
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
    CallRecordModel *crm=dataArr[indexPath.row];
    if (selectedIndex==indexPath.row) {//展开的Cell
        CallRecordModel *crm=dataArr[indexPath.row];
        ExpandedCallTableViewCell *expCallCell = [[ExpandedCallTableViewCell alloc] initWithCallRecordModel:crm];
        return expCallCell;
//        CallRecordModel *crm=dataArr[indexPath.row];
//        ExpandCallCell *expandCell=[ExpandCallCell Cell];
//        UILabel *nameLabel=expandCell.nameLabel;
//        UILabel *timeLabel=expandCell.timeLabel;
//        //        UIButton *expandBtn=expandCell.expandBtn;
//        UILabel *mobNumLabel=expandCell.phoneNumLabel;
//        UILabel *locationLabel=expandCell.locationLabel;
//        UIButton *callBtn=expandCell.callBtn;
//        UIButton *msgBtn=expandCell.msgBtn;
//        UIButton *delBtn=expandCell.delBtn;
//        UIButton *detailBtn=expandCell.detailBtn;
//        UIImageView *callStatusIv=expandCell.statusIv;
//        
//        callBtn.titleLabel.tag=indexPath.row;
//        [callBtn addTarget:self action:@selector(recordCallBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        
//        msgBtn.titleLabel.tag=indexPath.row;
//        [msgBtn addTarget:self action:@selector(recordMsgBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        
//        delBtn.titleLabel.tag=indexPath.row;
//        [delBtn addTarget:self action:@selector(recordDelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        
//        detailBtn.titleLabel.tag=indexPath.row;
//        [detailBtn addTarget:self action:@selector(recordDetailBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        
//        nameLabel.text=prm.name;
//        timeLabel.text=prm.call_time;
//        mobNumLabel.text=prm.phoneNum;
//        locationLabel.text=prm.location;
//        
//        if ([prm.type isEqualToString:@"1"]) {//呼入
//            [callStatusIv setImage:[UIImage imageNamed:@"icon_call_in"]];
//        }else if([prm.type isEqualToString:@"2"]){//呼出
//            [callStatusIv setImage:[UIImage imageNamed:@"icon_call_out"]];
//        }else if([prm.type isEqualToString:@"3"]){//未接
//            [callStatusIv setImage:[UIImage imageNamed:@"icon_call_off"]];
//        }
//        return expandCell;
    }else{//没有展开的Cell
        CallTableViewCell *callCell = [[CallTableViewCell alloc] initWithCallRecordModel:crm];
        return callCell;
    }
    return [UITableViewCell new];
}
//#pragma mark 通话记录展开按钮点击
//- (void) expandBtnClicked:(UIButton *) btn{
//    if (selectedIndex==btn.titleLabel.tag) {//点击自身则收起来
//        selectedIndex=-1;
//    }else{
//        selectedIndex=btn.titleLabel.tag;
//    }
//    [self.tableView reloadData];
//}

//- (void)setExtraCellLineHidden: (UITableView *)tableView {
//    UIView *view = [UIView new];
//    view.backgroundColor = [UIColor clearColor];
//    [tableView setTableFooterView:view];
//    [view release];
//}
#pragma mark 通话记录拨号按钮点击
- (void) recordCallBtnClicked:(UIButton *) btn{
    //    long index=btn.titleLabel.tag;
    
    
}
#pragma mark 通话记录消息按钮点击
- (void) recordMsgBtnClicked:(UIButton *) btn{
    //    long index=btn.titleLabel.tag;
    
    
}
#pragma mark 通话记录删除按钮点击
- (void) recordDelBtnClicked:(UIButton *) btn{
    //    long index=btn.titleLabel.tag;
    
    
}
#pragma mark 通话记录详情按钮点击
- (void) recordDetailBtnClicked:(UIButton *) btn{
    //    long index=btn.titleLabel.tag;
    
    
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