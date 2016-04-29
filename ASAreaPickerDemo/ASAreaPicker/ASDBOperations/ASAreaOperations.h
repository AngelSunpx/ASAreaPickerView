//
//  ASAreaOperations.h
//  CanZone
//
//  Created by AngelSunpx on 22/4/2016.
//  Copyright © 2016 sunpx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASAreaModel.h"

@interface ASAreaOperations : NSObject


+(BOOL)addAreaInfoWithAreaId:(NSString *)areaId areaName:(NSString *)areaName parentId:(NSString *)parentId;

/**
 *  插入/更新数据
 *
 *  @param model 地区model
 *
 *  @return bool
 */
+ (BOOL)insertAreaData:(ASAreaModel *)model;

/**
 *  查询所有省
 *
 *  @return 省
 */
+ (NSMutableArray *)queryAllParentData;

/**
 *  查询某个省下的所有市和区
 *
 *  @param areaId 父级id
 *
 *  @return 市和区
 */
+(NSMutableArray *)queryAllCityData:(NSString *)parentId;

/**
 *  查询市所属省
 *
 *  @param areaId areaId
 *
 *  @return 区模型
 */
+(ASAreaModel *)queryParentByCity:(NSString *)areaId;

/**
 *  根据proCode查询省市
 *
 *  @param areaId areaId
 *
 *  @return 区模型
 */
+(ASAreaModel *)queryParentOrCity:(NSString *)areaId;

/**
 *  清空数据
 *
 *  @return bool
 */
+(BOOL)deleteAllAreaData;

/**
 *  查询所选节点全名
 *
 *  @param areaId areaId
 *
 *  @return 全名
 */
+(NSString *)queryWholeAreaName:(NSString *)areaId;

@end
