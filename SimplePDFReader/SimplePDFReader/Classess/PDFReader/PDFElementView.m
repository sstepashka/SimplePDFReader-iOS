//
//  PDFElementView.m
//  SimplePDFReader
//
//  Created by Dmitriy Kuragin on 3/11/13.
//  Copyright (c) 2013 Dmitriy Kuragin. All rights reserved.
//

#import "PDFElementView.h"

@implementation PDFElementView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect scrollFrame = frame;
        scrollFrame.origin = CGPointZero;
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
        scrollView.maximumZoomScale = 5.f;
        scrollView.minimumZoomScale = 1.f;
        scrollView.delegate = self;
        
        [self setAutoresizesSubviews:YES];
        [self addSubview:scrollView];
        
        self.scrollView = scrollView;
        
        self.PDFPageView = [[PDFPageView alloc] initWithFrame:scrollFrame];
        
        UIViewAutoresizing autoresizing = UIViewAutoresizingFlexibleLeftMargin;
        autoresizing |= UIViewAutoresizingFlexibleWidth;
        autoresizing |= UIViewAutoresizingFlexibleRightMargin;
        autoresizing |= UIViewAutoresizingFlexibleTopMargin;
        autoresizing |= UIViewAutoresizingFlexibleHeight;
        autoresizing |= UIViewAutoresizingFlexibleBottomMargin;
        
        _PDFPageView.autoresizingMask = autoresizing;
        
        [_scrollView addSubview:_PDFPageView];
        [_scrollView setAutoresizesSubviews:YES];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        tap.numberOfTapsRequired = 2;
        tap.numberOfTouchesRequired = 1;
        [_scrollView addGestureRecognizer:tap];
    }
    
    return self;
}

- (void)tapGesture:(UITapGestureRecognizer*)gesture {
    if (_scrollView.zoomScale > _scrollView.minimumZoomScale) {
        [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:YES];
    } else {
        CGPoint location = [gesture locationInView:_scrollView];
        
        CGRect zoomRect = [self zoomRectForScale:_scrollView.maximumZoomScale withCenter:location];
        [_scrollView zoomToRect:zoomRect animated:YES];
    }
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    zoomRect.size.height = [_PDFPageView frame].size.height / scale;
    zoomRect.size.width  = [_PDFPageView frame].size.width  / scale;
    
    center = [_PDFPageView convertPoint:center fromView:self];
    
    zoomRect.origin.x    = center.x - ((zoomRect.size.width / 2.0));
    zoomRect.origin.y    = center.y - ((zoomRect.size.height / 2.0));
    
    return zoomRect;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _PDFPageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView.zoomScale <= 1.f) {
        UIView *view = [self viewForZoomingInScrollView:scrollView];
        CGPoint center = CGPointMake(scrollView.frame.size.width / 2.f, scrollView.frame.size.height / 2.f);
        [view setCenter:center];
    }
}

@end
