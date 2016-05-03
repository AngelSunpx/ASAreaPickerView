# ASAreaPickerView
### A area pickerview demo with about 46000 data that can be customed.

# Start
### It starts with ViewController's function testClick,-(void)testClick{[ASAreaPickerView shareInstance].showOnView = self.view;[ASAreaPickerView shareInstance].delegate = self;[ASAreaPickerView shareInstance].btnColor = [UIColor redColor];[ASAreaPickerView shareInstance].areaTitleColor = [UIColor orangeColor];[ASAreaPickerView shareInstance].areaTextColor = [UIColor blueColor];[ASAreaPickerView shareInstance].toolBarBgColor = [UIColor yellowColor];[ASAreaPickerView shareInstance].pickerViewBgColor = [UIColor redColor];[[ASAreaPickerView shareInstance] show];

# Features
### Customed easyly.
### Add new area data what you want.

# Deficiency
### Lack of some public property or perfect experience.
### Work with FMDB, so if consider upgrade, you can use cocoapods to manage FMDB.
### Due to the FMDB, it also must link libsqlite3.tbd.
