//
//  AQTGraphic+NonSwiftable.m
//  AquaTerm
//
//  Created by C.W. Betts on 1/5/16.
//
//

#import "AQTGraphic+NonSwiftable.h"

@implementation AQTGraphic (NonSwiftable)

-(void)_setCache:(id)object
{
	//[object retain];
	//[_cache release];
	_cache = object;
}

-(id)_cache
{
	return _cache;
}

@end
