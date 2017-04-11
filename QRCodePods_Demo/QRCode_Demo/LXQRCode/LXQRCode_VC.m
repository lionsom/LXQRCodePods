//
//  LXQRCode_VC.m
//  QRCode_Demo
//
//  Created by linxiang on 2017/4/11.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "LXQRCode_VC.h"

#import "ShowQRCodeResult_VC.h"

//调用系统摄像头文件
#import <AVFoundation/AVFoundation.h>

#define Screen_W CGRectGetWidth([UIScreen mainScreen].bounds)
#define Screen_H CGRectGetHeight([UIScreen mainScreen].bounds)
#define ST_QRCODE_WidthRate    Screen_W/320

@interface LXQRCode_VC ()<AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

//-----------View-------------
/** 1.中间扫描图片 */
@property(nonatomic, strong)UIImageView *imageScanZone;
/** 2.扫描的尺寸 */
@property(nonatomic, assign)CGRect rectScanZone;
/** 4.遮罩视图 */
@property(nonatomic, strong)UIView *viewMask;
/** 5.开启闪光灯 */
@property(nonatomic, strong)UIButton *buttonTurn;
/** 6.移动的图片 */
@property(nonatomic, strong)UIImageView *imageMove;
/** 7.提示语 */
@property(nonatomic, strong)UILabel *labelAlert;

@end

@implementation LXQRCode_VC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 1.设置标题和背景色
    self.title = @"扫描";
    self.view.backgroundColor = [UIColor blackColor];
    
    // 2.设置UIBarButtonItem， iOS8系统之后才支持本地扫描
    if ([UIDevice currentDevice].systemVersion.intValue >= 8) {
        UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:@"相册" style:UIBarButtonItemStyleDone target:self action:@selector(alumbEvent)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backEvent)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    

    //首先判断相机权限
    /**
     验证相机权限
     AVAuthorizationStatusNotDetermined = 0, //第一次使用会弹出打开弹窗
     AVAuthorizationStatusRestricted,        //此应用程序没有被授权访问的照片数据。可能是家长控制权限
     AVAuthorizationStatusDenied,            //用户已经明确否认了这一照片数据的应用程序访问
     AVAuthorizationStatusAuthorized         //有权限
     */
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusAuthorized || authStatus == AVAuthorizationStatusNotDetermined ) {      //有权限  //第一次使用会弹出打开弹窗
        //第三种：最常用
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startLoad];
        });//定制了延时执行的任务，不会阻塞线程，效率较高（推荐使用）
    }else{
        // 1. 实例化
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请在设置中开启摄像头权限" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        // 2. 添加方法
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url];
            }
        }]];
        // 3. 显示
        [self presentViewController:alert animated:YES completion:nil];
    }
}

/**
 进入界面后，再进行加载
 */
-(void)startLoad {
    [self createAVCapture];
    
    [self.view addSubview:self.viewMask];
    [self.view addSubview:self.imageScanZone];
    [self.view addSubview:self.imageMove];
    [self.view addSubview:self.buttonTurn];
    [self.view addSubview:self.labelAlert];
    
    [self startAnimation];
}


/**
 createAVCapture相机相关
 */
-(void)createAVCapture {
    //1.实例化拍摄设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //2.设置输入设备
    NSError * error = nil;
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    //3.设置元数据输出
    //3.1 实例化拍摄元数据输出
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //3.2 设置输出数据代理
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //4. 添加拍摄会话
    //4.1 实例化拍摄会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    //4.2 添加会话输入
    [session addInput:input];
    //4.3 添加会话输出
    [session addOutput:output];
    //4.4 设置输出数据类型，需要将元数据输出添加到会话后，才能指定元数据类型，否则会报错
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    self.session = session;
    
    // 5. 视频预览图层
    // 5.1 实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    // 设置参数
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.bounds;
    // 5.2 将图层插入当前视图
    [self.view.layer insertSublayer:layer atIndex:0];
    
    self.previewLayer = layer;
    
    // 6. 启动会话
    [_session startRunning];
}

#pragma mark -- 扫描 结果回调
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    // 会频繁的扫描，调用代理方法
    // 1. 如果扫描完成，停止会话
    [self.session stopRunning];
    // 2. 删除预览图层
    [self.previewLayer removeFromSuperlayer];
    
    NSLog(@"metadataObjects == %@", metadataObjects);
    // 3. 设置界面显示扫描结果
    
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        // 提示：如果需要对url或者名片等信息进行扫描，可以在此进行扩展！
        NSLog(@"二维码结果 == %@", obj.stringValue);
        
        NSString * result = obj.stringValue;
        
        //是否走代理通知
        if (_isDelegate) {
            if ([self.delegate respondsToSelector:@selector(qrcodeController:readerScanResult:type:)]) {
                [self.delegate qrcodeController:self readerScanResult:result type:LXQRCodeResultTypeSuccess];
                //返回
                [self backEvent];
            }
        }else {
            ShowQRCodeResult_VC * showView = [[ShowQRCodeResult_VC alloc]init];
            showView.QRMessageStr = result;
            [self.navigationController pushViewController:showView animated:YES];
        }
    }
}

#pragma mark -- 事件 回调
- (void)backEvent
{
    //关闭动画
    [self stopAnimation];
    
    //如果session还在跑，就关闭他
    if (self.session.isRunning) {
        [self.session stopRunning];
    }
    
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


/**
 点击相册事件，弹出相框
 */
- (void)alumbEvent
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) { //判断设备是否支持相册
        NSLog(@"未开启访问相册权限，请在设置中开始");
    }else {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        imagePickerController.allowsEditing = YES;
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:^{
            [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
        }];
    }
}


/**
 开关灯
 */
- (void)turnTorchEvent:(UIButton *)button
{
    button.selected = !button.selected;
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        //先判断是否由电筒功能    以及是否有闪光功能
        if ([device hasTorch] && [device hasFlash]){
            [device lockForConfiguration:nil];
            if (button.selected) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
            }
            [device unlockForConfiguration];
        }
    }
}

- (void)startAnimation
{
    CGFloat viewW = 200*ST_QRCODE_WidthRate;
    CGFloat viewH = 3;
    CGFloat viewX = (Screen_W - viewW)/2;
    __block CGFloat viewY = (Screen_H- viewW)/2;
    __block CGRect rect = CGRectMake(viewX, viewY, viewW, viewH);
    [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionRepeat animations:^{
        viewY = (Screen_H- viewW)/2 + 200*ST_QRCODE_WidthRate - 5;
        rect = CGRectMake(viewX, viewY, viewW, viewH);
        self.imageMove.frame = rect;
    } completion:^(BOOL finished) {
        viewY = (Screen_H- viewW)/2;
        rect = CGRectMake(viewX, viewY, viewW, viewH);
        self.imageMove.frame = rect;
    }];
}

- (void)stopAnimation
{
    CGFloat viewW = 200*ST_QRCODE_WidthRate;
    CGFloat viewH = 3;
    CGFloat viewX = (Screen_W - viewW)/2;
    __block CGFloat viewY = (Screen_H- viewW)/2;
    __block CGRect rect = CGRectMake(viewX, viewY, viewW, viewH);
    [UIView animateWithDuration:0.01 animations:^{
        self.imageMove.frame = rect;
    }];
}


#pragma mark -- 界面

- (CGRect)rectScanZone
{
    return CGRectMake(60*ST_QRCODE_WidthRate, (Screen_H-200*ST_QRCODE_WidthRate)/2, 200*ST_QRCODE_WidthRate, 200*ST_QRCODE_WidthRate);
}


- (UIView *)viewMask
{
    if (!_viewMask) {
        _viewMask = [[UIView alloc]initWithFrame:self.view.bounds];
        [_viewMask setBackgroundColor:[UIColor blackColor]];
        [_viewMask setAlpha:102.0/255];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path appendPath:[UIBezierPath bezierPathWithRect:_viewMask.bounds]];
        [path appendPath:[UIBezierPath bezierPathWithRect:self.rectScanZone].bezierPathByReversingPath];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = path.CGPath;
        _viewMask.layer.mask = maskLayer;
    }
    return _viewMask;
}

- (UIImageView *)imageScanZone{
    if (!_imageScanZone) {
        _imageScanZone = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"STQRCodeController.bundle/st_scanBackground@2x"]];
        _imageScanZone.frame = self.rectScanZone;
    }
    return _imageScanZone;
}

- (UIImageView *)imageMove
{
    if (!_imageMove) {
        CGFloat viewW = 200*ST_QRCODE_WidthRate;
        CGFloat viewH = 3;
        CGFloat viewX = (Screen_W - viewW)/2;
        CGFloat viewY = (Screen_H - viewW)/2;
        _imageMove = [[UIImageView alloc]initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
        _imageMove.image = [UIImage imageNamed:@"STQRCodeController.bundle/st_scanLine@2x"];
    }
    return _imageMove;
}

- (UIButton *)buttonTurn
{
    if (!_buttonTurn) {
        _buttonTurn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonTurn setBackgroundImage:[UIImage imageNamed:@"STQRCodeController.bundle/st_lightSelect@2x"] forState:UIControlStateNormal];
        [_buttonTurn setBackgroundImage:[UIImage imageNamed:@"STQRCodeController.bundle/st_lightNormal@2x"] forState:UIControlStateSelected];
        [_buttonTurn sizeToFit];
        [_buttonTurn addTarget:self action:@selector(turnTorchEvent:) forControlEvents:UIControlEventTouchUpInside];
        self.buttonTurn.center = CGPointMake(self.imageScanZone.center.x, CGRectGetMaxY(self.imageScanZone.frame) + 100);
    }
    return _buttonTurn;
}

- (UILabel *)labelAlert
{
    if (!_labelAlert) {
        CGFloat viewW = Screen_W;
        CGFloat viewH = 17;
        CGFloat viewX = 0;
        CGFloat viewY = 0;
        _labelAlert = [[UILabel alloc]initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
        [_labelAlert setText:@"将二维码/条形码放置框内，即开始扫描"];
        [_labelAlert setTextColor:[UIColor whiteColor]];
        [_labelAlert setFont:[UIFont systemFontOfSize:15]];
        [_labelAlert setTextAlignment:NSTextAlignmentCenter];
        _labelAlert.center = CGPointMake(self.imageScanZone.center.x, CGRectGetMaxY(self.imageScanZone.frame) + 20);
    }
    return _labelAlert;
}


#pragma mark - --- UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 1.获取图片信息
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    // 2.退出图片控制器
    [picker dismissViewControllerAnimated:YES completion:^{
        
        CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
        
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        if (features.count) {
            for (int index = 0; index < [features count]; index ++) {
                CIQRCodeFeature *feature = [features objectAtIndex:index];
                NSString *scannedResult = feature.messageString;
                NSLog(@"result:%@",scannedResult);
                
                //是否走代理通知
                if (_isDelegate) {
                    if ([self.delegate respondsToSelector:@selector(qrcodeController:readerScanResult:type:)]) {
                        [self.delegate qrcodeController:self readerScanResult:scannedResult type:LXQRCodeResultTypeSuccess];
                        //返回
                        [self backEvent];
                    }
                }else {
                    ShowQRCodeResult_VC * showView = [[ShowQRCodeResult_VC alloc]init];
                    showView.QRMessageStr = scannedResult;
                    [self.navigationController pushViewController:showView animated:YES];
                }
            }
        }else {
            //是否走代理通知
            if (_isDelegate) {
                if ([self.delegate respondsToSelector:@selector(qrcodeController:readerScanResult:type:)]) {
                    [self.delegate qrcodeController:self readerScanResult:@"" type:LXQRCodeResultTypeNoInfo];
                    //返回
                    [self backEvent];
                }
            }else {
                ShowQRCodeResult_VC * showView = [[ShowQRCodeResult_VC alloc]init];
                showView.QRMessageStr = @"无数据";
                [self.navigationController pushViewController:showView animated:YES];
            }
        }
    }];
}


/**
 取消相册的回调
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
        //扫描动画
        [self startAnimation];
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
