//
//  MGSpotyView.m
//  MGSpotyView
//
//  Created by Matteo Gobbi on 01/03/2015.
//  Copyright (c) 2015 Matteo Gobbi. All rights reserved.
//

#import "MGSpotyView.h"

@implementation MGSpotyView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGFloat offsetY = _overview.frame.origin.y + _tableView.contentOffset.y;
    
    CGRect rect = {_overview.frame.origin, {_overview.frame.size.width, _overview.frame.size.height-offsetY}};
    
    if (CGRectContainsPoint(rect, point)) {
        CGPoint convertedPoint = [_overview convertPoint:point fromView:self];
        return [_overview hitTest:convertedPoint withEvent:event];;
    }
    
    return [super hitTest:point withEvent:event];
}

@end
