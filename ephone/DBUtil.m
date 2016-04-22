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

#pragma mark 归属地数据库存储路径获取
- (NSString *)applicationDocumentsDirectoryFile {
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbPath=[docPath stringByAppendingPathComponent:@"telocation.db"];
    return dbPath;
}

#pragma mark创建数据库文件
- (void) createEditableCopyOfDbIfNeeded {
    code=[self openDB];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *writeDBPath=[self applicationDocumentsDirectoryFile];
    BOOL dbExist=[fileManager fileExistsAtPath:writeDBPath];//判断db文件是否存在
    if(!dbExist){
        NSString *defaultDBPath=[[NSBundle mainBundle] pathForResource:@"telocation" ofType:@"db"];
        NSError *error;
        BOOL success=[fileManager copyItemAtPath:defaultDBPath toPath:writeDBPath error:&error];//拷贝db文件到沙箱当中
        if(!success) {
            NSLog(@"DB文件拷贝出错:%@",[error localizedDescription]);
        }
    }
    codeLocation=[self openLocationDB];
}

#pragma mark 创建通话记录联系人表
- (void) createRecentContactsTable{
    //            code=[self openDB];
    if (code!=SQLITE_OK) {//数据库打开失败
        sqlite3_close(db);
        NSLog(@"数据库打开失败:%d",code);
    }else{
        NSString *SQL=[NSString stringWithFormat:
                       @"CREATE TABLE IF NOT EXISTS t_phone_record(id integer primary key autoincrement,name varchar(50),phoneNum varchar(20),location varchar(20),call_time varcher(60),type text,myPhoneNum varchar(20),endTime varchar(60),isPlatUpload text,isItmsUpload text,currentLocation text)"];
        [self execSql:SQL];
        /**
         通话记录数据库表格结构 t_phone_record
         id  int 主键
         name varchar(50) 联系人姓名
         phoneNum  varchar(20) 通话号码
         location varchar(20) 号码归属地
         call_time varcher(60) 通话开始时间点   例如 ：2015-03-25 14：00
         type int 接通方式    1：呼入  2：呼出  3：未接
         myPhoneNum varchar(20) 我的当前登录号码（因为可以切换账号）
         endTime varchar(60) 通话结束时间  例如 ：2015-03-25 14：20
         isPlatUpload int    0：话单未上报 1:平台服务器已话单上报
         isItmsUpload int    0：话单未上报 1:Itms服务器已话单上报
         currentlocation text ：通话位置（保留字段）             */
    }
}

#pragma mark 查询所有通话记录的方法
- (NSMutableArray *) findAllRecentContactsRecordByLoginMobNum:(NSString *) myPhoneNum{
    //                code=[self openDB];
    NSMutableArray *resultList=[[NSMutableArray alloc]init];
    if (code!=SQLITE_OK) {//数据库打开失败
        sqlite3_close(db);
        NSLog(@"数据库打开失败",nil);
    }else{
        NSString *SQL=@"select * from t_phone_record where myPhoneNum=? order by call_time DESC";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [SQL UTF8String], -1, &statement, NULL)==SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [myPhoneNum UTF8String], -1, NULL);
            while (sqlite3_step(statement)==SQLITE_ROW) {
                //                NSMutableDictionary *objDict=[[NSMutableDictionary alloc]init];//封装结果成字典对象
                CallRecordModel *recordModel=[[CallRecordModel alloc]init];
                recordModel.dbId=sqlite3_column_int(statement, 0);
                
                
                //                int  pid=sqlite3_column_int(statement, 0);
                //                [objDict setObject:[NSNumber numberWithInt:pid] forKey:@"id"];
                
                char  *name=(char *)sqlite3_column_text(statement, 1);
                //                [objDict setObject:[[NSString alloc ]initWithUTF8String:name] forKey:@"name"];
                recordModel.name=[[NSString alloc ]initWithUTF8String:name];
                
                char  *phoneNum=(char *)sqlite3_column_text(statement, 2);
                //                [objDict setObject:[[NSString alloc ]initWithUTF8String:phoneNum] forKey:@"phoneNum"];
                recordModel.phoneNum=[[NSString alloc ]initWithUTF8String:phoneNum];
                
                char  *address=(char *)sqlite3_column_text(statement, 3);
                //                [objDict setObject:[[NSString alloc ]initWithUTF8String:location] forKey:@"location"];
                
                recordModel.address=[[NSString alloc ]initWithUTF8String:address];
                
                char  *call_time=(char *)sqlite3_column_text(statement, 4);
                //                [objDict setObject:[[NSString alloc ]initWithUTF8String:call_time] forKey:@"call_time"];
                recordModel.call_time=[[NSString alloc ]initWithUTF8String:call_time];
                
                //                int  type=sqlite3_column_int(statement, 5);
                //                [objDict setObject:[NSNumber numberWithInt:type] forKey:@"type"];
                char  *type=(char *)sqlite3_column_text(statement, 5);
                recordModel.type=[[NSString alloc ]initWithUTF8String:type];
                
                char  *myPhoneNum=(char *)sqlite3_column_text(statement, 6);
                //                [objDict setObject:[[NSString alloc ]initWithUTF8String:myPhoneNum] forKey:@"myPhoneNum"];
                
                recordModel.myPhoneNum=[[NSString alloc ]initWithUTF8String:myPhoneNum];
                
                char  *endTime=(char *)sqlite3_column_text(statement, 7);
                //                [objDict setObject:[[NSString alloc ]initWithUTF8String:endTime] forKey:@"endTime"];
                recordModel.endTime=[[NSString alloc ]initWithUTF8String:endTime];
                //                int  isPlatUpload=sqlite3_column_int(statement,8);
                //                [objDict setObject:[NSNumber numberWithInt:isPlatUpload] forKey:@"isPlatUpload"];
                char  *isPlatUpload=(char *)sqlite3_column_text(statement, 8);
                recordModel.isPlatUpload=[[NSString alloc ]initWithUTF8String:isPlatUpload];
                
                //                int  isItmsUpload=sqlite3_column_int(statement,9);
                //                [objDict setObject:[NSNumber numberWithInt:isItmsUpload] forKey:@"isItmsUpload"];
                char  *isItmsUpload=(char *)sqlite3_column_text(statement, 9);
                recordModel.isItmsUpload=[[NSString alloc ]initWithUTF8String:isItmsUpload];
                
                char  *currentLocation=(char *)sqlite3_column_text(statement, 10);
                //                [objDict setObject:[[NSString alloc ]initWithUTF8String:currentLocation] forKey:@"currentLocation"];
                recordModel.currentLocation=[[NSString alloc ]initWithUTF8String:currentLocation];
                
                
                [resultList addObject:recordModel];
            }
        }
        sqlite3_finalize(statement);
        //        [self closeDB];
    }
    return resultList;
}

#pragma mark 插入通话记录的方法
- (BOOL) insertRecentContactsRecord:(CallRecordModel *) recordModel{
    //                code=[self openDB];
    if (code!=SQLITE_OK) {//数据库打开失败
        sqlite3_close(db);
        NSLog(@"数据库打开失败",nil);
        return NO;
    }else{
        NSString *SQL=@"insert into t_phone_record(id,name,phoneNum,location,call_time,type,myPhoneNum,endTime,isPlatUpload,isItmsUpload,currentLocation) values(NULL,?,?,?,?,?,?,?,?,?,?)";
        sqlite3_stmt *statement;
        int code1= sqlite3_prepare_v2(db, [SQL UTF8String], -1, &statement, NULL);
        if (code1==SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [recordModel.name UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 2, [recordModel.phoneNum UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 3, [recordModel.address UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 4, [recordModel.call_time UTF8String], -1, NULL);
            //            sqlite3_bind_int(statement, 5, [(NSNumber *)[recordDict objectForKey:@"type"] intValue]);
            //sqlite3_bind_text(statement, 5, [recordModel.type UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 6, [recordModel.myPhoneNum UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 7, [recordModel.endTime UTF8String], -1, NULL);
            //            sqlite3_bind_int(statement, 8, [(NSNumber *)[recordDict objectForKey:@"isPlatUpload"] intValue]);
            sqlite3_bind_text(statement, 8, [recordModel.isPlatUpload UTF8String], -1, NULL);
            //            sqlite3_bind_int(statement, 9, [(NSNumber *)[recordDict objectForKey:@"isItmsUpload"] intValue]);
            sqlite3_bind_text(statement, 9, [recordModel.isItmsUpload UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 10, [recordModel.currentLocation UTF8String], -1, NULL);
            
            if (sqlite3_step(statement)!=SQLITE_DONE)
            {
                NSLog(@"通话记录插入失败");
                return NO;
            }
            //删除超过60条的记录
            [self deleteMoreThan60RecentContactRecordWithLoginMobNum:recordModel.myPhoneNum];
        }
        sqlite3_finalize(statement);
    }
    return YES;
}

#pragma mark 删除指定id通话记录的方法
- (BOOL) deleteRecentContactRecordById:(int) dbId{
    if (code!=SQLITE_OK) {//数据库打开失败
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
    }
    return YES;
}

#pragma mark 根据登陆手机号清空该用户通话记录表的方法
- (BOOL) deleteAllRecentContactRecordWithLoginMobNum:(NSString *) mobNum{
    //                code=[self openDB];
    if (code!=SQLITE_OK) {//数据库打开失败
        sqlite3_close(db);
        NSLog(@"数据库打开失败",nil);
        return NO;
    }else{
        NSString *SQL=@"delete from t_phone_record where myPhoneNum=?";
        sqlite3_stmt *statement;
        int code2= sqlite3_prepare_v2(db, [SQL UTF8String], -1, &statement, NULL);
        if (code2==SQLITE_OK) {
            sqlite3_bind_text(statement,1, [mobNum UTF8String],-1,NULL);
            if (sqlite3_step(statement)!=SQLITE_DONE)
            {
                NSLog(@"通话记录清空失败", nil);
                return NO;
            }
            
        }
        sqlite3_finalize(statement);
        //        [self closeDB];
    }
    return YES;
}

#pragma mark 关闭数据库的方法
- (void) closeDB{
    if (db!=nil ) {
        sqlite3_close(db);
    }
    if(locationDb!=nil){
        sqlite3_close(locationDb);
    }
}

#pragma mark Private Methods

#pragma mark 打开ephone数据库的方法
-(int) openDB{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *dbPath = [documents stringByAppendingPathComponent:@"ephone.sqlite"];
    return sqlite3_open([dbPath UTF8String], &db);
}

#pragma mark 打开归属地数据库的方法
-(int) openLocationDB{
    NSString *dbPath=[self applicationDocumentsDirectoryFile];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    BOOL dbExist=[fileManager fileExistsAtPath:dbPath];//判断db文件是否存在
    if(!dbExist){
        NSLog(@"数据库文件不存在",nil);
    }
    return sqlite3_open([dbPath UTF8String], &locationDb);
}

-(void)execSql:(NSString *)sql{
    char *err;
    int rc=sqlite3_exec(db, [sql UTF8String], nil, nil, &err);
    if(rc!=SQLITE_OK){
        //        sqlite3_close(db);
        NSLog(@"%@:SQL=%@",@"数据库操作失败",sql);
        NSLog(@"%@",[[NSString alloc]initWithUTF8String:err]);
    }
}

#pragma mark 删除超过60条的早期通话记录
- (BOOL) deleteMoreThan60RecentContactRecordWithLoginMobNum:(NSString *) mobNum{
    //                code=[self openDB];
    if (code!=SQLITE_OK) {//数据库打开失败
        sqlite3_close(db);
        NSLog(@"数据库打开失败",nil);
        return NO;
    }else{
        NSString *SQL=@"delete from t_phone_record where (select count(id) from t_phone_record)> 60 and id in (select id from t_phone_record order by call_time desc limit (select count(id) from t_phone_record) offset 60 ) and myPhoneNum=?";
        sqlite3_stmt *statement;
        int code2= sqlite3_prepare_v2(db, [SQL UTF8String], -1, &statement, NULL);
        if (code2==SQLITE_OK) {
            sqlite3_bind_text(statement,1, [mobNum UTF8String],-1,NULL);
            if (sqlite3_step(statement)!=SQLITE_DONE)
            {
                NSLog(@"超量60通话记录清空失败", nil);
                return NO;
            }
            
        }
        sqlite3_finalize(statement);
        //        [self closeDB];
    }
    return YES;
}

@end
