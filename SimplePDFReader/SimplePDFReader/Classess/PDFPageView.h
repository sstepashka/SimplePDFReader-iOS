//
//  PDFPageView.h
//  SimplePDFReader
//
//  Created by Dmitriy Kuragin on 3/5/13.
//  Copyright (c) 2013 Dmitriy Kuragin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFPageView : UIView

@property(nonatomic, assign) CGPDFPageRef PDFPage;

@end
