#import "mainController.h"


@implementation mainController (MOUSE)

-(void)mouseDraggedFromView:(NSEvent *)event
{
    NSPoint mP = [NSEvent mouseLocation];
    
    float deltaX = mP.x - mouseX;
    float deltaY = mP.y - mouseY;

    degX_axis += deltaY;
    degY_axis -= deltaX;
    
    if( degX_axis > 36000.0 )
    { degX_axis -= 360.0; }
    else if( degX_axis < -36000.0 )
    { degX_axis += 360.0;}
    
    if( degY_axis > 36000.0 )
    { degY_axis -= 360.0; }
    else if( degY_axis < -36000.0)
    { degY_axis += 360.0; }
    
    mouseX = mP.x;
    mouseY = mP.y;
    
}

- (void)mouseDownFromView:(NSEvent *)event
{
    NSPoint mP = [NSEvent mouseLocation];
    
    mouseX = mP.x;
    mouseY = mP.y;
}

- (void)mouseUpFromView:(NSEvent *)event
{
    mouseX = 0.0;
    mouseY = 0.0;
}

@end