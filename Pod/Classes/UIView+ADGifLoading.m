//
//  UIView+ADGifLoading.m
//  ThirtySixKr
//
//  Created by aidenluo on 14/12/30.
//  Copyright (c) 2014年 aidenluo. All rights reserved.
//  Edited by Paul Rolfe 2015.
//

#import "UIView+ADGifLoading.h"
#import <objc/runtime.h>

static char LoadingGifName;
static char LoadingView;

@implementation UIView (ADGifLoading)

- (void)ad_setLoadingImageGifName:(NSString *)name
{
    NSParameterAssert(name);
    objc_setAssociatedObject(self, &LoadingGifName, name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)ad_showLoading
{
    UIView *loadingView = objc_getAssociatedObject(self, &LoadingView);
    if (loadingView) {
        return;
    }
    
    NSString *name = objc_getAssociatedObject(self, &LoadingGifName);
    UIView *container = [[UIView alloc] initWithFrame:self.bounds];
    container.backgroundColor = [UIColor clearColor];
    container.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:container];
    
    UIImage *loadingImage = [[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:name]];
    UIImageView *loadingImageView = [[UIImageView alloc] initWithImage:[loadingImage.images firstObject]];
    loadingImageView.animationImages = loadingImage.images;
    loadingImageView.animationDuration = (CGFloat)ceilf(1.0/30 * (CGFloat)loadingImage.images.count);
    loadingImageView.animationRepeatCount = HUGE_VAL;
    [loadingImageView sizeToFit];
    loadingImageView.center = container.center;
    loadingImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [container addSubview:loadingImageView];
    [loadingImageView startAnimating];
    
    [self bringSubviewToFront:container];
    
    objc_setAssociatedObject(self, &LoadingView, container, OBJC_ASSOCIATION_ASSIGN);
}

- (void)ad_hideLoading
{
    UIView *loadingView = objc_getAssociatedObject(self, &LoadingView);
    [loadingView removeFromSuperview];
    objc_setAssociatedObject(self, &LoadingView, nil, OBJC_ASSOCIATION_ASSIGN);
}

@end
