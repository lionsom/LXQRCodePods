# LXQRCodePods
##It's a simple demo about QRCode. 可以扫描二维码、以及识别图片中的二维码



###第一步：导入<br>
1.1 导入CocoaPods<br>
    ```pod "LXQRCodePods"```<br>

1.2 项目添加权限 info.plist 中<br>
```
    Privacy - Camera Usage Description
    Privacy - Photo Library Usage Description
```

###第二步：使用<br>
2.1 导入头文件<br>
    ```#import "LXQRCode_VC.h"```<br>
2.2 在点击事件回调中
```
    LXQRCode_VC * QRCodeVC = [[LXQRCode_VC alloc]init];
    QRCodeVC.isDelegate = NO;
    //    QRCodeVC.delegate = self;
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:QRCodeVC];
    
    [self presentViewController:navVC animated:YES completion:^{
    }];
```



