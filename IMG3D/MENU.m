#import "mainController.h"

@implementation mainController (MENU)

- (IBAction)menu_showAxis:(NSMenuItem*)item
{
    isShowAxis = !isShowAxis;
}

- (IBAction)menu_invertBG:(NSMenuItem*)item
{
    isInvertBG = !isInvertBG;
}

- (IBAction)menu_showSpecular:(NSMenuItem*)item
{
    isShowSpecular = !isShowSpecular;
}


- (IBAction)menu_fullscreen:(NSMenuItem*)item
{
    isFullScreen = !isFullScreen;
    
    
    if( isFullScreen )
    {
        // remove glview
        [glView_obj retain];
        [glView_obj removeFromSuperview];
        
        // main window & screen
        NSScreen* currentScreen = [mainWindow_obj deepestScreen];
        NSRect fullRect = NSMakeRect(0.0, 0.0, currentScreen.frame.size.width, currentScreen.frame.size.height);
        [mainWindow_obj orderBack:nil];
        
        // show full window
        
        [fullWindow_obj setLevel:NSScreenSaverWindowLevel];
        [fullWindow_obj setFrame:[currentScreen frame] display:YES];
        
        // add glView
        [[fullWindow_obj contentView] addSubview:glView_obj];
        [glView_obj setFrame:fullRect];
        [fullWindow_obj makeKeyAndOrderFront:nil];
        
        // update context
        [glContext_obj update];
        
        
        // disable menu
        [export_menu_obj setHidden:YES];
        [open_menu_obj setHidden:YES];
        [drawingPanel_menu_obj setHidden:YES];
        [mainWindow_menu_obj setHidden:YES];
    }
    else
    {
        // remove glview
        [glView_obj retain];
        [glView_obj removeFromSuperview];
        
        // full window
        [fullWindow_obj setFrame:NSMakeRect(0, 0, 0, 0) display:NO];
        [fullWindow_obj orderBack:nil];
        
        // add glview to mainwindow
        [glView_obj setFrame:originalFrame];
        [[mainWindow_obj contentView] addSubview:glView_obj];
        [mainWindow_obj makeKeyAndOrderFront:nil];
        
        // update context
        [glContext_obj update];
        
        // enable menu
        [export_menu_obj setHidden:NO];
        [open_menu_obj setHidden:NO];
        [drawingPanel_menu_obj setHidden:NO];
        [mainWindow_menu_obj setHidden:NO];
    }
}

- (IBAction)menu_color:(NSMenuItem*)item
{
    long tagNum = [item tag];
    
    
    switch ( tagNum ) {
        case 0://red
            objColor[0] = 1.0;
            objColor[1] = 0.0;
            objColor[2] = 0.0;
            break;
        case 1://green
            objColor[0] = 0.0;
            objColor[1] = 1.0;
            objColor[2] = 0.0;
            break;
        case 2://blue
            objColor[0] = 0.0;
            objColor[1] = 0.0;
            objColor[2] = 1.0;
            break;
        case 3://C
            objColor[0] = 0.0;
            objColor[1] = 1.0;
            objColor[2] = 1.0;
            break;
        case 4://M
            objColor[0] = 1.0;
            objColor[1] = 0.0;
            objColor[2] = 1.0;
            break;
        case 5://Y
            objColor[0] = 1.0;
            objColor[1] = 1.0;
            objColor[2] = 0.0;
            break;
        case 6://W
            objColor[0] = 0.8;
            objColor[1] = 0.8;
            objColor[2] = 0.8;
            break;
            
        default:
            break;
    }
}



- (IBAction)menu_invertHeight:(NSMenuItem*)item
{
    if( isImgOpened )
    {
        isInvertHeight = !isInvertHeight;
    
        if( isInvertHeight )
        {
            [item setState:NSOnState];
        }
        else
        {
            [item setState:NSOffState];
        }
    
        [self calculate];
    }
}



- (IBAction)menu_drawingPanel:(NSMenuItem*)item
{
    BOOL isShowed = [drawingPanel_obj isVisible];
    
    if( isShowed )
    {
        [drawingPanel_obj orderOut:nil];
        isDrawingPanel = NO;
        [drawingView_obj windowWillClose];
    }
    else
    {
        [drawingPanel_obj makeKeyAndOrderFront:nil];
        isDrawingPanel = YES;
    }
}


- (IBAction)menu_changeUnit:(NSMenuItem*)item
{
    
    isInchUnit = !isInchUnit;
    
    if( isInchUnit )
    {
        [item setTitle:@"Change to mm"];
        [mm1_obj setStringValue:@"inch"];
        [mm2_obj setStringValue:@"inch"];
        [mm3_obj setStringValue:@"inch"];
        [baseHeight_text_obj setFloatValue:BASE_HEIGHT*(1.0/25.4)];
        [mappingRange_text_obj setFloatValue:MAP_RANGE*(1.0/25.4)];
        [xySize_text_obj setFloatValue:XY_SIZE*(1.0/25.4)];
    }
    else
    {
        [item setTitle:@"Change to Inch"];
        [mm1_obj setStringValue:@"mm"];
        [mm2_obj setStringValue:@"mm"];
        [mm3_obj setStringValue:@"mm"];
        [baseHeight_text_obj setFloatValue:BASE_HEIGHT];
        [mappingRange_text_obj setFloatValue:MAP_RANGE];
        [xySize_text_obj setFloatValue:XY_SIZE];
    }
}



- (IBAction)menu_mainWindow:(NSMenuItem*)item
{
    BOOL yn = mainWindow_obj.isVisible;
    
    if( yn )
    {
        [mainWindow_obj orderBack:nil];
    }
    else
    {
        [mainWindow_obj makeKeyAndOrderFront:nil];
    }
    
}

@end