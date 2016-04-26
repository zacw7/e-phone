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
#import "CallRecordModel.h"
#import "Constants.h"

#define DB_FILE_NAME @"ephone.sqlite3"

@interface DBUtil : NSObject {
    sqlite3 *db;
}

+ (DBUtil *) sharedManager; //获取单例对象

#pragma mark 数据库存储路径获取
- (NSString *)applicationDocumentsDirectoryFile;
#pragma mark 创建数据库文件
- (void) createEditableCopyOfDbIfNeeded;
#pragma mark 创建通话记录联系人表
- (BOOL) createRecentContactsTable;
#pragma mark 查询所有通话记录的方法
- (NSMutableArray *) findAllRecentContactsRecordByLoginMobNum:(NSString *) myAccount;
#pragma mark 插入通话记录的方法
- (BOOL) insertRecentContactsRecord:(CallRecordModel *) prm;
#pragma mark 删除指定id通话记录的方法
- (BOOL) deleteRecentContactRecordById:(int) dbId;
#pragma mark 根据登陆账号清空该用户通话记录表的方法
- (BOOL) deleteAllRecentContactRecordWithLoginMobNum:(NSString *) myAccount;

@end
