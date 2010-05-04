//
//  FeedItem.m
//  RSSReader
//
//  Created by Jeff Clark on 5/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FeedItem.h"

@implementation FeedItem
@synthesize isLabel, title;

- (void) dealloc {
	[title release];
	title = nil;
	[super dealloc];
}


- (id) initWithTitle:(NSString*)theTitle isLabel:(bool)theIslabel {
	self = [super init];
	if (nil != self) {
		self.isLabel = theIslabel;
		self.title = theTitle;
	}
	
	return self;
}

@end
