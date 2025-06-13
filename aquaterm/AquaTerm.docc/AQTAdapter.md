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
- ``addLabel(_:at:angle:shearAngle:align:)-(String,_,_,_,_)``
- ``addLabel(_:at:angle:shearAngle:align:)-(AttributedString,_,_,_,_)``
- ``addLabel(_:at:angle:shearAngle:align:)-(NSAttributedString,_,_,_,_)``

#### Line Handling
- ``lineWidth``
- ``setLinestylePattern:count:phase:``
- ``setLinestyle(pattern:phase:)-([Float],_)``
- ``setLinestyle(pattern:phase:)-([CGFloat],_)``
- ``setLinestyleSolid``
- ``lineCapStyle``
- ``moveToPoint:``
- ``addLineToPoint:``
- ``addPolylineWithPoints:pointCount:``
- ``addPolyline(points:)``

#### Rect and Polygon Handling
- ``moveToVertexPoint:``
- ``addEdgeToVertexPoint:``
- ``addPolygonWithVertexPoints:pointCount:``
- ``addPolygon(vertexPoints:)``
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

### Attributed String Keys
- ``AQTFontNameKey``
- ``AQTFontSizeKey``
- ``AQTBaselineAdjustKey``
- ``AQTNonPrintingCharKey``

### Deprecated Methods
Do not use these any more.
- ``setFontname:``
- ``setFontsize:`` 
- ``setLinewidth:`` 
- ``addTransformedImageWithBitmap:size:clipRect:``
