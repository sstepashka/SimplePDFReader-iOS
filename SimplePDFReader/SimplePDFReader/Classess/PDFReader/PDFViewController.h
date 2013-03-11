//
//  PDFViewController.h
//  SimplePDFReader
//
//  Created by Dmitriy Kuragin on 3/5/13.
//  Copyright (c) 2013 Dmitriy Kuragin. All rights reserved.
//

#import "SwipeView.h"


@interface PDFViewController : UIViewController <SwipeViewDataSource, SwipeViewDelegate>

@property(nonatomic, strong) IBOutlet SwipeView *swipeView;

@property(nonatomic, strong) NSData *pdfData;

- (instancetype)initWithPDFData:(NSData *)pdfData;

@end
