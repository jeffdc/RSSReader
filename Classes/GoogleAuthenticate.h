//
//  GoogleAuthenticate.h
//  RSSReader
//
//  Created by Jeff Clark on 4/4/10.
//  Copyright 2010 nothoo All rights reserved.
//

@class GoogleAuthenticate;
@protocol GoogleAuthenticateDelegate<NSObject>
- (void) authenticationComplete:(GoogleAuthenticate*) ga;
- (void) authenticationFailed:(GoogleAuthenticate*) ga;
@end

@interface GoogleAuthenticate : UIViewController {

	NSString *userName;
	NSString *password;
	NSString *SID;
	bool authenticated;
	NSString *failureReason;
	NSString *failureDescription;
	
	@private
	NSMutableData *responseData;
	NSURLConnection *conn;
	id<GoogleAuthenticateDelegate> delegate;
}

- (id) initWithDelegate:(id<GoogleAuthenticateDelegate>) theDelegate;
- (id)initWithUserName:(NSString *)newUserName password:(NSString *)newPassword delegate:(id<GoogleAuthenticateDelegate>) theDelegate;

- (void) authenticate;
- (void) authenticateWithUserName:(NSString*)theUserName password:(NSString*) thePassword;

- (NSString *)parseSID:(NSString *)response;

@property(nonatomic, retain) NSString *userName;
@property(nonatomic, retain) NSString *password;
@property(nonatomic, retain) NSString *SID;
@property bool authenticated;
@property(nonatomic, retain) NSString *failureReason;
@property(nonatomic, retain) NSString *failureDescription;
@property(nonatomic, retain) NSMutableData *responseData;
@property(nonatomic, retain) NSURLConnection *conn;
@property(assign) id<GoogleAuthenticateDelegate> delegate;
@end
