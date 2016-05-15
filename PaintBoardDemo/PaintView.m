//
//  PaintView.m
//  PaintBoardDemo
//
//  Created by TobyoTenma on 16/5/14.
//  Copyright © 2016年 TobyoTenma. All rights reserved.
//

#import "PaintView.h"
#import "PaintBezierPath.h"

@interface PaintView ()

@property (strong,nonatomic) NSMutableArray *pathsArray;

@property (strong,nonatomic) PaintBezierPath *path;

@end



@implementation PaintView

#pragma mark - 懒加载
-(NSMutableArray *)pathsArray{
    if (!_pathsArray) {
        _pathsArray = [NSMutableArray array];
    }
    return _pathsArray;
}

#pragma mark - 重写 image 的 setter
-(void)setImage:(UIImage *)image{
    _image = image;
    [self.pathsArray addObject:image];
    
    // 重绘
    [self setNeedsDisplay];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // 获取当前点
    UITouch *touch = touches.anyObject;
    CGPoint curP = [touch locationInView:self];
    
    // 创刊路径
    PaintBezierPath *path = [PaintBezierPath bezierPath];
    
    // 将 path 加入到路径数组中
    [self.pathsArray addObject:path];
    
    // 存储线条颜色
    if (self.paintLineColor) {
        
        path.paintLineColor = self.paintLineColor;
    }else{
        
        // 设置默认颜色
        path.paintLineColor = [UIColor blackColor];
    }
    
    // 存储线宽
    path.paintLineWidth = self.paintLineWidth;
    
    self.path = path;
    
    // 移动到指定点
    [path moveToPoint:curP];
    
    // 重绘
    [self setNeedsDisplay];
    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // 获取当前点
    UITouch *touch = touches.anyObject;
    CGPoint curP = [touch locationInView:self];
    
    [self.path addLineToPoint:curP];
    
    // 重绘
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

-(void)drawRect:(CGRect)rect{
    
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 从数组中取出 path
    for (int i = 0; i < self.pathsArray.count; i++) {
        
        if ([self.pathsArray[i] isKindOfClass:[UIImage class]]) {
            [self.pathsArray[i] drawInRect:self.bounds];
        }else{
            
            PaintBezierPath *path = self.pathsArray[i];
            
            // 设置线条颜色
            [path.paintLineColor set];
            
            // 设置线条宽度
            if (path.paintLineWidth != 0) {
                
                CGContextSetLineWidth(ctx, path.paintLineWidth);
            }
            
            // 设置圆角
            CGContextSetLineCap(ctx, kCGLineCapRound);
            CGContextSetLineJoin(ctx, kCGLineJoinRound);
            
            
            CGContextAddPath(ctx, path.CGPath);
            
            CGContextStrokePath(ctx);
        }
    }
}

#pragma mark - 清屏
-(void)clearPaintBoard{
    // 移出数组中所有元素
    [self.pathsArray removeAllObjects];
    
    // 重绘
    [self setNeedsDisplay];
}

#pragma mark - 撤消
-(void)undoLastStep{
    // 移除数组中最后一个元素
    [self.pathsArray removeLastObject];
    
    // 重绘
    [self setNeedsDisplay];
}

#pragma mark - 获取最后一个 path 的线条颜色
-(UIColor *)getColorOfLastPath{
    // 获取最后一个元素
    PaintBezierPath *lastPath = self.pathsArray.lastObject;
    
    // 返回颜色
    return lastPath.paintLineColor;
}






@end
