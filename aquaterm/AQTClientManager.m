//
//  AQTClientManager.m
//  AquaTerm
//
//  Created by Per Persson on Wed Nov 19 2003.
//  Copyright (c) 2003-2012 The AquaTerm Team. All rights reserved.
//

#import "AQTClientManager.h"
#import "AQTModel.h"
#import "AQTPlotBuilder.h"

#import "AQTEventProtocol.h"
#import "AQTConnectionProtocol.h"
#import "ARCBridge.h"

@implementation AQTClientManager
@synthesize errorBlock = _errorBlock;
@synthesize eventBlock = _eventBlock;

#pragma mark ==== Error handling ====
- (void)_aqtHandlerError:(NSString *)msg
{
   // FIXME: stuff @"42:Server error" in all event buffers/handlers ?
   [self logMessage:[NSString stringWithFormat:@"Handler error: %@", msg] logLevel:1];
   errorState = YES;
   printf("AquaTerm warning: Connection to display was lost,\n");
   printf("plot commands will be discarded until a new plot is started.\n");
}

- (void)clearErrorState
{
   BOOL serverDidDie = NO;

   [self logMessage:@"Trying to recover from error." logLevel:3];

   @try {
      [_server ping];
   } @catch (NSException *localException) {
      [self logMessage:@"Server not responding." logLevel:1];
      serverDidDie = YES;
   }

   if (serverDidDie) {
      [self terminateConnection];
   } else {
      [self closePlot];
   }
   errorState = NO;
}

#pragma mark ==== Init routines ====
+ (AQTClientManager *)sharedManager
{
   static AQTClientManager *sharedManager = nil;
   if (sharedManager == nil) {
      sharedManager = [[self alloc] init];
   }
   return sharedManager;
}

- (instancetype)init
{
   if(self = [super init]) {
      char *envPtr;
      _builders = [[NSMutableDictionary alloc] initWithCapacity:256];
      _plots = [[NSMutableDictionary alloc] initWithCapacity:256];
      _eventBuffer = [[NSMutableDictionary alloc] initWithCapacity:256];
      _logLimit = 0;
      // Read environment variable(s)
      envPtr = getenv("AQUATERM_LOGLEVEL");
      if (envPtr != (char *)NULL) {
         _logLimit = (int32_t)strtol(envPtr, (char **)NULL, 10);
      }
      [self logMessage:[NSString stringWithFormat:@"Warning: Logging at level %d", _logLimit] logLevel:1];
   }
   return self;
}

- (void)dealloc
{
   [NSException raise:@"AQTException" format:@"in --> %@ %s line %d", NSStringFromSelector(_cmd), __FILE__, __LINE__];
   
#if !__has_feature(objc_arc)
   [_activePlotKey release];
   [_eventBuffer release];
   [_builders release];
   [_plots release];
   if (_eventBlock) {
      Block_release(_eventBlock);
      _eventBlock = NULL;
   }
   
   if (_errorBlock) {
      Block_release(_errorBlock);
      _errorBlock = NULL;
   }
   [super dealloc];
#endif
}

#pragma mark ==== Server methods ====
- (void)setServer:(id)server
{
   _server = server;
}

- (BOOL)connectToServer
{
   return [self connectToServerWithName:@"aquatermServer"];
}

- (BOOL)connectToServerWithName:(NSString *)registeredName
{
   [self logMessage:@"Trying to connect..." logLevel:2];
   // FIXME: Check to see if _server exists.
   BOOL didConnect = NO;
   _server = [NSConnection rootProxyForConnectionWithRegisteredName:registeredName host:nil];
   if (!_server) {
      [self logMessage:@"Launching server..." logLevel:2];
      if (![self launchServer]) {
         [self logMessage:@"Launching failed." logLevel:2];
      } else {
         // Wait for server to start up
         int32_t timer = 10;
         while (--timer && !_server) {
            // sleep 1s
            [self logMessage:[NSString stringWithFormat:@"Waiting... %d", timer] logLevel:2];
            [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
            // check for server connection
            _server = [NSConnection rootProxyForConnectionWithRegisteredName:registeredName host:nil];
         }
      }
   }
   if (_server) {
      @try {
         if ([_server conformsToProtocol:@protocol(AQTConnectionProtocol)]) {
            int32_t a,b,c;
            RETAINOBJNORETURN(_server);
            [_server setProtocolForProxy:@protocol(AQTConnectionProtocol)];
            [_server getServerVersionMajor:&a minor:&b rev:&c];
            [self logMessage:[NSString stringWithFormat:@"Server version %d.%d.%d", a, b, c] logLevel:2];
            didConnect = YES;
         } else {
            [self logMessage:@"server is too old info" logLevel:1];
            _server = nil;
         }
         } @catch (NSException *localException) {
            // [localException raise];
            [self logMessage:@"An error occurred while talking to the server" logLevel:1];
         }
   }
   [self logMessage:didConnect?@"Connected!":@"Could not connect" logLevel:1];
   return didConnect;
}

// This is still troublesome... Needs to figure out if user is running from remote machine. NSTask
- (BOOL)launchServer
{
   NSURL *appURL;
   OSStatus status;
   
   if (getenv("AQUATERM_PATH") != (char *)NULL) {
      appURL = [NSURL fileURLWithPath:@(getenv("AQUATERM_PATH"))];
      status = LSOpenCFURLRef((__bridge CFURLRef)appURL, NULL);
   } else {
      // Look for AquaTerm at default location
      status = LSOpenCFURLRef((__bridge CFURLRef)[NSURL fileURLWithPath:@"/Applications/AquaTerm.app"], NULL);
      if (status != noErr) {
         status = LSOpenCFURLRef((__bridge CFURLRef)[NSURL fileURLWithPath:[@"~/Applications/AquaTerm.app" stringByExpandingTildeInPath]], NULL);
      }
      if (status != noErr) {
         // No, search for it based on creator code, choose latest version
         CFURLRef tmpURL;
         status = LSFindApplicationForInfo('AqTS', NULL, NULL, NULL, &tmpURL);//LSCopyApplicationURLsForBundleIdentifier
         [self logMessage:[NSString stringWithFormat:@"LSFindApplicationForInfo = %ld", (long)status] logLevel:2];
         appURL = (status == noErr) ? (NSURL*)CFBridgingRelease(tmpURL) : NULL;
         if (appURL) {
            status = LSOpenCFURLRef((__bridge CFURLRef)appURL, NULL);
         }
      }
   }
   [self logMessage:[NSString stringWithFormat:@"LSOpenCFURLRef = %ld", (long)status] logLevel:2];
   return (status == noErr);
}

- (void)terminateConnection
{
   NSArray *allKeys = [[_plots allKeys] copy];

   for (id key in allKeys) {
      [self setActivePlotKey:key];
      [self closePlot];
   }
   RELEASEOBJ(allKeys);
   if([_server isProxy]) {
      RELEASEOBJ(_server);
      _server = nil;
   }
   [self logMessage:@"Terminating connection." logLevel:1];
}

#pragma mark ==== Accessors ====

@synthesize activePlotKey = _activePlotKey;

- (void)setActivePlotKey:(id)newActivePlotKey
{
   RETAINOBJNORETURN(newActivePlotKey);
   RELEASEOBJ(_activePlotKey);
   _activePlotKey = newActivePlotKey;
   [self logMessage:_activePlotKey?[NSString stringWithFormat:@"Active plot: %ld", (long)[_activePlotKey integerValue]]:@"**** plot invalid ****"
           logLevel:3];
}

- (void)setErrorHandler:(void (*)(NSString *errMsg))fPtr
{
   if (!fPtr) {
      self.errorBlock = nil;
      return;
   }
   self.errorBlock = ^(NSString *errnsg) {
      (*fPtr)(errnsg);
   };
}

- (void)setEventHandler:(void (*)(int index, NSString *event))fPtr
{
   if (!fPtr) {
      self.eventBlock = nil;
      return;
   }
   self.eventBlock = ^(int index, NSString *event) {
      (*fPtr)(index, event);
   };
}

- (void)logMessage:(NSString *)msg logLevel:(int32_t)level
{
   // _logLimit: 0 -- output off
   //            1 -- severe errors
   //            2 -- user debug
   //            3 -- noisy, dev. debug
   if (level > 0 && level <= _logLimit) {
      NSLog(@"\nlibaquaterm::%@", msg);
   }
}

#pragma mark === Plot/builder methods ===

- (AQTPlotBuilder *)newPlotWithIndex:(int32_t)refNum
{
   AQTPlotBuilder *newBuilder = nil;
   NSNumber *key = @(refNum);;
   id <AQTClientProtocol> newPlot;

   if (errorState == YES) {
      [self clearErrorState];
      if (_server == nil) {
         [self connectToServer];
      }
   }
   // Check if plot already exists. If so, just select and clear it.
   if ([self selectPlotWithIndex:refNum] != nil) {
      newBuilder = [self clearPlot];
      _eventBuffer[key] = @"0";
      return newBuilder;
   }   

   @try {
      newPlot = [_server addAQTClient:key
                                 name:[NSProcessInfo processInfo].processName
                                  pid:[NSProcessInfo processInfo].processIdentifier];
   } @catch (NSException *localException) {
      // [localException raise];
      [self _aqtHandlerError:localException.name];
      newPlot = nil;
   }
   if (newPlot) {
      [newPlot setClient:self];
      // set active plot
      [self setActivePlotKey:key];
      _plots[key] = newPlot;
      // Also create a corresponding builder
      newBuilder = [[AQTPlotBuilder alloc] init];
      _builders[key] = newBuilder;
      // Clear event buffer
      _eventBuffer[key] = @"0";
      RELEASEOBJ(newBuilder);
   }
   return newBuilder;
}

- (AQTPlotBuilder *)selectPlotWithIndex:(int32_t)refNum
{
   NSNumber *key;
   AQTPlotBuilder *aBuilder;
 
   if (errorState == YES) return nil; // FIXME: Clear error state here too???

   key = @(refNum);
   aBuilder = _builders[key];

   if(aBuilder != nil) {
      [self setActivePlotKey:key];
   }
   return aBuilder;
}

- (void)renderPlot 
{
   AQTPlotBuilder *pb;

   if (errorState == YES || _activePlotKey == nil) return;

   pb = _builders[_activePlotKey];
   if (pb.modelIsDirty) {
      id <NSObject, AQTClientProtocol> thePlot = _plots[_activePlotKey];
      @try {
         if ([thePlot isProxy]) {
            [thePlot appendModel:pb.model];
            [pb removeAllParts];
         } else {
            [thePlot setModel:pb.model];
         }
         [thePlot draw];
      } @catch (NSException *localException) {
         // [localException raise];
         [self _aqtHandlerError:localException.name];
      }
   }
}

- (AQTPlotBuilder *)clearPlot
{
   AQTPlotBuilder *newBuilder, *oldBuilder;
   id <NSObject, AQTClientProtocol> thePlot;
   
   if (errorState == YES || _activePlotKey == nil) return nil;

   newBuilder = [[AQTPlotBuilder alloc] init];
   oldBuilder = _builders[_activePlotKey];
   thePlot = _plots[_activePlotKey];
  
   newBuilder.size = oldBuilder.model.canvasSize;
   newBuilder.title = oldBuilder.model.title;
   newBuilder.backgroundColor = oldBuilder.backgroundColor;
   
   _builders[_activePlotKey] = newBuilder;
   @try {
      [thePlot setModel:newBuilder.model];
      [thePlot draw];
   } @catch (NSException *localException) {
      // [localException raise];
      [self _aqtHandlerError:localException.name];
   }
   RELEASEOBJ(newBuilder);
   return newBuilder;
}

- (void)clearPlotRect:(NSRect)aRect 
{
   AQTPlotBuilder *pb;
   AQTRect aqtRect;
   id <NSObject, AQTClientProtocol> thePlot;

   if (errorState == YES || _activePlotKey == nil) return;

   pb = _builders[_activePlotKey];
   thePlot = _plots[_activePlotKey];

   @try {
      if (pb.modelIsDirty) {
         if ([thePlot isProxy]) {
            [thePlot appendModel:pb.model]; // Push any pending output to the viewer, don't draw
            [pb removeAllParts];
         } else {
            [thePlot setModel:pb.model];
         }
            
      }
      // FIXME make sure in server that this combo doesn't draw unnecessarily
      // 64 bit compatibility
      aqtRect.origin.x = aRect.origin.x;
      aqtRect.origin.y = aRect.origin.y;
      aqtRect.size.width = aRect.size.width;
      aqtRect.size.height = aRect.size.height;
      [thePlot removeGraphicsInRect:aqtRect];
      // [thePlot draw];
   } @catch (NSException *localException) {
      // [localException raise];
      [self _aqtHandlerError:localException.name];
   }
}

- (void)closePlot
{
   if (_activePlotKey == nil) return;

   @try {
      [_plots[_activePlotKey] setClient:nil];
      [_plots[_activePlotKey] close];
   } @catch (NSException *localException) {
      [self logMessage:@"Closing plot, discarding exception..." logLevel:2];
   }
   [_plots removeObjectForKey:_activePlotKey];
   [_builders removeObjectForKey:_activePlotKey];
   [self setActivePlotKey:nil];
}

#pragma mark ==== Events ====

- (void)setAcceptingEvents:(BOOL)flag  
{
   if (errorState == YES || _activePlotKey == nil) return;
   @try {
      [_plots[_activePlotKey] setAcceptingEvents:flag];
   } @catch (NSException *localException) {
      [self _aqtHandlerError:localException.name];
   }
}

- (NSString *)lastEvent  
{
   NSString *event;

   if (errorState == YES) return @"42:Server error";
   if (_activePlotKey == nil) return @"43:No plot selected";
   
   event = AUTORELEASEOBJ([_eventBuffer[_activePlotKey] copy]);
   _eventBuffer[_activePlotKey] = @"0";
   return event;
}

#pragma mark ==== AQTEventProtocol ====
- (oneway void)ping
{
   return;
}

- (oneway void)processEvent:(bycopy NSString *)event sender:(id)sender
{
   NSNumber *key;
   
   NSArray *keys = [_plots allKeysForObject:sender];
   if (keys.count == 0) return;
   key = keys[0];

   if (_eventBlock != nil) {
      _eventBlock(key.intValue, event);
   }
   _eventBuffer[key] = event;
}

#pragma mark ==== Testing methods ====
- (void)timingTestWithTag:(uint32_t)tag
{
   AQTPlotBuilder *pb;
   
   if (errorState == YES || _activePlotKey == nil) return;
   
   pb = _builders[_activePlotKey];
   if (pb.modelIsDirty) {
      id <NSObject, AQTClientProtocol> thePlot = _plots[_activePlotKey];
      @try {
         if ([thePlot isProxy]) {
            [thePlot appendModel:pb.model];
            [pb removeAllParts];
         } else {
            [thePlot setModel:pb.model];
         }
         [thePlot timingTestWithTag:tag];
      } @catch (NSException *localException) {
         // [localException raise];
         [self _aqtHandlerError:localException.name];
      }
   }
}
@end
