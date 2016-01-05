#import "AQTGraphic.h"

@class AQTModel;

@protocol AQTClientProtocol <NSObject>
// FIXME: Add "oneway" later
- (void)setClient:(nullable byref id)aClient;
- (void)setModel:(nullable bycopy AQTModel*)aModel; // (id)?
- (void)appendModel:(nonnull bycopy AQTModel*)aModel;
- (void)draw;
- (void)removeGraphicsInRect:(AQTRect)aRect; // FIXME: Replace by an AQTErase object?
- (void)setAcceptingEvents:(BOOL)flag;
- (void)close;
// Testing methods 
// FIXME: move into separate protocol?
- (void)timingTestWithTag:(uint32_t)tag;
@end
