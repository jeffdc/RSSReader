//
//  LabelParser.h
//  RSSReader
//
//  Created by Jeff Clark on 5/4/10.
//  Copyright 2010 nothoo. All rights reserved.
//

#import "BaseParser.h"

@interface LabelParser : BaseParser {
	bool isId;
	NSMutableString* term;
}

@property bool isId;
@property(nonatomic, retain) NSMutableString* term;

@end
