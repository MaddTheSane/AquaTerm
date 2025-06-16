# ``AQTPlotBuilder``

This is the class that performs all assembling of plots in the form of an ``AQTModel``. ``AQTAdapter`` has a reference to the currently selected builder and forwards all drawing related messages to it. 

## Topics

### Acessors

- ``modelIsDirty``
- ``model``
- ``size``
- ``title``

### Clip rect, applies to all objects

- ``clipRect``
- ``setDefaultClipRect``

### Color handling

- ``color``
- ``backgroundColor``

- ``takeColorFromColormapEntry:``
- ``takeBackgroundColorFromColormapEntry:``

- ``colormapSize``
- ``setColor:forColormapEntry:``
- ``colorForColormapEntry:``

### Text handling

- ``fontName``
- ``fontSize``

- ``addLabel:position:angle:shearAngle:justification:``

### Line handling

- ``lineWidth``

- ``setLinestylePattern:count:phase:``
- ``setLinestyleSolid``
- ``lineCapStyle``

- ``moveToPoint:``
- ``addLineToPoint:``
- ``addPolylineWithPoints:pointCount:`` 

### Filled areas

- ``moveToVertexPoint:``
- ``addEdgeToPoint:``
- ``addPolygonWithPoints:pointCount:``
- ``addFilledRect:``

### Image handling

- ``imageTransform``
- ``addImageWithBitmap:size:bounds:``
- ``addTransformedImageWithBitmap:size:clipRect:``
- ``addTransformedImageWithBitmap:size:``

- ``addImageWithBitmapData:size:bounds:``
- ``addImageWithRGBABitmapData:size:bounds:``
- ``addImageWithImageData:size:bounds:``

### Misc.

- ``removeAllParts``

### Deprecated

Deprecated, do not use these methods.

- ``setLinewidth:`` 
- ``setFontname:``
- ``setFontsize:``
