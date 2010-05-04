//
//  PreferencesViewController.h
//  RSSReader
//
//  Created by Jeff Clark on 5/3/10.
//  Copyright 2010 nothoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PreferencesViewController;

@protocol PreferencesViewControllerDelegate
- (void)preferencesViewControllerDidFinish:(PreferencesViewController *)controller;
@end

@interface PreferencesViewController : UIViewController<UITextFieldDelegate> {
	id<PreferencesViewControllerDelegate> delegate;
	IBOutlet UITextField* usernameField;
	IBOutlet UITextField* passwordField;
	UIToolbar* toolbar;
}

-(void)done:(id) sender;

@property (nonatomic, assign) id <PreferencesViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITextField *usernameField;
@property (nonatomic, retain) IBOutlet UITextField *passwordField;

@end
