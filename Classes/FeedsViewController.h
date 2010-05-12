//
//  FeedsViewController.h
//  RSSReader
//
//  Created by Jeff Clark on 5/8/10.
//  Copyright 2010 nothoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseGoogleViewController.h"

@interface FeedsViewController : BaseGoogleViewController {
	NSDictionary* tableData;
}

@property(nonatomic, retain) NSDictionary* tableData;

@end
