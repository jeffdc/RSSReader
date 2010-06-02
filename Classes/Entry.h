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
	BOOL starred;
	BOOL read;
}

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSDate* date;
@property (nonatomic, copy) NSString* author;
@property (nonatomic, copy) NSString* html;
@property (nonatomic, copy) NSString* siteName;
@property (nonatomic, copy) NSURL* url;
@property BOOL starred;
@property BOOL read;
@end
