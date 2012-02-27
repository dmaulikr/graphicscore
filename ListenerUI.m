//
//  ListenerUI.m
//  graphicscore
//
//  Created by Zebedee Pedersen on 27/02/2012.
//  Copyright (c) 2012 zebpedersen. All rights reserved.
//

#import "ListenerUI.h"

@interface ListenerUI ()

@end

@implementation ListenerUI
@synthesize delegate;

-(void)dismissViewAfterAnimationCompletion	{
	//	Dismiss view
	[self dismissModalViewControllerAnimated:NO];
	
	//	Trigger restoration of main screen UI elements
	[delegate restoreMainScreenFromUserSession];
}

-(void)triggerDismissalProcedure	{
	//	1:	Fade elements from screen 
//	[self fadeViewFromScreen];
	
	NSLog(@"Listener Dismissed");
	
	//	2:	Dismiss and destroy view after animations completed
	[self performSelector:@selector(dismissViewAfterAnimationCompletion) withObject:Nil afterDelay:1.15];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil	{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		
    }
    return self;
}

-(id)initWithDelegate:(id)_d	{
	self = [super initWithNibName:nil bundle:nil];
	if (self)	{
		[self.view setBackgroundColor:[UIColor orangeColor]];
//		CGRect frameFromParentViewController = [[[self parentViewController] view] frame];
//		[self.view setFrame:frameFromParentViewController];
		[self.view setFrame:CGRectMake(0, 0, 100, 100)];
		delegate = _d;
		NSLog(@"Listener Loaded");
		[self triggerDismissalProcedure];
	}
	return self;
}

- (void)loadView	{
    // Implement loadView to create a view hierarchy programmatically, without using a nib.
}

- (void)viewDidLoad	{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	NSLog(@"Listener view loaded");
}

- (void)viewDidUnload	{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
