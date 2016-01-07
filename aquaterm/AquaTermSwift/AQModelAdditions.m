//
//  AQTModelAdditions.m
//  AquaTerm
//
//  Created by Per Persson on Wed Jun 09 2004.
//  Copyright (c) 2004-2012 The AquaTerm Team. All rights reserved.
//

#import "AQModelAdditions.h"
#import <AquaTerm/AQTFunctions.h>
#import "AquaTermSwift-Swift.h"

@implementation AQTModel (AQModelAdditions)
-(void)invalidate
{
	dirtyRect = AQTRectFromSize(self.canvasSize);
}

-(void)clearDirtyRect
{
	dirtyRect = NSZeroRect;
}

-(void)appendModel:(AQTModel *)newModel
{
	BOOL backgroundDidChange; // FIXME
	// NSLog(@"in --> %@ %s line %d", NSStringFromSelector(_cmd), __FILE__, __LINE__);
	backgroundDidChange = !AQTEqualColors(self.color, newModel.color);
	self.title = newModel.title;
	self.canvasSize = newModel.canvasSize;
	self.color = newModel.color;
	self.bounds = AQTUnionRect(self.bounds, [newModel updateBounds]);
	[self addObjectsFromArray:newModel.modelObjects];
	dirtyRect = backgroundDidChange ? AQTRectFromSize(self.canvasSize) : AQTUnionRect(dirtyRect, newModel.bounds);
}

- (void)removeGraphicsInRect:(AQTRect)aRect
{
	NSRect targetRect;
	NSRect testRect;
	NSRect clipRect = AQTRectFromSize(self.canvasSize);
	NSRect newBounds = NSZeroRect;
	NSInteger i;
	NSInteger  objectCount = self.count;
	
	targetRect.origin.x = aRect.origin.x; targetRect.origin.y = aRect.origin.y;
	targetRect.size.width = aRect.size.width; targetRect.size.height = aRect.size.height;
	// check for nothing to remove or disjoint modelBounds <--> targetRect
	if (objectCount == 0 || AQTIntersectsRect(targetRect, self.bounds) == NO)
		return;
	
	// Apply clipRect (=canvasRect) to graphic bounds before comparing.
	if (AQTContainsRect(targetRect, NSIntersectionRect(self.bounds, clipRect))) {
		[self removeAllObjects];
	} else {
		for (i = objectCount - 1; i >= 0; i--) {
			testRect = [modelObjects[i] bounds];
			if (AQTContainsRect(targetRect, NSIntersectionRect(testRect, clipRect))) {
				[self removeObjectAtIndex:i];
			} else {
				newBounds = AQTUnionRect(newBounds, testRect);
			}
		}
	}
	self.bounds = newBounds;
	dirtyRect = AQTUnionRect(dirtyRect, targetRect);
}

@end
