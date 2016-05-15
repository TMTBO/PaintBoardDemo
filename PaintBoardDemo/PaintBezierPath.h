//
//  PaintBezierPath.h
//  PaintBoardDemo
//
//  Created by TobyoTenma on 16/5/14.
//  Copyright © 2016年 TobyoTenma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaintBezierPath : UIBezierPath

@property (nonatomic,strong) UIColor *paintLineColor;

@property (assign,nonatomic) CGFloat paintLineWidth;

@end
