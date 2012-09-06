//
//  PageControl.m
//  getProcess
//
//  Created by Showyou Friends on 9/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PageControl.h"

@interface PageControl (Private)
- (void) updateDots;
@end

@implementation PageControl

@synthesize imageNormal = mImageNormal;
@synthesize imageCurrent = mImageCurrent;

- (void) dealloc
{
    mImageNormal = nil;
    mImageCurrent = nil;
    [super dealloc];
}


/** override to update dots */
- (void) setCurrentPage:(NSInteger)currentPage
{
    [super setCurrentPage:currentPage];
    
    // update dot views
    [self updateDots];
}

/** override to update dots */
- (void) updateCurrentPageDisplay
{
    [super updateCurrentPageDisplay];
    
    // update dot views
    [self updateDots];
}

/** Override setImageNormal */
- (void) setImageNormal:(UIImage*)image
{
    //[mImageNormal release];
    mImageNormal = nil;
    mImageNormal = image;
    
    // update dot views
    [self updateDots];
}

/** Override setImageCurrent */
- (void) setImageCurrent:(UIImage*)image
{
    //[mImageCurrent release];
    mImageCurrent = nil;
    mImageCurrent = image;
    
    // update dot views
    [self updateDots];
}

/** Override to fix when dots are directly clicked */
- (void) endTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event 
{
    [super endTrackingWithTouch:touch withEvent:event];
    
    [self updateDots];
}

#pragma mark - (Private)

- (void) updateDots
{
    if(mImageCurrent || mImageNormal)
    {
        // Get subviews
        NSArray* dotViews = self.subviews;
        for(int i = 0; i < dotViews.count; ++i)
        {
            UIImageView* dot = [dotViews objectAtIndex:i];
            // Set image
            dot.image = (i == self.currentPage) ? mImageCurrent : mImageNormal;
            dot.frame = CGRectMake(dot.frame.origin.x, dot.frame.origin.y, (mImageCurrent.size.width - 10), (mImageCurrent.size.height - 10));
        }
    }
}

@end