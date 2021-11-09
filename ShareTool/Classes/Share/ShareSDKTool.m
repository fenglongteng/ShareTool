//
//  ShareSDKTool.m
//  BatMessager
//
//  Created by ds on 2017/12/5.
//  Copyright © 2017年 BatWord. All rights reserved.
//

#import "ShareSDKTool.h"
#import <MessageUI/MessageUI.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface ShareSDKTool ()<MFMessageComposeViewControllerDelegate,TencentSessionDelegate>

@end

static ShareSDKTool *tool = nil;
@implementation ShareSDKTool    

+ (instancetype _Nullable )Shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [ShareSDKTool new];
    });
    return tool;
}

-(void)wxrRegisterApp:(NSString*)appId universalLink:(NSString*)link{
    if ([WXApi registerApp:appId universalLink:link]){
        NSLog(@"微信sdK登录成功");
    }
}


-(void)qqInitWithAppId:(NSString*)appId andDelegate:(NSObject*)delegate{
    [[TencentOAuth alloc] initWithAppId:appId andDelegate:delegate];
}


- (void)shareTo:(ShareType)type WithScreenshot:(UIImage *)screenshot {
    
    // 检测是否安装了分享所需要的软件
    if (![self isInstalledShare:type]) { return; }
    
    if (type == ShareType_WenXin) {
        [self shareToWeiXinWithScreenshot:screenshot scene:WXSceneSession];
    }else if(type == ShareType_Friend){
        [self shareToWeiXinWithScreenshot:screenshot scene:WXSceneTimeline];
    }else if(type == ShareType_QQ){
        [self shareToQQWithWithScreenshot:screenshot];
    }

}

/// 检测是否安装了分享所需的软件
/// @param type 类型
- (BOOL)isInstalledShare:(ShareType)type {
    
    if ((type == ShareType_WenXin || type == ShareType_Friend) && ![WXApi isWXAppInstalled]) {
//        [ToastUtil shortMsg:@"您尚未安装微信"];
        return NO;
    }
    
    if (type == ShareType_QQ && ![QQApiInterface isQQInstalled]) {
//        [ToastUtil shortMsg:@"您尚未安装QQ"];
        return NO;
    }
    return YES;
}

#pragma mark - 分享图片
- (void)shareToWeiXinWithScreenshot:(UIImage *)screenshot scene:(int)scene{
    
    if (![self isInstalledShare:ShareType_WenXin]) { return; }
    
    WXMediaMessage *message = [WXMediaMessage message];
//    NSData * imageData = [screenshot compressBySizeWithMaxLength:32*1024];
    NSData * imageData = [NSData new];
    [message setThumbImage:[UIImage imageWithData:imageData]];
    WXImageObject *imageObject = [WXImageObject object];
    imageObject.imageData = UIImageJPEGRepresentation(screenshot, 1);
    message.mediaObject = imageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;// 分享到朋友圈
//    [WXApi sendReq:req];
    [WXApi sendReq:req completion:nil];
}

- (void)shareToQQWithWithScreenshot:(UIImage *)screenshot{
    
    if (![self isInstalledShare:ShareType_QQ]) { return; }
    
    NSData * imageData = UIImageJPEGRepresentation(screenshot, 1);
//    NSData * previewImageData = [screenshot compressBySizeWithMaxLength:1024*1024];
    NSData * previewImageData = [NSData new];

    QQApiImageObject * imageObj = [[QQApiImageObject alloc] initWithData:imageData previewImageData:previewImageData title:@"青藤" description:@""];
    SendMessageToQQReq * req = [SendMessageToQQReq reqWithContent:imageObj];
    [QQApiInterface sendReq:req];
}

- (void)shareToMessage:(NSString *)batId toPhone:(NSMutableArray*)phoneArray{
    [self sendMessage:[self shareMessageWithSMS:batId] toPhone:phoneArray];
}


#define ShareMessageUrl  @"https://www.batchat.com/share/share.html"

- (NSString *)shareMessageWithSMS:(NSString *)batid {
    
    NSString *shareBody = [NSString stringWithFormat:@"SendTexting_key", batid, ShareMessageUrl];
    return shareBody;
}


- (void)sendMessage:(NSString *)message toPhone:(NSMutableArray*)iphoneArray{
    //如果不能发送文本信息，就直接返回
    if(![MFMessageComposeViewController canSendText]){
        return;
    }
    //创建短信发送视图控制器
    MFMessageComposeViewController *messageController =
    [[MFMessageComposeViewController alloc] init];
    messageController.recipients = iphoneArray;
    messageController.navigationBar.tintColor = [UIColor whiteColor];
    //设置信息正文
    messageController.body = message;
    [messageController addAttachmentURL:[NSURL URLWithString:ShareMessageUrl] withAlternateFilename:nil];
    //设置代理,注意这里不是delegate而是messageComposeDelegate
    messageController.messageComposeDelegate = self;
    messageController.modalPresentationStyle =  UIModalPresentationFullScreen;
    //以模态弹出界面
    [[self topViewController] presentViewController:messageController animated:YES completion:nil];
}


- (void)dismissSMSVC{
    [[self topViewController] dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MFMessageComposeViewControllerDelegate

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    switch (result)
    {
        case MessageComposeResultCancelled:
        {
            break;
        }
        case MessageComposeResultSent:
        {
            break;
        }
        default:
        {
            break;
        }
    }
    [self dismissSMSVC];
}

//获取顶部viewController
- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

#pragma mark -- 分享
/// 分享网页
/// @param webpageUrl 链接
/// @param type 分享类型 0：聊天界面 1：朋友圈 2：收藏
- (void)shareToWechatWithWebpageUrl:(NSString *)webpageUrl
                             type:(ShareType)type{
    
    // 检测是否安装了分享所需要的软件
    if (![self isInstalledShare:type]) {
        return;
    }
    
    WXMediaMessage * message = [WXMediaMessage message];
//    QTUserConfig * userConfig = [QTUserConfigManager shareConfigManager].userConfig;
//    message.title = [NSString stringWithFormat:@"\"%@\"邀请你加入青藤APP",userConfig.name];
//    message.description = @"安全加密的聊天APP，和重要的人畅聊重要的事!";
    [message setThumbImage:[UIImage imageNamed:@"icon_share_img"]];
    
    WXWebpageObject * wbpageObject = [WXWebpageObject object];
    wbpageObject.webpageUrl = webpageUrl;
    message.mediaObject = wbpageObject;
 
    [self sendToWeChatWithBtText:NO message:message scene:type];
    
}

/// 发送消息给微信
/// @param bText 发送消息的类型
/// @param message 发送消息的结构体
/// @param scene 分享的类型场景
- (void)sendToWeChatWithBtText:(BOOL)bText message:(WXMediaMessage *)message scene:(NSUInteger)scene {
    
    SendMessageToWXReq * req = [[SendMessageToWXReq alloc]init];
    req.bText = bText;
    req.message = message;
    req.scene = (int)scene;
    
    [WXApi sendReq:req completion:^(BOOL success) {
        
        // 分享成功或者失败的回调
//        if (success) {
//            [MBProgressHUD showSuccessMessage:LocaliedLgKey(@"分享成功")];
//        }
    }];
}


/// 分享QQ
/// @param webpageUrl 链接
/// @param type 分享类型 2：聊天界面 3：QQ朋友圈
- (void)shareToQQWithWebpageUrl:(NSString *)webpageUrl
                           type:(ShareType)type{
    // 检测是否安装了分享所需要的软件
    if (![self isInstalledShare:type]) {
        return;
    }

//   QTUserConfig * userConfig = [QTUserConfigManager shareConfigManager].userConfig;
//    UIImage *image = [UIImage imageNamed:@"icon_share_img"];
//    NSString *title = [NSString stringWithFormat:@"\"%@\"邀请你加入青藤APP",userConfig.name];
        UIImage *image = [UIImage imageNamed:@"btn_p_adds"];

    QQApiNewsObject *QQObject = [QQApiNewsObject objectWithURL:[NSURL URLWithString:@"https://developers.weixin.qq.com/doc/oplatform/Mobile_App/Access_Guide/iOS.html"]   title:@"title" description:@"安全加密的聊天APP，和重要的人畅聊重要的事!" previewImageData:UIImageJPEGRepresentation(image,1.0f)];
    QQBaseReq *qqReq = [SendMessageToQQReq reqWithContent:QQObject];
    if (type == ShareType_QQ) {
        QQApiSendResultCode code = [QQApiInterface sendReq:qqReq];
        NSLog(@"分享%d",code);
    }else if(type == ShareType_Message){
        [QQApiInterface SendReqToQZone:qqReq];
    }
    

}

@end
