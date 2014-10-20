/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "EVTBaseDetailsViewController.h"

@implementation EVTBaseDetailsViewController

#pragma mark - Constructor

- (id)init
{
    if (self = [super init]) {
        self.tableViewStyle = UITableViewStyleGrouped;
    }
    return self;
}

#pragma mark - TTTableViewController methods

- (id<UITableViewDelegate>)createDelegate
{
    return [[[TTTableViewVarHeightDelegate alloc] initWithController:self] autorelease];
}

@end
