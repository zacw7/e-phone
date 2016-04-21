//
//  ContactsViewController.h
//  ephone-z
//
//  Created by Jian Liao on 16/3/9.
//  Copyright © 2016年 fungotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Constants.h"
#import "ContactDetailViewController.h"

@interface ContactsViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *listContacts;
@property (strong, nonatomic) UITableView *tableView;

- (void)filterContentForSearchText:(NSString*) searchText;

@end
