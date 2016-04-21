//
//  DBUtil.m
//  ephone
//
//  Created by Jian Liao on 16/4/21.
//  Copyright © 2016年 zeoh. All rights reserved.
//

#import "DBUtil.h"

@implementation DBUtil{
    int code;
    int codeLocation;
}

static DBUtil * util=nil;

+ (DBUtil *) sharedManager{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        util=[[self alloc]init];
        [util createEditableCopyOfDbIfNeeded];
    });
    
    return util;
}

//获取沙箱下数据库文件全路径
- (NSString *)applicationDocumentsDirectoryFile {
    return NULL;
}
//创建可编辑的数据库副本
- (void) createEditableCopyOfDbIfNeeded {
    
}
////获取沙箱下数据库文件全路径
//- (NSString *)applicationDocumentsDirectoryFile;
////创建可编辑的数据库副本
//- (void) createEditableCopyOfDbIfNeeded;

#pragma mark 创建通话记录联系人表
- (void) createRecentContactsTable {
    
}

#pragma mark 查询所有通话记录的方法
- (NSMutableArray *) findAllRecentContactsRecordByLoginMobNum:(NSString *) myPhoneNum {
    return NULL;
}

#pragma mark 插入通话记录的方法
- (BOOL) insertRecentContactsRecord:(PhoneRecordModel *) prm {
    return NULL;
}

#pragma mark 删除指定id通话记录的方法
- (BOOL) deleteRecentContactRecordById:(int) dbId {
    return NULL;
}

#pragma mark 根据登陆手机号清空该用户通话记录表的方法
- (BOOL) deleteAllRecentContactRecordWithLoginMobNum:(NSString *) mobNum{
    return NULL;
}

#pragma mark 关闭数据库的方法
- (void) closeDB{
    
}

@end
