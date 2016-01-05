//
//  AQTGraphic+NonSwiftable.h
//  AquaTerm
//
//  Created by C.W. Betts on 1/5/16.
//
//

#import <AquaTerm/AquaTerm.h>
#import <AquaTerm/AQTGraphic.h>

@interface AQTGraphic (NonSwiftable)
- (id)_cache;
- (void)_setCache:(id)object;

@end
