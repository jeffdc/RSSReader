//
//  Entry.m
//  RSSReader
//
//  Created by Jeff Clark on 5/4/10.
//  Copyright 2010 nothoo. All rights reserved.
//

#import "Entry.h"


@implementation Entry

@synthesize title, date, author, html, siteName, url, starred, read;

- (void) dealloc {
	[title release];
	[date release];
	[author release];
	[html release];
	[siteName release];
	[url release];
	
	[super dealloc];
}


@end
