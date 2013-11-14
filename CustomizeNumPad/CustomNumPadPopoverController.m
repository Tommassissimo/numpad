//
//  CustomNumPadPopoverController.m
//  CustomizeNumPad
//
//  Created by jiayi zhou on 10/31/13.
//  Copyright (c) 2013 jiayi zhou. All rights reserved.
//

#import "CustomNumPadPopoverController.h"

@interface CustomNumPadPopoverController ()

- (IBAction)numberKeyPressed:(id)sender;

@end

@implementation CustomNumPadPopoverController
@synthesize delegate;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)numberKeyPressed:(id)sender
{
   NSString *digital = [[sender titleLabel] text];
     NSLog(@"Test------>,numberKeyPressed,%@",digital);
    if ([self.delegate respondsToSelector:@selector(numPadPopoverControll:sendString:)]) {
        [self.delegate numPadPopoverControll:self sendString:digital];
    }
    
}



@end
