C API Documentation
=====

## Topics

### Constants and Enumerations

- ``AQT_EVENTBUF_SIZE``

- ``AQTLineCapStyle``
- ``AQTAlign``

### Horizontal
Constants that specify horizontal alignment for labels.

- ``AQTAlign-enum/AQTAlignLeft``
- ``AQTAlign/center`` 
- ``AQTAlign/right`` 

### Vertical
Constants that specify vertical alignment for labels.

- ``AQTAlign-enum/AQTAlignMiddle``
- ``AQTAlign/baseline`` 
- ``AQTAlign/bottom`` 
- ``AQTAlign/top``


### Class Initialization, Etc.
- ``aqtInit``
- ``aqtTerminate``
- ``aqtSetEventHandler``
- ``aqtSetEventBlock``


### Control Operations
- ``aqtOpenPlot``
- ``aqtSelectPlot``
- ``aqtSetPlotSize``
- ``aqtSetPlotTitle``
- ``aqtRenderPlot``
- ``aqtClearPlot``
- ``aqtClosePlot``

### Event Handling
- ``aqtSetAcceptingEvents``
- ``aqtGetLastEvent``
- ``aqtWaitNextEvent``

### Plotting related commands 

### Clip Rect, applies to all objects
- ``aqtSetClipRect``
- ``aqtSetDefaultClipRect``

### Colormap (Utility)
- ``aqtColormapSize``
- ``aqtSetColormapEntryRGBA``
- ``aqtGetColormapEntryRGBA``
- ``aqtSetColormapEntry``
- ``aqtGetColormapEntry``
- ``aqtTakeColorFromColormapEntry``
- ``aqtTakeBackgroundColorFromColormapEntry``

### Color Handling
- ``aqtSetColorRGBA``
- ``aqtSetBackgroundColorRGBA``
- ``aqtGetColorRGBA``
- ``aqtGetBackgroundColorRGBA``
- ``aqtSetColor``
- ``aqtSetBackgroundColor``
- ``aqtGetColor``
- ``aqtGetBackgroundColor``

### Text Handling
- ``aqtSetFontname``
- ``aqtSetFontsize``
- ``aqtAddLabel``
- ``aqtAddShearedLabel``

### Line Handling
- ``aqtSetLinewidth``
- ``aqtSetLinestylePattern``
- ``aqtSetLinestyleSolid``
- ``aqtSetLineCapStyle``
- ``aqtMoveTo``
- ``aqtAddLineTo``
- ``aqtAddPolyline``

### Rect and Polygon Handling
- ``aqtMoveToVertex``
- ``aqtAddEdgeToVertex``
- ``aqtAddPolygon``
- ``aqtAddFilledRect``
- ``aqtEraseRect``

### Image Handling
- ``aqtSetImageTransform``
- ``aqtResetImageTransform``
- ``aqtAddImageWithBitmap``
- ``aqtAddImageWithRGBABitmap``

### Deprecated
- ``AQTButtLineCapStyle``
- ``AQTRoundLineCapStyle``
- ``AQTSquareLineCapStyle``
- ``aqtAddTransformedImageWithBitmap``
