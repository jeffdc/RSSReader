//
//  StarredParser.h
//  RSSReader
//
//  Created by Neal on 5/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BaseParser.h"
#import "Site.h" // Should these be in .m?
#import "FeedItem.h"
#import "Entry.h"

@interface StarredParser : BaseParser {
	
	Entry* currentEntry;
	Site* starred;
	FeedItem* starredFeedItem;
	NSMutableArray* starredEntries;
	
	BOOL isEntry;
	BOOL inEntrySource;
	BOOL foundEntryTitle;
	BOOL foundSiteTitle;
	BOOL foundEntryAuthor;
	BOOL foundEntryURL;
	BOOL foundEntryHTML;
	BOOL foundEntryUpdatedDate;
	
	NSDictionary* linkAttributeDict;
	NSMutableString* currentEntryTitle;
	NSMutableString* currentSiteTitle;
	NSMutableString* currentEntryAuthor;
	NSMutableString* currentEntryHTML;
	NSMutableString* currentEntryUpdatedDate;
}

@end
