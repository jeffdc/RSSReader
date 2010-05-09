//
//  FeedsViewController.h
//  RSSReader
//
//  Created by Jeff Clark on 5/8/10.
//  Copyright 2010 nothoo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FeedsViewController : UITableViewController {
	NSDictionary* data;
}

@property(nonatomic, retain) NSDictionary* data;

@end
