//
//  DBUtil.h
//  ephone
//
//  Created by Jian Liao on 16/4/21.
//  Copyright © 2016年 zeoh. All rights reserved.
//

//
//  DBUtil.h
//  ephone
//
//  Created by administrator on 15/11/16.
//  Copyright © 2015年 com.cditv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "PhoneRecordModel.h"
#import "Constants.h"

//归属地数据库的名称
#define DB_FILE_NAME @"telocation.db";

@interface DBUtil : NSObject{
    sqlite3 *db;
    sqlite3 *locationDb;
}
+ (DBUtil *) sharedManager;//获取单例对象

//获取沙箱下数据库文件全路径
- (NSString *)applicationDocumentsDirectoryFile;
//创建可编辑的数据库副本
- (void) createEditableCopyOfDbIfNeeded;
////获取沙箱下数据库文件全路径
//- (NSString *)applicationDocumentsDirectoryFile;
////创建可编辑的数据库副本
//- (void) createEditableCopyOfDbIfNeeded;
#pragma mark 创建通话记录联系人表
- (void) createRecentContactsTable;
#pragma mark 查询所有通话记录的方法
- (NSMutableArray *) findAllRecentContactsRecordByLoginMobNum:(NSString *) myPhoneNum;
#pragma mark 插入通话记录的方法
- (BOOL) insertRecentContactsRecord:(PhoneRecordModel *) prm;
#pragma mark 删除指定id通话记录的方法
- (BOOL) deleteRecentContactRecordById:(int) dbId;
#pragma mark 根据登陆手机号清空该用户通话记录表的方法
- (BOOL) deleteAllRecentContactRecordWithLoginMobNum:(NSString *) mobNum;
#pragma mark 关闭数据库的方法
- (void) closeDB;

@end
