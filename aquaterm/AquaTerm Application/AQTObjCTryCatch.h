//
//  AQTObjCTryCatch.h
//  AquaTerm
//
//  Created by C.W. Betts on 8/15/22.
//  Copyright © 2022 AquaTerm Team. All rights reserved.
//

#ifndef AQTObjCTryCatch_h
#define AQTObjCTryCatch_h

#import <Foundation/Foundation.h>

void tryCatchBlock(NS_NOESCAPE dispatch_block_t _Nonnull aTry, void(NS_NOESCAPE ^ __nullable catchBlock)(NSException*_Nonnull)) NS_SWIFT_NAME(exceptionBlock(try:catch:));

#endif /* AQTObjCTryCatch_h */
