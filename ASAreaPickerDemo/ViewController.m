//
//  ViewController.m
//  ASAreaPickerDemo
//
//  Created by 孙攀翔 on 29/4/2016.
//  Copyright © 2016 AngelSunpx. All rights reserved.
//

#import "ViewController.h"
#import "ASAreaPickerView.h"

@interface ViewController ()<ASPickerDelegate>
{
    UILabel *areaLabel;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title  = @"测试";
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    UILabel *areaName = [[UILabel alloc] initWithFrame:CGRectMake(10, 85, 50, 30)];
    areaName.font = [UIFont systemFontOfSize:14];
    areaName.textColor = [UIColor grayColor];
    areaName.backgroundColor = [UIColor clearColor];
    areaName.text = @"地区：";
    [self.view addSubview:areaName];
    
    areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 80, [[UIScreen mainScreen] bounds].size.width-70, 40)];
    areaLabel.font = [UIFont systemFontOfSize:14];
    areaLabel.textColor = [UIColor grayColor];
    areaLabel.numberOfLines = 2;
    areaLabel.backgroundColor = [UIColor whiteColor];
    areaLabel.textAlignment = NSTextAlignmentCenter;
    areaLabel.text = @"请选择";
    areaLabel.userInteractionEnabled = YES;
    [self.view addSubview:areaLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(testClick)];
    [areaLabel addGestureRecognizer:tap];
}

-(void)testClick
{
    [ASAreaPickerView shareInstance].showOnView = self.view;
    [ASAreaPickerView shareInstance].delegate = self;
//    [ASAreaPickerView shareInstance].btnColor = [UIColor redColor];
//    [ASAreaPickerView shareInstance].areaTitleColor = [UIColor orangeColor];
//    [ASAreaPickerView shareInstance].areaTextColor = [UIColor blueColor];
//    [ASAreaPickerView shareInstance].toolBarBgColor = [UIColor yellowColor];
//    [ASAreaPickerView shareInstance].pickerViewBgColor = [UIColor redColor];
    [[ASAreaPickerView shareInstance] show];
    
    
}

-(void)changePickerData:(ASAreaModel *)model
{
    areaLabel.text = model.wholeAreaName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
