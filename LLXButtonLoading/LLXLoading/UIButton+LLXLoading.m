//
//  UIButton+LLXLoading.m
//  LLXButtonLoading
//
//  Created by 李林轩 on 2018/3/1.
//  Copyright © 2018年 李林轩. All rights reserved.
//
#define RGBA(r,g,b,a)     [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#import "UIButton+LLXLoading.h"
#import <objc/runtime.h>
@implementation UIButton (LLXLoading)
CALayer *_layer;
UIColor *_startColorOne;
UIColor *_startColorTwo;
NSInteger _lineWidths;
NSInteger _topHeight;
static NSString *keyOfMethod; //关联者的索引key-用于获取block

@dynamic startColorOne;
@dynamic startColorTwo;
@dynamic lineWidths;
@dynamic topHeight;

+ (UIButton *)createBtnWithFrame:(CGRect)frame actionBlock:(ActionBlock)actionBlock{
    
    UIButton *button = [[UIButton alloc]init];
    button.frame = frame;
    [button addTarget:button action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    //关联 block
    objc_setAssociatedObject (button , &keyOfMethod, actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    return button;
    
    
}
- (void)buttonClick:(UIButton *)button{
    NSLog(@"%ld",_layer.animationKeys.count);
    //判断动画-如果正在加载就不能点击
    if (_layer.animationKeys.count>0) {
        return;
    }
    //获取关联
    ActionBlock block1 = (ActionBlock)objc_getAssociatedObject(button, &keyOfMethod);
    if(block1){
        block1(button);
    }

    //旋转图片
    [button setTitle:@"" forState:UIControlStateNormal];
    [button setImage:nil forState:UIControlStateNormal];
    [self creatLayerWithStartLoadingButton:button];
}


/**
 *  加载完毕停止旋转
 *  title:停止后button的文字
 *  textColor :字体色 如果颜色不变就为nil
 *  backgroundColor :背景色 如果颜色不变就为nil
 **/

-(void)stopLoading:(NSString*)title textColor:(UIColor*)textColor backgroundColor:(UIColor*)backColor{
    
    if (textColor) {
        [self setTitleColor:textColor forState:UIControlStateNormal];
    }
    
    if (backColor) {
        self.backgroundColor = backColor;
    }
    
    [self setTitle:title forState:UIControlStateNormal];
    [_layer removeAllAnimations];//停止动画
    [_layer removeFromSuperlayer];//移除动画

    
}
//旋转图片
- (void)rotateView:(UIImageView *)view
{
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    rotationAnimation.duration = 0.8;
    rotationAnimation.repeatCount = HUGE_VALF;
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

-(void)setStartColorOne:(UIColor *)startColorOne{
    
    _startColorOne = startColorOne;
}
-(void)setStartColorTwo:(UIColor *)startColorTwo{
    
    _startColorTwo = startColorTwo;
}

-(void)setLineWidths:(NSInteger)lineWidths{
    _lineWidths = lineWidths;
}
-(void)setTopHeight:(NSInteger)topHeight{
    
    _topHeight = topHeight;
}


-(void)creatLayerWithStartLoadingButton:(UIButton*)btn{
    
    
    
    
    UIColor *backgroundColor = btn.backgroundColor;//获取背景色
    UIColor *textColor = btn.currentTitleColor;//获取字体色
    if (_startColorOne) {
        backgroundColor = _startColorOne;
    }
    if (_startColorTwo) {
        textColor = _startColorTwo;
    }
    NSInteger lineW =  5;//圆圈的宽度默认5
    if (_lineWidths>0) {
        lineW = _lineWidths;
    }
    NSInteger topWid = 5;
    if (_topHeight) {
        topWid = _topHeight;
    }
    
    CGRect rect = btn.frame;
    float wid = rect.size.height-topWid*2;
    float x = rect.size.width/2-wid/2;
    
    _layer = [CALayer layer];
    _layer.frame = CGRectMake(x, topWid, wid, wid);
    _layer.backgroundColor = backgroundColor.CGColor;
    
    [btn.layer addSublayer:_layer];
    //创建圆环
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(wid/2, wid/2) radius:(wid-lineW*2)/2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    //圆环遮罩
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = textColor.CGColor;
    shapeLayer.lineWidth = lineW;
    shapeLayer.strokeStart = 0;
    shapeLayer.strokeEnd = 1;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineDashPhase = 0.8;
    shapeLayer.path = bezierPath.CGPath;
    [_layer setMask:shapeLayer];
    
    
    //颜色渐变
    NSMutableArray *colors = [NSMutableArray arrayWithObjects:(id)backgroundColor.CGColor,(id)[RGBA(255, 255, 255, 0.5) CGColor], nil];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.shadowPath = bezierPath.CGPath;
    gradientLayer.frame = CGRectMake(0, 0, wid, wid/2);
    gradientLayer.startPoint = CGPointMake(1, 0);
    gradientLayer.endPoint = CGPointMake(0, 0);
    [gradientLayer setColors:[NSArray arrayWithArray:colors]];
    
    NSMutableArray *colors1 = [NSMutableArray arrayWithObjects:(id)[RGBA(255, 255, 255, 0.5) CGColor],(id)[textColor CGColor], nil];
    CAGradientLayer *gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.shadowPath = bezierPath.CGPath;
    gradientLayer1.frame = CGRectMake(0, wid/2, wid, wid/2);
    gradientLayer1.startPoint = CGPointMake(0, 1);
    gradientLayer1.endPoint = CGPointMake(1, 1);
    [gradientLayer1 setColors:[NSArray arrayWithArray:colors1]];
    [_layer addSublayer:gradientLayer]; //设置颜色渐变
    [_layer addSublayer:gradientLayer1];
    

    [self animation];
    
}

- (void)animation {
    //动画
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0];
    rotationAnimation.toValue = [NSNumber numberWithFloat:2.0*M_PI];
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.duration = 0.8;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_layer addAnimation:rotationAnimation forKey:@"rotationAnnimation"];
}





@end
