#import "AQTPrefController.h"
#import "PreferenceKeys.h"

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
   float lw = [preferences floatForKey:MinimumLineWidthKey];
   [imageInterpolateLevel selectItemAtIndex:[preferences integerForKey:ImageInterpolationKey]];
   [crosshairCursorColor selectItemAtIndex:[preferences integerForKey:CrosshairColorKey]];
   shouldAntialiasSwitch.state = [preferences boolForKey:AntialiasDrawingKey] ? NSOnState : NSOffState;
   minimumLinewidthSlider.doubleValue = lw;
   linewidthDisplay.stringValue = (lw < 0.04)?@"off":[NSString stringWithFormat:@"%4.2f", lw];
   minimumLinewidthSlider.doubleValue = [preferences floatForKey:MinimumLineWidthKey];
   convertSymbolFontSwitch.state = [preferences boolForKey:ConvertSymbolFontKey] ? NSOnState : NSOffState;
   closeWindowSwitch.state = [preferences boolForKey:CloseWindowWithPlotKey] ? NSOnState : NSOffState;
   confirmCloseWindowSwitch.state = [preferences boolForKey:ConfirmCloseWindowWithPlotKey] ? NSOnState : NSOffState;
   showProcessNameSwitch.state = [preferences boolForKey:ShowProcessNameKey] ? NSOnState : NSOffState;
   showProcessIdSwitch.state = [preferences boolForKey:ShowProcessIDKey] ? NSOnState : NSOffState;
   
   confirmCloseWindowSwitch.enabled = (closeWindowSwitch.state == NSOffState)?NO:YES;
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
   [preferences setInteger:imageInterpolateLevel.indexOfSelectedItem forKey:ImageInterpolationKey];
   [preferences setInteger:crosshairCursorColor.indexOfSelectedItem forKey:CrosshairColorKey];
   [preferences setBool:shouldAntialiasSwitch.state == NSOnState forKey:AntialiasDrawingKey];
   [preferences setFloat:minimumLinewidthSlider.doubleValue forKey:MinimumLineWidthKey];
   [preferences setBool:convertSymbolFontSwitch.state == NSOnState forKey:ConvertSymbolFontKey];
   [preferences setBool:closeWindowSwitch.state == NSOnState forKey:CloseWindowWithPlotKey];
   [preferences setBool:confirmCloseWindowSwitch.state == NSOnState forKey:ConfirmCloseWindowWithPlotKey];
   [preferences setBool:showProcessNameSwitch.state == NSOnState forKey:ShowProcessNameKey];
   [preferences setBool:showProcessIdSwitch.state == NSOnState forKey:ShowProcessIDKey];
   [prefWindow orderOut:self];
}

- (IBAction)linewidthSliderMoved:(id)sender
{
   double lw = [sender doubleValue];
   linewidthDisplay.stringValue = (lw < 0.04)?@"off":[NSString stringWithFormat:@"%4.2f", lw];
}

@end
