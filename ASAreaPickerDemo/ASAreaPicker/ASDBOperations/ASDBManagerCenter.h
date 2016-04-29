//
//  ASDBManagerCenter.h
//  CanZone
//
//  Created by AngelSunpx on 15/4/2016.
//  Copyright © 2016 sunpx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"

@interface ASDBManagerCenter : NSObject

/**
 *  获取数据库队列
 *
 *  @return 队列
 */
+ (FMDatabaseQueue *)getLocalDBQueue;

/**
 *  关闭数据库
 */
+ (void)closeLocalDB;

@end
