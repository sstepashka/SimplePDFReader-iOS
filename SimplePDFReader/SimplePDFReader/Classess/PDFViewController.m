//
//  PDFViewController.m
//  SimplePDFReader
//
//  Created by Dmitriy Kuragin on 3/5/13.
//  Copyright (c) 2013 Dmitriy Kuragin. All rights reserved.
//

#import "PDFViewController.h"
#import "PDFPageView.h"
#import "PDFElementView.h"
#import <QuartzCore/QuartzCore.h>

@interface PDFViewController ()

@property(nonatomic, assign) CGPDFDocumentRef documentRef;

@end

@implementation PDFViewController

- (instancetype)initWithPDFData:(NSData *)pdfData
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        self.pdfData = pdfData;
        
        CFDataRef myPDFData = (__bridge CFDataRef)_pdfData;
        CGDataProviderRef provider = CGDataProviderCreateWithCFData(myPDFData);
        self.documentRef = CGPDFDocumentCreateWithProvider(provider);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _swipeView.alignment = SwipeViewAlignmentEdge;
    _swipeView.pagingEnabled = YES;
    _swipeView.wrapEnabled = NO;
    _swipeView.itemsPerPage = 1;
    _swipeView.truncateFinalPage = YES;
}

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    NSInteger count = CGPDFDocumentGetNumberOfPages(_documentRef);
    return count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    PDFElementView *elementView = (PDFElementView *)view;
    elementView.PDFPageViewFirst.layer.contents = nil;
    elementView.PDFPageViewSecond.layer.contents = nil;
    
    if (elementView == nil)
    {
        elementView = [[PDFElementView alloc] initWithFrame:swipeView.frame];
        
        UIViewAutoresizing autoresizing = UIViewAutoresizingFlexibleLeftMargin;
        autoresizing |= UIViewAutoresizingFlexibleWidth;
        autoresizing |= UIViewAutoresizingFlexibleRightMargin;
        autoresizing |= UIViewAutoresizingFlexibleTopMargin;
        autoresizing |= UIViewAutoresizingFlexibleHeight;
        autoresizing |= UIViewAutoresizingFlexibleBottomMargin;
        
        elementView.autoresizingMask = autoresizing;
    }
    
    [elementView setFrame:swipeView.frame];
    
    
    [elementView.scrollView setZoomScale:1.f];
    
    if (UIInterfaceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
        elementView.PDFPageViewFirst.PDFPage = CGPDFDocumentGetPage(_documentRef, index * 2 + 1);
        elementView.PDFPageViewSecond.PDFPage = CGPDFDocumentGetPage(_documentRef, index * 2 + 2);
        [elementView.PDFPageViewSecond setNeedsDisplay];
        [elementView.PDFPageViewSecond setNeedsLayout];
    } else {
        elementView.PDFPageViewFirst.PDFPage = CGPDFDocumentGetPage(_documentRef, index + 1);
    }
    
    [elementView.PDFPageViewFirst setNeedsDisplay];
    [elementView.PDFPageViewFirst setNeedsLayout];
    
    return elementView;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return swipeView.frame.size;
}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView
{

}

- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"Selected item at index %i", index);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSInteger currentItemIndex = 0;
    if (UIInterfaceOrientationIsLandscape(fromInterfaceOrientation)) {
        currentItemIndex = _swipeView.currentItemIndex * 2;
    } else {
        currentItemIndex = _swipeView.currentItemIndex / 2;
    }
    [_swipeView reloadData];
    [_swipeView scrollToItemAtIndex:currentItemIndex duration:0.f];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)dealloc
{
    CGPDFDocumentRelease(_documentRef);
}

@end
