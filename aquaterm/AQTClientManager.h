//
//  AQTClientManager.h
//  AquaTerm
//
//  Created by Per Persson on Wed Nov 19 2003.
//  Copyright (c) 2003-2012 The AquaTerm Team. All rights reserved.
//

#import <stdint.h>
#import <Foundation/Foundation.h>
#import "AQTEventProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class AQTPlotBuilder;
@protocol AQTEventProtocol;
@protocol AQTClientProtocol;
@interface AQTClientManager : NSObject <AQTEventProtocol>
{
   id _server; /* The viewer app's (AquaTerm) default connection */
   NSMutableDictionary *_builders; /* The objects responsible for assembling a model object from client's calls. */
   NSMutableDictionary<id, id<AQTClientProtocol>> *_plots; /* The objects responsible for assembling a model object from client's calls. */
   id _activePlotKey;
   //void (*_errorHandler)(NSString *msg);	/* A callback function optionally installed by the client */
   //void (*_eventHandler)(long index, NSString *event); /* A callback function optionally installed by the client */
   void (^_eventBlock)(int index, NSString *event);
   void (^_errorBlock)(NSString *msg);
   id _eventBuffer;
   int32_t _logLimit;
   BOOL errorState;
}
+ (AQTClientManager *)sharedManager;
- (void)setServer:(id)server;
- (BOOL)connectToServerWithName:(NSString *)registeredName;
- (BOOL)connectToServer;
- (BOOL)launchServer;
- (void)terminateConnection;
@property (nonatomic, nullable, retain) id activePlotKey;
@property (copy, nullable) void (^errorBlock)(NSString *__nullable msg);
@property (copy, nullable) void (^eventBlock)(int index, NSString *__nullable event);
- (void)setErrorHandler:(void (*__nullable)(NSString *__nullable errMsg))fPtr;
- (void)setEventHandler:(void (*__nullable)(int index, NSString *__nullable event))fPtr;

- (void)logMessage:(NSString *)msg logLevel:(int32_t)level;

- (nullable AQTPlotBuilder *)newPlotWithIndex:(int32_t)refNum;
- (nullable AQTPlotBuilder *)selectPlotWithIndex:(int32_t)refNum;
- (void)closePlot; 

- (void)renderPlot; 
- (nullable AQTPlotBuilder *)clearPlot;
- (void)clearPlotRect:(NSRect)aRect;

- (void)setAcceptingEvents:(BOOL)flag; 
@property (readonly, copy) NSString *lastEvent;

/* testing methods */
- (void)timingTestWithTag:(uint32_t)tag;
@end

NS_ASSUME_NONNULL_END
