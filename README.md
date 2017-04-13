# LXQRCodePods
## It's a simple demo about QRCode. 可以扫描二维码、以及识别图片中的二维码（原生）

## 最新版本：0.0.5

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
    
2.2 在点击事件回调中 
* 方式一：不需要Delegate
```
    LXQRCode_VC * QRCodeVC = [[LXQRCode_VC alloc]init];
    QRCodeVC.isDelegate = NO;
//    QRCodeVC.delegate = self; //暂时不需要代理
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:QRCodeVC];
    [self presentViewController:navVC animated:YES completion:^{
    }];
```
* 方式二：需要delegate<br>

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
        NSLog(@"FirstViewController == %@", readerScanResult);
        NSLog(@"FirstViewController == %lu", (unsigned long)resultType);
    }
```

### 在此参考了GitHub上的一些项目，如有侵权，请及时与我联系。<br>
### 邮箱：lionsom_lin@qq.com <br>

