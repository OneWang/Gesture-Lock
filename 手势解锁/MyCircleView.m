//
//  MyCircleView.m
//  手势解锁
//
//  Created by LI on 16/2/3.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "MyCircleView.h"

@implementation MyCircleView

//初始化

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup{

    self.userInteractionEnabled = NO;
    
    [self setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
    
    [self setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];

}

@end
