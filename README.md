# LXQRCodePods（原生）
## It's a simple demo about QRCode. 可以扫描二维码、以及识别图片中的二维码

## 最新版本：0.0.7
1、修正QRCode从后台进入后的界面小问题。<br>

版本：0.0.6<br>
1、添加了多种传值方式：block、delegate等<br>

### 第一步：导入<br>
1.1 导入CocoaPods<br>
    ```pod "LXQRCodePods"```<br>

1.2 项目添加权限 info.plist 中<br>
```
    Privacy - Camera Usage Description
    Privacy - Photo Library Usage Description
```

### 第二步：使用<br>
2.1 导入头文件<br>
```
    #import "LXQRCode_VC.h"
```

#### 三种数据传送方式
*  LXQRCodeReturnResultType_Common = 0,    // 1.向下一个界面进行数据传值
*  LXQRCodeReturnResultType_Delegate = 1,  // 2.利用代理向上个界面传值
*  LXQRCodeReturnResultType_block = 2      // 3.利用block向上一个界面传值

2.2 具体代码实现<br>
* 方式一：单向传值 - LXQRCodeReturnResultType_Common<br>
```
    LXQRCode_VC * QRCodeVC = [[LXQRCode_VC alloc]init];
    QRCodeVC.LXQRCodeReturnResultType = LXQRCodeReturnResultType_Common;
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:QRCodeVC];

    [self presentViewController:navVC animated:YES completion:^{
    }];
```
* 方式二：需要delegate - LXQRCodeReturnResultType_Delegate<br>

** 添加代理<br>
```
    @interface FirstViewController ()<LXQRCodeControllerDelegate>
```
** 具体使用<br>
```
    LXQRCode_VC * QRCodeVC = [[LXQRCode_VC alloc]init];
    QRCodeVC.isDelegate = YES;
    QRCodeVC.delegate = self;
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:QRCodeVC];
    [self presentViewController:navVC animated:YES completion:^{
    }];
```
** 代理方法<br>
```
    #pragma mark -- Delegate
    - (void)qrcodeController:(LXQRCode_VC *)qrcodeController readerScanResult:(NSString *)readerScanResult type:(LXQRCodeResultType)resultType
{
    if (resultType == LXQRCodeResultTypeSuccess) {
        NSLog(@"FirstViewController  Success == %@",readerScanResult);
    }else {
        NSLog(@"FirstViewController  fail == %@",readerScanResult);
    }
}
```

* 方式三：block传值 - LXQRCodeReturnResultType_block<br>
```
    LXQRCode_VC * QRCodeVC = [[LXQRCode_VC alloc]init];
    QRCodeVC.LXQRCodeReturnResultType = LXQRCodeReturnResultType_block;
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:QRCodeVC];
    
    QRCodeVC.callBackBlock = ^(NSString * QRCode_Result){
        NSLog(@"Block Get is %@",QRCode_Result);
    };
    
    [self presentViewController:navVC animated:YES completion:^{
    }];

```

欢迎指正批评！！！<br>

### 在此参考了GitHub上的一些项目，如有侵权，请及时与我联系。<br>
### 邮箱：lionsom_lin@qq.com <br>

