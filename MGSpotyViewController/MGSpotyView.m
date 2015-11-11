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

        if ([self mg_existActionsOnSubviewsOfView:_overview underPoint:convertedPoint]) {
            return [_overview hitTest:convertedPoint withEvent:event];
        }
    }
    
    return [super hitTest:point withEvent:event];
}

- (BOOL)mg_existActionsOnSubviewsOfView:(__kindof UIView *)mainView underPoint:(CGPoint)point
{
    for (id subview in mainView.subviews) {
        if ([self mg_deepExistActionsOnSubviewsOfView:subview underPoint:point]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)mg_deepExistActionsOnSubviewsOfView:(__kindof UIView *)mainView underPoint:(CGPoint)point
{
    UIView *view = mainView;
    
    if (!CGRectContainsPoint(view.bounds, point)) {
        return NO;
    }
    
    if (view.gestureRecognizers.count > 0) {
        return YES;
    }
    
    if ([mainView isKindOfClass:[UIControl class]]) {
        UIControl *control = mainView;
        if (control.allTargets > 0) {
            return YES;
        }
    }
    
    // Check if is in a subview of the _overview
    for (id subview in view.subviews) {
        CGPoint newPoint = [subview convertPoint:point fromView:mainView];
        if ([self mg_deepExistActionsOnSubviewsOfView:subview underPoint:newPoint]) {
            return YES;
        }
    }
    
    return NO;
}

@end
