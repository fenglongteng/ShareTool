//
//  ShareSDKTool.h
//  BatMessager
//
//  Created by ds on 2017/12/5.
//  Copyright © 2017年 BatWord. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ShareType) {
    ShareType_WenXin  = 0,
    ShareType_Friend,
    ShareType_QQ,
    ShareType_Message,
};
@interface ShareSDKTool : NSObject

+ (instancetype _Nullable )Shared;

-(void)wxrRegisterApp:(NSString*)appId universalLink:(NSString*)link;


-(void)qqInitWithAppId:(NSString*)appId andDelegate:(NSObject*)delegate;


/// 分享海报
- (void)shareTo:(ShareType)type WithScreenshot:(UIImage *)screenshot;


/// 分享短信
- (void)shareToMessage:(NSString *)batId toPhone:(NSMutableArray*)phoneArray;

/// 分享微信 Url
/// @param webpageUrl  链接
/// @param type 分享类型 0：聊天界面 1：朋友圈
- (void)shareToWechatWithWebpageUrl:(NSString *)webpageUrl
                             type:(ShareType)type;

/// 分享QQ  Url
/// @param webpageUrl  链接
/// @param type 分享类型 2：聊天界面 3：QQ朋友圈
- (void)shareToQQWithWebpageUrl:(NSString *)webpageUrl
                             type:(ShareType)type;

@end

NS_ASSUME_NONNULL_END
