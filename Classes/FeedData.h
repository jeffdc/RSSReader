//
//  FeedData.h
//  RSSReader
//
//  Created by Jeff Clark on 6/1/10.
//  Copyright 2010 nothoo. All rights reserved.
//

@interface FeedData : NSObject {
	NSMutableArray* feeds;
}

@property (nonatomic, copy) NSMutableArray* feeds;

@end
