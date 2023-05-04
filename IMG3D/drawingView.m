//
//  drawingView.m
//  IMG3D
//
//  Created by 渡辺 圭介 on 2013/10/28.
//  Copyright (c) 2013年 渡辺 圭介. All rights reserved.
//

#import "drawingView.h"

@implementation drawingView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        
        isSomethingDrawn = NO;
        penMode = 0;
        
        penPos[0] = 0.0;
        penPos[1] = 0.0;
    }
    return self;
}


- (void)awakeFromNib
{
    NSImage* pencilImage = [NSImage imageNamed:@"pencil"];
    NSImage* eraserImage = [NSImage imageNamed:@"eraser"];
    
    [pencilButton setImage:pencilImage];
    [pencilButton setAlternateImage:pencilImage];
    [eraserButton setImage:eraserImage];
    [eraserButton setAlternateImage:eraserImage];
    
    
    [pencilButton setEnabled:NO];
    [eraserButton setEnabled:YES];
    [pencilButton setAlphaValue:0.5];
    [eraserButton setAlphaValue:1.0];
    
    
    NSLog(@"drawing View AFN");
    
    // focus to drawing view
    [self lockFocus];
    
    // set color
    [[NSColor blackColor] set];
    
    // make fill rect
    NSRect entireRect = NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height );
    
    // draw rect
    [NSBezierPath fillRect:entireRect];
    
    // flush
    [[NSGraphicsContext currentContext] flushGraphics];
    
    [self unlockFocus];
    
    
    drawColor_ARRAY = [[NSMutableArray alloc] init];
    eraseColor_ARRAY = [[NSMutableArray alloc] init];
    
    for( int i = 1 ; i <= 10; i++ )
    {
        NSColor* tempColor = [NSColor colorWithDeviceRed:1.0 green:1.0 blue:1.0 alpha:i*0.075];
        [drawColor_ARRAY addObject:tempColor];
        
        NSColor* clearColor = [NSColor colorWithDeviceRed:0.0 green:0.0 blue:0.0 alpha:i*0.075];
        [eraseColor_ARRAY addObject:clearColor];
    }
    
}

//- (void)drawRect:(NSRect)dirtyRect
//{
// 	//[super drawRect:dirtyRect];
//	
//}




- (void)mouseDragged:(NSEvent *)theEvent
{
    isSomethingDrawn = YES;
    
    //NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    NSMutableArray* targetArray;
    float penX = [theEvent locationInWindow].x;
    float penY = [theEvent locationInWindow].y;
    float yShift = self.frame.origin.y;     penY -= yShift;
    
    
    // lock focus
    [self lockFocus];
    
    
    // set color and radius
    if (penMode == 0)
    {
        targetArray = drawColor_ARRAY;
    }
    else
    {
        targetArray = eraseColor_ARRAY;
    }
    
    
    for( int i = 0 ; i < 10 ; i++  )
    {
        // set color
        NSColor* tempColor = [targetArray objectAtIndex:i];
        [tempColor set];
        
        // set radius
        float radius = (10-i)*2.0 + 10.0;
    
        [NSBezierPath setDefaultLineWidth:radius];
        [NSBezierPath setDefaultLineCapStyle:NSRoundLineCapStyle];
        
        [NSBezierPath strokeLineFromPoint:NSMakePoint(penPos[0], penPos[1])
                                  toPoint:NSMakePoint(penX, penY)];
        

    }
    
    
    
    
    
    // flush context
    [[NSGraphicsContext currentContext] flushGraphics];
    
    
    // unlock and pool release
    [self unlockFocus];
    //[pool release];
    
    
    // set current pen position
    penPos[0] = penX;
    penPos[1] = penY;
}
- (void)mouseDown:(NSEvent *)theEvent
{
    isSomethingDrawn = YES;
    
    //NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    NSMutableArray* targetArray;
    float penX = [theEvent locationInWindow].x;
    float penY = [theEvent locationInWindow].y;
    float yShift = self.frame.origin.y;     penY -= yShift;
    
    
    // lock focus
    [self lockFocus];
    
    
    // set color and radius
    if (penMode == 0)
    {
        targetArray = drawColor_ARRAY;
    }
    else
    {
        targetArray = eraseColor_ARRAY;
    }
    
    
    for( int i = 0 ; i < 10 ; i++  )
    {
        // set color
        NSColor* tempColor = [targetArray objectAtIndex:i];
        [tempColor set];
        
        // set radius
        float radius = (10-i)*3.0;
        
        [NSBezierPath setDefaultLineWidth:radius];
        [NSBezierPath setDefaultLineCapStyle:NSRoundLineCapStyle];
        
        [NSBezierPath strokeLineFromPoint:NSMakePoint(penX, penY)
                                  toPoint:NSMakePoint(penX, penY)];
        
        
    }
    
    
    
    
    
    // flush context
    [[NSGraphicsContext currentContext] flushGraphics];
    
    
    // unlock and pool release
    [self unlockFocus];
    //[pool release];
    
    
    // set current pen position
    penPos[0] = penX;
    penPos[1] = penY;
}
- (void)mouseUp:(NSEvent *)theEvent
{
    [self lockFocus];
    
    NSBitmapImageRep* imageRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:[self bounds]];
    NSImage* drawnImage = [[NSImage alloc] initWithData:[imageRep TIFFRepresentation]];
    
    NSLog(@"%f %f %f %f", self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height );
    
    [mainController_obj getImageValue:drawnImage];
    
    [drawnImage release];
    [imageRep release];
    
    [self unlockFocus];

}




- (void)windowDidAppear
{
    if( !isSomethingDrawn )
    {
        [self lockFocus];
        
        // set color
        [[NSColor blackColor] set];
        
        // make rect
        NSRect tempRect = NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height );
        
        // draw rect
        [NSBezierPath fillRect:tempRect];
        
        [[NSGraphicsContext currentContext] flushGraphics];
        
        [self unlockFocus];
    }
}
- (void)windowWillClose
{
}







- (IBAction)pencilButton:(NSButton*)button
{
    penMode = 0;
    [button setEnabled:NO];
    [button setAlphaValue:0.5];
    [eraserButton setEnabled:YES];
    [eraserButton setState:NSOffState];
    [eraserButton setAlphaValue:1.0];
}
- (IBAction)eraserButton:(NSButton*)button
{
    penMode = 1;
    [button setEnabled:NO];
    [button setAlphaValue:0.5];
    [pencilButton setEnabled:YES];
    [pencilButton setState:NSOffState];
    [pencilButton setAlphaValue:1.0];
}
- (IBAction)deleteAllButton:(NSButton*)button
{
    [self lockFocus];
    
    // set color
    [[NSColor blackColor] set];
    
    // make rect
    NSRect tempRect = NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height );
    
    // draw rect
    [NSBezierPath fillRect:tempRect];
    
    [[NSGraphicsContext currentContext] flushGraphics];
    
    [self unlockFocus];
    
    
    
    
    // and make 3D
    [self lockFocus];
    
    NSBitmapImageRep* imageRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:[self bounds]];
    NSImage* drawnImage = [[NSImage alloc] initWithData:[imageRep TIFFRepresentation]];
    
    NSLog(@"%f %f %f %f", self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height );
    
    [mainController_obj getImageValue:drawnImage];
    
    [drawnImage release];
    [imageRep release];
    
    [self unlockFocus];

}

@end
