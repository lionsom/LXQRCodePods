//
//  FirstViewController.m
//  QRCode_Demo
//
//  Created by linxiang on 2017/4/6.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "FirstViewController.h"

#import "LXQRCode_VC.h"

@interface FirstViewController ()<LXQRCodeControllerDelegate>

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)callBack:(id)sender {
    
    LXQRCode_VC * QRCodeVC = [[LXQRCode_VC alloc]init];
    QRCodeVC.isDelegate = NO;
    QRCodeVC.delegate = self;
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:QRCodeVC];
    
    [self presentViewController:navVC animated:YES completion:^{
    }];
}

#pragma mark -- Delegate
- (void)qrcodeController:(LXQRCode_VC *)qrcodeController readerScanResult:(NSString *)readerScanResult type:(LXQRCodeResultType)resultType
{
    NSLog(@"FirstViewController == %@", readerScanResult);
    NSLog(@"FirstViewController == %lu", (unsigned long)resultType);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
