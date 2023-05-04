//
//  mainController.m
//  IMG3D
//
//  Created by 渡辺 圭介 on 2013/10/24.
//  Copyright (c) 2013年 渡辺 圭介. All rights reserved.
//

#import "mainController.h"

@implementation mainController

- (id)init
{
    self = [super init];
    
    
    // init object
    matrix_obj = [[matrixClass alloc] init];
    
    
    // init variable
    mouseX = 0.0;
    mouseY = 0.0;
    scrollDelta = 0.0;
    
    BASE_HEIGHT = 10.0;
    MAP_RANGE = 20.0;
    XY_SIZE = 100.0;
    
    degX_axis = act_degX = -30.0;
    degY_axis = act_degY = 30.0;
    eyeDistance = act_eyeDistance = 120.0;
    
    isShowAxis = YES;
    isShowSpecular = YES;
    isInvertBG = NO;
    isFullScreen = NO;
    
    IMG_WIDTH = 0;
    IMG_HEIGHT = 0;
    isImgOpened = NO;
    
    smoothness = 0.0;
    for( int i = 0 ; i < 7 ; i++ )
    {
        for( int j = 0 ; j < 7 ; j++ )
        {
            gaussCoef[i][j] = 0.0;
        }
    }
    gaussCoef[3][3] = 1.0;
    
    
    objColor[0] = 1.0;
    objColor[1] = 0.0;
    objColor[2] = 0.0;
    
    NUM_OF_Triangles = 0;
    
    isInvertHeight = NO;
    
    isDrawingPanel = NO;
    
    isInchUnit = NO;
    
    // pointer
    sVert_Ptr = nil;
    sNorm_Ptr = nil;
    sCoef_Ptr = nil;
    
    LR_Vert_Ptr = nil;
    LR_Norm_Ptr = nil;
    LR_Coef_Ptr = nil;
    
    TB_Vert_Ptr = nil;
    TB_Norm_Ptr = nil;
    TB_Coef_Ptr = nil;
    
    cap_Vert_Ptr = nil;
    cap_Norm_Ptr = nil;
    cap_Coef_Ptr = nil;
    
    return self;
}


- (void)awakeFromNib
{
    NSLog(@"mainController AFN");
    
    
    
    // set title Window to screen center
    NSScreen* tempScreen = [NSScreen mainScreen];
    float sWidth = tempScreen.frame.size.width;
    float sHeight = tempScreen.frame.size.height;
    
    float titleWindow_Width = titleWindow_obj.frame.size.width;
    float titleWindow_Height = titleWindow_obj.frame.size.height;
    
    NSPoint originPoint = NSMakePoint((sWidth/2.0) - (titleWindow_Width/2.0),
                                      (sHeight/2.0) - (titleWindow_Height/2.0));
    
    // set title image
    NSImage* titleImage = [NSImage imageNamed:@"title"];
    [titleImageView_obj setImage:titleImage];
    
    // show title window
    [titleWindow_obj setLevel:NSScreenSaverWindowLevel];
    [titleWindow_obj setFrameOrigin:originPoint];
    [titleWindow_obj orderFront:nil];
    
    
    // get container view's rect
    originalFrame = [glView_obj frame];
    
    // disable GUI
    [self enableGUI:NO];
    [self enableMenu:NO];
    [self setGUIValue];
    
    // init GUI
    [baseHeight_text_obj setFloatValue:BASE_HEIGHT];
    [mappingRange_text_obj setFloatValue:MAP_RANGE];
    [xySize_text_obj setFloatValue:XY_SIZE];
    
    // set timer for closing title window
    NSTimer* tempTimer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                          target:self
                                                        selector:@selector(deleteTitleWindow:)
                                                        userInfo:nil
                                                         repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:tempTimer forMode:NSDefaultRunLoopMode];
    
}




- (void)deleteTitleWindow:(NSTimer*)timer
{
    [timer invalidate];
    
    
    // hide title window
    [titleWindow_obj orderBack:nil];
    [titleWindow_obj release];
    
    //
    NSScreen* tempScreen = [NSScreen mainScreen];
    float sWidth = tempScreen.frame.size.width;
    float sHeight = tempScreen.frame.size.height;
    float mainWindow_Width = mainWindow_obj.frame.size.width;
    float mainWindow_Height = mainWindow_obj.frame.size.height;
    NSPoint originPoint = NSMakePoint((sWidth/2.0) - (mainWindow_Width/2.0),
                                      (sHeight/2.0) - (mainWindow_Height/2.0));
    [mainWindow_obj setFrameOrigin:originPoint];
    [mainWindow_obj makeKeyAndOrderFront:nil];
    
    
    
    // init OpenGL, Shader,
    
    [self initOpenGL];
    
    // enable menu
    [self enableMenu:YES];
    
    
    // start draw timer
    drawTimer_obj = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0
                                                     target:self
                                                   selector:@selector(drawGL:)
                                                   userInfo:Nil
                                                    repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:drawTimer_obj forMode:NSDefaultRunLoopMode];
}


- (void)windowWillClose:(NSNotification *)notification
{
    isDrawingPanel = NO;
    [drawingView_obj windowWillClose];
}

- (void)windowDidBecomeKey:(NSNotification *)notification
{
    isDrawingPanel = YES;
    [drawingView_obj windowDidAppear];
}

@end
