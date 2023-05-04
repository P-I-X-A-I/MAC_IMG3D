//
//  glView.h
//  IMG3D
//
//  Created by 渡辺 圭介 on 2013/10/24.
//  Copyright (c) 2013年 渡辺 圭介. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "mainController.h"

@interface glView : NSView
{
    IBOutlet mainController* mainController_obj;
}

- (void)mouseDragged:(NSEvent *)theEvent;
- (void)mouseDown:(NSEvent *)theEvent;
- (void)mouseUp:(NSEvent *)theEvent;
@end
