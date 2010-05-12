//
//  Entry.m
//  RSSReader
//
//  Created by Jeff Clark on 5/4/10.
//  Copyright 2010 nothoo. All rights reserved.
//

#import "Entry.h"


@implementation Entry

@synthesize title, date, author, html, siteName, url;

- (id) initWithTitle:(NSString*)entryTitle entryDate:(NSDate*)entryDate entryAuthor:(NSString*)entryAuthor 
		   entryHTML:(NSString*)entryHTML entrySiteName(NSString*):entrySiteName entryURL:(NSURL*)entryURL{
	self = [super init];
	
	if (nil != self) {
		self.title = entryTitle;
		self.date = entryDate;
		self.author = entryAuthor;
		self.html = entryHTML;
		self.siteName = entrySiteName;
		self.url = entryURL;
	}
	
	return self;
}

- (void) dealloc {
	[super dealloc];
}


@end
