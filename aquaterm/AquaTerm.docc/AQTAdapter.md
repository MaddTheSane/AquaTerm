# ``AQTAdapter``

## Topics

### Class initialization etc.
- ``init``
- ``initWithServer:``
- ``errorBlock``
- ``eventBlock``
- ``setErrorHandler:``
- ``setEventHandler:``
### Control Operations
- ``openPlotWithIndex:``
- ``selectPlotWithIndex:``
- ``plotSize``
- ``plotTitle``
- ``renderPlot``
- ``clearPlot``
- ``closePlot``
### Event Handling
- ``setAcceptingEvents:``
- ``lastEvent``
- ``waitNextEvent``
### Plotting Related Commands
#### Clip rect, applies to all objects
- ``clipRect``
- ``setDefaultClipRect``
#### Colormap (Utility)
- ``colormapSize``
- ``setColormapEntry:red:green:blue:alpha:``
- ``getColormapEntry:red:green:blue:alpha:``
- ``setColormapEntry:red:green:blue:``
- ``getColormapEntry:red:green:blue:``
- ``takeColorFromColormapEntry:``
- ``takeBackgroundColorFromColormapEntry:``
#### Color Handling
- ``setColorRed:green:blue:alpha:``
- ``setBackgroundColorRed:green:blue:alpha:``
- ``getColorRed:green:blue:alpha:``
- ``getBackgroundColorRed:green:blue:alpha:``
- ``setColorRed:green:blue:``
- ``setBackgroundColorRed:green:blue:``
- ``getColorRed:green:blue:``
- ``getBackgroundColorRed:green:blue:``
- ``color``
- ``backgroundColor``
#### Text Handling
- ``fontName``
- ``fontSize``
- ``addLabel:atPoint:``
- ``addLabel:atPoint:angle:align:``
- ``addLabel:atPoint:angle:shearAngle:align:``
#### Line Handling
- ``lineWidth``
- ``setLinestylePattern:count:phase:``
- ``setLinestyleSolid``
- ``lineCapStyle``
- ``moveToPoint:``
- ``addLineToPoint:``
- ``addPolylineWithPoints:pointCount:``
#### Rect and Polygon Handling
- ``moveToVertexPoint:``
- ``addEdgeToVertexPoint:``
- ``addPolygonWithVertexPoints:pointCount:``
- ``addFilledRect:``
- ``eraseRect:``
#### Image Handling
- ``setImageTransformM11:m12:m21:m22:tX:tY:``
- ``resetImageTransform``
- ``addImageWithBitmap:size:bounds:``
- ``addTransformedImageWithBitmap:size:``
- ``addImageWithBitmapData:size:bounds:``
- ``addImageWithRGBABitmapData:size:bounds:``
- ``addImageWithImageData:size:bounds:``
- ``addImageWithImageData:bounds:``
### Private Methods
- ``timingTestWithTag:``
### Deprecated Methods
Do not use these any more.
- ``setFontname:``
- ``setFontsize:`` 
- ``setLinewidth:`` 
- ``addTransformedImageWithBitmap:size:clipRect:``


### Attributed String Keys
- ``AQTFontNameKey``
- ``AQTFontSizeKey``
- ``AQTBaselineAdjustKey``
- ``AQTNonPrintingCharKey``
