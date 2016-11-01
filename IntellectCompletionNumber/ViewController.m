//
//  ViewController.m
//  IntellectCompletionNumber
//
//  Created by superCode on 16/11/1.
//  Copyright © 2016年 superCode. All rights reserved.
//

//使用指导说明：
//根据自己需要，设置bigNum/smallNum
//bigNum:整数个数
//smallNum:小数点后的个数

//Use Introduce:
//fllow what you want,set the bigNum param and the smallNum param.
//bigNum:most integer num
//smallNum:num behind the small point

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate>
@property (nonatomic,assign) NSInteger bigNum;//整数个数
@property (nonatomic,assign) NSInteger smallNum;//小数个数
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }

    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    [self.view addSubview:textField];
    textField.delegate = self;
    textField.center = self.view.center;
    textField.backgroundColor = [UIColor lightGrayColor];
    
    _bigNum = 5;
    _smallNum = 2;

}

#pragma mark - textField 代理方法
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    
    if (textField.tag == 100) {
        return  YES;
    }
    
    
    NSString *currentStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSInteger totalLength = textField.text.length - range.length + string.length;
    
    //防止黏贴中文进入
    //只能输入数字
    //[\u4e00-\u9fa5]
    NSRange allZeroRange = [currentStr rangeOfString:@"[\u4e00-\u9fa5]+" options:NSRegularExpressionSearch];
    if (allZeroRange.location != NSNotFound){
        return NO;
    }else
    {
        
    }

    //防止可以输入两个不连续的小数点
    BOOL havePoint = [textField.text containsString:@"."];
    BOOL point = [string containsString:@"."];
    if (havePoint&&point) {
        return NO;
    }
    
    //不给输入两个连续的小数点
    BOOL haveTwoPoint = [currentStr containsString:@".."];
    if (haveTwoPoint) {
        return NO;
    }else
    {
        
        BOOL havePoint = [currentStr containsString:@"."];
        
        //-------------------------控制数字格式---------------------------
        //有小数点可以有加多两位
        if (havePoint == YES) {
            
            NSInteger pointPosition = [currentStr rangeOfString:@"."].location;
            return totalLength <= pointPosition + _smallNum + 1;
            
        }else//没有小数点，只有5位
        {
            return totalLength <= _bigNum;
        }
        //-------------------------控制数字格式---------------------------
        
        
    }

    
}




//情形分析：
//纯数字的/无小数点的/都是零的/无输入的
//有小数点，后面跟一位或者什么都不跟
#pragma mark - 自动补全0和移除0，数字后有两位小数
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    //如果全部是0的处理方式
    NSRange allZeroRange = [textField.text rangeOfString:@"[1-9]+" options:NSRegularExpressionSearch];
    if (allZeroRange.location != NSNotFound){
        
    }else
    {
        //没有输入的
        textField.text = @"0.00";
        return;
    }
    
    
    BOOL havePoint = [textField.text containsString:@"."];
    if (havePoint == YES) {
        
        //处理下开头是0的
        NSRange zeroRange = [textField.text rangeOfString:@"^[0]+" options:NSRegularExpressionSearch];
        if (zeroRange.location != NSNotFound){
            
            textField.text = [textField.text substringFromIndex:zeroRange.length];
            
        }else
        {
            
        }
        
        //处理下开头是.的
        NSRange pointBeginRange = [textField.text rangeOfString:@"^[.]{1}" options:NSRegularExpressionSearch];
        if (pointBeginRange.location != NSNotFound){
            
            textField.text = [NSString stringWithFormat:@"0%@",textField.text];
            
        }else
        {
            
        }
        
        //有小数点，后面跟一位或者什么都不跟
        NSRange range = [textField.text rangeOfString:@"[.]{1}[0-9]?" options:NSRegularExpressionSearch];
        if (range.location != NSNotFound) {
            
            
            NSRange oneNumRange = [textField.text rangeOfString:@"[.]{1}[0-9]{1}" options:NSRegularExpressionSearch];
            if (oneNumRange.location != NSNotFound) {
                
                NSRange twoNumRange = [textField.text rangeOfString:@"[.]{1}[0-9]{2}" options:NSRegularExpressionSearch];
                if (twoNumRange.location != NSNotFound)
                {
                    //三，小数点后面有两位
                }else
                {
                    //一，小数点后面只有一位
                    textField.text = [NSString stringWithFormat:@"%@0",textField.text];
                    
                }
                
                
                
            }else
            {
                //二，小数点后面没有位数
                textField.text = [NSString stringWithFormat:@"%@00",textField.text];
            }
            
            
        }else
        {
            
        }
        
        
        
    }else
    {
        //四，没有小数点的
        if (textField.text.length > 0) {
            
            //处理下开头是0的
            NSRange zeroRange = [textField.text rangeOfString:@"^[0]+" options:NSRegularExpressionSearch];
            if (zeroRange.location != NSNotFound){
                
                textField.text = [textField.text substringFromIndex:zeroRange.length];
                
            }else
            {
                
            }
            
            textField.text = [NSString stringWithFormat:@"%@.00",textField.text];
            
        }else
        {
            
        }
        
    }
    

    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self setEditing:NO animated:NO];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
