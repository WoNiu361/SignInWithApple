//
//  YHASAuthorizationAppleIDCredential.h
//  Xcode11-Test
//
//  Created by LYH on 2019/10/29.
//  Copyright © 2019 LYH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AuthenticationServices/ASAuthorization.h>
#import <AuthenticationServices/ASAuthorizationCredential.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YHASUserDetectionStatus) { // 用户检测状态
    YHASUserDetectionStatusUnsupported, // 用户检测状态不受支持
    YHASUserDetectionStatusUnknown,     // 用户检测状态未知
    YHASUserDetectionStatusLikelyReal,  // 用户检测状态可能为真实
};

NS_ASSUME_NONNULL_BEGIN

@interface YHASAuthorizationAppleIDCredential : NSObject

/*! @abstract An opaque user ID associated with the AppleID used for the sign in. This identifier will be stable across the 'developer team', it can later be used as an input to @see ASAuthorizationRequest to request user contact information.

 The identifier will remain stable as long as the user is connected with the requesting client.  The value may change upon user disconnecting from the identity provider.
 只要用户与发出请求的客户端连接，标识符就将保持稳定。用户断开身份提供者的连接后，该值可能会更改。
 
 与已认证用户关联的标识符。
 */
@property (nonatomic, readonly, copy) NSString *user;

/*! @abstract A copy of the state value that was passed to ASAuthorizationRequest.
     传递给ASAuthorizationRequest的状态值的副本。
 
 您的应用程序提供给生成凭据的请求的任意字符串
 */
@property (nonatomic, readonly, copy, nullable) NSString *state;

/*! @abstract This value will contain a list of scopes for which the user provided authorization.  These may contain a subset of the requested scopes on @see ASAuthorizationAppleIDRequest.  The application should query this value to identify which scopes were returned as it maybe different from ones requested.
 该值将包含用户为其提供授权的范围的列表。这些可能包含@see ASAuthorizationAppleIDRequest上请求的范围的子集。应用程序应查询该值以标识返回的范围，因为它可能与请求的范围不同。
 
 用户授权您的应用访问的联系信息。
 */
@property (nonatomic, readonly, copy) NSArray<ASAuthorizationScope> *authorizedScopes;

/*! @abstract A short-lived, one-time valid token that provides proof of authorization to the server component of the app. The authorization code is bound to the specific transaction using the state attribute passed in the authorization request. The server component of the app can validate the code using Apple’s identity service endpoint provided for this purpose.
 一种短暂的一次性有效令牌，可为应用程序的服务器组件提供授权证明。授权代码使用授权请求中传递的state属性绑定到特定事务​​。该应用程序的服务器组件可以使用为此目的提供的Apple身份服务端点来验证代码。
 
 说白了就是：给后台向苹果服务器验证使用，这个有时效性 五分钟之内有效
 
 与应用程序的服务器副本交互时，应用程序使用的短暂令牌来作为授权证明。
 */
@property (nonatomic, readonly, copy, nullable) NSData *authorizationCode;

/*! @abstract A JSON Web Token (JWT) used to communicate information about the identity of the user in a secure way to the app. The ID token will contain the following information: Issuer Identifier, Subject Identifier, Audience, Expiry Time and Issuance Time signed by Apple's identity service.
 
 JSON Web令牌（JWT），用于以安全方式将有关用户身份的信息传达给应用。 ID令牌将包含以下信息：由Apple身份服务签名的发行者标识符，主题标识符，受众，有效期和发行时间。
 
 JSON Web令牌（JWT），可将有关用户的信息安全地传递到您的应用程序。
 */
@property (nonatomic, readonly, copy, nullable) NSData *identityToken;

/*! @abstract An optional email shared by the user.  This field is populated with a value that the user authorized.
       用户共享的可选电子邮件。该字段填充有用户授权的值。
 
     用户的邮箱地址
 */
@property (nonatomic, readonly, copy, nullable) NSString *email;

/*! @abstract An optional full name shared by the user.  This field is populated with a value that the user authorized.
      用户共享的可选全名。该字段填充有用户授权的值。
 
     用户名
 */
@property (nonatomic, readonly, copy, nullable) NSPersonNameComponents *fullName;

/*! @abstract Check this property for a hint as to whether the current user is a "real user".  @see YHASUserDetectionStatus for guidelines on handling each status
 检查此属性以获取有关当前用户是否为“真实用户”的提示。 @有关处理每个状态的准则，请参见YHASUserDetectionStatus
 
 指示用户是否看起来是真实人物的值
 */
@property (nonatomic, readonly) YHASUserDetectionStatus realUserStatus;

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
