//
//  KWXAppStoreTableView.m
//  KWXAppStoreTableView
//
//  Created by Michael Hurni on 20/10/2018.
//  Copyright © 2018 Michael Hurni. All rights reserved.
//

#import "KWXAppStoreTableView.h"

@interface KWXAppStoreTableView () {
    CGPoint initialOffset;
    BOOL isPressed;
}
@end

@implementation KWXAppStoreTableView

- (void)didTouchWithGestureReconizer:(UIGestureRecognizer *)g {
    if([self.delegate respondsToSelector:@selector(didTouchWithGestureReconizer:)]) {
        [self.delegate performSelector:@selector(didTouchWithGestureReconizer:) withObject:g];
        return;
    }
    
    // default behavior, call the original didSelectRowAtIndexPath delegation method
    NSIndexPath *indexPath;
    
    if([g isKindOfClass:UILongPressGestureRecognizer.class]) {
        indexPath = [self indexPathForRowAtPoint:[g locationInView:self]];
    } else {
        indexPath = [self indexPathForRowAtPoint:g.view.frame.origin];
    }
    
    if([self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.delegate tableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // Simultaneous UIScrollViewPanGestureRecognizer and UILongPressGestureRecognizer
    return ([gestureRecognizer isKindOfClass:UILongPressGestureRecognizer.class] ||
            [otherGestureRecognizer isKindOfClass:UILongPressGestureRecognizer.class]);
}

- (void)addGestureReconizersToView:(UIView *)view {
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    press.minimumPressDuration = 0.2;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tap.numberOfTapsRequired = 1;
    
    [view addGestureRecognizer:press];
    [view addGestureRecognizer:tap];
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer*)g {
    if (g.state == UIGestureRecognizerStateBegan) {
        if(isPressed) return;
        
        isPressed = YES;
        initialOffset = self.contentOffset;
        
        [UIView animateWithDuration:.5 delay:0
             usingSpringWithDamping:.8 initialSpringVelocity:.2
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{ g.view.transform = CGAffineTransformMakeScale(0.94, 0.94);
                             g.view.subviews.firstObject.subviews.firstObject.subviews.firstObject.transform = CGAffineTransformMakeScale(1.025, 1.025);}
                         completion:nil];
    }
    else if (g.state == UIGestureRecognizerStateEnded || g.state == UIGestureRecognizerStateCancelled) {
        if(isPressed == NO) return;
        [self didTouchWithGestureReconizer:g];
    }
    
    if ((g.state == UIGestureRecognizerStateEnded || g.state == UIGestureRecognizerStateCancelled) ||
        (g.state == UIGestureRecognizerStateChanged && fabs(self.contentOffset.y - initialOffset.y) > 40))
    {
        // Restore initial aspect
        [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.4 initialSpringVelocity:.2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{ g.view.transform = CGAffineTransformIdentity;
            g.view.subviews.firstObject.subviews.firstObject.subviews.firstObject.transform = CGAffineTransformIdentity;} completion:^(BOOL finished) { isPressed = NO; }];
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)g {
    [UIView animateWithDuration:.2 delay:0
         usingSpringWithDamping:.8 initialSpringVelocity:.2
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{ g.view.transform = CGAffineTransformMakeScale(0.98, 0.98); }
                     completion:^(BOOL finished) {
                         [self didTouchWithGestureReconizer:g];
                         // Restore initial aspect
                         [UIView animateWithDuration:.2 delay:0 usingSpringWithDamping:.4 initialSpringVelocity:.2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{ g.view.transform = CGAffineTransformIdentity; } completion:nil];
                     }];
}

@end
