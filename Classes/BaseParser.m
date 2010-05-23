//
//  BaseParser.m
//  RSSReader
//
//  Created by Jeff Clark on 5/4/10.
//  Copyright 2010 nothoo. All rights reserved.
//

#import "BaseParser.h"

@interface BaseParser ()
-(void)parse;
@end

@implementation BaseParser

@synthesize delegate, url, mainXmlData, parsedData;

-(void) dealloc {
	[parsedData release];
	[url release];
	[mainXmlData release];
	[super dealloc];
}

-(id) initWithDelegate:(id<ParserDelegate>) theDelegate url:(NSURL*)theUrl {
	self = [super init];
	if (nil != self) {
		self.delegate = theDelegate;
		self.url = theUrl;
		parsedData = [[NSMutableDictionary alloc] init];
	}

	return self;
}

-(void) parse {
	//NSLog(@"parse");
//	// make sure the proper cookie is set
//	if (![[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url]) {
//		NSLog(@"No google cookie set!");
//	}
	
	NSURLRequest *request = [[NSURLRequest alloc]initWithURL:self.url];
	
	NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
	[request release];
	[conn release];
}

-(void) startParsing {
	NSXMLParser *mainXMLDataParser = [[NSXMLParser alloc] initWithData:mainXmlData];
	mainXMLDataParser.delegate = self;
	[mainXMLDataParser parse];
	[mainXMLDataParser release];
}

-(BOOL) isHtml:(NSString*)elementName aParser:(NSXMLParser*)parser {
	// see if we are actually authenticated to Google, if not then we will be getting HTML, not XML back from the call
	if ([elementName isEqualToString:@"html"]) {
		[parser abortParsing];
		
		//TODO: add error protocol so that the delegate can authenticate and retry if desired.
		return YES;
	}
	return NO;
}
#pragma mark -
#pragma mark Connection methods
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[mainXmlData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:[error localizedDescription] message:[error localizedFailureReason] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
	[errorAlert release];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
//	NSString *s = [[NSString alloc] initWithData:mainXmlData encoding:NSASCIIStringEncoding];
//	NSLog(@"%@", s);
//	[s release];
	[self startParsing];
}

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
		} else {
			self.mainXmlData = [[NSMutableData alloc] init];
		}
		
	}
}

@end
