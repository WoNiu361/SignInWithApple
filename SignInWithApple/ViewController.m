//
//  ViewController.m
//  SignInWithApple
//
//  Created by LYH on 2019/10/30.
//  Copyright © 2019 LYH. All rights reserved.
//

/**
 typedef NS_ENUM(NSInteger, ASAuthorizationAppleIDButtonStyle) {//按钮的风格
     ASAuthorizationAppleIDButtonStyleWhite,   //白色的背景，黑色的文字和图标
     ASAuthorizationAppleIDButtonStyleWhiteOutline, //带有褐色的边框、黑色额字体和图标，白色的背景
     ASAuthorizationAppleIDButtonStyleBlack,//黑色的背景，白色的文字和图标
 }
 */

/**
 typedef NS_ENUM(NSInteger, ASAuthorizationAppleIDButtonType) {//按钮上文字的i显示
     ASAuthorizationAppleIDButtonTypeSignIn, // Sign in with Apple （通过Apple登录）
     ASAuthorizationAppleIDButtonTypeContinue, // Continue with Apple（通过Apple继续）

     ASAuthorizationAppleIDButtonTypeDefault = ASAuthorizationAppleIDButtonTypeSignIn,
 }
 */

#import "ViewController.h"
#import <AuthenticationServices/AuthenticationServices.h>
#import <objc/runtime.h>

@interface ViewController ()<ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    
     UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        textField.placeholder = @"你好，Xcode11 And iOS 13";
        textField.backgroundColor = [UIColor whiteColor];
        textField.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        if (@available(iOS 13.0, *)) {//13.0的新属性
            
            ASAuthorizationAppleIDButton *appleIDButton = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeSignIn style:ASAuthorizationAppleIDButtonStyleWhite];
            appleIDButton.frame = CGRectMake(50, 150, 200, 50);
            [appleIDButton addTarget:self action:@selector(userAppIDLogin:) forControlEvents:UIControlEventTouchUpInside];
            appleIDButton.cornerRadius = 5;
            [self.view addSubview:appleIDButton];
            
            [self antherButton];
            
            [self getAuthorizationButtonProperty:appleIDButton];
            
        } else {
    //        [textField setValue:[UIColor orangeColor] forKey:@"_placeholderLabel.textColor"];
        }
        [self.view addSubview:textField];
    
    if (@available(iOS 13.0, *)) {//判断授权是否失效
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(monitorSignInWithAppleStateChanged:) name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
    }
}

#pragma mark - 处理授权
- (void)userAppIDLogin:(ASAuthorizationAppleIDButton *)button  API_AVAILABLE(ios(13.0)){
    if (@available(iOS 13.0, *)) {
         // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
        ASAuthorizationAppleIDProvider *appleIdProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        // 创建新的AppleID 授权请求
        ASAuthorizationAppleIDRequest *request = appleIdProvider.createRequest;
         // 在用户授权期间请求的联系信息
        request.requestedScopes = @[ASAuthorizationScopeEmail,ASAuthorizationScopeFullName];
        
         //需要考虑用户已经登录过，可以直接使用keychain密码来进行登录-这个很智能 (但是这个有问题)
//        ASAuthorizationPasswordProvider *appleIDPasswordProvider = [[ASAuthorizationPasswordProvider alloc] init];
//        ASAuthorizationPasswordRequest *passwordRequest = appleIDPasswordProvider.createRequest;
        
        // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
        ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
         // 设置授权控制器通知授权请求的成功与失败的代理
        controller.delegate = self;
        // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
        controller.presentationContextProvider = self;
         // 在控制器初始化期间启动授权流
        [controller performRequests];
    } else {
        NSLog(@"system is lower");
    }
}
#pragma mark - 授权成功的回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization  API_AVAILABLE(ios(13.0)) {
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        // 用户登录使用ASAuthorizationAppleIDCredential
        ASAuthorizationAppleIDCredential *credential = authorization.credential;
        NSString *user = credential.user;
        NSData *identityToken = credential.identityToken;
        NSLog(@"fullName -     %@",credential.fullName);
        //授权成功后，你可以拿到苹果返回的全部数据，根据需要和后台交互。
        NSLog(@"user   -   %@  %@",user,identityToken);
        //保存apple返回的唯一标识符
        [[NSUserDefaults standardUserDefaults] setObject:user forKey:@"userIdentifier"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        // 用户登录使用现有的密码凭证
        ASPasswordCredential *psdCredential = authorization.credential;
        // 密码凭证对象的用户标识 用户的唯一标识
        NSString *user = psdCredential.user;
        NSString *psd = psdCredential.password;
        NSLog(@"psduser -  %@   %@",psd,user);
    } else {
       NSLog(@"授权信息不符");
    }
}

#pragma mark - 授权回调失败
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error  API_AVAILABLE(ios(13.0)){
    
     NSLog(@"错误信息：%@", error);
     NSString *errorMsg;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            NSLog(@"errorMsg -   %@",errorMsg);
            break;
            
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            NSLog(@"errorMsg -   %@",errorMsg);
            break;
            
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            NSLog(@"errorMsg -   %@",errorMsg);
            break;
            
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            NSLog(@"errorMsg -   %@",errorMsg);
            break;
            
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            NSLog(@"errorMsg -   %@",errorMsg);
            break;
                        
        default:
            break;
    }
}

- (void)getAuthorizationButtonProperty:(ASAuthorizationAppleIDButton *)button API_AVAILABLE(ios(13.0)) {
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([ASAuthorizationAppleIDButton class], &count);
    for (NSInteger i = 0; i < count; i ++) {
        Ivar ivar = ivars[i];
        NSLog(@"name    %s  \n  %s",ivar_getName(ivar),ivar_getTypeEncoding(ivar));
    }
}
    
- (void)antherButton {
    if(@available(iOS 13.0, *)) {
        ASAuthorizationAppleIDButton *appleIDButton = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeContinue style:ASAuthorizationAppleIDButtonStyleBlack];
        appleIDButton.frame = CGRectMake(50, 220, 200, 50);
        [appleIDButton addTarget:self action:@selector(userAppIDLogin:) forControlEvents:UIControlEventTouchUpInside];
        //        appleIDButton.cornerRadius = 20;
        //        appleIDButton.layer.masksToBounds = true;
        
        [self.view addSubview:appleIDButton];
    }
}

- (void)monitorSignInWithAppleStateChanged:(NSNotification *)notification {
    NSLog(@"state CHANGE -  %@",notification);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
}
@end
