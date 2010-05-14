//
//  FeedParser.h
//  RSSReader
//
//  Created by Jeff Clark on 5/9/10.
//  Copyright 2010 nothoo. All rights reserved.
//

#import "BaseParser.h"

typedef enum {
	Starred,
	All,
	Unread,
	Read,
	KeptUnread,
	Public,
	ByLabel,
	BySite
} FeedType;

@interface FeedParser : BaseParser {
}

-(id) initWithDelegate:(id<ParserDelegate>) theDelegate forFeedType:(FeedType)type;
-(id) initWithDelegate:(id<ParserDelegate>) theDelegate forFeedType:(FeedType)type forString:(NSString*)string;

@end
