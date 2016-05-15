//
//  HandlerView.m
//  PaintBoardDemo
//
//  Created by TobyoTenma on 16/5/14.
//  Copyright © 2016年 TobyoTenma. All rights reserved.
//

#import "HandlerView.h"



@interface HandlerView() <UIGestureRecognizerDelegate>

@property (weak,nonatomic) UIImageView *imgView;

@end

@implementation HandlerView
#pragma mark - 重写 img 的 setter
-(void)setImg:(UIImage *)img{
    _img = img;
    
    self.imgView.image = img;
    
    self.imgView.frame = self.bounds;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        // 为这个 UIView 添加一个缩放手势
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
        // 创建一个 UIImageView
        UIImageView *imgView = [[UIImageView alloc]  init];
        
        imgView.userInteractionEnabled = YES;
        
        self.imgView = imgView;
        
        // 将 imgView 加入到视图中
        [self addSubview:imgView];
        
        // 设置代理
        pinch.delegate = self;
        
        // 将 pinch 加入到 imgView 中
        [self.imgView addGestureRecognizer:pinch];
        
        // 添加一个旋转手势
        UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotation:)];
        
        // 设置代理
        rotation.delegate = self;
        
        // 将 rotation 加入到 imgView 中
        [self.imgView addGestureRecognizer:rotation];
        
        // 添加移动手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        
        // 将 pan 加入到 imgView 中
        [self.imgView addGestureRecognizer:pan];
        
        //  添加双击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        
        // 设置双击
        tap.numberOfTapsRequired = 2;
        
        // 将tap 加入到 imgView 中
        [self.imgView addGestureRecognizer:tap];
        
    }
    return self;
}

#pragma mark - 缩放手势
-(void)pinch:(UIPinchGestureRecognizer *)pinch{
    // 缩放
    self.imgView.transform = CGAffineTransformScale(self.imgView.transform, pinch.scale, pinch.scale);
    // 还原
    pinch.scale = 1;
}

#pragma mark - 旋转手势
-(void)rotation:(UIRotationGestureRecognizer *)rotation{
    
    // 旋转
    self.imgView.transform = CGAffineTransformRotate(self.imgView.transform, rotation.rotation);
    // 还原
    rotation.rotation = 0;
}

#pragma mark - 移动手势
-(void)pan:(UIPanGestureRecognizer *)pan{
    CGPoint offset = [pan translationInView:self.imgView];
    // 移动
    self.imgView.transform = CGAffineTransformTranslate(self.imgView.transform, offset.x, offset.y);
    // 还原
    [pan setTranslation:CGPointZero inView:self.imgView];
}

#pragma mark - 双击手势
-(void)tap:(UITapGestureRecognizer *)tap{
    // 开启上下文
    UIGraphicsBeginImageContext(self.frame.size);
    
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self.layer renderInContext:ctx];
    
    // 获取图片
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文
    UIGraphicsEndImageContext();
    
    // 调用 block 回传img
    if (self.picBlock) {
        
        self.picBlock(newImg);
    }
    // 移出当前视图
    [self removeFromSuperview];
    
    
}

#pragma mark - 缩放与旋转的冲突
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end
