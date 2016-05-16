 //
//  ContactsViewController.m
//  ephone-z
//
//  Created by Jian Liao on 16/3/9.
//  Copyright © 2016年 fungotech. All rights reserved.
//

#import "ContactsViewController.h"

@implementation ContactsViewController {
    //被选中联系人行的下标
    long selectedIndex;
    //联系人数组
    NSMutableArray *dataArr;
    // Current Contact
    ContactModel *expandedContact;
    // DBUtil
    DBUtil *dbUtil;
    
    BOOL isKeyboardShow;
    CGPoint newContactViewOrginCenter;
}

@synthesize delegate = _delegate;
@synthesize editContactView = _editContactView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initViews];
}

- (void)initData {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshData:)
                                                 name:@"refresh"
                                               object:nil];
    
    dbUtil = [DBUtil sharedManager];
    selectedIndex = -1;
    dataArr=[dbUtil findAllContactsByLoginMobNum:(NSString*)self.myAccount];

}

- (void)initViews {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // init noContactView
    self.noContactView = [[UIView alloc] initWithFrame:self.view.frame];
    UIImageView *noContactImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    noContactImageView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-40);
    noContactImageView.image = [UIImage imageNamed:@"bg_no_contacts.png"];
    [self.noContactView addSubview:noContactImageView];
    
    UILabel *noContactLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 20)];
    noContactLabel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 40 + noContactImageView.frame.size.height);
    noContactLabel.text = @"No Record";
    noContactLabel.textAlignment = NSTextAlignmentCenter;
    noContactLabel.textColor = [UIColor lightGrayColor];
    [self.noContactView addSubview:noContactLabel];
    [self.view addSubview:self.noContactView];
    
    // init SearchBar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(SCREEN_ORIGIN_X, SCREEN_ORIGIN_Y+32,
                                                                   SCREEN_WIDTH, 32)];
    self.searchBar.delegate = self;
    self.searchBar.showsScopeBar = NO;
    [self.searchBar sizeToFit];
    [self.view addSubview:self.searchBar];
    
    // init TableView
    self.contactTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_ORIGIN_X, SCREEN_ORIGIN_Y+self.searchBar.frame.size.height+32, SCREEN_WIDTH, SCREEN_HEIGHT-196) style:UITableViewStylePlain];
    self.contactTableView.delegate=self;
    self.contactTableView.dataSource=self;
    [self.contactTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.contactTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.contactTableView];
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
        dataArr=[dbUtil findAllContactsByLoginMobNum:(NSString*)self.myAccount];
    } else {
        // condition search
        dataArr = [dbUtil findContactsByLoginSearchBarContent:searchText withAccount:(NSString*)self.myAccount];
    }
    if([dataArr count]) {
        [_contactTableView setHidden:NO];
        [_contactTableView reloadData];
    } else {
        [_contactTableView setHidden:YES];
    }
}

#pragma mark UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([dataArr count]) { //没有通话记录
        [self.view bringSubviewToFront: self.contactTableView];
    }else{
        [self.view bringSubviewToFront: self.noContactView];
    }
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
    [self.contactTableView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (selectedIndex==indexPath.row) {//展开的Cell
        expandedContact=dataArr[indexPath.row];
        ExpandedContactTableViewCell *expContactCell = [[ExpandedContactTableViewCell alloc] initWithContactModel:expandedContact];
        [expContactCell.callBtn addTarget:self action:@selector(contactCallBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [expContactCell.editBtn addTarget:self action:@selector(contactEditBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [expContactCell.deleteBtn addTarget:self action:@selector(contactDeleteBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        return expContactCell;
    }else{//没有展开的Cell
        ContactModel *cm =dataArr[indexPath.row];
        ContactTableViewCell *contactCell = [[ContactTableViewCell alloc] initWithContactModel:cm];
        return contactCell;
    }
    return [UITableViewCell new];
}

#pragma mark 联系人拨号按钮点击
- (void)contactCallBtnClicked {
    if(expandedContact.networkType == SIP){}
    NSString *sipUri;
    if(_delegate) {
        switch (expandedContact.networkType) {
            case SIP:
                sipUri = [[expandedContact.account stringByAppendingString:@"@"] stringByAppendingString:expandedContact.domain];
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

#pragma mark 联系人修改按钮点击
- (void)contactEditBtnClicked {
    ContactModel *cm = [ContactModel alloc];
    cm.dbId = expandedContact.dbId;
    cm.name = expandedContact.name;
    cm.account = expandedContact.account;
    cm.domain = expandedContact.domain;
    cm.attribution = expandedContact.attribution;
    cm.networkType = expandedContact.networkType;
    cm.myAccount = expandedContact.myAccount;
    
    _editContactView = [[EditContactView alloc] initWithContactModel:cm];
    newContactViewOrginCenter = _editContactView.center;
    [self.view addSubview:_editContactView];
    _editContactView.nameInput.delegate = self;
    _editContactView.accountInput.delegate = self;
    _editContactView.addressInput.delegate = self;
}

#pragma mark 联系人删除按钮点击
- (void)contactDeleteBtnClicked {
    [dbUtil deleteContactById:expandedContact.dbId];
}

#pragma mark - TextFieldDelegate
- (void)hideKeyboardEventHandler {
    [_editContactView.nameInput resignFirstResponder];
    [_editContactView.accountInput resignFirstResponder];
    [_editContactView.addressInput resignFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if (textField == _editContactView.nameInput) {
        [_editContactView.accountInput becomeFirstResponder];
    } else if(textField == _editContactView.accountInput) {
        [_editContactView.addressInput becomeFirstResponder];
    }else {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) keyboardWillShow: (NSNotification *)notif {
    float duration = (isKeyboardShow) ? 0 : 0.3;
    isKeyboardShow = YES;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationDelegate:self];
    _editContactView.center = CGPointMake(newContactViewOrginCenter.x, newContactViewOrginCenter.y - 100);
    [UIView commitAnimations];
}

- (void) keyboardWillHide: (NSNotification *)notif {
    isKeyboardShow = NO;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    CGPoint newCenter = _editContactView.center;
    newCenter.y += 100;
    _editContactView.center = newContactViewOrginCenter;
    [UIView commitAnimations];
}


- (void)refreshData:(id)sender{
    if(self.searchBar.text.length) {
        dataArr = [dbUtil findContactsByLoginSearchBarContent:self.searchBar.text withAccount:(NSString*)self.myAccount];
    } else {
        dataArr = [dbUtil findAllContactsByLoginMobNum:(NSString*)self.myAccount];
    }
    [_contactTableView reloadData];
}

@end