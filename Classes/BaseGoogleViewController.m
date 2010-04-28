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
#import "AuthenticationViewController.h"

static NSString *const USER_DEFAULTS_KEY = @"rssreader.nothoo.com";

@interface BaseGoogleViewController ()
- (NSHTTPCookie*) createSidCookie;
- (void) completeAuthentication:(NSString*)theSid;
@end

@implementation BaseGoogleViewController

@synthesize sid, sidCookie, authenticated, ga;

- (void) dealloc {
	[ga dealloc];
	[sid dealloc];
	[sidCookie dealloc];
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
	UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"The Future is (Almost) Now" 
														message:@"This feature will be coming soon!" 
													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
	[errorAlert release];
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

# pragma mark ViewController delegates
- (void) viewDidLoad {
	self.authenticated = NO;
	self.ga = [[GoogleAuthenticate alloc] initWithDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
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
	
	[super viewWillAppear:animated];
}

#pragma mark AuthenticationViewController delegate
- (void) authenticationVCComplete:(AuthenticationViewController*) avc {
	[avc dismissModalViewControllerAnimated:YES];
	[self completeAuthentication:avc.sid];
	// save to "disk"
	[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:avc.usernameField.text, avc.passwordField.text, nil] forKey:USER_DEFAULTS_KEY];
}

#pragma mark GoogleAuthenticate delegate
- (void) authenticationComplete:(GoogleAuthenticate*) theGa {
	[self completeAuthentication:theGa.SID];
}

- (void) authenticationFailed:(GoogleAuthenticate*) theGa {
	NSLog(@"Authentication failed. %@", theGa.failureReason);
	self.authenticated = NO;
}
@end
