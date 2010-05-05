//
//  FeedItem.h
//  RSSReader
//
//  Created by Jeff Clark on 5/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

@interface FeedItem : NSObject {
	bool isLabel;
	NSString* title;
	NSMutableArray* sites;
}

- (id) initWithTitle:(NSString*)theTitle isLabel:(bool)theIslabel;

@property bool isLabel;
@property(nonatomic, retain) NSString* title;
@property(nonatomic, retain) NSMutableArray* sites;
@end
