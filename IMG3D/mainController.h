//
//  mainController.h
//  IMG3D
//
//  Created by 渡辺 圭介 on 2013/10/24.
//  Copyright (c) 2013年 渡辺 圭介. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGL/OpenGL.h>
#import <OpenGL/gl.h>
#import <OpenGL/glu.h>
#import <GLUT/GLUT.h>

#import "matrixClass.h"
#import "drawingView.h"

#define MAX_IMG_SIZE 640

@interface mainController : NSObject <NSWindowDelegate>
{
    
    GLfloat tempVertex[MAX_IMG_SIZE][MAX_IMG_SIZE][3];
    IBOutlet NSWindow* titleWindow_obj;
    IBOutlet NSWindow* mainWindow_obj;
    IBOutlet NSWindow* fullWindow_obj;
    IBOutlet NSPanel* drawingPanel_obj;
    IBOutlet NSImageView* titleImageView_obj;
    IBOutlet NSView* glView_obj;
    IBOutlet NSView* containerView_obj;
    IBOutlet NSView* windowTopView_obj;
    IBOutlet drawingView* drawingView_obj;
    IBOutlet NSTextField* mm1_obj;
    IBOutlet NSTextField* mm2_obj;
    IBOutlet NSTextField* mm3_obj;
    
    // button
    IBOutlet NSButton* export_button_obj;
    //slider
    IBOutlet NSSlider* baseHeight_slider_obj;
    IBOutlet NSSlider* mappinRange_slider_obj;
    IBOutlet NSSlider* xySize_slider_obj;
    IBOutlet NSSlider* smoothing_slider_obj;
    
    //textfield
    IBOutlet NSTextField* baseHeight_text_obj;
    IBOutlet NSTextField* mappingRange_text_obj;
    IBOutlet NSTextField* xySize_text_obj;

    //menu item
    IBOutlet NSMenuItem* open_menu_obj;
    IBOutlet NSMenuItem* export_menu_obj;
    IBOutlet NSMenuItem* showAxis_menu_obj;
    IBOutlet NSMenuItem* showSpecular_menu_obj;
    IBOutlet NSMenuItem* invertBG_menu_obj;
    IBOutlet NSMenuItem* fullscreen_menu_obj;
    IBOutlet NSMenuItem* invertHeight_menu_obj;
    IBOutlet NSMenuItem* drawingPanel_menu_obj;
    IBOutlet NSMenuItem* changeUnit_menu_obj;
    IBOutlet NSMenuItem* mainWindow_menu_obj;
    
    
    // general settings
    BOOL isInchUnit;
    
    
    // fullscreen
    NSRect originalFrame;
    
    

    // OpenGL
    NSOpenGLContext* glContext_obj;
    NSOpenGLPixelFormat* pixFormat;
    
    GLuint VS_OBJ;
    GLuint FS_OBJ;
    GLuint PRG_OBJ;
    GLint UNF_mvp_Matrix;
    GLint UNF_eyeVec;
    GLint UNF_baseColor;
    GLint UNF_specCoef;
    GLint UNF_lightVec;
    
    GLuint axVS_OBJ;
    GLuint axFS_OBJ;
    GLuint axPRG_OBJ;
    GLuint UNF_ax_mvpMatrix;
    
    // for Draw
    matrixClass* matrix_obj;
    NSTimer* drawTimer_obj;
    
    double degX_axis;
    double degY_axis;
    double act_degX;
    double act_degY;
    double eyeDistance;
    double act_eyeDistance;
    
    BOOL isShowAxis;
    BOOL isShowSpecular;
    BOOL isInvertBG;
    BOOL isFullScreen;
    
    GLfloat baseCorner[8][3];
    
    // mouse
    float mouseX;
    float mouseY;
    float scrollDelta;
    
    
    // for object
    float BASE_HEIGHT;
    float MAP_RANGE;
    float XY_SIZE;
    
    GLfloat* sVert_Ptr;
    GLfloat* sNorm_Ptr;
    GLfloat* sCoef_Ptr;
    
    GLfloat* LR_Vert_Ptr;
    GLfloat* LR_Norm_Ptr;
    GLfloat* LR_Coef_Ptr;
    
    GLfloat* TB_Vert_Ptr;
    GLfloat* TB_Norm_Ptr;
    GLfloat* TB_Coef_Ptr;
    
    GLfloat* cap_Vert_Ptr;
    GLfloat* cap_Norm_Ptr;
    GLfloat* cap_Coef_Ptr;
    
    GLfloat objColor[3];
    
    unsigned int NUM_OF_Triangles;
    
    // for Opened image
    int IMG_WIDTH;
    int IMG_HEIGHT;
    BOOL isImgOpened;
    float smoothness;
    double gaussCoef[7][7];
    BOOL isInvertHeight;
    
    unsigned char IMG_VALUE[MAX_IMG_SIZE][MAX_IMG_SIZE];


    // for drawing panel
    BOOL isDrawingPanel;
    
    
    GLfloat biggerSize;
}



- (void)deleteTitleWindow:(NSTimer*)timer;

- (void)windowWillClose:(NSNotification *)notification;

@end




@interface mainController (OPENGL)
- (void)initOpenGL;
- (void)readShader_VS:(GLuint*)vObj FS:(GLuint*)fObj PRG:(GLuint*)prgObj NAME:(NSString*)name;
@end


@interface mainController (MOUSE)
- (void)mouseDraggedFromView:(NSEvent*)event;
- (void)mouseDownFromView:(NSEvent*)event;
- (void)mouseUpFromView:(NSEvent*)event;
@end


@interface mainController (DRAW)
- (void)drawGL:(NSTimer*)timer;
@end


@interface mainController (GUIINIT)
- (void)enableGUI:(BOOL)yn;
- (void)enableMenu:(BOOL)yn;
- (void)setGUIValue;
@end


@interface mainController (GUIMETHOD)
- (IBAction)openButton:(NSButton*)button;
- (IBAction)exportSTL:(NSButton*)button;
- (IBAction)sliderAction:(NSSlider*)slider;
- (IBAction)textFieldAction:(NSTextField*)tField;
- (IBAction)smoothingSlider:(NSSlider*)slider;
@end


@interface mainController (MENU)
- (IBAction)menu_showAxis:(NSMenuItem*)item;
- (IBAction)menu_invertBG:(NSMenuItem*)item;
- (IBAction)menu_fullscreen:(NSMenuItem*)item;
- (IBAction)menu_color:(NSMenuItem*)item;
- (IBAction)menu_invertHeight:(NSMenuItem*)item;
- (IBAction)menu_drawingPanel:(NSMenuItem*)item;
- (IBAction)menu_changeUnit:(NSMenuItem*)item;
- (IBAction)menu_mainWindow:(NSMenuItem*)item;
@end


@interface mainController (UTILITY)
- (void)calculate;
@end