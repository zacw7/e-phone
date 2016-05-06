//
//  AddContactView.h
//  ephone
//
//  Created by Jian Liao on 16/5/6.
//  Copyright © 2016年 zeoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactModel.h"
#import "Constants.h"
#import "DBUtil.h"

@interface AddContactView : UIView <UITextFieldDelegate>

- (id)initWithContactModel:(ContactModel*) cm;

@end