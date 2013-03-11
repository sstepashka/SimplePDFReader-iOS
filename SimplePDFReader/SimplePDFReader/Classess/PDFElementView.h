//
//  PDFElementView.h
//  SimplePDFReader
//
//  Created by Dmitriy Kuragin on 3/11/13.
//  Copyright (c) 2013 Dmitriy Kuragin. All rights reserved.
//

#import "PDFPageView.h"

@interface PDFElementView : UIView <UIScrollViewDelegate>

@property(nonatomic, strong) IBOutlet UIView *contentView;

@property(nonatomic, strong) IBOutlet PDFPageView *PDFPageViewFirst;
@property(nonatomic, strong) IBOutlet PDFPageView *PDFPageViewSecond;
@property(nonatomic, strong) IBOutlet UIScrollView *scrollView;

@end
