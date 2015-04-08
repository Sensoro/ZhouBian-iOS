//
//  SelectButton.m
//  BeaconConfig
//
//  Created by skyming on 15/4/2.
//  Copyright (c) 2015年 Sensoro. All rights reserved.
//

#import "SelectButton.h"

@implementation SelectButton

- (void)setHighlighted:(BOOL)highlighted{
//    [super setHighlighted:highlighted];

    CGFloat bgColorAlpha = highlighted?0.1:0.3;
    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:bgColorAlpha];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
