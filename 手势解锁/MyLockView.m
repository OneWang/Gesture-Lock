//
//  MyLockView.m
//  手势解锁
//
//  Created by LI on 16/2/3.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "MyLockView.h"
#import "MyCircleView.h"

@interface MyLockView ()<MyLockViewDelegate>

@property (strong, nonatomic) NSMutableArray *selectedButtons;

@property (assign, nonatomic) CGPoint currentMovePoint;

@end

@implementation MyLockView

- (NSMutableArray *)selectedButtons
{
    if (_selectedButtons == nil) {
        _selectedButtons = [NSMutableArray array];
    }
    return _selectedButtons;
}


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
    
    for (int index = 0; index < 9; index ++) {
        
        MyCircleView * button = [MyCircleView buttonWithType:UIButtonTypeCustom];
        
        button.tag = index;
        
        [self addSubview:button];
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int index = 0; index < self.subviews.count; index ++) {
        
        MyCircleView * btn = self.subviews[index];
        
        //设置frame
        CGFloat btnW = 74;
        CGFloat btnH = 74;
        NSInteger totalColumns = 3;
        NSInteger col = index % totalColumns;
        NSInteger row = index / totalColumns;
        CGFloat marginX = (self.frame.size.width - totalColumns * btnW) / (totalColumns + 1);
        CGFloat marginY = marginX;
        CGFloat btnX = marginX + col * (btnW + marginX);
        CGFloat btnY = row * (btnH + marginY);
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
}

#pragma mark - 私有方法
/**
 *  根据touches集合获得对应的触摸点的位置
 */
- (CGPoint)pointWithTouches:(NSSet *)touches{
    UITouch * touch = [touches anyObject];
    return [touch locationInView:touch.view];
}

/**
 *  根据触摸点位置获得对应的按钮
 */
- (MyCircleView *)buttonWithPoint:(CGPoint)point{
    for (MyCircleView * button in self.subviews) {
        
        CGFloat width = 24;
        CGFloat frameX = button.center.x - width * 0.5;
        CGFloat frameY = button.center.y - width * 0.5;
        
        if (CGRectContainsPoint(CGRectMake(frameX, frameY, width, width), point)) {
            return button;
        }
    }
    return nil;
}

#pragma mark - 触摸方法

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //清空当前的触摸点
    self.currentMovePoint = CGPointMake(-10, -10);
    
    //1.获得触摸点
    CGPoint pos = [self pointWithTouches:touches];
    //2.获得触摸的按钮
    MyCircleView * button = [self buttonWithPoint:pos];
    //3.设置按钮状态
    //数组和字典加东西的时候要考虑是否为空
    if(button && button.selected == NO){
        button.selected = YES;
        [self.selectedButtons addObject:button];
    }
    //4.刷新
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //1.获得触摸点
    CGPoint pos = [self pointWithTouches:touches];
    //2.获得触摸的按钮
    MyCircleView * button = [self buttonWithPoint:pos];
    //3.设置按钮状态
    if(button && button.selected == NO){//摸到按钮
        button.selected = YES;
        [self.selectedButtons addObject:button];
    }else{//没有摸到按钮
        self.currentMovePoint = pos;
    }
    //4.刷新
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    if ([self.delegate respondsToSelector:@selector(lockView:didFinishPath:)]) {
        NSMutableString * path = [NSMutableString string];
        for (MyCircleView * button  in self.selectedButtons) {
            [path appendFormat:@"%ld",button.tag];
        }
        [self.delegate lockView:self didFinishPath:path];
    }
    
    //通知代理
    
    //取消选中所有的按钮
    //第一种做法
   for (MyCircleView * btn in self.selectedButtons) {
        btn.selected = NO;
    }
    //第二种做法
//    [self.selectedButtons makeObjectsPerformSelector:@selector(setSelected:) withObject:@(NO)];
    
    //清空选中的按钮
    [self.selectedButtons removeAllObjects];
    
    [self setNeedsDisplay];

}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

#pragma mark - 绘图
- (void)drawRect:(CGRect)rect
{
    if (self.selectedButtons.count == 0) return;
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    //遍历所有按钮
    for (int index = 0; index < self.selectedButtons.count; index++) {
        MyCircleView * btn = self.selectedButtons[index];
        
        if (index == 0) {
            [path moveToPoint:btn.center];
        }else{
            [path addLineToPoint:btn.center];
        }
    }
    
    //连接
    if (CGPointEqualToPoint(self.currentMovePoint, CGPointMake(-10, -10)) == NO) {
        [path addLineToPoint:self.currentMovePoint];
    }
    
    //绘图
    path.lineWidth = 8;
    [[UIColor colorWithRed:32/255.0 green:210/255.0 blue:254/255.0 alpha:.7] set];
    path.lineJoinStyle = kCGLineJoinBevel;
    [path stroke];
    
}

@end
