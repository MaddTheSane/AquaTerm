#ifndef __AQUATERM_AQTEVENTPROTOCOL_H__
#define __AQUATERM_AQTEVENTPROTOCOL_H__

#import <Foundation/NSObject.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AQTClientProtocol;

@protocol AQTEventProtocol <NSObject>
- (oneway void)processEvent:(bycopy NSString *)event sender:(id<AQTClientProtocol>)sender;
- (oneway void)ping;
//- (BOOL)isValidKey:(id)key;
@end

NS_ASSUME_NONNULL_END

#endif
