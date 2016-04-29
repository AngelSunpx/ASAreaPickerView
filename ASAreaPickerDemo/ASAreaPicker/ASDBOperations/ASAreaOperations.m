//
//  ASAreaOperations.m
//  CanZone
//
//  Created by AngelSunpx on 22/4/2016.
//  Copyright © 2016 sunpx. All rights reserved.
//

#import "ASAreaOperations.h"
#import "ASDBManagerCenter.h"

#define AS_DB_AREA      @"AS_DB_AREA"

@implementation ASAreaOperations

+(BOOL)addAreaInfoWithAreaId:(NSString *)areaId areaName:(NSString *)areaName parentId:(NSString *)parentId
{
    if (![self queryAreaIsAlreadyExist:areaId parentId:parentId])
    {
        FMDatabaseQueue *dataQueue = [ASDBManagerCenter getLocalDBQueue];
        __block BOOL result = NO;
        
        [dataQueue inDatabase:^(FMDatabase *db)
         {
             NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (areaId,areaName,parentId) VALUES('%@','%@','%@')",AS_DB_AREA,areaId,areaName,parentId];
             result = [db executeUpdate:sql];
         }];
        
        return result;
    }
    else
    {
        return [self updateAreaInfoWithAreaId:areaId areaName:areaName parentId:parentId];
    }
}

+(NSString*)queryAreaIsAlreadyExist:(NSString *)areaId parentId:(NSString *)parentId
{
    __block  NSString *tmpAreaId;
    
    FMDatabaseQueue *dataQueue = [ASDBManagerCenter getLocalDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *findSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE areaId = '%@' AND parentId = '%@'",AS_DB_AREA,areaId,parentId];
         FMResultSet *rs = [db executeQuery:findSql];
         while([rs next])
         {
             tmpAreaId = [rs stringForColumn:@"areaId"];
         }
         if (rs) {
             [rs close];
         }
     }];
    
    return tmpAreaId;
}

+(BOOL)updateAreaInfoWithAreaId:(NSString *)areaId areaName:(NSString *)areaName parentId:(NSString *)parentId
{
    FMDatabaseQueue *dataQueue = [ASDBManagerCenter getLocalDBQueue];
    __block BOOL result = NO;
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET areaName = '%@' WHERE areaId = '%@' AND parentId = '%@'",AS_DB_AREA,areaName,areaId,parentId];
         result = [db executeUpdate:sql];
     }];
    
    return result;
}

//插入更新数据
+ (BOOL)insertAreaData:(ASAreaModel *)model
{
    if (![self queryAreaIsAlreadyExist:model.areaId]) {
        __block BOOL result = NO;
        FMDatabaseQueue *dataQueue = [ASDBManagerCenter getLocalDBQueue];
        [dataQueue inDatabase:^(FMDatabase *db) {
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (areaId,areaName,parentId) VALUES('%@','%@','%@')",AS_DB_AREA,model.areaId,model.areaName,model.parentId];
            result = [db executeUpdate:sql];
        }];
        
        return result;
    }
    else
    {
        return NO;
    }
}

//查询省
+ (NSMutableArray *)queryAllParentData
{
    __block NSMutableArray *resultArr = [[NSMutableArray alloc] initWithCapacity:0];
    FMDatabaseQueue *dataQueue = [ASDBManagerCenter getLocalDBQueue];
    [dataQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE parentId = '0'",AS_DB_AREA];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            ASAreaModel *model = [[ASAreaModel alloc] init];
            model.areaId = [rs stringForColumn:@"areaId"];
            model.areaName = [rs stringForColumn:@"areaName"];
            model.parentId = [rs stringForColumn:@"parentId"];
            model.grandParentId = @"-1";
            [resultArr addObject:model];
        }
    }];
    
    return resultArr;
}
//根据省id查询对应省的所有城市
+(NSMutableArray *)queryAllCityData:(NSString *)parentId
{
    __block NSMutableArray *resultArr = [[NSMutableArray alloc] initWithCapacity:0];
    FMDatabaseQueue *dataQueue = [ASDBManagerCenter getLocalDBQueue];
    [dataQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE parentId = '%@'",AS_DB_AREA,parentId];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            ASAreaModel *model = [[ASAreaModel alloc] init];
            model.areaId = [rs stringForColumn:@"areaId"];
            model.areaName = [rs stringForColumn:@"areaName"];
            model.parentId = [rs stringForColumn:@"parentId"];
            [resultArr addObject:model];
        }
    }];
    
    return resultArr;
}

//查询市所属省
+(ASAreaModel *)queryParentByCity:(NSString *)areaId
{
    __block ASAreaModel *resultModel = [[ASAreaModel alloc] init];
    FMDatabaseQueue *dataQueue = [ASDBManagerCenter getLocalDBQueue];
    [dataQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE areaId = '%@'",AS_DB_AREA,areaId];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            resultModel.areaId = [rs stringForColumn:@"areaId"];
            resultModel.areaName = [rs stringForColumn:@"areaName"];
            resultModel.parentId = [rs stringForColumn:@"parentId"];
        }
    }];
    
    return resultModel;
}

//根据proCode查询省市
+(ASAreaModel *)queryParentOrCity:(NSString *)parentId
{
    __block ASAreaModel *resultModel = [[ASAreaModel alloc] init];
    FMDatabaseQueue *dataQueue = [ASDBManagerCenter getLocalDBQueue];
    [dataQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE parentId = '%@'",AS_DB_AREA,parentId];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            resultModel.areaId = [rs stringForColumn:@"areaId"];
            resultModel.areaName = [rs stringForColumn:@"areaName"];
            resultModel.parentId = [rs stringForColumn:@"parentId"];
        }
    }];
    
    return resultModel;
}

//清空表数据
+(BOOL)deleteAllAreaData
{
    FMDatabaseQueue *dataQueue = [ASDBManagerCenter getLocalDBQueue];
    __block BOOL result = NO;
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@",AS_DB_AREA];
         
         result = [db executeUpdate:sql];
         
         if(!result)
         {
//             DDLogError(@"deleteAppModelByAppId is Failed!!!");
         }
     }];
    
    return result;
}

+(BOOL)queryAreaIsAlreadyExist:(NSString *)areaId
{
    __block  BOOL isAlreadyExist = NO;
    
    FMDatabaseQueue *dataQueue = [ASDBManagerCenter getLocalDBQueue];
    
    [dataQueue inDatabase:^(FMDatabase *db)
     {
         NSString *findSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE areaId = '%@'",AS_DB_AREA,areaId];
         FMResultSet *rs = [db executeQuery:findSql];
         while([rs next])
         {
             isAlreadyExist = YES;
         }
         if (rs) {
             [rs close];
         }
     }];
    
    return isAlreadyExist;
}

+(NSString *)queryWholeAreaName:(NSString *)areaId
{
    __block NSString *wholeName = @"";
    FMDatabaseQueue *dataQueue = [ASDBManagerCenter getLocalDBQueue];
    [dataQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE areaId = '%@'",AS_DB_AREA,areaId];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next])
        {
            if ([rs stringForColumn:@"parentId"] && ![[rs stringForColumn:@"parentId"] isEqualToString:@""])
            {
                NSString *parentSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE areaId = '%@'",AS_DB_AREA,[rs stringForColumn:@"parentId"]];
                FMResultSet *parentRs = [db executeQuery:parentSql];
                while ([parentRs next])
                {
                    if ([parentRs stringForColumn:@"parentId"] && ![[parentRs stringForColumn:@"parentId"] isEqualToString:@""])
                    {
                        NSString *grandPaSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE areaId = '%@'",AS_DB_AREA,[parentRs stringForColumn:@"parentId"]];
                        FMResultSet *grandPaRs = [db executeQuery:grandPaSql];
                        while ([grandPaRs next])
                        {
                            if (![grandPaRs stringForColumn:@"parentId"] || [[grandPaRs stringForColumn:@"parentId"] isEqualToString:@""])
                            {
                                wholeName = [NSString stringWithFormat:@"%@-%@-%@",[grandPaRs stringForColumn:@"areaName"],[parentRs stringForColumn:@"areaName"],[rs stringForColumn:@"areaName"]];
                            }
                        }
                        if (grandPaRs) {
                            [grandPaRs close];
                        }
                    }else{
                        wholeName = [NSString stringWithFormat:@"%@-%@",[parentRs stringForColumn:@"areaName"],[rs stringForColumn:@"areaName"]];
                    }
                }
                if (parentRs) {
                    [parentRs close];
                }
            }else{
                wholeName = [rs stringForColumn:@"areaName"];
            }
        }
        if (rs) {
            [rs close];
        }
    }];
    return wholeName;
}

@end
