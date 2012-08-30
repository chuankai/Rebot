//
//  ViewController.m
//  Rebot
//
//  Created by Lin Chuankai on 8/31/12.
//  Copyright (c) 2012 KILAB. All rights reserved.
//

#import "ViewController.h"
#import "IPenController.h"

@interface ViewController ()
{
    IPenController *controller;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    controller = [IPenController sharedController];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
- (IBAction)switchToggled:(id)sender
{
    if (((UISwitch*)sender).isOn)
        [controller start];
    else
        [controller stop];

}

@end
