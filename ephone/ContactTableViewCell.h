//
//  ContactTableViewCell.h
//  ephone
//
//  Created by Jian Liao on 16/5/9.
//  Copyright © 2016年 zeoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ContactModel.h>

@interface ContactTableViewCell : UITableViewCell

@property (weak, nonatomic) ContactModel *contact;
@property (strong, nonatomic) UIImageView *expandImageView;

- (id)initWithContactModel:(ContactModel*) cm;
- (void)initViews;
- (UIImage*)imageCompressWithSimple:(UIImage*)image scale:(float)scale;

@end
