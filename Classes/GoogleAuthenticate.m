//
//  GoogleAuthenticate.m
//  RSSReader
//
//  Created by Jeff Clark on 4/4/10.
//  Copyright 2010 nothoo. All rights reserved.
//

#import "GoogleAuthenticate.h"

// Private string constants - should these be externalized to config somehow?
static NSString *const GOOGLE_LOGIN_URL = @"https://www.google.com/accounts/ClientLogin";
static NSString *const USER_AGENT = @"nothoo-test";
static NSString *const FORM_TEMPLATE = @"Email=%@&Passwd=%@&service=reader&accountType=HOSTED_OR_GOOGLE&source=%@";
static NSString *const APP_ID = @"nothoo-tester-1.0";

@interface GoogleAuthenticate ()
- (NSString *)parseSID:(NSString *)response;
@end

@implementation GoogleAuthenticate

@synthesize userName, password, SID, authenticated, failureReason, failureDescription, responseData, delegate;

- (void) dealloc {
	[userName release];
	[password release];
	[SID release];
	[failureReason release];
	[failureDescription release];
	[responseData release];
	
	[super dealloc];
}

- (id) initWithDelegate:(id<GoogleAuthenticateDelegate>) theDelegate {
	return [self initWithUserName:nil password:nil delegate:theDelegate];
}

- (id)initWithUserName:(NSString *)newUserName password:(NSString *)newPassword delegate:(id<GoogleAuthenticateDelegate>) theDelegate; {
	self = [super init];
	if (nil != self) {
		self.userName = newUserName;
		self.password = newPassword;
		self.authenticated = NO;
		self.delegate = theDelegate;
	}
	return self;
}

- (void) authenticateWithUserName:(NSString*)theUserName password:(NSString*) thePassword {
	self.userName = theUserName;
	self.password = thePassword;
	[self authenticate];
}

- (void) authenticate {
	if (!authenticated) {
		// authenticate with google
		NSURL *url = [NSURL URLWithString:GOOGLE_LOGIN_URL];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
		[request setValue:USER_AGENT forHTTPHeaderField:@"User-Agent"];
		[request setHTTPMethod:@"POST"];
		[request addValue:@"Content-Type" forHTTPHeaderField:@"application/x-www-form-urlencoded"];
		NSString *requestBody = [[NSString alloc] 
								 initWithFormat:FORM_TEMPLATE,
								 userName, password, APP_ID];
		
		[request setHTTPBody:[requestBody dataUsingEncoding:NSASCIIStringEncoding]];
		
		NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
		if (!conn) {
			// error could not create request
			self.failureReason = @"Failed to connect to Google.";
			self.failureDescription = @"The Google server is not responding or you do not have a network connection.";
			[self.delegate authenticationFailed: self];
		} else {
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
		}
		[request release];
		[requestBody release];
		[conn release];
	}
}

- (NSString *)parseSID:(NSString *)responseString {
	NSRange startRange = [responseString rangeOfString:@"SID="];
	NSRange endRange = [responseString rangeOfString:@"\n" options:(NSCaseInsensitiveSearch) 
										 range:NSMakeRange(startRange.location, responseString.length)];
	NSUInteger start = startRange.location + startRange.length;
	return [responseString substringWithRange:NSMakeRange(start, endRange.location - start)];	
}

#pragma mark connection delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	if ([response respondsToSelector:@selector(statusCode)])
	{
		int statusCode = [((NSHTTPURLResponse *)response) statusCode];
		if (statusCode >= 400)
		{
			NSLog(@"Received HTTP status code %i", statusCode);
			
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];		
			[connection cancel];

		    //TODO: handle errors more appropriately
			failureReason = @"Invalid Login";
			failureDescription = [NSHTTPURLResponse localizedStringForStatusCode:statusCode];
			[self.delegate authenticationFailed: self];
		} else {
			self.responseData = [[NSMutableData alloc] init];
		}
	}
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

	[responseData release];
	failureReason = [error localizedFailureReason];
	failureDescription = [error localizedDescription];
	NSLog(@"%s", failureReason);
	NSLog(@"%s", failureDescription);
	authenticated = NO;
	[self.delegate authenticationFailed: self];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	self.SID = [self parseSID:[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]];
	
	[self.responseData release];
	self.authenticated = YES;
	[self.delegate authenticationComplete: self];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
	return nil;
}
@end
