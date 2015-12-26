//
//  ViewController.m
//  1226-OrderSystem
//
//  Created by kouhanjin on 15/12/26.
//  Copyright © 2015年 khj. All rights reserved.
//

#import "ViewController.h"

typedef enum : NSUInteger {
    KJFoodTypeFriut = 0,
    KJFoodTypeMainFood,
    KJFoodTypeDrink
} KJFoodType;

@interface ViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong) NSArray *foods;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
/**
 *  水果
 */
@property (weak, nonatomic) IBOutlet UILabel *friutLabel;
/**
 *  主食
 */
@property (weak, nonatomic) IBOutlet UILabel *mainFoodLabel;
/**
 *  饮料
 */
@property (weak, nonatomic) IBOutlet UILabel *drinkLabel;
/**
 *  随机按钮事件
 */
- (IBAction)randomBtnClick;

@end

@implementation ViewController
/**
 *  数据的懒加载
 *
 */
- (NSArray *)foods
{
    if (_foods == nil) {
        // 从plist中加载数据
        NSString *path = [[NSBundle mainBundle] pathForResource:@"foods" ofType:@"plist"];
        _foods = [NSArray arrayWithContentsOfFile:path];
    }
    
    return _foods;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 默认选中每列的第一行
    for (int i = 0; i < self.foods.count; i++) {
        [self pickerView:self.pickerView didSelectRow:0 inComponent:i];
    }
    
}

#pragma mark - 数据源方法
/**
 *  返回有好多列
 *
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

/**
 *  返回每列有好多行
 *
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
     // 取出有几列
    NSArray *rowArray = self.foods[component];
    // 返回每列有多少行
    return rowArray.count;
}

#pragma mark - 代理方法
/**
 *  第component列的第row行显示什么文字
 */
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // 取出有几列
    NSArray *rowArray = self.foods[component];
    // 返回每列的每行的文字
    return rowArray[row];
}
/**
 *  选中了第component列的第row行
 */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"component:%ld,row:%ld",component,row);
    // 取出第几列的第几行的值
//    NSArray *rowArr = self.foods[component];
//    NSString *rowStr = rowArr[row];
    NSString *rowStr = self.foods[component][row];
    // 赋值
    if (component == KJFoodTypeFriut) {// 水果
        self.friutLabel.text = rowStr;
    }else if (component == KJFoodTypeMainFood)
    {// 主食
        self.mainFoodLabel.text = rowStr;
    }else if (component == KJFoodTypeDrink)
    {// 饮料
        self.drinkLabel.text = rowStr;
    }
}

#pragma mark - 随机按钮事件
- (IBAction)randomBtnClick {
    
    for (NSInteger i = 0; i < self.foods.count; i++) {
        NSArray *component = self.foods[i];
        // 每列行的随机数
        NSInteger randowRow = arc4random_uniform((int)component.count);
        // 之前的行号
        NSInteger oldRow = [self.pickerView selectedRowInComponent:i];
        // 解决随机的时候可能出现两次随机数一样的情况，则判断产生的随机数与选中的随机数是否一样  如果不一样则设置，如果一样,继续生成随机数
        while (oldRow == randowRow) {
            randowRow = arc4random_uniform((int)component.count);
        }
        // 让pickerView主动选中第compoent列的第row行
        [self.pickerView  selectRow:randowRow inComponent:i animated:YES];
        // 修改label的文字
        [self pickerView:self.pickerView didSelectRow:randowRow inComponent:i];
    }
    
}

@end
