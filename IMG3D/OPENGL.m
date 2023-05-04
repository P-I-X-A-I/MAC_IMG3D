#import "mainController.h"


@implementation mainController (OPENGL)

- (void)initOpenGL
{
    NSLog(@"init OpenGL");
    
    
    NSOpenGLPixelFormatAttribute attr[] = {
        NSOpenGLPFAFullScreen,
        NSOpenGLPFAScreenMask,
        CGDisplayIDToOpenGLDisplayMask( kCGDirectMainDisplay ),
        NSOpenGLPFADoubleBuffer,
        NSOpenGLPFAMultisample,
        NSOpenGLPFASampleBuffers, 1,
        NSOpenGLPFASamples, 4,
        NSOpenGLPFAColorSize, 24,
        NSOpenGLPFAAlphaSize, 8,
        NSOpenGLPFADepthSize, 16,
        0
    };
    
    pixFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attr];
    glContext_obj = [[NSOpenGLContext alloc] initWithFormat:pixFormat shareContext:nil];
    
    GLint swapInterval = 1;
    
    [glContext_obj setValues:&swapInterval forParameter:NSOpenGLCPSwapInterval];
    [glContext_obj setView:glView_obj];
    [glContext_obj makeCurrentContext];
    
    
    glEnable( GL_BLEND );
    glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );
    
    glFrontFace( GL_CCW );
    glEnable( GL_CULL_FACE );
    glCullFace( GL_BACK );
    
    glEnable( GL_DEPTH_TEST );
    glEnableVertexAttribArray( 0 );
    glEnableVertexAttribArray( 1 );
    glEnableVertexAttribArray( 2 );
    glEnableVertexAttribArray( 3 );
    
    glClearColor( 0.0, 0.0, 0.0, 1.0 );
    glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
    
    [glContext_obj flushBuffer];
    
    
    
    // read shader
    [self readShader_VS:&VS_OBJ
                     FS:&FS_OBJ
                    PRG:&PRG_OBJ
                   NAME:@"model"];
    glBindAttribLocation( PRG_OBJ, 0, "position");
    glBindAttribLocation( PRG_OBJ, 1, "normal");
    glBindAttribLocation( PRG_OBJ, 2, "heightCoef");
    
    glLinkProgram( PRG_OBJ );
    
    UNF_mvp_Matrix = glGetUniformLocation( PRG_OBJ, "mvp_Matrix" );
    UNF_eyeVec = glGetUniformLocation( PRG_OBJ, "eyeVec" );
    UNF_baseColor = glGetUniformLocation( PRG_OBJ, "baseColor" );
    UNF_specCoef = glGetUniformLocation( PRG_OBJ, "specCoef" );
    UNF_lightVec = glGetUniformLocation( PRG_OBJ, "lightVec" );
    NSLog(@"UNF_mvp_Matrix %d", UNF_mvp_Matrix );
    NSLog(@"UNF_eyeVec %d", UNF_eyeVec);
    NSLog(@"UNF_baseColor %d", UNF_baseColor );
    NSLog(@"UNF_specCoef %d", UNF_specCoef );
    NSLog(@"UNF_lightVec %d", UNF_lightVec );
    
    
    [self readShader_VS:&axVS_OBJ
                     FS:&axFS_OBJ
                    PRG:&axPRG_OBJ
                   NAME:@"axis"];
    
    glBindAttribLocation( axPRG_OBJ, 0, "position");
    glBindAttribLocation( axPRG_OBJ, 1, "color" );
    
    glLinkProgram( axPRG_OBJ );
    
    UNF_ax_mvpMatrix = glGetUniformLocation( axPRG_OBJ, "mvp_Matrix");
    NSLog(@"UNF_ax_mvpMatrix %d", UNF_ax_mvpMatrix);
}



- (void)readShader_VS:(GLuint *)vObj FS:(GLuint *)fObj PRG:(GLuint *)prgObj NAME:(NSString *)name
{
    const GLchar* VS_CODE;
    const GLchar* FS_CODE;
    
    GLint logLength;
    
    NSString* VS_Path_STR = [[NSBundle mainBundle] pathForResource:name ofType:@"vsh"];
    NSString* FS_Path_STR = [[NSBundle mainBundle] pathForResource:name ofType:@"fsh"];
    
    VS_CODE = (GLchar*)[[NSString stringWithContentsOfFile:VS_Path_STR
                                                  encoding:NSUTF8StringEncoding
                                                     error:nil] UTF8String];
    
    FS_CODE = (GLchar*)[[NSString stringWithContentsOfFile:FS_Path_STR
                                                  encoding:NSUTF8StringEncoding
                                                     error:nil] UTF8String];
    
    *vObj = glCreateShader( GL_VERTEX_SHADER );
    *fObj = glCreateShader( GL_FRAGMENT_SHADER );
    
    glShaderSource( *vObj, 1, &VS_CODE, NULL );
    glShaderSource( *fObj, 1, &FS_CODE, NULL );
    
    glCompileShader( *vObj );
    glCompileShader( *fObj );
    
    
    glGetShaderiv( *vObj, GL_INFO_LOG_LENGTH, &logLength );
    if( logLength > 0 )
    {
        GLchar* log = (GLchar*)malloc( logLength );
        glGetShaderInfoLog( *vObj, logLength, &logLength, log );
        NSLog(@"%@ vs compile error : %s", name, log );
        free( log );
    }
    glGetShaderiv( *fObj, GL_INFO_LOG_LENGTH, &logLength );
    if( logLength > 0 )
    {
        GLchar* log = (GLchar*)malloc( logLength );
        glGetShaderInfoLog( *fObj, logLength, &logLength, log );
        NSLog(@"%@ fs compile error : %s", name, log );
        free( log );
    }
    
    
    *prgObj = glCreateProgram();
    
    glAttachShader( *prgObj, *vObj );
    glAttachShader( *prgObj, *fObj );
    
}
@end