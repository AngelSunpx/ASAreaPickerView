//
//  ASAreaPickerView.h
//  CanZone
//
//  Created by AngelSunpx on 22/4/2016.
//  Copyright © 2016 纪琛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASAreaModel.h"

@protocol ASPickerDelegate <NSObject>

@optional

/**
 *  选择地区
 *
 *  @param model 地区模型
 */
-(void)changePickerData:(ASAreaModel *)model;

@end

@interface ASAreaPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIView                *showOnView;                //父view显示
@property (nonatomic, weak)   id<ASPickerDelegate>  delegate;                   //地址选择代理
@property (nonatomic, strong) UIColor               *btnColor;                  //按钮字体和边框颜色
@property (nonatomic, strong) UIColor               *areaTextColor;             //地区字体颜色
@property (nonatomic, strong) UIColor               *areaTitleColor;            //当前地区title颜色
@property (nonatomic, strong) UIColor               *toolBarBgColor;            //工具栏颜色
@property (nonatomic, strong) UIColor               *pickerViewBgColor;         //选择器颜色

/**
 *  单例化
 *
 *  @return 空间
 */
+(ASAreaPickerView *)shareInstance;

/**
 *  确认选择
 */
-(void)change;

/**
 *  取消选择
 */
-(void)dismiss;

/**
 *  展现
 *
 *  @param areaDelegate 地址代理
 */
-(void)show;

@end
