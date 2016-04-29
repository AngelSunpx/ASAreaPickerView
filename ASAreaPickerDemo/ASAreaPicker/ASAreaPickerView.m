//
//  ASAreaPickerView.m
//  CanZone
//
//  Created by AngelSunpx on 22/4/2016.
//  Copyright © 2016 纪琛. All rights reserved.
//

#import "ASAreaPickerView.h"
#import "ASAreaOperations.h"

#define kMainScreenFrameRect                            [[UIScreen mainScreen] bounds]
#define kMainScreenHeight                               kMainScreenFrameRect.size.height
#define kMainScreenWidth                                kMainScreenFrameRect.size.width
#define RGBA(r,g,b,a)                                   [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]

@interface ASAreaPickerView()

@property (nonatomic, strong) UIPickerView          *pickerView;
@property (nonatomic, strong) NSArray               *provinceArray;     //省份数组
@property (nonatomic, strong) NSArray               *cityArray;         //城市数组
@property (nonatomic, strong) NSArray               *domainArray;       //县区数组
@property (nonatomic, strong) UIView                *bgView;
@property (nonatomic, strong) UILabel               *titleTextLabel;
@property (nonatomic, strong) UIButton              *cancelButton;
@property (nonatomic, strong) UIButton              *confirmButton;
@property (nonatomic, strong) UIToolbar             *toolBar;

@end


@implementation ASAreaPickerView

+(ASAreaPickerView *)shareInstance
{
    static ASAreaPickerView *globalAreaPicker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (globalAreaPicker == nil)
        {
            globalAreaPicker = [[ASAreaPickerView alloc] initWithFrame:CGRectMake(0,0, kMainScreenWidth, kMainScreenHeight)];
        }
    });
    return globalAreaPicker;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        //初始化省、市、区数据
        _provinceArray = [ASAreaOperations queryAllParentData];
        if (_provinceArray.count > 0) {
            ASAreaModel *areaModel = _provinceArray[0];
            _cityArray = [ASAreaOperations queryAllCityData:areaModel.areaId];
        }
        if (_cityArray.count > 0) {
            ASAreaModel *areaModel = _cityArray[0];
            _domainArray = [ASAreaOperations queryAllCityData:areaModel.areaId];
        }
        
        //空间选择背景
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kMainScreenFrameRect.size.height - 216 - 44, kMainScreenWidth, 216 + 44)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
        
        //取消按钮
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(0, 0, 45, 25);
        _cancelButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-bold" size:12.0];;
        _cancelButton.layer.borderColor = RGBA(34, 131, 246, 1).CGColor;
        _cancelButton.layer.borderWidth = 1;
        _cancelButton.layer.cornerRadius = 5;
        _cancelButton.clipsToBounds  = YES;
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:RGBA(34, 131, 246, 1) forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:_cancelButton];
        
        //确定按钮
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.frame = CGRectMake(0, 0, 45, 25);
        _confirmButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-bold" size:12.0];
        _confirmButton.layer.borderColor = RGBA(34, 131, 246, 1).CGColor;
        _confirmButton.layer.borderWidth = 1;
        _confirmButton.layer.cornerRadius = 5;
        _confirmButton.clipsToBounds  = YES;
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:RGBA(34, 131, 246, 1) forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *confirmItem = [[UIBarButtonItem alloc] initWithCustomView:_confirmButton];
        
        //所选地区实时显示
        _titleTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth-140, 30)];
        _titleTextLabel.textColor = [UIColor lightGrayColor];
        _titleTextLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        _titleTextLabel.textAlignment = NSTextAlignmentCenter;
        _titleTextLabel.numberOfLines = 2;
        UIBarButtonItem *textItem = [[UIBarButtonItem alloc] initWithCustomView:_titleTextLabel];
        
        //工具栏
        _toolBar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, kMainScreenWidth, 44)];
        [_toolBar setBarStyle:UIBarStyleDefault];
        [_toolBar setBackgroundColor:[UIColor whiteColor]];
        [_toolBar setItems:[NSArray arrayWithObjects:cancelItem,textItem,confirmItem, nil]];
        
        //选择器
        _pickerView = [[UIPickerView alloc] initWithFrame: CGRectMake(0,44, kMainScreenWidth, 216)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        [_bgView addSubview:_toolBar];
        [_bgView addSubview:_pickerView];
        
        [self setHidden:YES];
    }
    return self;
}

#pragma mark - 确认按钮
-(void)change
{
    if (_delegate && [_delegate respondsToSelector:@selector(changePickerData:)]) {
        [_delegate changePickerData:[self currentSelectedAreaModel]];
    }
    [self dismiss];
}

#pragma mark - 获取当前所选地区模型
-(ASAreaModel *)currentSelectedAreaModel
{
    NSInteger provinceIndex = [_pickerView selectedRowInComponent:0];
    NSInteger cityIndex = [_pickerView selectedRowInComponent:1];
    NSInteger domainIndex = [_pickerView selectedRowInComponent:2];
    
    ASAreaModel *provinceModel = [_provinceArray objectAtIndex:provinceIndex];
    ASAreaModel *cityModel = [_cityArray objectAtIndex:cityIndex];
    ASAreaModel *domainModel = [_domainArray objectAtIndex:domainIndex];
    
    ASAreaModel *returnModel = [[ASAreaModel alloc] init];
    if (domainModel) {
        returnModel.areaId = domainModel.areaId;
        returnModel.parentId = cityModel.areaId;
        returnModel.grandParentId = provinceModel.areaId;
        returnModel.areaName = domainModel.areaName;
        returnModel.wholeAreaName = [NSString stringWithFormat:@"%@-%@-%@",provinceModel.areaName,cityModel.areaName,domainModel.areaName];
    }else{
        if (cityModel) {
            returnModel.areaId = cityModel.areaId;
            returnModel.parentId = provinceModel.areaId;
            returnModel.grandParentId = provinceModel.parentId;
            returnModel.areaName = cityModel.areaName;
            returnModel.wholeAreaName = [NSString stringWithFormat:@"%@-%@",provinceModel.areaName,cityModel.areaName];
        }else{
            returnModel.areaId = provinceModel.areaId;
            returnModel.parentId = provinceModel.parentId;
            returnModel.grandParentId = @"-1";
            returnModel.areaName = provinceModel.areaName;
            returnModel.wholeAreaName = [NSString stringWithFormat:@"全国-%@",provinceModel.areaName];
        }
    }
    return returnModel;
}

#pragma mark - 取消按钮
-(void)dismiss
{
    [UIView animateWithDuration:0.35 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        _bgView.frame = CGRectMake(0, kMainScreenHeight, _bgView.frame.size.width, _bgView.frame.size.height);
    } completion:^(BOOL finished) {
        [self setDelegate:nil];
        [self setHidden:YES];
        [self removeFromSuperview];
    }];
}

#pragma mark - 地区显示
-(void)show
{
    [self setHidden:NO];
    [_showOnView addSubview:self];
    
    //初始化弹出界面
    _titleTextLabel.text = [self currentSelectedAreaModel].wholeAreaName;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    self.bgView.frame = CGRectMake(0, kMainScreenFrameRect.size.height-20, kMainScreenWidth, 20);
    //黑色阴影
    self.bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.bgView.layer.shadowOffset = CGSizeMake(-3.0, -3.0);
    self.bgView.layer.shadowOpacity = 1;
    
    [UIView animateWithDuration:0.35 animations:^{
        //移动弹出视图
        self.bgView.frame = CGRectMake(0, kMainScreenFrameRect.size.height - 216 - 44, kMainScreenWidth, 216 + 44);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    }];
}

#pragma mark - DataSource & delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {//省份个数
        return [_provinceArray count];
    } else if(component == 1) {//市的个数
        return [_cityArray count];
    }else{
        return [_domainArray count];
    }
}

//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    if (component == 0) {//选择省份名
//        ASAreaModel *proAreaModel = _provinceArray[row];
//        return proAreaModel.areaName;
//    } else if(component == 1){//选择市名
//        ASAreaModel *cityAreaModel = _cityArray[row];
//        return cityAreaModel.areaName;
//    } else{
//        ASAreaModel *domainAreaModel = _domainArray[row];
//        return domainAreaModel.areaName;
//    }
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        if (_provinceArray.count > row)
        {
            ASAreaModel *proAreaModel = [_provinceArray objectAtIndex:row];
            //更新城市数据
            _cityArray = [ASAreaOperations queryAllCityData:proAreaModel.areaId];
            [self.pickerView reloadComponent:1];
            
            NSInteger selectedCityIndex = [self.pickerView selectedRowInComponent:1];
            if (_cityArray.count > selectedCityIndex)
            {
                ASAreaModel *cityAreaModel = [_cityArray objectAtIndex:selectedCityIndex];
                _domainArray = [ASAreaOperations queryAllCityData:cityAreaModel.areaId];
                [self.pickerView reloadComponent:2];
            }else{
                _domainArray = [ASAreaOperations queryAllCityData:nil];
                [self.pickerView reloadComponent:2];
            }
        }
    }
    else if(component==1)
    {
        if (_cityArray.count > row)
        {
            ASAreaModel *cityAreaModel = [_cityArray objectAtIndex:row];
            _domainArray = [ASAreaOperations queryAllCityData:cityAreaModel.areaId];
            [self.pickerView reloadComponent:2];
        }
    }
    _titleTextLabel.text = [self currentSelectedAreaModel].wholeAreaName;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //地区显示label
    UILabel *areaTextLabel = [[UILabel alloc] init];
    [areaTextLabel setFont:[UIFont fontWithName:@"Helvetica" size:13]];
    _areaTextColor?[areaTextLabel setTextColor:_areaTextColor]:[areaTextLabel setTextColor:RGBA(50, 50, 50, 1)];
    [areaTextLabel setTextAlignment:NSTextAlignmentCenter];
    [areaTextLabel setNumberOfLines:2];
    if (component == 0) {
        ASAreaModel *areaModel = [_provinceArray objectAtIndex:row];
        areaTextLabel.text = areaModel.areaName;
    }else if (component == 1){
        ASAreaModel *areaModel = [_cityArray objectAtIndex:row];
        areaTextLabel.text = areaModel.areaName;
    }else{
        ASAreaModel *areaModel = [_domainArray objectAtIndex:row];
        areaTextLabel.text = areaModel.areaName;
    }
    return areaTextLabel;
}

#pragma mark - 触摸地址栏外的其他区域隐藏
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self];
    if (!CGRectContainsPoint([self.bgView frame], pt))
    {
        [self dismiss];
    }
}

#pragma mark - 自定义颜色
-(void)setBtnColor:(UIColor *)btnColor
{
    [_confirmButton setTitleColor:btnColor forState:UIControlStateNormal];
    [_confirmButton.layer setBorderColor:btnColor.CGColor];
    [_cancelButton setTitleColor:btnColor forState:UIControlStateNormal];
    [_cancelButton.layer setBorderColor:btnColor.CGColor];
}

-(void)setAreaTitleColor:(UIColor *)areaTitleColor
{
    [_titleTextLabel setTextColor:areaTitleColor];
}

-(void)setToolBarBgColor:(UIColor *)toolBarBgColor
{
    [_toolBar setBackgroundColor:toolBarBgColor];
}

-(void)setPickerViewBgColor:(UIColor *)pickerViewBgColor
{
    [_pickerView setBackgroundColor:pickerViewBgColor];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
