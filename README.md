# LLXButtonLoading
![image](https://github.com/lilinxuan/LLXButtonLoading/blob/master/loading.gif)

使用方法


    //使用分类方法创建 button 
    UIButton  *btn = [UIButton createBtnWithFrame:CGRectMake(150, 100, 80, 40) actionBlock:^(UIButton * _Nullable button) {
        //此处为处理button的点击事件
        //点击后处理的方法-停止加载圆圈
        [button stopLoading:@"已收藏" textColor:[UIColor grayColor] backgroundColor:RGBA(222, 222, 222, 1)];
    }];
    btn.lineWidths = 3;//设置圆圈宽度
    btn.topHeight = 5;//距离上下的边距
    
    旋转的圆圈 默认是由 button的背景颜色和字体颜色这两种颜色来渐变的。
    可以通过以下两个属性来改变。
    btn.startColorOne = [UIColor redColor];
    btn.startColorTwo = [UIColor orangeColor];

如果对您有帮助请点一个star吧，O(∩_∩)O谢谢~
如您发现了bug请联系我~QQ或者微信 942944822
