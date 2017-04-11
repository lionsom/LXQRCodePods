//
//  LXQRCode_VC.h
//  QRCode_Demo
//
//  Created by linxiang on 2017/4/11.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LXQRCodeResultType) {
    LXQRCodeResultTypeSuccess = 0, // 1.成功获取图片中的二维码信息
    LXQRCodeResultTypeNoInfo = 1,  // 2.识别的图片没有二维码信息
    LXQRCodeResultTypeError = 2   // 3.其他错误
};

@class LXQRCode_VC;

@protocol LXQRCodeControllerDelegate <NSObject>

- (void)qrcodeController:(LXQRCode_VC *)qrcodeController readerScanResult:(NSString *)readerScanResult type:(LXQRCodeResultType)resultType;

@end


@interface LXQRCode_VC : UIViewController

@property (nonatomic, assign) BOOL isDelegate;

@property(nonatomic, weak) id<LXQRCodeControllerDelegate> delegate;

@end
