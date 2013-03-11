//
//  PDFElementView.h
//  SimplePDFReader
//
//  Created by Dmitriy Kuragin on 3/11/13.
//  Copyright (c) 2013 Dmitriy Kuragin. All rights reserved.
//

#import "PDFPageView.h"

@interface PDFElementView : UIView <UIScrollViewDelegate>

@property(nonatomic, strong) IBOutlet PDFPageView *PDFPageView;
@property(nonatomic, strong) IBOutlet UIScrollView *scrollView;

@end
