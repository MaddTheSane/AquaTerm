C API Documentation
=====

## Topics

### Constants and Enumerations

- ``AQT_EVENTBUF_SIZE``

- ``AQTLineCapStyle``
- ``AQTAlign``

### Horizontal
Constants that specify horizontal alignment for labels.

- ``AQTAlign-enum/Left``
- ``AQTAlign/center`` 
- ``AQTAlign/right`` 

### Vertical
Constants that specify vertical alignment for labels.

- ``AQTAlign/aqtalignmiddle``
- ``AQTAlign/baseline`` 
- ``AQTAlign/bottom`` 
- ``AQTAlign/top``


### Class initialization etc.
- ``aqtInit``
- ``aqtTerminate``
- ``aqtSetEventHandler``
- ``aqtSetEventBlock``


### Control operations
- ``aqtOpenPlot``
- ``aqtSelectPlot``
- ``aqtSetPlotSize``
- ``aqtSetPlotTitle``
- ``aqtRenderPlot``
- ``aqtClearPlot``
- ``aqtClosePlot``

### Event handling
- ``aqtSetAcceptingEvents``
- ``aqtGetLastEvent``
- ``aqtWaitNextEvent``

### Plotting related commands 

### Clip rect, applies to all objects
- ``aqtSetClipRect``
- ``aqtSetDefaultClipRect``

### Colormap (utility)
- ``aqtColormapSize``
- ``aqtSetColormapEntryRGBA``
- ``aqtGetColormapEntryRGBA``
- ``aqtSetColormapEntry``
- ``aqtGetColormapEntry``
- ``aqtTakeColorFromColormapEntry``
- ``aqtTakeBackgroundColorFromColormapEntry``

### Color handling

- ``aqtSetColorRGBA``
- ``aqtSetBackgroundColorRGBA``
- ``aqtGetColorRGBA``
- ``aqtGetBackgroundColorRGBA``
- ``aqtSetColor``
- ``aqtSetBackgroundColor``
- ``aqtGetColor``
- ``aqtGetBackgroundColor``

### Text handling

- ``aqtSetFontname``
- ``aqtSetFontsize``
- ``aqtAddLabel``
- ``aqtAddShearedLabel``

### Line handling

- ``aqtSetLinewidth``
- ``aqtSetLinestylePattern``
- ``aqtSetLinestyleSolid``
- ``aqtSetLineCapStyle``
- ``aqtMoveTo``
- ``aqtAddLineTo``
- ``aqtAddPolyline``

### Rect and polygon handling

- ``aqtMoveToVertex``
- ``aqtAddEdgeToVertex``
- ``aqtAddPolygon``
- ``aqtAddFilledRect``
- ``aqtEraseRect``

### Image handling

- ``aqtSetImageTransform``
- ``aqtResetImageTransform``
- ``aqtAddImageWithBitmap``
- ``aqtAddImageWithRGBABitmap``
- ``aqtAddTransformedImageWithBitmap``
