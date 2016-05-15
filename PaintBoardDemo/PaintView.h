//
//  PaintView.h
//  PaintBoardDemo
//
//  Created by TobyoTenma on 16/5/14.
//  Copyright © 2016年 TobyoTenma. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface PaintView : UIView

@property (nonatomic,strong) UIColor *paintLineColor;

@property (assign,nonatomic) CGFloat paintLineWidth;

@property (strong,nonatomic) UIImage *image;




-(void)clearPaintBoard;

-(void)undoLastStep;

-(UIColor *)getColorOfLastPath;

@end
