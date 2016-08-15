//
//  AQTPlot.h
//  AquaTerm
//
//  Created by Per Persson on Mon Jul 28 2003.
//  Copyright (c) 2003-2012 The AquaTerm Team. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AquaTerm/AQTClientProtocol.h>
#import <AquaTerm/AQTEventProtocol.h>

@class AQTModel, AQTView;
@protocol AQTEventProtocol;
@interface AQTPlot : NSObject <AQTClientProtocol>
{
  AQTModel	*model;		/**< Holds the model for the view "*/
  BOOL _isWindowLoaded;
  BOOL _acceptingEvents;
  id <AQTEventProtocol> _client;
  pid_t _clientPID;
  NSString *_clientName;
  // interface additions
  IBOutlet NSBox *extendSavePanelView;
  IBOutlet NSPopUpButton *saveFormatPopUp;
}
@property (nonatomic, readwrite, retain) id<AQTEventProtocol> client;
/// Holds the model for the view
@property (nonatomic, readwrite, retain) AQTModel *model;
- (void)cascadeWindowOrderFront:(BOOL)orderFront;
- (void)constrainWindowToFrame:(NSRect)tileFrame;
/// Points to the rendering view
@property (weak) IBOutlet AQTView *canvas;
- (void)setClient:(byref id<AQTEventProtocol>)client;
- (void)setClientInfoName:(NSString *)name pid:(pid_t)pid;
@property (readonly) BOOL clientValidAndResponding;
- (BOOL)invalidateClient;
@property (readwrite, nonatomic) BOOL acceptingEvents;

- (void)processEvent:(NSString *)theEvent;

- (IBAction)refreshView:(id)sender;

// testing methods
- (void)timingTestWithTag:(uint32_t)tag;
@end
