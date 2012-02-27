//
//  ViewController.m
//  graphicscore
//
//  Created by Zebedee Pedersen on 14/12/2011.
//  Copyright (c) 2011 zebpedersen. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
////////////////////////////////////////////////////////////////////////////////////////

-(void)restoreMainScreenFromUserSession	{	
	[UIView beginAnimations:@"Fade in" context:nil];
	[UIView setAnimationDelay:0.0];
	[UIView setAnimationDuration:1.0];
	
	//	Restore the background
	mainScreenBackground_ImageView.alpha = 1.0;
	
	//	Restore the logo
	logo_ImageView.alpha = 1.0;
	[logo_ImageView setFrame:CGRectMake(90, 60, 300, 100)];
	
	//	Restore the start button
	startButton.alpha = 1.0;
	[startButton setFrame:CGRectMake(140, 160, 100, 40)];	
	
	//	Restore the listen button
	[listenModeButton setFrame:CGRectMake(240, 210, 100, 40)];
	listenModeButton.alpha = 1.0;

	//	Restore the view
	self.view.alpha = 1.0;
	
	//	Begin the animations
	[UIView commitAnimations];
	NSLog(@"RESTORED");
}


-(void)fadeImage:(UIImageView*)viewToDissolve withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait	{
	[UIView beginAnimations:@"Fade Out" context:nil];
	[UIView setAnimationDelay:wait];
	[UIView setAnimationDuration:duration];

	//	Dissolve the background image
	viewToDissolve.alpha = 0.0;
	
	//	Dissolve and move the logo 
	logo_ImageView.alpha = 0.0;
	[logo_ImageView setFrame:CGRectMake(90, 50, 300, 100)];
	
	//	Dissolve the view itself
	self.view.alpha = 0.0;
	
	[UIView commitAnimations];
}

-(void)dismissButtonFromView:(UIButton*)buttonToMove withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait withTargetPosition:(CGPoint)t	{
	[UIView beginAnimations:@"Dismiss Start Button" context:nil];
	[UIView setAnimationDelay:wait];
	[UIView setAnimationDuration:duration];
	buttonToMove.frame = CGRectMake(t.x, t.y, 100, 40);
	buttonToMove.alpha = 0.0;
	[UIView commitAnimations];
}

-(void)presentUserSession	{
	UserScreen* userScreen	= [[UserScreen alloc] init];
	userScreen.delegate		= self;
	[self presentModalViewController:userScreen animated:NO];	
}

-(void)beginNewSession	{
	[self fadeImage:mainScreenBackground_ImageView withDuration:1.15 andWait:0.0];
	[self dismissButtonFromView:startButton withDuration:1.0 andWait:0.15 withTargetPosition:CGPointMake(-50, 160)];
	[self dismissButtonFromView:listenModeButton withDuration:1.0 andWait:0.15 withTargetPosition:CGPointMake(530, 220)];
	[self performSelector:@selector(presentUserSession) withObject:Nil afterDelay:1.15];
}

//	LISTENING SESSION

-(void)presentListeningSession	{
//	ListenerUI* listenerScreen	= [[ListenerUI alloc] init];
//	listenerScreen.delegate		= self;
//	[self presentModalViewController:listenerScreen animated:YES];
}

-(void)beginNewListeningSession	{
	NSLog(@"Present listening session!");
	[self fadeImage:mainScreenBackground_ImageView withDuration:1.15 andWait:0.0];
	[self dismissButtonFromView:startButton withDuration:1.0 andWait:0.15 withTargetPosition:CGPointMake(-50, 160)];
	[self dismissButtonFromView:listenModeButton withDuration:1.0 andWait:0.15 withTargetPosition:CGPointMake(530, 220)];
	[self performSelector:@selector(presentListeningSession) withObject:Nil afterDelay:1.15];
}

////////////////////////////////////////////////////////////////////////////////////////

- (void)didReceiveMemoryWarning	{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad	{
 	[super viewDidLoad];

	//	Init background transparent for fade in
	self.view.alpha = 0.0;
	
	//	Main screen background init
	//	1:	Load the image
	mainScreenBackground_Image =	[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"background" ofType:@"png"]];

	//	2:	Init the UIImageView with the image
	mainScreenBackground_ImageView=	[[UIImageView alloc] initWithImage:mainScreenBackground_Image];

	//	3:	Size and position the image view.
	[mainScreenBackground_ImageView setFrame:CGRectMake(0, 0, mainScreenBackground_Image.size.width, mainScreenBackground_Image.size.height)];
	//	4:	Add to main view
	[self.view addSubview:mainScreenBackground_ImageView];
	
	
	//	Add the logo
	//	1:	Load the logo image
	logo_Image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"]];
	
	//	2:	Add to the image view
	logo_ImageView = [[UIImageView alloc] initWithImage:logo_Image];
	
	//	3:	Set position on the screen
	[logo_ImageView setFrame:CGRectMake(90, 60, 300, 100)];
	
	//	4:	Add to the main view
	[self.view addSubview:logo_ImageView];
	
	
	//	Start button init
	//	1:	Load the state images
	UIImage *startButtonImageDefault =	[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"start" ofType:@"png"]];
	UIImage *startButtonImagePressed =	[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"start_pressed" ofType:@"png"]];
	//	2:	Init the button as custom type
	startButton = [UIButton buttonWithType:UIButtonTypeCustom];
	//	3:	Set position on screen
	[startButton setFrame:CGRectMake(140, 160, 100, 40)];
	
	//	4:	Add the images for states
	[startButton setImage:startButtonImageDefault forState:UIControlStateNormal];
	[startButton setImage:startButtonImagePressed forState:UIControlStateHighlighted];	
	//	5:	Add target actions for the button (touchUpInside)
	[startButton addTarget:self action:@selector(beginNewSession) forControlEvents:UIControlEventTouchUpInside];
	//	6:	Add the button to the main view
	[self.view addSubview:startButton];
	
	
	//	Listening mode
	UIImage *listenButtonImageDefault = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"listen" ofType:@"png"]];
	UIImage *listenButtonImagePressed = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"listen_pressed" ofType:@"png"]];

	listenModeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[listenModeButton setImage:listenButtonImageDefault forState:UIControlStateNormal];
	[listenModeButton setImage:listenButtonImagePressed forState:UIControlStateHighlighted];
	[listenModeButton setFrame:CGRectMake(240, 210, 100, 40)];
	[listenModeButton addTarget:self action:@selector(beginNewListeningSession) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:listenModeButton];
	
	//	Commit animations
	[self restoreMainScreenFromUserSession];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	if (interfaceOrientation==UIInterfaceOrientationLandscapeRight || interfaceOrientation==UIInterfaceOrientationLandscapeLeft)	{
		return YES;
	}
	else return NO;}

@end
