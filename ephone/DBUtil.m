//
//  DBUtil.m
//  ephone
//
//  Created by Jian Liao on 16/4/21.
//  Copyright © 2016年 zeoh. All rights reserved.
//

#import "DBUtil.h"

@implementation DBUtil

static DBUtil * util=nil;

+ (DBUtil *) sharedManager{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        util=[[self alloc]init];
        [util createEditableCopyOfDbIfNeeded];
    });
    
    return util;
}

#pragma mark 数据库存储路径获取
- (NSString *)applicationDocumentsDirectoryFile {
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbPath=[docPath stringByAppendingPathComponent:DB_FILE_NAME];
    return dbPath;
}

#pragma mark创建数据库文件
- (void) createEditableCopyOfDbIfNeeded {
    if([self openDB] != SQLITE_OK) {
        NSLog(@"Open DB failed.");
    } else
        [self createRecentContactsTable];
    sqlite3_close(db);
}

#pragma mark 创建通话记录联系人表
- (BOOL) createRecentContactsTable{
    NSString *SQL=[NSString stringWithFormat:
                    @"CREATE TABLE IF NOT EXISTS t_phone_record(id integer primary key autoincrement, name varchar(32), account varchar(32), domain varchar(32), attribution varchar(20), callTime varcher(20), duration char(8), callType int, networkType int, myAccount varchar(32))"];
    BOOL isCreationSuccess = [self execSql:SQL];
    return isCreationSuccess;
    /**
     通话记录数据库表格结构 t_phone_record
     id  int 主键
     name varchar(32) 联系人姓名
     account varchar(32) 通话号码
     domain varchar(32) remote server address
     attribution varchar(20) 号码归属地
     callTime varcher(20) 通话开始时间点   例如 ：2015-03-25 14:00:02
     duration char(8) 通话时长 e.g. 00:02:32
     callType int 接通方式    0:outcoming 1：incoming  2：failed  3：missed
     networkType int 网络类型 0:SIP 1:PSTN
     myAccount varchar(32) 我的当前登录号码
     **/
}

#pragma mark 查询所有通话记录的方法
- (NSMutableArray *) findAllRecentContactsRecordByLoginMobNum:(NSString *) myAccount{
    //                code=[self openDB];
    NSMutableArray *resultList=[[NSMutableArray alloc]init];
    if ([self openDB]!=SQLITE_OK) {//数据库打开失败
        sqlite3_close(db);
        NSLog(@"数据库打开失败",nil);
    }else{
        NSString *SQL=@"select * from t_phone_record where myAccount=? order by id DESC";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [SQL UTF8String], -1, &statement, NULL)==SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [myAccount UTF8String], -1, NULL);
            while (sqlite3_step(statement)==SQLITE_ROW) {
                //                NSMutableDictionary *objDict=[[NSMutableDictionary alloc]init];//封装结果成字典对象
                CallRecordModel *recordModel=[[CallRecordModel alloc]init];
                recordModel.dbId=sqlite3_column_int(statement, 0);
                
                //                int  pid=sqlite3_column_int(statement, 0);
                //                [objDict setObject:[NSNumber numberWithInt:pid] forKey:@"id"];
                
                char *name=(char *)sqlite3_column_text(statement, 1);
                //                [objDict setObject:[[NSString alloc ]initWithUTF8String:name] forKey:@"name"];
                if(name) recordModel.name=[[NSString alloc ] initWithUTF8String:name];
                
                char *account=(char *)sqlite3_column_text(statement, 2);
                //                [objDict setObject:[[NSString alloc ]initWithUTF8String:phoneNum] forKey:@"phoneNum"];
                if(account) recordModel.account=[[NSString alloc ] initWithUTF8String:account];
                
                char *domain=(char *)sqlite3_column_text(statement, 3);
                //                [objDict setObject:[[NSString alloc ]initWithUTF8String:location] forKey:@"location"];
                if(domain) recordModel.domain=[[NSString alloc ] initWithUTF8String:domain];
                
                char *attribution=(char *)sqlite3_column_text(statement, 4);
                //                [objDict setObject:[[NSString alloc ]initWithUTF8String:location] forKey:@"location"];
                if(attribution) recordModel.attribution=[[NSString alloc ] initWithUTF8String:attribution];
                
                char  *callTime=(char *)sqlite3_column_text(statement, 5);
                //                [objDict setObject:[[NSString alloc ]initWithUTF8String:call_time] forKey:@"call_time"];
                if(callTime) recordModel.callTime=[[NSString alloc ]initWithUTF8String:callTime];
                
                char  *duration=(char *)sqlite3_column_text(statement, 6);
                //                [objDict setObject:[[NSString alloc ]initWithUTF8String:call_time] forKey:@"call_time"];
                if(duration) recordModel.duration=[[NSString alloc ]initWithUTF8String:duration];
                
                //                int  type=sqlite3_column_int(statement, 5);
                //                [objDict setObject:[NSNumber numberWithInt:type] forKey:@"type"];
                
                CallType callType = atoi((char*)sqlite3_column_text(statement, 7));
                recordModel.callType=callType;
                
                NetworkType networkType=atoi((char*)sqlite3_column_text(statement, 8));
                recordModel.networkType = networkType;
                
                char  *myAccount=(char *)sqlite3_column_text(statement, 9);
                //                [objDict setObject:[[NSString alloc ]initWithUTF8String:myAccount] forKey:@"myAccount"];
                if(myAccount) recordModel.myAccount=[[NSString alloc ]initWithUTF8String:myAccount];
                
                [resultList addObject:recordModel];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return resultList;
}

#pragma mark 插入通话记录的方法
- (BOOL) insertRecentContactsRecord:(CallRecordModel *) recordModel{
    //                code=[self openDB];
    if ([self openDB] != SQLITE_OK) {//数据库打开失败
        sqlite3_close(db);
        NSLog(@"数据库打开失败",nil);
        return NO;
    }else{
        NSString *SQL=@"insert into t_phone_record(id, name, account, domain, attribution, callTime, duration, callType, networkType, myAccount) values(NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        sqlite3_stmt *statement;
        int code1= sqlite3_prepare_v2(db, [SQL UTF8String], -1, &statement, NULL);
        if (code1==SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [recordModel.name UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 2, [recordModel.account UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 3, [recordModel.domain UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 4, [recordModel.attribution UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 5, [recordModel.callTime UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 6, [recordModel.duration UTF8String], -1, NULL);
            
            sqlite3_bind_int(statement, 7, recordModel.callType);
            sqlite3_bind_int(statement, 8, recordModel.networkType);
            
            sqlite3_bind_text(statement, 9, [recordModel.myAccount UTF8String], -1, NULL);
            
            if (sqlite3_step(statement)!=SQLITE_DONE)
            {
                NSLog(@"通话记录插入失败");
                return NO;
            }
            //删除超过60条的记录
            [self deleteMoreThan60RecentContactRecordWithLoginMobNum:recordModel.myAccount];
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return YES;
}

#pragma mark 删除指定id通话记录的方法
- (BOOL) deleteRecentContactRecordById:(int) dbId{
    if ([self openDB]!=SQLITE_OK) {//数据库打开失败
        sqlite3_close(db);
        NSLog(@"数据库打开失败",nil);
        return NO;
    }else{
        NSString *SQL=@"delete from t_phone_record where id=?";
        sqlite3_stmt *statement;
        int code1= sqlite3_prepare_v2(db, [SQL UTF8String], -1, &statement, NULL);
        if (code1==SQLITE_OK) {
            sqlite3_bind_int(statement, 1, dbId);
            if (sqlite3_step(statement)!=SQLITE_DONE)
            {
                NSLog(@"通话记录删除失败id=%d",dbId);
                return NO;
            }
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return YES;
}

#pragma mark 根据登陆手机号清空该用户通话记录表的方法
- (BOOL) deleteAllRecentContactRecordWithLoginMobNum:(NSString *) myAccount{
    if ([self openDB]!=SQLITE_OK) {//数据库打开失败
        sqlite3_close(db);
        NSLog(@"数据库打开失败",nil);
        return NO;
    }else{
        NSString *SQL=@"delete from t_phone_record where myAccount=?";
        sqlite3_stmt *statement;
        int code2= sqlite3_prepare_v2(db, [SQL UTF8String], -1, &statement, NULL);
        if (code2==SQLITE_OK) {
            sqlite3_bind_text(statement,1, [myAccount UTF8String],-1,NULL);
            if (sqlite3_step(statement)!=SQLITE_DONE) {
                NSLog(@"通话记录清空失败", nil);
                return NO;
            }
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return YES;
}

#pragma mark Private Methods

#pragma mark 打开ephone数据库的方法
-(int) openDB{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documents = [paths objectAtIndex:0];
//    NSString *dbPath = [documents stringByAppendingPathComponent:@"ephone.sqlite3"];
//    return sqlite3_open([dbPath UTF8String], &db);
    NSString *DBPath=[self applicationDocumentsDirectoryFile];
    return sqlite3_open([DBPath UTF8String], &db);
}

-(BOOL) execSql:(NSString *)sql{
    char *err;
    int rc=sqlite3_exec(db, [sql UTF8String], nil, nil, &err);
    if(rc!=SQLITE_OK) {
        NSLog(@"%@:SQL=%@",@"数据库操作失败",sql);
        return NO;
    } else
        return YES;
}

#pragma mark 删除超过60条的早期通话记录
- (BOOL) deleteMoreThan60RecentContactRecordWithLoginMobNum:(NSString *) mobNum{
    //                code=[self openDB];
    if ([self openDB]!=SQLITE_OK) {//数据库打开失败
        sqlite3_close(db);
        NSLog(@"数据库打开失败",nil);
        return NO;
    }else{
        NSString *SQL=@"delete from t_phone_record where (select count(id) from t_phone_record)> 60 and id in (select id from t_phone_record order by id desc limit (select count(id) from t_phone_record) offset 60 ) and myAccount=?";
        sqlite3_stmt *statement;
        int code2= sqlite3_prepare_v2(db, [SQL UTF8String], -1, &statement, NULL);
        if (code2==SQLITE_OK) {
            sqlite3_bind_text(statement,1, [mobNum UTF8String],-1,NULL);
            if (sqlite3_step(statement)!=SQLITE_DONE) {
                NSLog(@"超量60通话记录清空失败", nil);
                return NO;
            }
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return YES;
}

@end
