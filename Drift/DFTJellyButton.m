//
//  DFTJellyButton.m
//  Drift
//
//  Created by Thierry Ng on 19/01/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTJellyButton.h"

@implementation DFTJellyButton

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	NSLog(@"Touches began in Jelly View");
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	NSLog(@"Touches entered in Jelly View");
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	NSLog(@"Touches ended in Jelly View");
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	NSLog(@"Touches cancelled in Jelly View");
}

@end
