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
        
        self.contentView = [[UIView alloc] initWithFrame:scrollFrame];
        
        UIViewAutoresizing autoresizing = UIViewAutoresizingFlexibleLeftMargin;
        autoresizing |= UIViewAutoresizingFlexibleWidth;
        autoresizing |= UIViewAutoresizingFlexibleRightMargin;
        autoresizing |= UIViewAutoresizingFlexibleTopMargin;
        autoresizing |= UIViewAutoresizingFlexibleHeight;
        autoresizing |= UIViewAutoresizingFlexibleBottomMargin;
        
        _contentView.autoresizingMask = autoresizing;
        
        [_scrollView addSubview:_contentView];
        [_scrollView setAutoresizesSubviews:YES];
        
        self.PDFPageViewFirst = [[PDFPageView alloc] initWithFrame:scrollFrame];
        self.PDFPageViewSecond = [[PDFPageView alloc] initWithFrame:scrollFrame];
        
        [_contentView addSubview:_PDFPageViewSecond];
        [_contentView addSubview:_PDFPageViewFirst];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        tap.numberOfTapsRequired = 2;
        tap.numberOfTouchesRequired = 1;
        [_scrollView addGestureRecognizer:tap];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [UIView animateWithDuration:0.2f animations:^{
        BOOL isLandscape = UIInterfaceOrientationIsLandscape([[UIDevice currentDevice] orientation]);
        
        if (isLandscape) {
            CGRect frameFirstPage = _contentView.frame;
            frameFirstPage.size.width /= 2.f;
            
            CGRect frameSecondPage = _contentView.frame;
            frameSecondPage.size.width /= 2.f;
            frameSecondPage.origin.x = _contentView.frame.size.width / 2.f;
            
            _PDFPageViewFirst.frame = frameFirstPage;
            _PDFPageViewSecond.frame = frameSecondPage;
        } else {
            CGRect frame = _contentView.frame;
            _PDFPageViewFirst.frame = frame;
        }
    }];
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
    
    zoomRect.size.height = [_contentView frame].size.height / scale;
    zoomRect.size.width  = [_contentView frame].size.width  / scale;
    
    center = [_contentView convertPoint:center fromView:self];
    
    zoomRect.origin.x    = center.x - ((zoomRect.size.width / 2.0));
    zoomRect.origin.y    = center.y - ((zoomRect.size.height / 2.0));
    
    return zoomRect;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _contentView;
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
