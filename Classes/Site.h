//
//  Site.h
//  RSSReader
//
//  Created by Jeff Clark on 5/4/10.
//  Copyright 2010 nothoo. All rights reserved.
//

@interface Site : NSObject {
	NSString* title;
	NSURL* url;
	NSMutableArray* entries;
}

@property(nonatomic, retain) NSString* title;
@property(nonatomic, retain) NSURL* url;
@property(nonatomic, retain) NSMutableArray* entries;

@end
