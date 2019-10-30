#import "SceneDelegate.h"
#import <AuthenticationServices/AuthenticationServices.h>

/**
 
 typedef NS_ENUM(NSInteger, ASAuthorizationAppleIDProviderCredentialState) {
     ASAuthorizationAppleIDProviderCredentialRevoked,  // 授权状态失效（用户停止使用AppID 登录App）
     ASAuthorizationAppleIDProviderCredentialAuthorized, // 已授权(已使用AppleID 登录过App）
     ASAuthorizationAppleIDProviderCredentialNotFound, // 授权凭证缺失（可能是使用AppleID 登录过App）
     ASAuthorizationAppleIDProviderCredentialTransferred, // 授权AppleID提供者凭证已转移
 }
 */

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    
//    [self monitorSignInWithAppleState];
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
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
                        errorMsg = @"苹果授权凭证失效";
                        NSLog(@"Revoked  - %@",errorMsg);
                        break;
                        
                    case ASAuthorizationAppleIDProviderCredentialAuthorized:
                        errorMsg = @"苹果授权凭证状态良好";
                        NSLog(@"Authorized - %@",errorMsg);
                        break;
                        
                    case ASAuthorizationAppleIDProviderCredentialNotFound:
                        errorMsg = @"未发现苹果授权凭证";
                        NSLog(@"NotFound - %@",errorMsg);
                        break;
                        
                    case ASAuthorizationAppleIDProviderCredentialTransferred:
                        errorMsg = @"授权AppleID提供者凭证已转移";
                        NSLog(@"CredentialTransferred - %@",errorMsg);
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



@end
