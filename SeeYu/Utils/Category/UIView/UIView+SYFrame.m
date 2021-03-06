//
//  UIView+SYFrame.m
//  SYDevLibExample
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import "UIView+SYFrame.h"

@implementation UIView (SYFrame)

- (void)setSy_x:(CGFloat)sy_x
{
    CGRect frame = self.frame;
    frame.origin.x = sy_x;
    self.frame = frame;
}
- (CGFloat)sy_x
{
    return self.frame.origin.x;
}




- (void)setSy_y:(CGFloat)sy_y
{
    CGRect frame = self.frame;
    frame.origin.y = sy_y;
    self.frame = frame;
}
- (CGFloat)sy_y
{
    return self.frame.origin.y;
}




- (void)setSy_centerX:(CGFloat)sy_centerX
{
    CGPoint center = self.center;
    center.x = sy_centerX;
    self.center = center;
}
- (CGFloat)sy_centerX
{
    return self.center.x;
}



- (void)setSy_centerY:(CGFloat)sy_centerY
{
    CGPoint center = self.center;
    center.y = sy_centerY;
    self.center = center;
}
- (CGFloat)sy_centerY
{
    return self.center.y;
}




- (void)setSy_width:(CGFloat)sy_width
{
    CGRect frame = self.frame;
    frame.size.width = sy_width;
    self.frame = frame;
}
- (CGFloat)sy_width
{
    return self.frame.size.width;
}





- (void)setSy_height:(CGFloat)sy_height
{
    CGRect frame = self.frame;
    frame.size.height = sy_height;
    self.frame = frame;
}
- (CGFloat)sy_height
{
    return self.frame.size.height;
}





- (void)setSy_size:(CGSize)sy_size
{
    CGRect frame = self.frame;
    frame.size = sy_size;
    self.frame = frame;
}
- (CGSize)sy_size
{
    return self.frame.size;
}





- (void)setSy_origin:(CGPoint)sy_origin
{
    CGRect frame = self.frame;
    frame.origin = sy_origin;
    self.frame = frame;
}
- (CGPoint)sy_origin
{
    return self.frame.origin;
}


- (void)setSy_top:(CGFloat)sy_top
{
    CGRect frame = self.frame;
    frame.origin.y = sy_top;
    self.frame = frame;
}
- (CGFloat)sy_top
{
    return self.frame.origin.y;
}


- (void)setSy_left:(CGFloat)sy_left
{
    CGRect frame = self.frame;
    frame.origin.x = sy_left;
    self.frame = frame;
}
- (CGFloat)sy_left
{
    return self.frame.origin.x;
}


- (void)setSy_bottom:(CGFloat)sy_bottom
{
    CGRect frame = self.frame;
    frame.origin.y = sy_bottom - frame.size.height;
    self.frame = frame;
}
- (CGFloat)sy_bottom{
    return self.frame.origin.y + self.frame.size.height;
}


- (void)setSy_right:(CGFloat)sy_right
{
    CGRect frame = self.frame;
    frame.origin.x = sy_right - frame.size.width;
    self.frame = frame;
}
- (CGFloat)sy_right{
    return self.frame.origin.x + self.frame.size.width;
}

@end
