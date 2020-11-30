#import <AquaTerm/AQTGraphic.h>

@class AQTModel;
@protocol AQTEventProtocol;

@protocol AQTClientProtocol <NSObject>
//@property (readwrite, nullable, retain) id<AQTEventProtocol> client;
// FIXME: Add "oneway" later
- (void)setClient:(nullable byref id<AQTEventProtocol>)aClient;
//@property (readwrite, nullable, retain) AQTModel *model;
- (void)setModel:(nullable bycopy AQTModel*)aModel; // (id)?
- (void)appendModel:(nonnull bycopy AQTModel*)aModel;
- (void)draw;
- (void)removeGraphicsInRect:(AQTRect)aRect; // FIXME: Replace by an AQTErase object?
- (void)setAcceptingEvents:(BOOL)flag;
- (void)close;

@optional
// Testing methods 
// FIXME: move into separate protocol?
- (void)timingTestWithTag:(uint32_t)tag;
@end
