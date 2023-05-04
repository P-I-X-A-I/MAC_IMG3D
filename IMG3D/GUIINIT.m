#import "mainController.h"


@implementation  mainController (GUIINIT)

- (void)enableGUI:(BOOL)yn
{
    [export_button_obj setEnabled:yn];
    
    [baseHeight_slider_obj setEnabled:yn];
    [baseHeight_text_obj setEnabled:yn];
    
    [mappinRange_slider_obj setEnabled:yn];
    [mappingRange_text_obj setEnabled:yn];
    
    [xySize_slider_obj setEnabled:yn];
    [xySize_text_obj setEnabled:yn];
    
    [smoothing_slider_obj setEnabled:yn];
    
}


- (void)enableMenu:(BOOL)yn
{
    [export_menu_obj setHidden:!yn];
    [open_menu_obj setHidden:!yn];
    [showAxis_menu_obj setHidden:!yn];
    [showSpecular_menu_obj setHidden:!yn];
    [invertBG_menu_obj setHidden:!yn];
    [fullscreen_menu_obj setHidden:!yn];
    [invertBG_menu_obj setHidden:!yn];
    [invertHeight_menu_obj setHidden:!yn];
    [drawingPanel_menu_obj setHidden:!yn];
    [mainWindow_menu_obj setHidden:!yn];
}


- (void)setGUIValue
{
    float convert;
    if( isInchUnit )
    {
        [mm1_obj setStringValue:@"inch"];
        [mm2_obj setStringValue:@"inch"];
        [mm3_obj setStringValue:@"inch"];
        convert = 1.0/25.4;
        
        [changeUnit_menu_obj setTitle:@"Change to mm"];
    }
    else
    {
        [mm1_obj setStringValue:@"mm"];
        [mm2_obj setStringValue:@"mm"];
        [mm3_obj setStringValue:@"mm"];
        convert = 1.0;
        
        [changeUnit_menu_obj setTitle:@"Change to Inch"];
    }
    
    
    [baseHeight_slider_obj setFloatValue:BASE_HEIGHT];
    [baseHeight_text_obj setFloatValue:BASE_HEIGHT*convert];
    
    [mappinRange_slider_obj setFloatValue:MAP_RANGE];
    [mappingRange_text_obj setFloatValue:MAP_RANGE*convert];
    
    [xySize_slider_obj setFloatValue:XY_SIZE];
    [xySize_text_obj setFloatValue:XY_SIZE*convert];
    
    [smoothing_slider_obj setFloatValue:smoothness];
    
    
    [invertBG_menu_obj setState:isInvertHeight];
    
    
    
}

@end