//
//  AQTClientManager.h
//  AquaTerm
//
//  Created by Per Persson on Wed Nov 19 2003.
//  Copyright (c) 2003-2012 The AquaTerm Team. All rights reserved.
//

#ifndef __AQUATERM_AQTCLIENTMANAGER_H__
#define __AQUATERM_AQTCLIENTMANAGER_H__

#import <stdint.h>
#import <Foundation/Foundation.h>
#import <AquaTerm/AQTEventProtocol.h>
#import <AquaTerm/AQTClientProtocol.h>
#import <AquaTerm/AQTConnectionProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@class AQTPlotBuilder;
@protocol AQTClientProtocol;

@interface AQTClientManager : NSObject <AQTEventProtocol>
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"

   /// The viewer app's (AquaTerm) default connection
   __unsafe_unretained NSDistantObject<AQTConnectionProtocol> *_server;
   
#pragma clang diagnostic pop
   NSMutableDictionary *_builders; /**< The objects responsible for assembling a model object from client's calls. */
   NSMutableDictionary<id, id<AQTClientProtocol>> *_plots; /**< The objects responsible for assembling a model object from client's calls. */
   id _activePlotKey;
   void (^_eventBlock)(int index, NSString *event);	/**< A callback function optionally installed by the client */
   void (^_errorBlock)(NSString *msg); /**< A callback function optionally installed by the client */
   id _eventBuffer;
   int32_t _logLimit;
   BOOL errorState;
}
@property (class, readonly, retain) AQTClientManager *sharedManager;
- (void)setServer:(id)server;
- (BOOL)connectToServerWithName:(NSString *)registeredName;
- (BOOL)connectToServer;
- (BOOL)launchServer;
- (void)terminateConnection;
@property (nonatomic, nullable, retain) id activePlotKey;
/** A callback function optionally installed by the client */
@property (copy, nullable) void (^errorBlock)(NSString *__nullable msg);
/** A callback function optionally installed by the client */
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

/*! testing methods */
- (void)timingTestWithTag:(uint32_t)tag;
@end

NS_ASSUME_NONNULL_END

#endif
