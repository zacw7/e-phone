 //
//  ContactsViewController.m
//  ephone-z
//
//  Created by Jian Liao on 16/3/9.
//  Copyright © 2016年 fungotech. All rights reserved.
//

#import "ContactsViewController.h"

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initViews];
}

- (void)initData {
    //tabBarController = (MainTabBarViewController*)self.tabBarController;
    
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    __weak ContactsViewController *weakSelf = self;
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        if(granted) {
            [weakSelf filterContentForSearchText:@""];
        }
    });
    CFRelease(addressBook);
}

- (void)initViews {
    // set search bar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(SCREEN_ORIGIN_X+16, SCREEN_ORIGIN_Y+32,
                                                                   SCREEN_WIDTH-32, 32)];
    self.searchBar.delegate = self;
    self.searchBar.showsScopeBar = NO;
    [self.searchBar sizeToFit];
    [self.view addSubview:self.searchBar];
    
    // set table view
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_ORIGIN_X+16, SCREEN_ORIGIN_Y+self.searchBar.frame.size.height+32, SCREEN_WIDTH-32, SCREEN_HEIGHT-64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)filterContentForSearchText:(NSString *)searchText {
    if(ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
        return;
    }

    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    if([searchText length] == 0) {
        // search all
        self.listContacts = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
    } else {
        // condition search
        CFStringRef cfSearchText = (CFStringRef)CFBridgingRetain(searchText);
        self.listContacts = CFBridgingRelease(ABAddressBookCopyPeopleWithName(addressBook, cfSearchText));
        CFRelease(cfSearchText);
    }
    [self.tableView reloadData];
    CFRelease(addressBook);
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ContactDetailViewController *contactDetailViewController = [segue destinationViewController];
        
        ABRecordRef thisPerson = CFBridgingRetain([self.listContacts objectAtIndex:[indexPath row]]);
        
        ABRecordID personID = ABRecordGetRecordID(thisPerson);
        NSNumber *personIDAsNumber = [NSNumber numberWithInt:personID];
        
        contactDetailViewController.personIDAsNumber = personIDAsNumber;
        
        CFRelease(thisPerson);
    }
}

#pragma mark - Table View Settings

- (NSInteger *)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listContacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ContactCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    ABRecordRef thisPerson = CFBridgingRetain([self.listContacts objectAtIndex:[indexPath row]]);
    NSString *firstName = CFBridgingRelease(ABRecordCopyValue(thisPerson, kABPersonFirstNameProperty));
    firstName = (firstName != nil) ? firstName : @"";
    NSString *lastName = CFBridgingRelease(ABRecordCopyValue(thisPerson, kABPersonLastNameProperty));
    lastName = (lastName != nil) ? lastName : @"";
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    NSString* name = CFBridgingRelease(ABRecordCopyCompositeName(thisPerson));
    cell.textLabel.text = name;
    
    CFRelease(thisPerson);
    
    return cell;
}


#pragma mark - Search Bar Delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self filterContentForSearchText:self.searchBar.text];
    [self.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(nonnull NSString *)searchText {
    [self filterContentForSearchText:self.searchBar.text];
}

@end