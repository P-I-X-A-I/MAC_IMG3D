//
//  glView.m
//  IMG3D
//
//  Created by 渡辺 圭介 on 2013/10/24.
//  Copyright (c) 2013年 渡辺 圭介. All rights reserved.
//

#import "glView.h"

@implementation glView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}


- (void)mouseDragged:(NSEvent *)theEvent
{
    [mainController_obj mouseDraggedFromView:theEvent];
}
- (void)mouseDown:(NSEvent *)theEvent
{
    [mainController_obj mouseDownFromView:theEvent];
}
- (void)mouseUp:(NSEvent *)theEvent
{
    [mainController_obj mouseUpFromView:theEvent];
}

@end
