//
//  ViewController.m
//  LLXButtonLoading
//
//  Created by 李林轩 on 2018/3/1.
//  Copyright © 2018年 李林轩. All rights reserved.
//
#define RGBA(r,g,b,a)     [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#import "ViewController.h"
#import "UIButton+LLXLoading.h"
@interface ViewController ()
{
    UIButton *btn;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    btn = [UIButton createBtnWithFrame:CGRectMake(150, 100, 80, 40) actionBlock:^(UIButton *button) {

        if ([button.currentTitle isEqualToString:@"收藏"]) {
            //请求收藏-延时1秒模拟请求数据~
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //请求成功
                [button stopLoading:@"已收藏" textColor:[UIColor grayColor] backgroundColor:RGBA(222, 222, 222, 1)];
            });
        }else{
            
            //取消收藏
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //请求成功
                [button stopLoading:@"收藏" textColor:[UIColor whiteColor] backgroundColor:[UIColor redColor]];
            });
            
        }
        
        
    }];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"收藏" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.lineWidths = 3;//设置圆圈宽度
    btn.topHeight = 5;//距离上下的边距
    [self.view addSubview:btn];

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
