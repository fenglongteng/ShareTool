//
//  QTViewController.m
//  ShareTool
//
//  Created by 冯龙腾 on 11/08/2021.
//  Copyright (c) 2021 冯龙腾. All rights reserved.
//

#import "QTViewController.h"
#import <ShareTool/ShareSDKTool.h>

@interface QTViewController ()

@end

@implementation QTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[ShareSDKTool Shared] shareToQQWithWebpageUrl:@"sfsf" type:ShareType_QQ];
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
