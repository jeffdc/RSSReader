//
//  AuthenticationViewController.m
//  RSSReader
//
//  Created by Neal on 3/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "RSSReaderAppDelegate.h"
#import "RootViewController.h"

@implementation AuthenticationViewController

@synthesize msg, usernameField, passwordField, sid, authenticated, sidCookie, delegate, ga;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	self.authenticated = NO;
	return self;
}

- (IBAction) login:(id)sender {
	self.ga = [[GoogleAuthenticate alloc] initWithUserName:usernameField.text password:passwordField.text];
	self.ga.delegate = self;
	
	[self.msg setText:@"Authenticating..."];
	
	[activityIndicator startAnimating];
	[self.ga authenticate];
}

#pragma mark delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField	{
	[textField resignFirstResponder];
	if (textField == passwordField) {
		[self login:self];
	} else {
		[passwordField becomeFirstResponder];
	}
	
	return NO;
}

- (void) authenticationComplete:(GoogleAuthenticate*) ga {
	NSLog(@"authenticationComplete");

	self.sid = self.ga.SID;
	
	NSDictionary* cookieProperties = [NSDictionary dictionaryWithObjectsAndKeys:
									  @"SID", NSHTTPCookieName,
									  @".google.com", NSHTTPCookieDomain, 
									  @"/", NSHTTPCookiePath, 
									  @"1600000000", NSHTTPCookieExpires, 
									  self.ga.SID, NSHTTPCookieValue,
									  nil];
	
	sidCookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
	if (!sidCookie) {
		NSLog(@"Failed to create cookie.");
	}
	
	[[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:sidCookie];
	
	self.authenticated = YES;
	[activityIndicator stopAnimating];
	[delegate authenticationComplete:self SIDCookie:sidCookie];
}

- (void) authenticationFailed:(GoogleAuthenticate*) ga {
	NSLog(@"authenticationFailed");
	[self.msg setText:self.ga.failureReason];
	[activityIndicator stopAnimating];
}
#pragma mark end delegate methods

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
