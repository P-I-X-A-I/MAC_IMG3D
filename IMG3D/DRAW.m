#import "mainController.h"

@implementation mainController (DRAW)

- (void)drawGL:(NSTimer *)timer
{
    
    NSWindow* currentWindow;
    
    if( isFullScreen )
    {
        currentWindow = fullWindow_obj;
    }
    else
    {
        currentWindow = mainWindow_obj;
    }
    
    // check mouse wheel
    NSEvent* windowEvent = [currentWindow currentEvent];
    float wheelY = [windowEvent deltaY];
    NSEventType eType = [windowEvent type];
    
    if( eType == NSScrollWheel && wheelY != 0.0 && scrollDelta != wheelY )
    {
        eyeDistance -= wheelY*2.0;
        
        if(eyeDistance < 50.0)
        {
            eyeDistance = 50.0;
        }
        else if( eyeDistance > 200.0 )
        {
            eyeDistance = 200.0;
        }
        
        scrollDelta = wheelY;
    }
    
    
    // increment veriable
    act_degX += ( degX_axis - act_degX )*0.3;
    act_degY += ( degY_axis - act_degY )*0.3;
    act_eyeDistance += ( eyeDistance - act_eyeDistance )*0.1;
    
    
    // get View Width
    float WIDTH = glView_obj.frame.size.width;
    float HEIGHT = glView_obj.frame.size.height;
    float RATIO = WIDTH / HEIGHT;
    
    
    

    
    
    // Calculate eye and head and farPlaneVec
    float FAR = -200.0;
    float eye[3] = { 0.0, 0.0, act_eyeDistance };
    float head[3] = { 0.0, 1.0, 0.0 };
    float light[3] = { 0.0, -1.0, -0.3 };
    float fPlane_Origin[3] = { 0.0, 0.0, FAR };
    float fPlane_UnitX[3] = { 1.0, 0.0, 0.0 };
    float fPlane_UnitY[3] = { 0.0, 1.0, 0.0 };
    float normEye[3];
    
    [matrix_obj initMatrix];
    [matrix_obj rotate_Xdeg:act_degX];
    [matrix_obj rotate_Ydeg:act_degY];
    [matrix_obj calculate_vec3:eye];
    [matrix_obj calculate_vec3:head];
    [matrix_obj calculate_vec3:light];
    [matrix_obj calculate_vec3:fPlane_Origin];
    [matrix_obj calculate_vec3:fPlane_UnitX];
    [matrix_obj calculate_vec3:fPlane_UnitY];
    


    float cEyeLength = 1.0 / sqrt( eye[0]*eye[0] + eye[1]*eye[1] + eye[2]*eye[2] );
    normEye[0] = eye[0]*cEyeLength;
    normEye[1] = eye[1]*cEyeLength;
    normEye[2] = eye[2]*cEyeLength;
    
    float cLight = 1.0 / sqrt( light[0]*light[0] + light[1]*light[1] + light[2]*light[2] );
    light[0] *= cLight;
    light[1] *= cLight;
    light[2] *= cLight;
    

    
    // set shader to object draw
    glUseProgram(PRG_OBJ);

    
    // set view matrix
    [matrix_obj initMatrix];
    [matrix_obj lookAt_Ex:eye[0] Ey:eye[1] Ez:eye[2]
                       Vx:0.0 Vy:0.0 Vz:0.0
                       Hx:head[0] Hy:head[1] Hz:head[2]];
    [matrix_obj perspective_fovy:60.0 aspect:RATIO near:0.1 far:act_eyeDistance-FAR+20.0];
    
    
    
    
    
    
    // draw object
    glViewport(0, 0, (GLsizei)WIDTH, (GLsizei)HEIGHT );
    glClearColor( 0.0, 0.0, 0.0, 1.0 );
    glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
    
    
    
    // set uniform
    float specValue;
    if( isShowSpecular )
    {
        specValue = 1.0;
    }
    else
    {
        specValue = 0.0;
    }
    
    glUniformMatrix4fv( UNF_mvp_Matrix, 1, GL_FALSE, [matrix_obj getMatrix]);
    glUniform3f( UNF_eyeVec, normEye[0], normEye[1], normEye[2] );
    glUniform3f( UNF_baseColor, objColor[0], objColor[1], objColor[2]);
    glUniform1f( UNF_specCoef, specValue );
    glUniform3f( UNF_lightVec, light[0], light[1], light[2] );
    
    if( isImgOpened )
    {
        glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 0, sVert_Ptr );
        glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 0, sNorm_Ptr );
        glVertexAttribPointer(2, 1, GL_FLOAT, GL_FALSE, 0, sCoef_Ptr );
        
        glDrawArrays(GL_TRIANGLES, 0, (IMG_WIDTH-1)*(IMG_HEIGHT-1)*6);
        
        
        glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 0, LR_Vert_Ptr );
        glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 0, LR_Norm_Ptr );
        glVertexAttribPointer(2, 1, GL_FLOAT, GL_FALSE, 0, LR_Coef_Ptr );
        
        glDrawArrays( GL_TRIANGLES, 0, ((IMG_HEIGHT-1)*6 + IMG_HEIGHT*3)*2 );
        
        
        glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 0, TB_Vert_Ptr );
        glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 0, TB_Norm_Ptr );
        glVertexAttribPointer(2, 1, GL_FLOAT, GL_FALSE, 0, TB_Coef_Ptr );
        
        glDrawArrays( GL_TRIANGLES, 0, ((IMG_WIDTH-1)*6 + IMG_WIDTH*3)*2 );
        
        
        glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 0, cap_Vert_Ptr );
        glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 0, cap_Norm_Ptr );
        glVertexAttribPointer(2, 1, GL_FLOAT, GL_FALSE, 0, cap_Coef_Ptr );
        
        glDrawArrays( GL_TRIANGLES, 0, 6 );
    }
    
    
    
    
    
    // draw axis
    glUseProgram( axPRG_OBJ );
    glUniformMatrix4fv(UNF_ax_mvpMatrix, 1, GL_FALSE, [matrix_obj getMatrix]);
    
    
    
    // draw object base's edge
    GLfloat edgeV[8][2][4];
    GLfloat edgeC[8][2][4];
    
    if( isImgOpened )
    {
        
        for( int k = 0 ; k < 3 ; k++ )
        {
            edgeV[0][0][k] = baseCorner[0][k];
            edgeV[0][1][k] = baseCorner[4][k];

            edgeV[1][0][k] = baseCorner[1][k];
            edgeV[1][1][k] = baseCorner[5][k];
            
            edgeV[2][0][k] = baseCorner[2][k];
            edgeV[2][1][k] = baseCorner[6][k];
            
            edgeV[3][0][k] = baseCorner[3][k];
            edgeV[3][1][k] = baseCorner[7][k];
            
            edgeV[4][0][k] = baseCorner[0][k];
            edgeV[4][1][k] = baseCorner[1][k];
            
            edgeV[5][0][k] = baseCorner[1][k];
            edgeV[5][1][k] = baseCorner[2][k];
            
            edgeV[6][0][k] = baseCorner[2][k];
            edgeV[6][1][k] = baseCorner[3][k];
            
            edgeV[7][0][k] = baseCorner[3][k];
            edgeV[7][1][k] = baseCorner[0][k];
        }
        
        
        for( int k = 0 ; k < 8 ; k++ )
        {
            edgeV[k][0][3] = edgeV[k][1][3] = 1.0;
            edgeC[k][0][0] = edgeC[k][1][0] = objColor[0];
            edgeC[k][0][1] = edgeC[k][1][1] = objColor[1];
            edgeC[k][0][2] = edgeC[k][1][2] = objColor[2];
            edgeC[k][0][3] = edgeC[k][1][3] = 0.1;
        }
        
        glLineWidth( 4.0 );
        glDepthRange(0.0, 0.99998);
        
        glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 0, edgeV);
        glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, 0, edgeC);
        
        glDrawArrays( GL_LINES, 0, 16);
    }
    
    
    glLineWidth( 1.0 );
    glDepthRange(0.0, 1.0);
    
    GLfloat axisV[6][4];
    GLfloat axisC[6][4];
    axisV[0][0] = axisV[2][0] = axisV[4][0] = 0.0;
    axisV[0][1] = axisV[2][1] = axisV[4][1] = 0.0;
    axisV[0][2] = axisV[2][2] = axisV[4][2] = 0.0;
    axisV[0][3] = axisV[2][3] = axisV[4][3] = 1.0;
    
    axisV[1][0] = 1000.0;   axisV[1][1] = 0.0;  axisV[1][2] = 0.0;  axisV[1][3] = 1.0;
    axisV[3][0] = 0.0;   axisV[3][1] = 1000.0;  axisV[3][2] = 0.0;  axisV[3][3] = 1.0;
    axisV[5][0] = 0.0;   axisV[5][1] = 0.0;  axisV[5][2] = 1000.0;  axisV[5][3] = 1.0;

    axisC[0][0] = axisC[1][0] = 1.0;
    axisC[0][1] = axisC[1][1] = 0.0;
    axisC[0][2] = axisC[1][2] = 0.0;
    axisC[0][3] = axisC[1][3] = 1.0;
    
    axisC[2][0] = axisC[3][0] = 0.0;
    axisC[2][1] = axisC[3][1] = 1.0;
    axisC[2][2] = axisC[3][2] = 0.0;
    axisC[2][3] = axisC[3][3] = 1.0;
    
    axisC[4][0] = axisC[5][0] = 0.0;
    axisC[4][1] = axisC[5][1] = 0.0;
    axisC[4][2] = axisC[5][2] = 1.0;
    axisC[4][3] = axisC[5][3] = 1.0;
    
    
    if( isShowAxis )
    {
        glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 0, axisV);
        glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, 0, axisC);
        glDrawArrays(GL_LINES, 0, 6);
    }
    
    
    // draw Back Plane
    double distanceToPlane = (act_eyeDistance-FAR);
    double planeY = distanceToPlane * 0.57735026918963; // 1.0 / sqrt(3.0)
    double planeX = planeY * RATIO;

    
    GLfloat vPlane[4][4];
    GLfloat cPlane[4][4];
    GLfloat P_UNIT_X[3];
    GLfloat P_UNIT_Y[3];
    GLfloat BGColor[2];
    
    
    P_UNIT_X[0] = fPlane_UnitX[0]*planeX;
    P_UNIT_X[1] = fPlane_UnitX[1]*planeX;
    P_UNIT_X[2] = fPlane_UnitX[2]*planeX;
    
    P_UNIT_Y[0] = fPlane_UnitY[0]*planeY;
    P_UNIT_Y[1] = fPlane_UnitY[1]*planeY;
    P_UNIT_Y[2] = fPlane_UnitY[2]*planeY;
    
    
    vPlane[0][0] = fPlane_Origin[0] - P_UNIT_X[0] + P_UNIT_Y[0];
    vPlane[0][1] = fPlane_Origin[1] - P_UNIT_X[1] + P_UNIT_Y[1];
    vPlane[0][2] = fPlane_Origin[2] - P_UNIT_X[2] + P_UNIT_Y[2];
    vPlane[0][3] = 1.0;
    vPlane[1][0] = fPlane_Origin[0] - P_UNIT_X[0] - P_UNIT_Y[0];
    vPlane[1][1] = fPlane_Origin[1] - P_UNIT_X[1] - P_UNIT_Y[1];
    vPlane[1][2] = fPlane_Origin[2] - P_UNIT_X[2] - P_UNIT_Y[2];
    vPlane[1][3] = 1.0;
    vPlane[2][0] = fPlane_Origin[0] + P_UNIT_X[0] + P_UNIT_Y[0];
    vPlane[2][1] = fPlane_Origin[1] + P_UNIT_X[1] + P_UNIT_Y[1];
    vPlane[2][2] = fPlane_Origin[2] + P_UNIT_X[2] + P_UNIT_Y[2];
    vPlane[2][3] = 1.0;
    vPlane[3][0] = fPlane_Origin[0] + P_UNIT_X[0] - P_UNIT_Y[0];
    vPlane[3][1] = fPlane_Origin[1] + P_UNIT_X[1] - P_UNIT_Y[1];
    vPlane[3][2] = fPlane_Origin[2] + P_UNIT_X[2] - P_UNIT_Y[2];
    vPlane[3][3] = 1.0;
    
    
    if( isInvertBG )
    {
        BGColor[0] = 1.0;
        //BGColor[1] = 1.0;
        BGColor[1] = 0.8;
    }
    else
    {
        BGColor[0] = 0.0;
        //BGColor[1] = 0.0;
        BGColor[1] = 0.2;
    }
    
    
    cPlane[0][0] = cPlane[2][0] = BGColor[0];
    cPlane[0][1] = cPlane[2][1] = BGColor[0];
    cPlane[0][2] = cPlane[2][2] = BGColor[0];
    cPlane[0][3] = cPlane[2][3] = 1.0;
    
    cPlane[1][0] = cPlane[3][0] = BGColor[1];
    cPlane[1][1] = cPlane[3][1] = BGColor[1];
    cPlane[1][2] = cPlane[3][2] = BGColor[1];
    cPlane[1][3] = cPlane[3][3] = 1.0;
    
    
    glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 0, vPlane);
    glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, 0, cPlane);
    glDrawArrays( GL_TRIANGLE_STRIP, 0, 4 );
    
    //
    [glContext_obj flushBuffer];

}
@end