//
//  FeedItem.h
//  RSSReader
//
//  Created by Jeff Clark on 5/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

@interface FeedItem : NSObject {
	BOOL isLabel;
	NSString* title;
	NSMutableArray* sites;
}

- (id) initWithTitle:(NSString*)theTitle forIsLabel:(BOOL)islabel;

@property BOOL isLabel;
@property(nonatomic, copy) NSString* title;
@property(nonatomic, copy) NSMutableArray* sites;

@end
