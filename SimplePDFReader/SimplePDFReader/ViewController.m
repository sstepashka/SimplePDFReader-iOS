//
//  ViewController.m
//  SimplePDFReader
//
//  Created by Dmitriy Kuragin on 3/5/13.
//  Copyright (c) 2013 Dmitriy Kuragin. All rights reserved.
//

#import "ViewController.h"
#import "PDFViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)start:(id)sender
{
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tennis-life-2011-09-sep" ofType:@"pdf"]];
    
    PDFViewController *controller = [[PDFViewController alloc] initWithPDFData:data];
    [self presentViewController:controller animated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
