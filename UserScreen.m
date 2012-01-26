//
//  UserScreen.m
//  graphicscore
//
//  Created by Zebedee Pedersen on 14/12/2011.
//  Copyright (c) 2011 zebpedersen. All rights reserved.
//

#import "UserScreen.h"

@implementation UserScreen
@synthesize delegate;

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
	touchpad.alpha					= 1.0;
	
	//	Buttons fade in and move, slightly.
	[selectBrown	setFrame:CGRectMake(18,  258, 44, 44)];	
	[selectBlue		setFrame:CGRectMake(98,  258, 44, 44)];
	[selectYellow	setFrame:CGRectMake(178, 258, 44, 44)];
	[selectRed		setFrame:CGRectMake(258, 258, 44, 44)];
	[selectGreen	setFrame:CGRectMake(338, 258, 44, 44)];
	
	[exitButton		setFrame:CGRectMake(418, 258, 44, 44)];
	
	
	selectBrown.alpha	= 1.0;
	selectBlue.alpha	= 1.0;
	selectYellow.alpha	= 1.0;
	selectRed.alpha		= 1.0;
	selectGreen.alpha	= 1.0;

	exitButton.alpha	= 1.0;	
	
	selectFillMode.alpha= 1.0;
	selectDrawMode.alpha= 1.0;
	
	
	[UIView commitAnimations];
}

-(void)fadeViewFromScreen	{
	[UIView beginAnimations:@"Fade out view" context:nil];
	[UIView setAnimationDelay:0.0];
	[UIView setAnimationDuration:1.15];
	
	//	Fade view and background alpha to transparent
	self.view.alpha					= 0.0;
	userBackground_imageView.alpha	= 0.0;
	touchpad.alpha					= 0.0;
	
	
	//	Buttons fade out and move, slightly.
	[selectBrown	setFrame:CGRectMake(18-15,  258, 44, 44)];	
	[selectBlue		setFrame:CGRectMake(98-15,  258, 44, 44)];
	[selectYellow	setFrame:CGRectMake(178-15, 258, 44, 44)];
	[selectRed		setFrame:CGRectMake(258-15, 258, 44, 44)];
	[selectGreen	setFrame:CGRectMake(338-15, 258, 44, 44)];
	
	[exitButton setFrame:CGRectMake(418-15, 258, 44, 44)];	
	
	selectBrown.alpha	= 0.0;
	selectBlue.alpha	= 0.0;
	selectYellow.alpha	= 0.0;
	selectRed.alpha		= 0.0;
	selectGreen.alpha	= 0.0;
	
	exitButton.alpha = 0.0;	
	
	selectFillMode.alpha= 0.0;
	selectDrawMode.alpha= 0.0;
	
	[UIView commitAnimations];
}

-(void)dismissViewAfterAnimationCompletion	{
	//	Dismiss view
	[self dismissModalViewControllerAnimated:NO];
	
	//	Trigger restoration of main screen UI elements
	[delegate restoreMainScreenFromUserSession];	
}

-(void)triggerDismissalProcedure	{
	//	1:	Fade elements from screen 
	[self fadeViewFromScreen];
	
	//	2:	Dismiss and destroy view after animations completed
	[self performSelector:@selector(dismissViewAfterAnimationCompletion) withObject:Nil afterDelay:1.15];
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

/*
	Selection methods for colors / controls
*/
-(void)selectBrown	{
	[touchpad setPathToDraw:0];
	NSLog(@"BROWN");
}

-(void)selectBlue	{
	[touchpad setPathToDraw:1];
	NSLog(@"BLUE");
}

-(void)selectYellow	{
	[touchpad setPathToDraw:2];
	NSLog(@"YELLOW");
}

-(void)selectRed	{
	[touchpad setPathToDraw:3];
	NSLog(@"RED");
}

-(void)selectGreen	{
	[touchpad setPathToDraw:4];
	NSLog(@"GREEN");
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

-(void) fillWithColor:(int)i	{
	//	ADD LOGIC HERE FOR WHICH COLOR IS SELECTED
	NSLog(@"Fill received");
	[self.view setBackgroundColor:[UIColor redColor]];
}

-(void) fillModeSelect	{
	[touchpad setMode:@"Fill"];
	NSLog(@"FILL");
}

-(void) drawModeSelect	{
	[touchpad setMode:@"Draw"];
	NSLog(@"DRAW");
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		NSLog(@"Loaded");		
		//	Set view totally transparent for fade in effect
		self.view.alpha = 0.0;
		self.view.backgroundColor = [UIColor whiteColor];
		//	Create & add background image
		userBackground_image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"background" ofType:@"png"]];
		userBackground_imageView = [[UIImageView alloc] initWithImage:userBackground_image];
		[userBackground_imageView setFrame:CGRectMake(0, 0, userBackground_image.size.width, userBackground_image.size.height)];
		[self.view addSubview:userBackground_imageView];
		
		/*
				Create & add touchpad
		*/
		touchpad = [[TouchArea alloc] init];
		[touchpad setDelegate:self];
		[touchpad setFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width)];
		touchpad.alpha = 0.0;
		[self.view addSubview:touchpad];
		
		/*
				Create palettes
		 */
		userPalette = [[Palette alloc] init];
		[userPalette create];
		remotePalette = [userPalette createOpposite];
		
		/*		
				Add buttons to the screen
		*/
		//	BROWN
		//	1:	Set button type
		selectBrown = [UIButton buttonWithType:UIButtonTypeCustom];													
		
		//	2:	Set background color
//		selectBrown.backgroundColor = [UIColor colorWithRed:0.16 green:0.09 blue:0.0 alpha:0.22];					
		selectBrown.backgroundColor = [userPalette.colors objectAtIndex:0];
		
		//	3:	Add target action
		[selectBrown addTarget:self action:@selector(selectBrown) forControlEvents:UIControlEventTouchUpInside];	
		
		//	4:	Set size & position
		[selectBrown setFrame:CGRectMake(18-15, 258, 44, 44)];
		
		//	5:	Configure rounded corners
		selectBrown.layer.cornerRadius = 15.0f;
		
		//	6:	Prepare for fade in
		selectBrown.alpha = 0.0;
		
		//	7:	Add to view
		[self.view addSubview:selectBrown];		
		
		
		//	BLUE
		selectBlue = [UIButton buttonWithType:UIButtonTypeCustom];
//		selectBlue.backgroundColor = [UIColor colorWithRed:0.0 green:0.282 blue:0.63 alpha:0.22];
		selectBlue.backgroundColor = [userPalette.colors objectAtIndex:1];		
		[selectBlue addTarget:self action:@selector(selectBlue) forControlEvents:UIControlEventTouchUpInside];
		[selectBlue setFrame:CGRectMake(98-15, 258, 44, 44)];
		selectBlue.layer.cornerRadius = 15.0f;	
		selectBlue.alpha = 0.0;
		[self.view addSubview:selectBlue];		
		
		
		//	YELLOW
		selectYellow = [UIButton buttonWithType:UIButtonTypeCustom];
//		selectYellow.backgroundColor = [UIColor colorWithRed:0.69 green:0.41 blue:0.0 alpha:0.22];
		selectYellow.backgroundColor = [userPalette.colors objectAtIndex:2];
		[selectYellow addTarget:self action:@selector(selectYellow) forControlEvents:UIControlEventTouchUpInside];
		[selectYellow setFrame:CGRectMake(178-15, 258, 44, 44)];
		selectYellow.layer.cornerRadius = 15.0f;		
		selectYellow.alpha = 0.0;
		[self.view addSubview:selectYellow];
		
		
		//	RED
		selectRed = [UIButton buttonWithType:UIButtonTypeCustom];
		//selectRed.backgroundColor = [UIColor colorWithRed:0.78 green:0.0 blue:0.19 alpha:0.22];
		selectRed.backgroundColor = [userPalette.colors objectAtIndex:3];		
		[selectRed addTarget:self action:@selector(selectRed) forControlEvents:UIControlEventTouchUpInside];
		[selectRed setFrame:CGRectMake(258-15, 258, 44, 44)];
		selectRed.layer.cornerRadius = 15.0f;	
		selectRed.alpha = 0.0;
		[self.view addSubview:selectRed];		
		
		
		//	GREEN
		selectGreen = [UIButton buttonWithType:UIButtonTypeCustom];
//		selectGreen.backgroundColor = [UIColor colorWithRed:0.17 green:0.55 blue:00 alpha:0.22];
		selectGreen.backgroundColor = [userPalette.colors objectAtIndex:4];		
		[selectGreen addTarget:self action:@selector(selectGreen) forControlEvents:UIControlEventTouchUpInside];
		[selectGreen setFrame:CGRectMake(338-15, 258, 44, 44)];
		selectGreen.layer.cornerRadius = 15.0f;	
		selectGreen.alpha = 0.0;
		[self.view addSubview:selectGreen];		
		
		
		//	EXIT
		exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
		exitButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:00 alpha:0.22];
		[exitButton addTarget:self action:@selector(triggerDismissalProcedure) forControlEvents:UIControlEventTouchUpInside];
		[exitButton setFrame:CGRectMake(418-15, 258, 44, 44)];
		exitButton.layer.cornerRadius = 15.0f;	
		exitButton.alpha = 0.0;
		[self.view addSubview:exitButton];		
		
		//	SELECT DRAW
		selectDrawMode = [UIButton buttonWithType:UIButtonTypeCustom];
		selectDrawMode.backgroundColor = [UIColor purpleColor];
		[selectDrawMode addTarget:self action:@selector(drawModeSelect) forControlEvents:UIControlEventTouchUpInside];
		[selectDrawMode setFrame:CGRectMake(3, 3, 44, 44)];
		selectDrawMode.layer.cornerRadius = 15.0f;
		selectDrawMode.alpha = 0.0;
		[self.view addSubview:selectDrawMode];
		
		//	SELECT DRAW
		selectFillMode = [UIButton buttonWithType:UIButtonTypeCustom];
		selectFillMode.backgroundColor = [UIColor orangeColor];
		[selectFillMode addTarget:self action:@selector(fillModeSelect) forControlEvents:UIControlEventTouchUpInside];
		[selectFillMode setFrame:CGRectMake(83, 3, 44, 44)];
		selectFillMode.layer.cornerRadius = 15.0f;
		selectFillMode.alpha = 0.0;
		[self.view addSubview:selectFillMode];		
		
		//	Fade in UI elements
		[self fadeViewToScreen];
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if (interfaceOrientation==UIInterfaceOrientationLandscapeRight || interfaceOrientation==UIInterfaceOrientationLandscapeLeft)	{
		return YES;
	}
	else return NO;
	
    // Return YES for supported orientations
//	return (interfaceOrientation = UIInterfaceOrientationLandscapeRight);
}

@end
