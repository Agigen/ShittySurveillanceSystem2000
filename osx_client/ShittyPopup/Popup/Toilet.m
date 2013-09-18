//
//  Toilet.m
//  Popup
//
//  Created by Daniel Mauno Pettersson on 9/17/13.
//
//

#import "Toilet.h"

@implementation Toilet

- (id)initWithTitle:(NSString *)title occupied:(BOOL)occupied {
    if ((self = [super init])) {
        self.title = title;
        self.occupied = occupied;
    }
    return self;
}

@end
