//
//  AQTController.h
//  AquaTerm
//
//  Created by Per Persson on Wed Jun 25 2003.
//  Copyright (c) 2003-2012 The AquaTerm Team. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AquaTerm/AQTConnectionProtocol.h>

@class AQTAdapter;
@class AQTPlot;

@interface AQTController : NSObject <NSApplicationDelegate, NSWindowDelegate, AQTConnectionProtocol>
{
  NSMutableArray<AQTPlot*>*handlerList;		/*" Array of client handlers "*/
  NSPopUpButton   *saveFormatPopup;
  NSBox           *extendSavePanelView;
  NSPoint cascadingPoint;
}

- (AQTAdapter *)sharedAdapter;
- (void)removePlot:(id)aPlot;
- (void)windowDidClose:(NSNotification *)aNotification;
- (void)setWindowPos:(NSWindow *)plotWindow;

-(IBAction)tileWindows:(id)sender;
-(IBAction)cascadeWindows:(id)sender;
-(IBAction)showHelp:(id)sender;
-(IBAction)showAvailableFonts:(id)sender;
-(IBAction)showPrefs:(id)sender;
-(IBAction)debug:(id)sender;
-(IBAction)mailBug:(id)sender;
-(IBAction)mailFeedback:(id)sender;
-(IBAction)testview:(id)sender;
-(IBAction)stringDrawingTest:(id)sender;
-(IBAction)lineDrawingTest:(id)sender;
@end
