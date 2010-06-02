//
//  FeedData.m
//  RSSReader
//
//  Created by Jeff Clark on 6/1/10.
//  Copyright 2010 nothoo. All rights reserved.
//

#import "FeedData.h"


@implementation FeedData
@synthesize feeds;

-(void) dealloc {
	[feeds release];
	[super dealloc];
}

@end
