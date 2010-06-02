//
//  Site.m
//  RSSReader
//
//  Created by Jeff Clark on 5/4/10.
//  Copyright 2010 nothoo. All rights reserved.
//

#import "Feed.h"


@implementation Feed

@synthesize title, url, entries, labels;

- (void) dealloc {
	[entries release];
	[labels release];
	[title release];
	[url release];
	
	[super dealloc];
}

- (id) initWithTitle:(NSString*)name URL:(NSURL*)URL {
	self = [super init];
	
	if (nil != self) {
		self.title = name;
		self.url = URL;
		entries = [[NSMutableArray alloc] init];
		labels = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (BOOL) addEntry:(Entry*)entry {
	//TODO
}

- (BOOL) addLabel:(NSString*)label {
	//TODO
}

@end
