//
//  Site.m
//  RSSReader
//
//  Created by Jeff Clark on 5/4/10.
//  Copyright 2010 nothoo. All rights reserved.
//

#import "Site.h"


@implementation Site

@synthesize title, url, entries;

- (id) initWithName:(NSString*)name URL:(NSURL*)URL siteEntries:(NSMutableArray*)siteEntries;{
	self = [super init];
	
	if (nil != self) {
		self.title = name;
		self.url = URL;
		self.entries = siteEntries;
	}
	entries = [[NSMutableArray alloc] init];
	
	return self;
}

- (void) dealloc {
	[entries release];
	[title release];
	[url release];
	
	[super dealloc];
}

@end
