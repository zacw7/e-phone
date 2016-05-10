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
#import "DBUtil.h"

@interface ContactsViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) const NSString *myAccount;

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UIView *noContactView;
@property (strong, nonatomic) UITableView *contactTableView;

- (void)filterContentForSearchText:(NSString*) searchText;

@end
