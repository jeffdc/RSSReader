//
//  FeedItem.m
//  RSSReader
//
//  Created by Jeff Clark on 5/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FeedItem.h"

@implementation FeedItem
@synthesize isLabel, title, sites;

- (id) initWithTitle:(NSString*)theTitle isLabel:(BOOL)theIslabel { 
	self = [super init];
	if (nil != self) {
		self.isLabel = theIslabel;
		self.title = theTitle;
	}
	
	sites = [[NSMutableArray alloc] init];
	
	return self;
}

- (void) dealloc {
	[title release];
	[sites release];
	
	[super dealloc];
}

@end
