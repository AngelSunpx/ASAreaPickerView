//
//  ASAreaModel.h
//  CanZone
//
//  Created by AngelSunpx on 22/4/2016.
//  Copyright © 2016 sunpx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASAreaModel : NSObject

//区域id
@property (nonatomic, strong) NSString *areaId;
//区域名
@property (nonatomic, strong) NSString *areaName;
//父节点id
@property (nonatomic, strong) NSString *parentId;
//爷节点id
@property (nonatomic, strong) NSString *grandParentId;
//当前节点全名
@property (nonatomic, strong) NSString  *wholeAreaName;

@end
