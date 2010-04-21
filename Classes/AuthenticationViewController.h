//
//  AuthenticationViewController.h
//  RSSReader
//
//  Created by Neal on 3/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleAuthenticate.h"

@class AuthenticationViewController;

@protocol AuthenticationViewControllerDelegate<NSObject>
- (void) authenticationComplete:(AuthenticationViewController*) avc SIDCookie:(NSHTTPCookie*) cookie;
@end

@interface AuthenticationViewController : UIViewController<UITextFieldDelegate, GoogleAuthenticateDelegate> {
	
	IBOutlet UITextField *usernameField;
	IBOutlet UITextField *passwordField;
	IBOutlet UILabel *msg;
	IBOutlet UIActivityIndicatorView *activityIndicator;

	NSString *sid;
	NSHTTPCookie *sidCookie;
	bool authenticated;
	
	@private
	id<AuthenticationViewControllerDelegate> delegate;
	GoogleAuthenticate* ga;
}

- (IBAction) login:(id)sender;

@property (nonatomic, retain) IBOutlet UILabel *msg;
@property (nonatomic, retain) IBOutlet UITextField *usernameField;
@property (nonatomic, retain) IBOutlet UITextField *passwordField;
@property (nonatomic, retain) NSString *sid;
@property (nonatomic, retain) NSHTTPCookie *sidCookie;
@property bool authenticated;
@property (assign) id<AuthenticationViewControllerDelegate> delegate;
@property(nonatomic, retain) GoogleAuthenticate* ga;

@end