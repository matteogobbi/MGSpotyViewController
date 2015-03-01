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
    CGRect rect = {_overview.frame.origin, {_overview.frame.size.width, _overview.frame.size.height-_tableView.contentOffset.y}};
    
    if (CGRectContainsPoint(rect, point)) {
        return [_overview hitTest:point withEvent:event];;
    }
    
    return [super hitTest:point withEvent:event];
}

@end
