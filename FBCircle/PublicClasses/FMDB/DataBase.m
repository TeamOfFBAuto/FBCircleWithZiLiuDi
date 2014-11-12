//
//  DataBase.m
//  FbLife
//
//  Created by soulnear on 13-6-8.
//  Copyright (c) 2013年 szk. All rights reserved.
//

#import "DataBase.h"
#define KBBPath @"FBCircle.sqlite"
static sqlite3 * dbPointer = nil;

@implementation DataBase
+(sqlite3 *)openDB
{
    if (dbPointer) {
        return dbPointer;
    }
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"docpath = %@",docPath);
    NSString * sqlFilePath = [docPath stringByAppendingPathComponent:KBBPath];
    NSString * originFilePath = [[NSBundle mainBundle] pathForResource:@"FBCircle.sqlite" ofType:nil];
    NSLog(@"orr=%@==sqlfilepath==%@",originFilePath,sqlFilePath);
    
    NSFileManager * fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:sqlFilePath]==NO) {
        NSError * error = nil;
        if ([fm copyItemAtPath:originFilePath toPath:sqlFilePath error:&error]==NO) {
            NSLog(@"创建数据库的时候出现了错误:%@",[error localizedDescription]);
        }
    }
    sqlite3_open([sqlFilePath UTF8String], &dbPointer);
    return dbPointer;
}
+(void)closeDB
{
    if (dbPointer) {
        sqlite3_close(dbPointer);
        dbPointer = nil;
    }
}

@end
