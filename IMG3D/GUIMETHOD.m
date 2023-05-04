#import "mainController.h"

@implementation mainController (GUIMETHOD)


- (IBAction)sliderAction:(NSSlider*)slider
{
    float value = [slider floatValue];
    NSInteger tagNum = [slider tag];
    
    float convert;
    
    if( isInchUnit )
    {
        convert = 1.0 / 25.4;
    }
    else
    {
        convert = 1.0;
    }
    
    switch ( tagNum ) {
        case 0: // base height
            BASE_HEIGHT = value;
            [baseHeight_text_obj setFloatValue:BASE_HEIGHT*convert];
            break;
        case 1: // mapping range
            MAP_RANGE = value;
            [mappingRange_text_obj setFloatValue:MAP_RANGE*convert];
            break;
        case 2: // xy size
            XY_SIZE = value;
            [xySize_text_obj setFloatValue:XY_SIZE*convert];
            break;
        default:
            break;
    }
    
    [self calculate];
}



- (IBAction)textFieldAction:(NSTextField*)tField
{
    float value = [tField floatValue];
    NSInteger tagNum = [tField tag];
    double maxV, minV;
    float displayedValue;
    
    double convert;
    double mmToInch;
    
    if( isInchUnit )
    {
        convert = 25.4;
        mmToInch = 1.0/25.4;
    }
    else
    {
        convert = 1.0;
        mmToInch = 1.0;
    }
    
    switch ( tagNum ) {
        case 0:
            maxV = [baseHeight_slider_obj maxValue]*mmToInch;
            minV = [baseHeight_slider_obj minValue]*mmToInch;
            
            BASE_HEIGHT = fmax(minV, value);
            BASE_HEIGHT = fmin(maxV, BASE_HEIGHT);
            displayedValue = BASE_HEIGHT;
            BASE_HEIGHT *= convert;
            [baseHeight_text_obj setFloatValue:displayedValue];
            [baseHeight_slider_obj setFloatValue:BASE_HEIGHT];
            
            break;
        case 1:
            maxV = [mappinRange_slider_obj maxValue]*mmToInch;
            minV = [mappinRange_slider_obj minValue]*mmToInch;
            
            MAP_RANGE = fmax( minV, value );
            MAP_RANGE = fmin( maxV, MAP_RANGE );
            displayedValue = MAP_RANGE;
            MAP_RANGE *= convert;
            [mappingRange_text_obj setFloatValue:displayedValue];
            [mappinRange_slider_obj setFloatValue:MAP_RANGE];

            break;
        case 2:
            maxV = [xySize_slider_obj maxValue]*mmToInch;
            minV = [xySize_slider_obj minValue]*mmToInch;
            
            XY_SIZE = fmax( minV, value );
            XY_SIZE = fmin( maxV, XY_SIZE );
            displayedValue = XY_SIZE;
            XY_SIZE *= convert;
            [xySize_text_obj setFloatValue:displayedValue];
            [xySize_slider_obj setFloatValue:XY_SIZE];

            break;
            
        default:
            break;
    }
    
    [self calculate];
}


- (IBAction)smoothingSlider:(NSSlider*)slider
{
    float value = [slider floatValue];
    
    if( value < 0.1 )
    {
        smoothness = 0.0;
        for( int i = 0 ; i < 7 ; i++ )
        {
            for( int j = 0 ; j < 7 ; j++ )
            {
                gaussCoef[i][j] = 0.0;
            }
        }
        gaussCoef[3][3] = 1.0;
    }
    else
    {
        
        smoothness = value;
        double sum = 0.0;
        double normalize;
        
        for( int i = 0 ; i < 7 ; i++ )
        {
            for( int j = 0 ; j < 7 ; j++ )
            {
                double X = i-3;
                double Y = j-3;
                
                double value = 1.0/(M_PI*2.0*smoothness) * exp(-(X*X + Y*Y)/(2.0*smoothness));
                gaussCoef[i][j] = value;
                
                sum += gaussCoef[i][j];
            }
            
            //NSLog(@"%1.3f %1.3f %1.3f %1.3f %1.3f %1.3f %1.3f \n", gaussCoef[i][0], gaussCoef[i][1], gaussCoef[i][2], gaussCoef[i][3], gaussCoef[i][4], gaussCoef[i][5], gaussCoef[i][6]);
        }

        // calculate normalize coef
        normalize = 1.0 / sum;
        
        // normalize gaussfilter
        for( int i = 0 ; i < 7 ; i++ )
        {
            for( int j = 0 ; j < 7 ; j++ )
            {
                gaussCoef[i][j] *= normalize;
            }
        }
        
        
    }// else
    
    [self calculate];
}








- (IBAction)openButton:(NSButton*)button
{
    
    // stop draw timer
    [drawTimer_obj invalidate];
    
    
    // Open open Panel
    NSOpenPanel* o_Panel = [NSOpenPanel openPanel];
    
    // set allowed type
    NSArray* allowedFileType = [NSArray arrayWithObjects:@"bmp", @"png", @"jpg", @"jpeg", nil];
    [o_Panel setAllowedFileTypes:allowedFileType];
    
    
    // show open panel
    NSURL* fileURL;
    NSInteger pressedButton = [o_Panel runModal];
    
    
    if( pressedButton == NSOKButton )
    {
        fileURL = [o_Panel URL];
    }
    else
    {
        fileURL = nil;
        
        
        // fire timer
        drawTimer_obj = [NSTimer scheduledTimerWithTimeInterval:1/60.0
                                                         target:self
                                                       selector:@selector(drawGL:)
                                                       userInfo:nil
                                                        repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:drawTimer_obj forMode:NSDefaultRunLoopMode];
        
        return;
    }
    
    
    
    
    
    // Open Image
    NSImage* openImage = [[NSImage alloc] initWithContentsOfURL:fileURL];
    
    
    // get image data
    [self getImageValue:openImage];
    
    
    
    
    
    
    // release image
    //[imageRep release];
    [openImage release];
    //[scaled_Image release];


    // fire timer
    NSLog(@"re-fire timer");
    drawTimer_obj = [NSTimer scheduledTimerWithTimeInterval:1/60.0
                                                     target:self
                                                   selector:@selector(drawGL:)
                                                   userInfo:nil
                                                    repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:drawTimer_obj forMode:NSDefaultRunLoopMode];

}




- (void)getImageValue:(NSImage*)openImageN
{
    int i, j;
    // check image size
    
    // Create CGImage because of NSImage's Retina issue.
//    NSBitmapImageRep* tempRep = [[NSBitmapImageRep alloc] initWithData:[openImage TIFFRepresentation]];
//    CGImageRef tempCGRep = [tempRep CGImage];
//    
//    float imgWidth = CGImageGetWidth( tempCGRep );
//    float imgHeight = CGImageGetHeight( tempCGRep );
//    float imgRepWidth = (float)[tempRep pixelsWide];
//    float imgRepHeight = (float)[tempRep pixelsHigh];
//    float nsImageWidth = (float)[openImage size].width;
//    float nsImageHeight = (float)[openImage size].height;
//    
//    float scaleFactor = [[NSScreen mainScreen] backingScaleFactor];
//    NSRect scaledRect;
//    NSImage* scaled_Image;
//    
//    NSLog(@"NSwidth:%1.1f NSheight:%1.1f : CGwidth:%1.1f CGHeight:%1.1f : pixWidth:%1.1f pixHeight:%1.1f SFactor %f", nsImageWidth, nsImageHeight, imgWidth, imgHeight, imgRepWidth, imgRepHeight, scaleFactor );
//    
//    if( imgWidth <= MAX_IMG_SIZE && imgHeight <= MAX_IMG_SIZE )
//    {
//        scaled_Image = [[NSImage alloc] initWithData:[openImage TIFFRepresentation]];
//    }
//    else
//    {
//        if( imgWidth > imgHeight )
//        {
//            float coef = (float)MAX_IMG_SIZE / imgWidth;
//            float scaledHeight = imgHeight * coef;
//            scaledRect = NSMakeRect( 0.0, 0.0, MAX_IMG_SIZE, (int)scaledHeight);
//            scaled_Image = [[NSImage alloc] initWithSize:scaledRect.size];
//            
//
//        }
//        else if( imgWidth < imgHeight )
//        {
//            float coef = (float)MAX_IMG_SIZE / imgHeight;
//            float scaledWidth = imgWidth * coef;
//            NSLog(@"scaled width %f", scaledWidth);
//            scaledRect = NSMakeRect( 0.0, 0.0, (int)scaledWidth, MAX_IMG_SIZE );
//            scaled_Image = [[NSImage alloc] initWithSize:scaledRect.size];
//        }
//        else // imgWidth == imgHeight
//        {
//            float coef = (float)MAX_IMG_SIZE / imgWidth;
//            float scaledHeight = imgHeight * coef;
//            scaledRect = NSMakeRect( 0.0, 0.0, MAX_IMG_SIZE, (int)scaledHeight);
//            scaled_Image = [[NSImage alloc] initWithSize:scaledRect.size];
//        }
//        
//        // draw original image to new scaled image
//        [scaled_Image lockFocus];
//        
//        [NSGraphicsContext saveGraphicsState];
//        [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
//        
//        [openImage drawInRect:scaledRect
//                     fromRect:NSZeroRect
//                    operation:NSCompositeSourceOver
//                     fraction:1.0];
//        
//        [NSGraphicsContext restoreGraphicsState];
//        [scaled_Image unlockFocus];
//    }
//    
//    
    
    
    
    // Create NSBitmapImageRep
    NSBitmapImageRep* imageRep = [[NSBitmapImageRep alloc] initWithData:[openImageN TIFFRepresentation]];
    NSInteger bpp = [imageRep bitsPerPixel];
    unsigned char* imagePtr = [imageRep bitmapData];
    
    //CGImage
    CGImageRef imageCG = [imageRep CGImage];
    int Original_Width = (int)CGImageGetWidth( imageCG );
    int Original_Height = (int)CGImageGetHeight( imageCG );
    
    unsigned char tempValue[3];
    
    NSLog(@"CGImage W:%d H:%d bits per pixel %ld", IMG_WIDTH, IMG_HEIGHT, (long)bpp);
    
    
    
    // check image size if larger than 2048
    if( Original_Width >= 2048 && Original_Height >= 2048 )
    {
        NSLog(@"larrrrrgerrrrr than 2048");
    }
    else
    {
        NSLog(@"image is smaller than 2048 pix");
        unsigned char TEMP_VALUE[Original_Width][Original_Height];
        
        switch ( bpp ) {
            case 8:
                for( j = 0 ; j < Original_Height ; j++ )
                {
                    for( i = 0 ; i < Original_Width ; i++ )
                    {
                        TEMP_VALUE[i][j] = *imagePtr;   imagePtr++;
                    }
                }
                break;
            case 24:
                for( j = 0 ; j < Original_Height ; j++ )
                {
                    for( i = 0 ; i < Original_Width ; i++ )
                    {
                        tempValue[0] = *imagePtr; imagePtr++;
                        tempValue[1] = *imagePtr; imagePtr++;
                        tempValue[2] = *imagePtr; imagePtr++;
                        
                        TEMP_VALUE[i][j] = (unsigned char)(tempValue[0]*0.2126 +
                                                          tempValue[1]*0.7152 +
                                                          tempValue[2]*0.0722);
                    }
                }
                break;
            case 32:
                for( j = 0 ; j < Original_Height ; j++ )
                {
                    for( i = 0 ; i < Original_Width ; i++ )
                    {
                        tempValue[0] = *imagePtr;   imagePtr++;
                        tempValue[1] = *imagePtr;   imagePtr++;
                        tempValue[2] = *imagePtr;   imagePtr++;
                        imagePtr++;
                        
                        TEMP_VALUE[i][j] = (unsigned char)(tempValue[0]*0.2126 +
                                                          tempValue[1]*0.7152 +
                                                          tempValue[2]*0.0722);
                    }
                }
                break;
            default:
                break;
        }// switch
        
        
        
        // decide access index
        int INDEX_W[MAX_IMG_SIZE];
        int INDEX_H[MAX_IMG_SIZE];
        int scaled_W, scaled_H;
        
        if( Original_Width <= MAX_IMG_SIZE && Original_Height <= MAX_IMG_SIZE )
        {
            scaled_W = Original_Width;
            scaled_H = Original_Height;
            
            for( i = 0 ; i < Original_Width ; i++ )
            {
                INDEX_W[i] = i;
            }
            for( j = 0 ; j < Original_Height ; j++ )
            {
                INDEX_H[j] = j;
            }
        }
        else if( Original_Width > Original_Height )
        {
            double coef = (double)Original_Width / (double)MAX_IMG_SIZE;
            double inv_coef = (double)MAX_IMG_SIZE / (double)Original_Width;
            float tempW = 0.0;
            float tempH = 0.0;
            
            scaled_W = MAX_IMG_SIZE;
            scaled_H = (int)((double)Original_Height * inv_coef);
            
            for( i = 0 ; i < scaled_W ; i++ )
            {
                INDEX_W[i] = (int)tempW;
                tempW += coef;
            }
            
            for( j = 0 ; j < scaled_H ; j++ )
            {
                INDEX_H[j] = (int)tempH;
                tempH += coef;
            }
            
        }// if W > H
        else if( Original_Width < Original_Height )
        {
            double coef = (double)Original_Height / (double)MAX_IMG_SIZE;
            double inv_coef = (double)MAX_IMG_SIZE / (double)Original_Height;
            float tempW = 0.0;
            float tempH = 0.0;
            
            scaled_W = (int)((double)Original_Width * inv_coef);
            scaled_H = MAX_IMG_SIZE;
            
            for( i = 0 ; i < scaled_W ; i++ )
            {
                INDEX_W[i] = (int)tempW;
                tempW += coef;
            }
            
            for(j = 0 ; j < scaled_H ; j++ )
            {
                INDEX_H[j] = (int)tempH;
                tempH += coef;
            }
        }// if W < H
        else // W == H and larger
        {
            double coef = (double)Original_Width / (double)MAX_IMG_SIZE;
            double inv_coef = (double)MAX_IMG_SIZE / (double)Original_Width;
            
            float tempWH = 0.0;
            
            scaled_W = MAX_IMG_SIZE;
            scaled_H = MAX_IMG_SIZE;
            
            for( i = 0 ; i < scaled_W ; i++ )
            {
                INDEX_W[i] = (int)tempWH;
                INDEX_H[i] = (int)tempWH;
                
                tempWH += coef;
            }
        }// W == H
        
        
        // set IMG WIDTH & HEIGHT
        NSLog(@"scaled WH %d %d", scaled_W, scaled_H );
        IMG_WIDTH = scaled_W;
        IMG_HEIGHT = scaled_H;
        
    
    
    // get value
    
        for( i = 0 ; i < scaled_W ; i++ )
        {
            for( j = 0 ; j < scaled_H ; j++ )
            {
                IMG_VALUE[i][j] = TEMP_VALUE[ INDEX_W[i] ][ INDEX_H[j] ];
            }
        }
        
    
    // set Flag
    isImgOpened = YES;
    
    // enable GUI
    [self enableGUI:YES];

    
    // calculate vertex
    [self calculate];
    
    [imageRep release];
    //[scaled_Image release];
        
        
    }// else smaller than 2048

}





- (IBAction)exportSTL:(NSButton*)button
{
    [drawTimer_obj invalidate];
    
    
    // Open Save Panel
    NSSavePanel* savePanel = [NSSavePanel savePanel];
    NSArray* allowedFileTypes = [NSArray arrayWithObjects:@"stl", nil];
    [savePanel setAllowedFileTypes:allowedFileTypes];
    
    
    
    // check button state
    NSInteger pressedButton = [savePanel runModal];
    
    
    
    // condition
    if( pressedButton == NSOKButton)
    {
        int i, j;
        
        NSURL* url = [savePanel URL];
        NSString* savePathString = [url path];
        
        
        // save data
        NSMutableData* STL_Data = [[NSMutableData alloc] initWithLength:0];
        
        
        // header data( 80 byte )
        char header_char[80] = "stl export dayo---";
        [STL_Data appendBytes:header_char length:80];
        
        
        // num of Triangles
        [STL_Data appendBytes:&NUM_OF_Triangles length:sizeof(NUM_OF_Triangles)];
        
        
        // Add vertex Data
        GLfloat* vPtr = sVert_Ptr;
        float tempNORM[3];
        float tempVERT[3][3];
        
        
        // convert coordinate to STL space
        matrixClass* tempMatrix = [[matrixClass alloc] init];
        [tempMatrix rotate_Xdeg:90.0];
        
        // empty mem
        unsigned char* emptyMem = malloc(2);
        memset( emptyMem, 0, 2 );
        
        
        
        // surface vertex
        for( i = 0 ; i < IMG_WIDTH-1 ; i++ )
        {
            for( j = 0 ; j < IMG_HEIGHT-1 ; j++ )
            {
                for( int k = 0 ; k < 2 ; k++ )
                {
                    tempVERT[0][0] = *vPtr;     vPtr++;
                    tempVERT[0][1] = *vPtr;     vPtr++;
                    tempVERT[0][2] = *vPtr;     vPtr++;
                    vPtr++;
                    tempVERT[1][0] = *vPtr;     vPtr++;
                    tempVERT[1][1] = *vPtr;     vPtr++;
                    tempVERT[1][2] = *vPtr;     vPtr++;
                    vPtr++;
                    tempVERT[2][0] = *vPtr;     vPtr++;
                    tempVERT[2][1] = *vPtr;     vPtr++;
                    tempVERT[2][2] = *vPtr;     vPtr++;
                    vPtr++;
                    
                    [tempMatrix calculate_vec3:&tempVERT[0][0]];
                    [tempMatrix calculate_vec3:&tempVERT[1][0]];
                    [tempMatrix calculate_vec3:&tempVERT[2][0]];
                    
                    [self calcNorm_vec1:&tempVERT[0][0]
                                   vec2:&tempVERT[1][0]
                                   vec3:&tempVERT[2][0]
                                   norm:tempNORM];
                    
                    
                    [STL_Data appendBytes:tempNORM length:12];
                    [STL_Data appendBytes:tempVERT length:36];
                    [STL_Data appendBytes:emptyMem length:2];
                    
                }
            }
        }
        
        
        int numOfLR = ((IMG_HEIGHT-1)*2 + IMG_HEIGHT)*2;
        vPtr = LR_Vert_Ptr;
        
        for( i = 0 ; i < numOfLR ; i++ )
        {
            tempVERT[0][0] = *vPtr; vPtr++;
            tempVERT[0][1] = *vPtr; vPtr++;
            tempVERT[0][2] = *vPtr; vPtr++;
            vPtr++;
            tempVERT[1][0] = *vPtr; vPtr++;
            tempVERT[1][1] = *vPtr; vPtr++;
            tempVERT[1][2] = *vPtr; vPtr++;
            vPtr++;
            tempVERT[2][0] = *vPtr; vPtr++;
            tempVERT[2][1] = *vPtr; vPtr++;
            tempVERT[2][2] = *vPtr; vPtr++;
            vPtr++;
            
            [tempMatrix calculate_vec3:&tempVERT[0][0]];
            [tempMatrix calculate_vec3:&tempVERT[1][0]];
            [tempMatrix calculate_vec3:&tempVERT[2][0]];

            [self calcNorm_vec1:&tempVERT[0][0]
                           vec2:&tempVERT[1][0]
                           vec3:&tempVERT[2][0]
                           norm:tempNORM];
            
            [STL_Data appendBytes:tempNORM length:12];
            [STL_Data appendBytes:tempVERT length:36];
            [STL_Data appendBytes:emptyMem length:2];
        }
        
        
        
        int numOfTB = ((IMG_WIDTH-1)*2 + IMG_WIDTH)*2;
        vPtr = TB_Vert_Ptr;
        
        for( i = 0 ; i < numOfTB ; i++ )
        {
            tempVERT[0][0] = *vPtr; vPtr++;
            tempVERT[0][1] = *vPtr; vPtr++;
            tempVERT[0][2] = *vPtr; vPtr++;
            vPtr++;
            tempVERT[1][0] = *vPtr; vPtr++;
            tempVERT[1][1] = *vPtr; vPtr++;
            tempVERT[1][2] = *vPtr; vPtr++;
            vPtr++;
            tempVERT[2][0] = *vPtr; vPtr++;
            tempVERT[2][1] = *vPtr; vPtr++;
            tempVERT[2][2] = *vPtr; vPtr++;
            vPtr++;
            
            [tempMatrix calculate_vec3:&tempVERT[0][0]];
            [tempMatrix calculate_vec3:&tempVERT[1][0]];
            [tempMatrix calculate_vec3:&tempVERT[2][0]];
            
            [self calcNorm_vec1:&tempVERT[0][0]
                           vec2:&tempVERT[1][0]
                           vec3:&tempVERT[2][0]
                           norm:tempNORM];
            
            [STL_Data appendBytes:tempNORM length:12];
            [STL_Data appendBytes:tempVERT length:36];
            [STL_Data appendBytes:emptyMem length:2];
        }
        
        
        vPtr = cap_Vert_Ptr;
        for( i = 0 ; i < 2 ; i++ )
        {
            tempVERT[0][0] = *vPtr; vPtr++;
            tempVERT[0][1] = *vPtr; vPtr++;
            tempVERT[0][2] = *vPtr; vPtr++;
            vPtr++;
            tempVERT[1][0] = *vPtr; vPtr++;
            tempVERT[1][1] = *vPtr; vPtr++;
            tempVERT[1][2] = *vPtr; vPtr++;
            vPtr++;
            tempVERT[2][0] = *vPtr; vPtr++;
            tempVERT[2][1] = *vPtr; vPtr++;
            tempVERT[2][2] = *vPtr; vPtr++;
            vPtr++;
            
            [tempMatrix calculate_vec3:&tempVERT[0][0]];
            [tempMatrix calculate_vec3:&tempVERT[1][0]];
            [tempMatrix calculate_vec3:&tempVERT[2][0]];
            
            [self calcNorm_vec1:&tempVERT[0][0]
                           vec2:&tempVERT[1][0]
                           vec3:&tempVERT[2][0]
                           norm:tempNORM];
            
            [STL_Data appendBytes:tempNORM length:12];
            [STL_Data appendBytes:tempVERT length:36];
            [STL_Data appendBytes:emptyMem length:2];
        }
        
        
        [STL_Data writeToFile:savePathString atomically:NO];
        
        [STL_Data release];
    }// if OK button
    
    
    
    drawTimer_obj = [NSTimer timerWithTimeInterval:1.0/60.0
                                        target:self
                                          selector:@selector(drawGL:)
                                          userInfo:nil
                                                repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:drawTimer_obj forMode:NSDefaultRunLoopMode];
}




- (void)calcNorm_vec1:(float*)v1 vec2:(float*)v2 vec3:(float*)v3 norm:(float*)n
{
    float pointA[3];
    float pointB[3];
    float pointC[3];
    float vecA[3];
    float vecB[3];
    float crossVec[3];
    float* aPtr = v1;
    float* bPtr = v2;
    float* cPtr = v3;
    float* nPtr = n;
    
    pointA[0] = *aPtr;    aPtr++;
    pointA[1] = *aPtr;    aPtr++;
    pointA[2] = *aPtr;    aPtr++;
    
    pointB[0] = *bPtr;    bPtr++;
    pointB[1] = *bPtr;    bPtr++;
    pointB[2] = *bPtr;    bPtr++;
    
    pointC[0] = *cPtr;    cPtr++;
    pointC[1] = *cPtr;    cPtr++;
    pointC[2] = *cPtr;    cPtr++;
    
    
    vecA[0] = pointC[0] - pointB[0];
    vecA[1] = pointC[1] - pointB[1];
    vecA[2] = pointC[2] - pointB[2];
    
    vecB[0] = pointA[0] - pointB[0];
    vecB[1] = pointA[1] - pointB[1];
    vecB[2] = pointA[2] - pointB[2];
    
    
    crossVec[0] = vecA[1]*vecB[2] - vecA[2]*vecB[1];
    crossVec[1] = vecA[2]*vecB[0] - vecA[0]*vecB[2];
    crossVec[2] = vecA[0]*vecB[1] - vecA[1]*vecB[0];
    
    float coeff = 1.0 / sqrt(crossVec[0]*crossVec[0] + crossVec[1]*crossVec[1] + crossVec[2]*crossVec[2]);
    crossVec[0]*=coeff;
    crossVec[1]*=coeff;
    crossVec[2]*=coeff;
    
    *nPtr = crossVec[0];    nPtr++;
    *nPtr = crossVec[1];    nPtr++;
    *nPtr = crossVec[2];
}
@end
