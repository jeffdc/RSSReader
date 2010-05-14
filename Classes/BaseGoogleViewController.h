//
//  BaseGoogleViewController.h
//  RSSReader
//
//  Created by Jeff Clark on 4/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GoogleAuthenticate.h"
#import "AuthenticationViewController.h"
#import "PreferencesViewController.h"

@interface BaseGoogleViewController : UITableViewController<
				GoogleAuthenticateDelegate, AuthenticationViewControllerDelegate, PreferencesViewControllerDelegate> {
	UIToolbar* toolbar;
	NSString *sid;
	NSHTTPCookie *sidCookie;
	BOOL authenticated;
	
@private
	GoogleAuthenticate* ga;
	BOOL initalized;
}

-(void)authenticate;
-(void)settingsClick:(id) sender;

-(void)authencationComplete;

@property (nonatomic, retain) NSString *sid;
@property (nonatomic, retain) NSHTTPCookie *sidCookie;
@property BOOL authenticated;
@property(nonatomic, retain) GoogleAuthenticate* ga;

@end
