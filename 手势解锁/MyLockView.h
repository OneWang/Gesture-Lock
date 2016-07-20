//
//  MyLockView.h
//  手势解锁
//
//  Created by LI on 16/2/3.
//  Copyright © 2016年 LI. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyLockView;

@protocol MyLockViewDelegate <NSObject>

@optional
- (void)lockView:(MyLockView *)lockView didFinishPath:(NSString *)path;

@end

@interface MyLockView : UIView

@property (weak, nonatomic) IBOutlet id<MyLockViewDelegate> delegate;

@end
