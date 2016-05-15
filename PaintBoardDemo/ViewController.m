//
//  ViewController.m
//  PaintBoardDemo
//
//  Created by TobyoTenma on 16/5/14.
//  Copyright © 2016年 TobyoTenma. All rights reserved.
///Users/tobyotenma/Developer/iOS/PaintBoardDemo/PaintBoardDemo/ViewController.m:122:9: Capturing 'self' strongly in this block is likely to lead to a retain cycle

#import "ViewController.h"
#import "PaintView.h"
#import "HandlerView.h"

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong,nonatomic) UIColor *lastColor;

@property (strong,nonatomic) HandlerView *handlerView;

@property (weak, nonatomic) IBOutlet UIView *toolBarView;

@property (weak, nonatomic) IBOutlet UIView *selectionBar;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *wipeOut;

@property (weak, nonatomic) IBOutlet PaintView *paintView;

@property (weak, nonatomic) IBOutlet UIView *showColorView;

@property (weak, nonatomic) IBOutlet UISlider *redColorValue;

@property (weak, nonatomic) IBOutlet UISlider *greenColorValue;

@property (weak, nonatomic) IBOutlet UISlider *blueColorValue;


@end

@implementation ViewController

#pragma mark - 懒加载 handlerView
-(HandlerView *)handlerView{
    if (!_handlerView) {
        _handlerView = [[HandlerView alloc] initWithFrame:self.paintView.frame];
    }
    return _handlerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 清屏
- (IBAction)claerAction:(UIBarButtonItem *)sender {
    [self.paintView clearPaintBoard];
}

#pragma mark - 撤消
- (IBAction)undoAction:(UIBarButtonItem *)sender {
    [self.paintView undoLastStep];
}

#pragma mark - 擦除
- (IBAction)wipeOutAction:(UIBarButtonItem *)sender {
    
    // 判断当前按钮的状态
    if ([sender.title isEqualToString:@"WipeOut"]) {

        // 保存当前颜色
        self.lastColor = [self.paintView getColorOfLastPath];
        
        // 设置线条颜色为白色
        self.paintView.paintLineColor = [UIColor whiteColor];
        
        // 修改按钮的文字
        sender.title = @"Cancel";
    }else{
        // 重新设置颜色为之前的颜色
        self.paintView.paintLineColor = self.lastColor;
        
        sender.title = @"WipeOut";
    }
}

#pragma mark - 打开相册
- (IBAction)albumAction:(UIBarButtonItem *)sender {
    
    // 打开相册
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    // 打开相册目录
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    // 打开视力
    [self presentViewController:picker animated:YES completion:nil];
    
    //设置代理
    picker.delegate = self;

}

#pragma markk - 实现 picker 的代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    // 关闭视图
    [self dismissViewControllerAnimated:YES completion:nil];
        
    // 获取选中的图片
    UIImage *img = info[UIImagePickerControllerOriginalImage];
    
    //  给 handlerView赋值
    self.handlerView.img = img;
    
    // 加入到 view 中
    [self.view addSubview:self.handlerView];
    
    
    // 获取最终得到的图片
    __weak typeof(self) weakSelf = self;
    self.handlerView.picBlock = ^(UIImage *newImg){
        weakSelf.paintView.image = newImg;
    };
    // 将上下两个 view移动到最上层
    [self.view  bringSubviewToFront:self.toolBarView];
    [self.view  bringSubviewToFront:self.selectionBar];
}

#pragma mark - 保存到相册
- (IBAction)saveAction:(UIBarButtonItem *)sender {
    // 开启一个上下文
    UIGraphicsBeginImageContext(self.paintView.frame.size);
    
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self.paintView.layer renderInContext:ctx];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    // 保存 img
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

#pragma mark - 存储图片后的操作方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
#warning complete here
}

#pragma mark - 设置线条粗细
- (IBAction)slide2ChangeLineWidth:(UISlider *)sender {
    // 传递线条宽
    self.paintView.paintLineWidth = sender.value;
}

#pragma mark - 根据 slider 来改变颜色
- (IBAction)slide2ChangeColorValue:(UISlider *)sender {
    // 传递新的颜色
    self.paintView.paintLineColor = [self getNewColor];;

    // 三个 slider 的值发生改变,就重新展示选中的颜色
    self.showColorView.backgroundColor = [self getNewColor];
}

#pragma mark - 获取改变后的颜色
-(UIColor *)getNewColor{
    CGFloat r = self.redColorValue.value;
    CGFloat g = self.greenColorValue.value;
    CGFloat b = self.blueColorValue.value;
    
    // 取得设置的颜色
    UIColor *newColor = [UIColor colorWithRed:r green:g blue:b alpha:1.0];
    return newColor;
}



@end
