//
//  Entry.h
//  RSSReader
//
//  Created by Jeff Clark on 5/4/10.
//  Copyright 2010 nothoo. All rights reserved.
//


@interface Entry : NSObject {
	NSString* title;
	NSDate* date;
	NSString* author;
	NSData* html;
}

@end
