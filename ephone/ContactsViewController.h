//
//  ContactsViewController.h
//  ephone-z
//
//  Created by Jian Liao on 16/3/9.
//  Copyright © 2016年 fungotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "ContactTableViewCell.h"
#import "ExpandedContactTableViewCell.h"
#import "DBUtil.h"
#import "EditContactView.h"

@interface ContactsViewController : UIViewController <UITextFieldDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) id<DialDelegate> delegate;
@property (nonatomic, assign) const NSString *myAccount;

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UIView *noContactView;
@property (strong, nonatomic) UITableView *contactTableView;

@property (strong, nonatomic) EditContactView *editContactView;

- (void)filterContentForSearchText:(NSString*) searchText;

@end
