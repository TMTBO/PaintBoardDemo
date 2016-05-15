//
//  HandlerView.h
//  PaintBoardDemo
//
//  Created by TobyoTenma on 16/5/14.
//  Copyright © 2016年 TobyoTenma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HandlerView : UIView

@property (nonatomic,strong) UIImage *img;

@property (nonatomic,copy) void (^picBlock)(UIImage *);

@end
