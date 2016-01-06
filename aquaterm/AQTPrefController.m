#import "AQTPrefController.h"

@implementation AQTPrefController
+ (AQTPrefController *)sharedPrefController
{
   static AQTPrefController *sharedPrefController = nil;
   if (sharedPrefController == nil) {
      sharedPrefController = [[self alloc] init];
   }   return sharedPrefController;
}

-(instancetype)init
{
   if (self = [super init])
   {
      [NSBundle loadNibNamed:@"Preferences.nib" owner:self];
   }
   return self;
}

-(void)awakeFromNib
{
   [self showPrefs]; 
}

- (void)showPrefs {
   float lw = [preferences floatForKey:@"MinimumLinewidth"];
   [imageInterpolateLevel selectItemAtIndex:[preferences integerForKey:@"ImageInterpolationLevel"]];
   [crosshairCursorColor selectItemAtIndex:[preferences integerForKey:@"CrosshairCursorColor"]];
   shouldAntialiasSwitch.integerValue = [preferences integerForKey:@"ShouldAntialiasDrawing"];
   minimumLinewidthSlider.doubleValue = lw;
   linewidthDisplay.stringValue = (lw < 0.04)?@"off":[NSString stringWithFormat:@"%4.2f", lw];
   minimumLinewidthSlider.doubleValue = [preferences floatForKey:@"MinimumLinewidth"];
   convertSymbolFontSwitch.integerValue = [preferences integerForKey:@"ShouldConvertSymbolFont"];
   closeWindowSwitch.integerValue = [preferences integerForKey:@"CloseWindowWhenClosingPlot"];
   confirmCloseWindowSwitch.integerValue = [preferences integerForKey:@"ConfirmCloseWindowWhenClosingPlot"];
   showProcessNameSwitch.integerValue = [preferences integerForKey:@"ShowProcessName"];
   showProcessIdSwitch.integerValue = [preferences integerForKey:@"ShowProcessId"];
   
   confirmCloseWindowSwitch.enabled = (closeWindowSwitch.integerValue == 0)?NO:YES;
   [self updateTitleExample:self];
   [prefWindow makeKeyAndOrderFront:self];
}

- (IBAction)windowClosingChanged:(id)sender
{
   confirmCloseWindowSwitch.enabled = (closeWindowSwitch.integerValue == 0)?NO:YES;
}

- (IBAction)updateTitleExample:(id)sender
{
   titleExample.stringValue = [NSString stringWithFormat:@"%@%@Figure 1", showProcessNameSwitch.integerValue?@"gnuplot ":@"", showProcessIdSwitch.integerValue?@"(1151) ":@""];
}

- (IBAction)cancelButtonPressed:(id)sender
{
   [prefWindow orderOut:self];   
}

- (IBAction)OKButtonPressed:(id)sender
{
   [preferences setInteger:imageInterpolateLevel.indexOfSelectedItem forKey:@"ImageInterpolationLevel"];
   [preferences setInteger:crosshairCursorColor.indexOfSelectedItem forKey:@"CrosshairCursorColor"];
   [preferences setInteger:shouldAntialiasSwitch.integerValue forKey:@"ShouldAntialiasDrawing"];
   [preferences setFloat:minimumLinewidthSlider.doubleValue forKey:@"MinimumLinewidth"];
   [preferences setInteger:convertSymbolFontSwitch.integerValue forKey:@"ShouldConvertSymbolFont"];
   [preferences setInteger:closeWindowSwitch.integerValue forKey:@"CloseWindowWhenClosingPlot"];
   [preferences setInteger:confirmCloseWindowSwitch.integerValue forKey:@"ConfirmCloseWindowWhenClosingPlot"];
   [preferences setInteger:showProcessNameSwitch.integerValue forKey:@"ShowProcessName"];
   [preferences setInteger:showProcessIdSwitch.integerValue forKey:@"ShowProcessId"];
   [prefWindow orderOut:self];
}

- (IBAction)linewidthSliderMoved:(id)sender
{
   float lw = [sender doubleValue];
   linewidthDisplay.stringValue = (lw < 0.04)?@"off":[NSString stringWithFormat:@"%4.2f", lw];
}

@end
