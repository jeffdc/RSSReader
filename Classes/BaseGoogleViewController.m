//
//  BaseGoogleViewController.m
//  RSSReader
//
//  Provides common functionality for all views that interact with the Google Reader service. Namely:
//  * Checks for stored user credentials and authenticates and/or displays an authentication view.
//  * Creates the toolbar shared by all views.
// 
//  Created by Jeff Clark on 4/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BaseGoogleViewController.h"
#import "Constants.h"

@interface BaseGoogleViewController ()
- (NSHTTPCookie*) createSidCookie;
- (void) completeAuthentication:(NSString*)theSid;
@end

@implementation BaseGoogleViewController

@synthesize sid, sidCookie, authenticated, ga;

- (void) dealloc {
	[ga release];
	[sid release];
	[sidCookie release];
	[toolbar release];
	[super dealloc];
}

-(void)authenticate {
	if (!self.authenticated) {
		// try to get user name and password from "disk"
		NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
		NSArray *vals = [ud stringArrayForKey:USER_DEFAULTS_KEY];
		if (vals && [vals count] > 0) {
			[ga authenticateWithUserName: [vals objectAtIndex:0] password:[vals objectAtIndex:1]];
		} else {
			AuthenticationViewController *avc = [[AuthenticationViewController alloc] initWithNibName:@"AuthenticationView" bundle:nil];
			avc.delegate = self;
			[self.navigationController presentModalViewController:avc animated:YES];
		}
	}	
}

-(void)settingsClick:(id) sender {
	PreferencesViewController* controller = [[PreferencesViewController alloc] initWithNibName:@"PreferencesView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
}

- (NSHTTPCookie*) createSidCookie {
	NSLog(@"SID = '%@'", self.sid);
	NSDictionary* cookieProperties = [NSDictionary dictionaryWithObjectsAndKeys:
									  @"SID", NSHTTPCookieName,
									  @".google.com", NSHTTPCookieDomain, 
									  @"/", NSHTTPCookiePath, 
									  @"1600000000", NSHTTPCookieExpires, 
									  self.sid, NSHTTPCookieValue,
									  nil];
	
	sidCookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
	if (!sidCookie) {
		NSLog(@"Failed to create cookie.");
	}
	
	[[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:sidCookie];
	
	return sidCookie;	
}

- (void) completeAuthentication:(NSString*)theSid {
	self.sid = theSid;
	self.sidCookie = [self createSidCookie];
	self.authenticated = YES;
}

-(void)authencationComplete {
	[NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

# pragma mark ViewController delegates
- (void) viewDidLoad {
	NSLog(@"called viewDidLoad");
	self.authenticated = NO;
	self.ga = [[GoogleAuthenticate alloc] initWithDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
	NSLog(@"called viewWIllAppear");
	
	if (!initalized) {
		[self authenticate];
		
		// setup the toolbar
		toolbar = [[UIToolbar alloc] init];
		toolbar.barStyle = UIBarStyleDefault;
		[toolbar sizeToFit];
		CGFloat toolbarHeight = [toolbar frame].size.height;
		CGRect rootViewBounds = self.parentViewController.view.bounds;
		CGFloat rootViewHeight = CGRectGetHeight(rootViewBounds);
		CGFloat rootViewWidth = CGRectGetWidth(rootViewBounds);
		CGRect rectArea = CGRectMake(0, rootViewHeight - toolbarHeight, rootViewWidth, toolbarHeight);
		[toolbar setFrame:rectArea];
		
		UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction 
																					target:self 
																					action:@selector(settingsClick:)];
		
		[toolbar setItems:[NSArray arrayWithObjects:infoButton,nil]];
		
		//Add the toolbar as a subview to the navigation controller.
		[self.navigationController.view addSubview:toolbar];
		
		initalized = YES;
	}
	
	[super viewWillAppear:animated];
}

#pragma mark AuthenticationViewController delegate
- (void) authenticationVCComplete:(AuthenticationViewController*) avc {
	[avc dismissModalViewControllerAnimated:YES];
	[self completeAuthentication:avc.sid];
	// save to "disk"
	[[NSUserDefaults standardUserDefaults] 
	 setObject:[NSArray arrayWithObjects:avc.usernameField.text, avc.passwordField.text, nil] 
	 forKey:USER_DEFAULTS_KEY];
}

#pragma mark GoogleAuthenticate delegate
- (void) authenticationComplete:(GoogleAuthenticate*) theGa {
	[self completeAuthentication:theGa.SID];
	[self authencationComplete];
}

- (void) authenticationFailed:(GoogleAuthenticate*) theGa {
	NSLog(@"Authentication failed. %@", theGa.failureReason);
	self.authenticated = NO;
}

#pragma mark PreferencesViewController delegate
- (void)preferencesViewControllerDidFinish:(PreferencesViewController *)controller {
	[self dismissModalViewControllerAnimated:YES];
	
	//TODO: why does this cause a crash later? where is controller being reused???
	//	[controller release];
}

@end
