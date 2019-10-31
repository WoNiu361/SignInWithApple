//
//  AppDelegate.m
//  SignInWithApple
//
//  Created by LYH on 2019/10/30.
//  Copyright © 2019 LYH. All rights reserved.
//

#import "AppDelegate.h"
#import <AuthenticationServices/AuthenticationServices.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [self monitorSignInWithAppleState];
    
    return YES;
}
#pragma mark - 监听apple登录的状态
- (void)monitorSignInWithAppleState {
    if (@available(iOS 13.0,*)) {
        NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"userIdentifier"];
        NSLog(@"user11 -     %@",user);
        ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc] init];
        __block NSString *errorMsg;
        [provider getCredentialStateForUserID:user completion:^(ASAuthorizationAppleIDProviderCredentialState credentialState, NSError * _Nullable error) {
            if (!error) {
                switch (credentialState) {
                    case ASAuthorizationAppleIDProviderCredentialRevoked:
                        NSLog(@"Revoked");
                        errorMsg = @"苹果授权凭证失效";
                        break;
                        
                    case ASAuthorizationAppleIDProviderCredentialAuthorized:
                        NSLog(@"Authorized");
                        errorMsg = @"苹果授权凭证状态良好";
                        break;
                        
                    case ASAuthorizationAppleIDProviderCredentialNotFound:
                        NSLog(@"NotFound");
                        errorMsg = @"未发现苹果授权凭证";
                        break;
                        
                    case ASAuthorizationAppleIDProviderCredentialTransferred:
                        NSLog(@"CredentialTransferred");
                        errorMsg = @"未发现苹果授权凭证";
                        break;
                        
                    default:
                        break;
                }
            } else {
                NSLog(@"state is failure");
            }
        }];
    }
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
