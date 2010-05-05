//
//  BaseParser.m
//  RSSReader
//
//  Created by Jeff Clark on 5/4/10.
//  Copyright 2010 nothoo. All rights reserved.
//

#import "BaseParser.h"


@implementation BaseParser

-(void) parse {
	NSURLRequest *request = [[NSURLRequest alloc]initWithURL:self.url];
	
	NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
	[request release];
	[conn release]; //nil out also?
}

-(void) startParsing {
	NSXMLParser *mainXMLDataParser = [[NSXMLParser alloc] initWithData:mainXMLData];
	mainXMLDataParser.delegate = self;
	[mainXMLDataParser parse];
	[mainXMLDataParser release];
}

#pragma mark -
#pragma mark Connection methods
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[mainXMLData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:[error localizedDescription] message:[error localizedFailureReason] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
	[errorAlert release];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
//	NSString *s = [[NSString alloc] initWithData:mainXMLData encoding:NSASCIIStringEncoding];
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
			self.mainXMLData = [[NSMutableData alloc] init];
		}
		
	}
}

@end
