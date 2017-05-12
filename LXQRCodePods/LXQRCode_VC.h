//
//  LXQRCode_VC.h
//  QRCode_Demo
//
//  Created by linxiang on 2017/4/11.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CallBackBlcok) (NSString * QRCode_Result);  // 1

typedef NS_ENUM(NSUInteger, LXQRCodeResultType) {
    LXQRCodeResultTypeSuccess = 0, // 1.成功获取图片中的二维码信息
    LXQRCodeResultTypeNoInfo = 1,  // 2.识别的图片没有二维码信息
    LXQRCodeResultTypeError = 2   // 3.其他错误
};

/* 如何返回扫面到的结果 */
typedef NS_ENUM(NSUInteger, LXQRCodeReturnResultType) {
    LXQRCodeReturnResultType_Common = 0,    // 1.向下一个界面进行数据传值
    LXQRCodeReturnResultType_Delegate = 1,  // 2.利用代理向上个界面传值
    LXQRCodeReturnResultType_block = 2      // 3.利用block向上一个界面传值
};

@class LXQRCode_VC;

@protocol LXQRCodeControllerDelegate <NSObject>



- (void)qrcodeController:(LXQRCode_VC *)qrcodeController readerScanResult:(NSString *)readerScanResult type:(LXQRCodeResultType)resultType;



@end


@interface LXQRCode_VC : UIViewController

@property (nonatomic,copy)CallBackBlcok callBackBlock;  // 2

@property (nonatomic, assign) LXQRCodeReturnResultType LXQRCodeReturnResultType;

@property(nonatomic, weak) id<LXQRCodeControllerDelegate> delegate;

@end
