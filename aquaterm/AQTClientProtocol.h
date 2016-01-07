#import "AQTGraphic.h"

@class AQTModel;
@protocol AQTEventProtocol;

@protocol AQTClientProtocol <NSObject>
// FIXME: Add "oneway" later
@property (readwrite, nullable, retain) id<AQTEventProtocol> client;
- (void)setClient:(nullable byref id<AQTEventProtocol>)aClient;
@property (readwrite, nullable, retain) AQTModel *model;
- (void)setModel:(nullable bycopy AQTModel*)aModel; // (id)?
- (void)appendModel:(nonnull bycopy AQTModel*)aModel;
- (void)draw;
- (void)removeGraphicsInRect:(AQTRect)aRect; // FIXME: Replace by an AQTErase object?
@property (readwrite) BOOL acceptingEvents;
- (void)setAcceptingEvents:(BOOL)flag;
- (void)close;

@optional
// Testing methods 
// FIXME: move into separate protocol?
- (void)timingTestWithTag:(uint32_t)tag;
@end
