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
	NSString* html;
	NSString* siteName;
	NSURL* url;
	//NSURL* siteURL; //null if not a starred item, because the entry can use it's site.title ... needed???
}

- (id) initWithTitle:(NSString*)entryTitle entryDate:(NSDate*)entryDate entryAuthor:(NSString*)entryAuthor 
		   entryHTML:(NSData*)entryHTML entrySiteName:(NSString*)entrySiteName entryURL:(NSURL*)entryURL;

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSDate* date;
@property (nonatomic, copy) NSString* author;
@property (nonatomic, copy) NSString* html;
@property (nonatomic, copy) NSString* siteName;
@property (nonatomic, copy) NSURL* url;

@end
