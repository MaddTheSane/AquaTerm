//
//  AQTGraphic+NonSwiftable.h
//  AquaTerm
//
//  Created by C.W. Betts on 1/5/16.
//
//

#import <Foundation/Foundation.h>
#import <AquaTerm/AquaTerm.h>
#import <AquaTerm/AQTGraphic.h>
#import <AquaTerm/AQTLabel.h>
#import <AquaTerm/AQTPath.h>
#import <AquaTerm/AQTModel.h>

@interface AQTGraphic (NonSwiftable)
- (nullable id)_cache;
- (void)_setCache:(nullable id)object;
@property (getter=_cache, setter=_setCache:, nullable, retain) id _cache;

@end

@interface AQTLabel (AQTLabelDrawing)
-(void)_aqtLabelUpdateCache;
@end

@interface AQTPath (AQTPathDrawing)
-(void)_aqtPathUpdateCache;
@end

void TryCatchBlock(dispatch_block_t __nonnull tryBlock, void (^__nullable catchBlock)(NSException * __nonnull localException));
