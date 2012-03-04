//
//  UserScreen.m
//  graphicscore
//
//  Created by Zebedee Pedersen on 14/12/2011.
//  Copyright (c) 2011 zebpedersen. All rights reserved.
//

#import "ListenerUI.h"

@implementation ListenerUI
@synthesize delegate, exitButtonImage, audioController, parameteriser, networkController, updateRemote;

//	Alert view delegate methods

-(void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex	{
	[self triggerDismissalProcedure];
	NSLog(@"Connection unavailable");
}

/*
 View dismissal / init animation
 */
-(void)fadeViewToScreen	{
	[UIView beginAnimations:@"Fade in view" context:nil];
	[UIView setAnimationDelay:0.0];
	[UIView setAnimationDuration:1.15];
	
	//	Fade view and background alpha to 100%
	self.view.alpha					= 1.0;
	userBackground_imageView.alpha	= .75;
	
	[exitButtonImage	setFrame:CGRectMake(418, 15, 44, 44)];	
		
	exitButtonImage.alpha	= .6;	
	
	remote.alpha = 1.0;
	
	[audioController togglePlayback];
	
	[UIView commitAnimations];
}

-(void)fadeViewFromScreen	{
	[UIView beginAnimations:@"Fade out view" context:nil];
	[UIView setAnimationDelay:0.0];
	[UIView setAnimationDuration:1.15];
	
	//	Fade view and background alpha to transparent
	self.view.alpha					= 0.0;
	userBackground_imageView.alpha	= 0.0;
	
	[exitButtonImage	setFrame:CGRectMake(418-15, 18, 44, 44)];		
	
	exitButtonImage.alpha	= 0.0;	
	
	remote.alpha = .0;
	
	[audioController togglePlayback];
	
	[UIView commitAnimations];
}

-(void)dismissViewAfterAnimationCompletion	{
	//	Stop audio unit
	[audioController closeAudioUnit];
	
	//	Dismiss view
	[self dismissModalViewControllerAnimated:NO];
	
	//	Trigger restoration of main screen UI elements
	[delegate restoreMainScreenFromUserSession];	
}

-(void)triggerDismissalProcedure	{
	//	1:	Fade elements from screen 
	[self fadeViewFromScreen];
	
	
	NSLog(@"DISMISSED");
	
	//	2:	Invalidate ping timer
	[[remote pingTimer] invalidate];
	
	//	3:	Dismiss and destroy view after animations completed
	[self performSelector:@selector(dismissViewAfterAnimationCompletion) withObject:Nil afterDelay:1.15];
}


////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil	{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		//	Set view totally transparent for fade in effect
		self.view.alpha = 0.0;
		self.view.backgroundColor = [UIColor whiteColor];
		
		//	Create & add background image
		userBackground_image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"background" ofType:@"png"]];
		userBackground_imageView = [[UIImageView alloc] initWithImage:userBackground_image];
		[userBackground_imageView setFrame:CGRectMake(0, 0, userBackground_image.size.width, userBackground_image.size.height)];
		[self.view addSubview:userBackground_imageView];
		
		/*
		 Create network controller
		 */
		networkController = [[GSNetworkController alloc] initForListener];
		
		if ([networkController session_id]!=0)	{
			/*
			 Create audio controller
			 */
			audioController = [[CAController alloc] init];
			[audioController initAudioController];
			[audioController startAudioUnit];
			
			/*
			 Create parameteriser
			 */
			parameteriser = [[Parameteriser alloc] initWithDelegate:audioController];
			
			
			/*
			 Create & add remoteMonitor
			 */
			remote = [[RemoteMonitor alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) andDelegate:parameteriser andNetworkController:networkController];
			remote.alpha = .0;
			[self.view addSubview:remote];
			
			//	EXIT
			exitButton = [UIButton buttonWithType:UIButtonTypeCustom];	
			[exitButton addTarget:self action:@selector(triggerDismissalProcedure) forControlEvents:UIControlEventTouchUpInside];
			[exitButton setFrame:CGRectMake(418, 18, 44, 44)];
			[self.view addSubview:exitButton];
			
			exitButtonImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"exit_button" ofType:@"png"]]];
			[exitButtonImage setFrame:CGRectMake(418-15, 18, 44, 44)];
			exitButtonImage.alpha = 0.0;		
			[exitButtonImage.layer setMasksToBounds:YES];
			exitButtonImage.layer.cornerRadius = 24.0f;
			[self.view addSubview:exitButtonImage];
			
			//	Fade in UI elements
			[self fadeViewToScreen];
		}
		
		else {
			UIAlertView* connectionError = [[UIAlertView alloc] initWithTitle:@"Connection error" message:@"The server is unreachable" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
			[connectionError show];
		}
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)didReceiveMemoryWarning	{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
- (void)viewDidUnload	{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation	{
	if (interfaceOrientation==UIInterfaceOrientationLandscapeRight || interfaceOrientation==UIInterfaceOrientationLandscapeLeft)
		return YES;
	else return NO;
}

@end
