//
//  ViewController.m
//  手势解锁
//
//  Created by LI on 16/2/3.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "ViewController.h"
#import "MyLockView.h"

@interface ViewController ()<MyLockViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)lockView:(MyLockView *)lockView didFinishPath:(NSString *)path
{
    NSLog(@"获得用户手势路径:%@",path);
}


@end
