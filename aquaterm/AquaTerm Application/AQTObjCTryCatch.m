//
//  AQTObjCTryCatch.m
//  AquaTerm
//
//  Created by C.W. Betts on 8/15/22.
//  Copyright © 2022 AquaTerm Team. All rights reserved.
//

#import "AQTObjCTryCatch.h"

void tryCatchBlock(dispatch_block_t aTry, void(^catchBlock)(NSException*))
{
   @try {
      aTry();
   }
   @catch (NSException *exception) {
      if (catchBlock) {
         catchBlock(exception);
      }
   }
}
