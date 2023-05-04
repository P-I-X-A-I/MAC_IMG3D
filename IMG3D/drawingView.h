//
//  drawingView.h
//  IMG3D
//
//  Created by 渡辺 圭介 on 2013/10/28.
//  Copyright (c) 2013年 渡辺 圭介. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface drawingView : NSView
{
    IBOutlet NSPanel* drawingPanel;
    IBOutlet NSButton* pencilButton;
    IBOutlet NSButton* eraserButton;
    
    BOOL isSomethingDrawn;
    int penMode;
    float penPos[2];
    NSMutableArray* drawColor_ARRAY;
    NSMutableArray* eraseColor_ARRAY;
    
    IBOutlet id mainController_obj;

}

- (IBAction)pencilButton:(NSButton*)button;
- (IBAction)eraserButton:(NSButton*)button;
- (IBAction)deleteAllButton:(NSButton*)button;

- (void)mouseDragged:(NSEvent *)theEvent;
- (void)mouseDown:(NSEvent *)theEvent;
- (void)mouseUp:(NSEvent *)theEvent;

- (void)windowDidAppear;
- (void)windowWillClose;

@end
