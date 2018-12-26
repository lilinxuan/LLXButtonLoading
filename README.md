# LLXButtonLoading
![image](https://github.com/lilinxuan/LLXButtonLoading/blob/master/loading.gif)

使用方法

    //一句代码调用
    [btn BindingBtnactionBlock:^(UIButton * _Nullable button) {
        [self didSelectBtn:button];
    }];
    //属性设置
    btn.lineWidths = 3;//设置圆圈宽度
    btn.topHeight = 5;//距离上下的边距
    
    旋转的圆圈 默认是由 button的背景颜色和字体颜色这两种颜色来渐变的。
    可以通过以下两个属性来改变。(一般使用无需设置)
    btn.startColorOne = [UIColor redColor];
    btn.startColorTwo = [UIColor orangeColor];

如果对您有帮助请点一个star吧，O(∩_∩)O谢谢~
如您发现了bug请联系我~QQ或者微信 942944822
