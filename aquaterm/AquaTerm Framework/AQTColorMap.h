//
//  AQTColorMap.h
//  AquaTerm
//
//  Created by Bob Savage on Mon Jan 28 2002.
//  Copyright (c) 2002-2012 The AquaTerm Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AquaTerm/AQTGraphic.h>

typedef AQTColor *AQTColorPtr;

NS_ASSUME_NONNULL_BEGIN

@interface AQTColorMap : NSObject	
{
   AQTColorPtr colormap; ///< NB. Not an object but a pointer to a struct
   int32_t size; 
}
/** \brief Creates an \c AQTColorMap with a size of 1.
 */
-(instancetype)init;

/** \brief Creates an \c AQTColorMap with the indicated size.
 \param size The amount of colors to store in the object.
 If zero or negative, defaults to 1.
 */
-(instancetype)initWithColormapSize:(int32_t)size NS_DESIGNATED_INITIALIZER;

/** @brief The number of colors that this object can hold.
 */
@property (readonly) int32_t size;

/** @brief Sets the color at the specified index.
 
 If \c index is outside the range of size, does nothing.
 \param newColor The color to replace at the specified index.
 \param index The index of the color to set.
 */
-(void)setColor:(AQTColor)newColor forIndex:(int32_t)index;

/** @brief Returns the color at the specified index.
 
 If \c index is outside the range of size, the first color is returned instead.
 \param index The index of the color to get.
 \return The color at the specified index.
 */
-(AQTColor)colorForIndex:(int32_t)index;

/** @brief Returns the color at the specified index.
 
 If \c index is outside the range of size, the first color is returned instead.
 
 This is used for Objective-C subscripting.
 \param index The index of the color to get.
 \return The color at the specified index.
 */
- (AQTColor)objectAtIndexedSubscript:(int32_t)index;

/** @brief Sets the color at the specified index.
 
 If \c index is outside the range of size, does nothing.
 
 This is used for Objective-C subscripting.
 \param newValue The color to replace at the specified index.
 \param index The index of the color to set.
 */
- (void)setObject:(AQTColor)newValue atIndexedSubscript:(int32_t)index;

@end

NS_ASSUME_NONNULL_END
