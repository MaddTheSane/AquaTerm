#import <Foundation/NSObject.h>

@protocol AQTConnectionProtocol <NSObject>
- (oneway void)ping;
- (void)getServerVersionMajor:(nonnull out int32_t *)major minor:(nonnull out int32_t *)minor rev:(nonnull out int32_t *)rev;
- (nonnull id)addAQTClient:(nullable bycopy id)client name:(nonnull bycopy NSString *)name pid:(pid_t)procId;
@optional
//- (BOOL)removeAQTClient:(bycopy id)client; 
@end
