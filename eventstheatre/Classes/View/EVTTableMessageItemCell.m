/*
 * Copyright (c) 2011 Ovidiu Bute. All rights reserved.
 */

#import "EVTTableMessageItemCell.h"

@implementation EVTTableMessageItemCell

- (void)setObject:(id)object 
{
    if (_item != object) {
        [super setObject:object];
        
        TTTableMessageItem* item = object;
        if (item.title.length) {
            self.titleLabel.text = item.title;
        }
        if (item.caption.length) {
            self.captionLabel.text = item.caption;
        }
        if (item.text.length) {
            self.detailTextLabel.text = item.text;
        }
        if (item.timestamp) {
            self.timestampLabel.text = nil;
            NSDate *date = item.timestamp;
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm"];
            self.timestampLabel.text = [dateFormatter stringFromDate:date];
            [dateFormatter release];
        }
        if (item.imageURL) {
            self.imageView2.urlPath = item.imageURL;
        }
    }
}

@end
