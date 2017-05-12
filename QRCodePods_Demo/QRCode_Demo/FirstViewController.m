//
//  FirstViewController.m
//  QRCode_Demo
//
//  Created by linxiang on 2017/4/6.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "FirstViewController.h"

#import "LXQRCode_VC.h"
#import "MBProgressHUD+NJ.h"

@interface FirstViewController ()<LXQRCodeControllerDelegate>

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

//扫描到的结果，向后传值
- (IBAction)btnClick_common:(id)sender {
    LXQRCode_VC * QRCodeVC = [[LXQRCode_VC alloc]init];
    QRCodeVC.LXQRCodeReturnResultType = LXQRCodeReturnResultType_Common;
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:QRCodeVC];

    [self presentViewController:navVC animated:YES completion:^{
    }];
}

//扫描到的结果，利用代理向回传值
- (IBAction)btnClick_delegate:(id)sender {

    LXQRCode_VC * QRCodeVC = [[LXQRCode_VC alloc]init];
    QRCodeVC.LXQRCodeReturnResultType = LXQRCodeReturnResultType_Delegate;
    QRCodeVC.delegate = self;
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:QRCodeVC];
    
    [self presentViewController:navVC animated:YES completion:^{
    }];
}

//扫描到的结果，利用block向回传值
- (IBAction)btnClick_block:(id)sender {
    
    LXQRCode_VC * QRCodeVC = [[LXQRCode_VC alloc]init];
    QRCodeVC.LXQRCodeReturnResultType = LXQRCodeReturnResultType_block;
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:QRCodeVC];
    
    QRCodeVC.callBackBlock = ^(NSString * QRCode_Result){   // 1
        NSLog(@"Block Get is %@",QRCode_Result);
        [MBProgressHUD showSuccess:QRCode_Result];
    };
    
    [self presentViewController:navVC animated:YES completion:^{
    }];
    
}



#pragma mark -- Delegate
- (void)qrcodeController:(LXQRCode_VC *)qrcodeController readerScanResult:(NSString *)readerScanResult type:(LXQRCodeResultType)resultType
{
    if (resultType == LXQRCodeResultTypeSuccess) {
        NSLog(@"FirstViewController  Success == %@",readerScanResult);
        [MBProgressHUD showSuccess:readerScanResult];
    }else {
        NSLog(@"FirstViewController  fail == %@",readerScanResult);
        [MBProgressHUD showError:@"扫描失败"];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
