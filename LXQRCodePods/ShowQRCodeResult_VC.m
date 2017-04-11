//
//  ShowQRCodeResult_VC.m
//  QRCode_Demo
//
//  Created by linxiang on 2017/4/11.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "ShowQRCodeResult_VC.h"

@interface ShowQRCodeResult_VC ()

@property (nonatomic, strong) UILabel * showLabel;

@end

@implementation ShowQRCodeResult_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 1.设置标题和背景色
    self.title = @"扫描结果";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem * leftItem_1 = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(closeEvent)];
    self.navigationItem.leftBarButtonItems = @[leftItem_1];

    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.showLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 50)];
    self.showLabel.text = _QRMessageStr;
    self.showLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.showLabel];
}

- (void)closeEvent {
    //关闭 navigationController
    [self dismissViewControllerAnimated:YES completion:nil];
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
