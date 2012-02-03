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
	userBackground_imageView.alpha	= .15;
	touchpad.alpha					= 1.0;
	
	//	Buttons fade in and move, slightly.
	[selectColor1	setFrame:CGRectMake(18,  258, 44, 44)];	
	[selectColor2	setFrame:CGRectMake(98,  258, 44, 44)];
	[selectColor3	setFrame:CGRectMake(178, 258, 44, 44)];
	[selectColor4	setFrame:CGRectMake(258, 258, 44, 44)];
	[selectColor5	setFrame:CGRectMake(338, 258, 44, 44)];
	
	[exitButton		setFrame:CGRectMake(418, 258, 44, 44)];
	
	
	selectColor1.alpha	= 1.0;
	selectColor2.alpha	= 1.0;
	selectColor3.alpha	= 1.0;
	selectColor4.alpha	= 1.0;
	selectColor5.alpha	= 1.0;

	exitButton.alpha	= 1.0;	

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
	[selectColor1	setFrame:CGRectMake(18-15,  258, 44, 44)];	
	[selectColor2		setFrame:CGRectMake(98-15,  258, 44, 44)];
	[selectColor3	setFrame:CGRectMake(178-15, 258, 44, 44)];
	[selectColor4	setFrame:CGRectMake(258-15, 258, 44, 44)];
	[selectColor5	setFrame:CGRectMake(338-15, 258, 44, 44)];
	
	[exitButton setFrame:CGRectMake(418-15, 258, 44, 44)];	
	
	selectColor1.alpha	= 0.0;
	selectColor2.alpha	= 0.0;
	selectColor3.alpha	= 0.0;
	selectColor4.alpha		= 0.0;
	selectColor5.alpha	= 0.0;
	
	exitButton.alpha = 0.0;	
	
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
//	ADD ID VALS TO BUTTONS AND USE SENDER TO CONDENSE THIS TO ONE METHOD

-(void)selectColor1	{	[touchpad setPathToDraw:0];	}
-(void)selectColor2	{	[touchpad setPathToDraw:1];	}
-(void)selectColor3	{	[touchpad setPathToDraw:2];	}
-(void)selectColor4	{	[touchpad setPathToDraw:3];	}
-(void)selectColor5	{	[touchpad setPathToDraw:4];	}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

-(void) fillWithColor:(int)i	{	
	[self.view setBackgroundColor:[[userPalette colors]objectAtIndex:i]];	
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
		[touchpad assignPalette:userPalette];
		
		/*		
				Add buttons to the screen
		*/
		//	BROWN
		//	1:	Set button type
		selectColor1 = [UIButton buttonWithType:UIButtonTypeCustom];													
		
		//	2:	Set background color
		selectColor1.backgroundColor = [userPalette.colors objectAtIndex:0];
		
		//	3:	Add target action
		[selectColor1 addTarget:self action:@selector(selectColor1) forControlEvents:UIControlEventTouchUpInside];	
		
		//	4:	Set size & position
		[selectColor1 setFrame:CGRectMake(18-15, 258, 44, 44)];
		
		//	5:	Configure rounded corners
		selectColor1.layer.cornerRadius = 15.0f;
		
		//	6:	Prepare for fade in
		selectColor1.alpha = 0.0;
		
		//	7:	Add to view
		[self.view addSubview:selectColor1];		
		
		
		//	BLUE
		selectColor2 = [UIButton buttonWithType:UIButtonTypeCustom];
		selectColor2.backgroundColor = [userPalette.colors objectAtIndex:1];		
		[selectColor2 addTarget:self action:@selector(selectColor2) forControlEvents:UIControlEventTouchUpInside];
		[selectColor2 setFrame:CGRectMake(98-15, 258, 44, 44)];
		selectColor2.layer.cornerRadius = 15.0f;	
		selectColor2.alpha = 0.0;
		[self.view addSubview:selectColor2];		
		
		
		//	YELLOW
		selectColor3 = [UIButton buttonWithType:UIButtonTypeCustom];
		selectColor3.backgroundColor = [userPalette.colors objectAtIndex:2];
		[selectColor3 addTarget:self action:@selector(selectColor3) forControlEvents:UIControlEventTouchUpInside];
		[selectColor3 setFrame:CGRectMake(178-15, 258, 44, 44)];
		selectColor3.layer.cornerRadius = 15.0f;		
		selectColor3.alpha = 0.0;
		[self.view addSubview:selectColor3];
		
		
		//	RED
		selectColor4 = [UIButton buttonWithType:UIButtonTypeCustom];
		selectColor4.backgroundColor = [userPalette.colors objectAtIndex:3];		
		[selectColor4 addTarget:self action:@selector(selectColor4) forControlEvents:UIControlEventTouchUpInside];
		[selectColor4 setFrame:CGRectMake(258-15, 258, 44, 44)];
		selectColor4.layer.cornerRadius = 15.0f;	
		selectColor4.alpha = 0.0;
		[self.view addSubview:selectColor4];		
		
		
		//	GREEN
		selectColor5 = [UIButton buttonWithType:UIButtonTypeCustom];
		selectColor5.backgroundColor = [userPalette.colors objectAtIndex:4];		
		[selectColor5 addTarget:self action:@selector(selectColor5) forControlEvents:UIControlEventTouchUpInside];
		[selectColor5 setFrame:CGRectMake(338-15, 258, 44, 44)];
		selectColor5.layer.cornerRadius = 15.0f;	
		selectColor5.alpha = 0.0;
		[self.view addSubview:selectColor5];		
		
		//	EXIT
		exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
		exitButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:00 alpha:0.22];
		[exitButton addTarget:self action:@selector(triggerDismissalProcedure) forControlEvents:UIControlEventTouchUpInside];
		[exitButton setFrame:CGRectMake(418-15, 258, 44, 44)];
		exitButton.layer.cornerRadius = 15.0f;	
		exitButton.alpha = 0.0;
		[self.view addSubview:exitButton];		
		

		//	Fade in UI elements
		[self fadeViewToScreen];
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
	if (interfaceOrientation==UIInterfaceOrientationLandscapeRight || interfaceOrientation==UIInterfaceOrientationLandscapeLeft)	{
		return YES;
	}
	else return NO;
}

@end
