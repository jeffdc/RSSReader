//
//  PreferencesViewController.m
//  RSSReader
//
//  Created by Jeff Clark on 5/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PreferencesViewController.h"
#import "Constants.h"

@implementation PreferencesViewController

@synthesize delegate, usernameField, passwordField;

- (void) done:(id) sender {
	// save to "disk"
	[[NSUserDefaults standardUserDefaults] 
	 setObject:[NSArray arrayWithObjects:usernameField.text, passwordField.text, nil] 
	 forKey:USER_DEFAULTS_KEY];
	
	[delegate preferencesViewControllerDidFinish:self];
}

- (void) viewWillAppear:(BOOL)animated {
 	// setup the toolbar
	toolbar = [[UIToolbar alloc] init];
	toolbar.barStyle = UIBarStyleDefault;
	[toolbar sizeToFit];
	CGFloat toolbarHeight = [toolbar frame].size.height;
	CGRect rootViewBounds = self.view.bounds;
	CGFloat rootViewHeight = CGRectGetHeight(rootViewBounds);
	CGFloat rootViewWidth = CGRectGetWidth(rootViewBounds);
	CGRect rectArea = CGRectMake(0, rootViewHeight - toolbarHeight, rootViewWidth, toolbarHeight);
	[toolbar setFrame:rectArea];
	
	UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction 
																				target:self 
																				action:@selector(done:)];
	
	[toolbar setItems:[NSArray arrayWithObjects:infoButton,nil]];
	
	//Add the toolbar as a subview to the navigation controller.
	[self.view addSubview:toolbar];

	// try to get user name and password from "disk"
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	NSArray *vals = [ud stringArrayForKey:USER_DEFAULTS_KEY];
	if (vals && [vals count] > 0) {
		usernameField.text = [vals objectAtIndex:0];
		passwordField.text = [vals objectAtIndex:1];
	}
		
	[super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[toolbar dealloc];
    [super dealloc];
}


@end
