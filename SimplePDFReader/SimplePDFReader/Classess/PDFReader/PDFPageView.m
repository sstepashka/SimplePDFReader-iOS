//
//  PDFPageView.m
//  SimplePDFReader
//
//  Created by Dmitriy Kuragin on 3/5/13.
//  Copyright (c) 2013 Dmitriy Kuragin. All rights reserved.
//

#import "PDFPageView.h"
#import <QuartzCore/QuartzCore.h>

@interface FastCATiledLayer : CATiledLayer
@end

@implementation FastCATiledLayer

- (id)init
{
    if ((self = [super init]))
    {
        self.levelsOfDetail = 4;
        self.levelsOfDetailBias = 3;
        self.tileSize = CGSizeMake(512.0, 512.0);
    }
    
    return self;
}

//+ (CFTimeInterval)fadeDuration
//{
//    return 0.0;
//}

@end

@implementation PDFPageView

- (void)setPDFPage:(CGPDFPageRef)PDFPage
{
    _PDFPage = PDFPage;
    [self setNeedsDisplay];
}

+ (Class)layerClass
{
    return [FastCATiledLayer class];
}

-(void)drawRect:(CGRect)rect
{

}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context
{
    CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f);
    CGContextFillRect(context, CGContextGetClipBoundingBox(context));
    CGContextTranslateCTM(context, 0.0f, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGContextConcatCTM(context, CGPDFPageGetDrawingTransform(_PDFPage, kCGPDFCropBox, self.bounds, 0, true));
    CGContextDrawPDFPage(context, _PDFPage);
}

@end
