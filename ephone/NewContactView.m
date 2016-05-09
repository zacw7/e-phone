//
//  AddContactView.m
//  ephone
//
//  Created by Jian Liao on 16/5/6.
//  Copyright © 2016年 zeoh. All rights reserved.
//

#import "NewContactView.h"

@implementation NewContactView {
    DBUtil *dbUtil;
    ContactModel *contactModel;
}

@synthesize nameInput = _nameInput;
@synthesize accountInput = _accountInput;
@synthesize addressInput = _addressInput;

- (id)initWithContactModel:(ContactModel*) cm {
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.8, SCREEN_HEIGHT*0.6)];
    if(self) {
        dbUtil = [DBUtil sharedManager];
        contactModel = cm;
        
        [self initViews];
    }
    return self;
}

- (void)initViews {
    self.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    [[self layer] setShadowOffset:CGSizeMake(1, 1)];
    [[self layer] setShadowOpacity:0.2];
    [[self layer] setShadowColor:[UIColor blackColor].CGColor];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height*0.1)];
    [title setText:@"New Contact"];
    [title setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:title];
    
    UILabel *test = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width*0.05, self.frame.size.height*0.12, self.frame.size.width*0.25, self.frame.size.width*0.25)];
    [test setBackgroundColor:[UIColor lightGrayColor]]; //////////
    [self addSubview:test];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width*0.35, self.frame.size.height*0.1, self.frame.size.width*0.2, self.frame.size.height*0.1)];
    [nameLabel setText:@"Name"];
    [self addSubview:nameLabel];
    
    _nameInput = [[UITextField alloc] initWithFrame:CGRectMake(self.frame.size.width*0.35, self.frame.size.height*0.2, self.frame.size.width*0.6, self.frame.size.height*0.1)];
    [_nameInput setText:contactModel.name];
    [[_nameInput layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    [[_nameInput layer] setBorderWidth:1.0f];
    [self addSubview:_nameInput];
    
    UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width*0.05, self.frame.size.height*0.35, self.frame.size.width*0.6, self.frame.size.height*0.1)];
    [accountLabel setText:@"Account number"];
    [self addSubview:accountLabel];
    
    _accountInput = [[UITextField alloc] initWithFrame:CGRectMake(self.frame.size.width*0.05, self.frame.size.height*0.45, self.frame.size.width*0.9, self.frame.size.height*0.1)];
    [_accountInput setText:contactModel.account];
    [[_accountInput layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    [[_accountInput layer] setBorderWidth:1.0f];
    [self addSubview:_accountInput];
    
    UILabel *attributionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width*0.05, self.frame.size.height*0.55, self.frame.size.width*0.6, self.frame.size.height*0.1)];
    [attributionLabel setText:@"Address"];
    [self addSubview:attributionLabel];
    
    _addressInput = [[UITextField alloc] initWithFrame:CGRectMake(self.frame.size.width*0.05, self.frame.size.height*0.65, self.frame.size.width*0.9, self.frame.size.height*0.1)];
    [_addressInput setText:contactModel.attribution];
    [[_addressInput layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    [[_addressInput layer] setBorderWidth:1.0f];
    [self addSubview:_addressInput];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width*0.15, self.frame.size.height*0.78, self.frame.size.width*0.3, self.frame.size.height*0.15)];
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(dissmissSelf) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width*0.55, self.frame.size.height*0.78, self.frame.size.width*0.3, self.frame.size.height*0.15)];
    [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveContact) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:saveBtn];
}

- (void)dissmissSelf {
    [self removeFromSuperview];
}

- (void)saveContact {
    [dbUtil insertContact:contactModel];
    [self removeFromSuperview];
}

@end
