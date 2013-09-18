//
//  Toilet.h
//  Popup
//
//  Created by Daniel Mauno Pettersson on 9/17/13.
//
//

#import <Foundation/Foundation.h>

@interface Toilet : NSObject

@property (strong) NSString *title;
@property (assign) BOOL occupied;

- (id)initWithTitle:(NSString*)title occupied:(BOOL)occupied;

@end
