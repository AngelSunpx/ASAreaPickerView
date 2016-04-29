//
//  ASDBManagerCenter.m
//  CanZone
//
//  Created by AngelSunpx on 15/4/2016.
//  Copyright © 2016 sunpx. All rights reserved.
//

#import "ASDBManagerCenter.h"

//////////////////////////////////////////////////////////////////////////
static FMDatabaseQueue *localDbQueue;

@implementation ASDBManagerCenter

+(FMDatabaseQueue *)getLocalDBQueue
{
    if (localDbQueue)
    {
        return localDbQueue;
    }
    @synchronized(self)
    {
        
        NSString *realPath = [[NSBundle mainBundle] pathForResource:@"AreaData" ofType:@"sqlite"];
        localDbQueue = [FMDatabaseQueue databaseQueueWithPath:realPath];
    }
    return localDbQueue;
}

+ (void)closeLocalDB
{
    [localDbQueue close];
}

@end
