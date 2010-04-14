//
//  GoogleAuthenticate.h
//  RSSReader
//
//  Created by Jeff Clark on 4/4/10.
//  Copyright 2010 nothoo All rights reserved.
//

@interface GoogleAuthenticate : UIViewController {

	NSString *userName;
	NSString *password;
	NSString *SID;
	bool authenticated;
	bool completed;
	NSString *failureReason;
	NSString *failureDescription;
	
	@private
	NSMutableData *responseData;
	NSURLConnection *conn;
}

- (id)initWithUserName:(NSString *)newUserName password:(NSString *)newPassword;

- (void) authenticate;

- (NSString *)parseSID:(NSString *)response;

@property(nonatomic, retain) NSString *userName;
@property(nonatomic, retain) NSString *password;
@property(nonatomic, retain) NSString *SID;
@property bool authenticated;
@property bool completed;
@property(nonatomic, retain) NSString *failureReason;
@property(nonatomic, retain) NSString *failureDescription;
@property(nonatomic, retain) NSMutableData *responseData;
@property(nonatomic, retain) NSURLConnection *conn;

@end
