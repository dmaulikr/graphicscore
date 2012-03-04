//
//  UserScreen.m
//  graphicscore
//
//  Created by Zebedee Pedersen on 14/12/2011.
//  Copyright (c) 2011 zebpedersen. All rights reserved.
//

#import "UserScreen.h"

@implementation UserScreen
@synthesize delegate, exitButtonImage, audioController, parameteriser, networkController;

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
	touchpad.alpha					= 1.0;
	
	//	Buttons fade in and move, slightly.
	[selectColorToDraw1	setFrame:CGRectMake(18,  258, 44, 44)];	
	[selectColorToDraw2	setFrame:CGRectMake(98,  258, 44, 44)];
	[selectColorToDraw3	setFrame:CGRectMake(178, 258, 44, 44)];
	[selectColorToDraw4	setFrame:CGRectMake(258, 258, 44, 44)];
	[selectColorToDraw5	setFrame:CGRectMake(338, 258, 44, 44)];
	
	[exitButtonImage	setFrame:CGRectMake(418, 15, 44, 44)];	
	
	selectColorToDraw1.alpha	= 1.0;
	selectColorToDraw2.alpha	= 1.0;
	selectColorToDraw3.alpha	= 1.0;
	selectColorToDraw4.alpha	= 1.0;
	selectColorToDraw5.alpha	= 1.0;

	exitButtonImage.alpha	= .6;	

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
	touchpad.alpha					= 0.0;
	
	
//	//	Buttons fade out and move, slightly.
	[selectColorToDraw1	setFrame:CGRectMake(18-15,  258, 44, 44)];	
	[selectColorToDraw2	setFrame:CGRectMake(98-15,  258, 44, 44)];
	[selectColorToDraw3	setFrame:CGRectMake(178-15, 258, 44, 44)];
	[selectColorToDraw4	setFrame:CGRectMake(258-15, 258, 44, 44)];
	[selectColorToDraw5	setFrame:CGRectMake(338-15, 258, 44, 44)];
	
	[exitButtonImage	setFrame:CGRectMake(418-15, 18, 44, 44)];		
	
	selectColorToDraw1.alpha	= 0.0;
	selectColorToDraw2.alpha	= 0.0;
	selectColorToDraw3.alpha	= 0.0;
	selectColorToDraw4.alpha		= 0.0;
	selectColorToDraw5.alpha	= 0.0;
	
	exitButtonImage.alpha	= 0.0;	

	[audioController togglePlayback];
	
	[UIView commitAnimations];
}

-(void)dismissViewAfterAnimationCompletion	{
	//	Kill audio controller
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
	[[touchpad pingTimer] invalidate];
	
	//	3:	Dismiss and destroy view after animations completed
	[self performSelector:@selector(dismissViewAfterAnimationCompletion) withObject:Nil afterDelay:1.15];
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
/*
	Selection methods for colors / controls
*/
-(void)setColor:(id)sender	{	[touchpad setColor_index:[(UIButton*)sender tag]];	}
-(void)setShape:(id)sender	{	[touchpad setShape_index:[(UIButton*)sender tag]];	}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

-(UIButton*)createNewColorButtonWithFrame:(CGRect)f andID:(NSUInteger)ident	{
	UIButton* colorButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[colorButton setTag:ident];
	[colorButton setBackgroundColor:[[userPalette colors]objectAtIndex:ident]];	
	[colorButton addTarget:self action:@selector(setColor:) forControlEvents:UIControlEventTouchUpInside];	
	[colorButton setFrame:f];
	[colorButton.layer setCornerRadius:15.0f];
	[colorButton setAlpha:0.0];
	return colorButton;
}

-(UIButton*)createNewShapeButtonWithFrame:(CGRect)f andID:(NSUInteger)ident	{
	//	Need to tie these together with fade in animations
	GSShapePalette* shapePalette = [[GSShapePalette alloc]initWithFrame:f andColorPalette:[Palette createBlack]];
	[self.view addSubview:[[shapePalette shapes] objectAtIndex:ident]];
	UIButton* shapeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[shapeButton addTarget:self action:@selector(setShape:) forControlEvents:UIControlEventTouchUpInside];
	[shapeButton setTag:ident];
	[shapeButton setFrame:f];
	return shapeButton;
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
		networkController = [[GSNetworkController alloc] init];

		if ([networkController session_id]!=0)	{
			
			/*
					Create palettes
			 */
			if ([networkController member_id]==1)	{
				userPalette		= [Palette	createPlayerOne];
				remotePalette	= [Palette	createPlayerTwo];			
			}
			else if ([networkController member_id]==2)	{
				remotePalette	= [Palette	createPlayerOne];
				userPalette		= [Palette	createPlayerTwo];			
			}
			
			
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
					Create & add touchpad
			 */	
			touchpad = [[TouchArea alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width) andDelegate:parameteriser andNetworkController:networkController];
			[touchpad assignPaletteForLocal:userPalette andRemote:remotePalette];		
			touchpad.alpha = 0.0;
			[self.view addSubview:touchpad];
		
		
			/*		
					Add buttons to the screen
			 */
			selectColorToDraw1 = [self createNewColorButtonWithFrame:CGRectMake(18-15, 258, 44, 44)		andID:0];
			selectColorToDraw2 = [self createNewColorButtonWithFrame:CGRectMake(98-15, 258, 44, 44)		andID:1];
			selectColorToDraw3 = [self createNewColorButtonWithFrame:CGRectMake(178-15, 258, 44, 44)	andID:2];
			selectColorToDraw4 = [self createNewColorButtonWithFrame:CGRectMake(258-15, 258, 44, 44)	andID:3];
			selectColorToDraw5 = [self createNewColorButtonWithFrame:CGRectMake(338-15, 258, 44, 44)	andID:4];
		
			[self.view addSubview:selectColorToDraw1];		
			[self.view addSubview:selectColorToDraw2];		
			[self.view addSubview:selectColorToDraw3];
			[self.view addSubview:selectColorToDraw4];
			[self.view addSubview:selectColorToDraw5];
	
			selectShapeToDraw1 = [self createNewShapeButtonWithFrame:CGRectMake(18, 18, 44, 44)		andID:0];
			selectShapeToDraw2 = [self createNewShapeButtonWithFrame:CGRectMake(98, 18, 44, 44)		andID:1];
			selectShapeToDraw3 = [self createNewShapeButtonWithFrame:CGRectMake(178, 18, 44, 44)	andID:2];
			selectShapeToDraw4 = [self createNewShapeButtonWithFrame:CGRectMake(258, 18, 44, 44)	andID:3];
		
			[self.view addSubview:selectShapeToDraw1];		
			[self.view addSubview:selectShapeToDraw2];
			[self.view addSubview:selectShapeToDraw3];
			[self.view addSubview:selectShapeToDraw4];
		
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
