#import "mainController.h"


@implementation mainController (UTILITY)

- (void)calculate
{
    int i, j;

    GLfloat xV, yV, zV;
    GLfloat gaussVertex[MAX_IMG_SIZE][MAX_IMG_SIZE];
    //GLfloat tempVertex[MAX_IMG_SIZE][MAX_IMG_SIZE][3];
    GLfloat tempGauss[7][7];

    //GLfloat biggerSize = fmaxf( IMG_WIDTH, IMG_HEIGHT );
    //GLfloat biggerSize;
    
    if( IMG_WIDTH > IMG_HEIGHT )
    {
        biggerSize = (GLfloat)IMG_WIDTH;
    }
    else if( IMG_HEIGHT > IMG_WIDTH )
    {
        biggerSize = (GLfloat)IMG_HEIGHT;
    }
    else
    {
        biggerSize = (GLfloat)IMG_WIDTH;
    }
    
    NSLog(@"width %d height %d biggersize %d", IMG_WIDTH, IMG_HEIGHT, biggerSize);

    for( i = 0 ; i < IMG_WIDTH ; i++ )
    {
        xV = (( i - ((float)IMG_WIDTH/2.0) ) / biggerSize)*XY_SIZE;
        
        for( j = 0 ; j < IMG_HEIGHT ; j++ )
        {
            zV = (( j - ((float)IMG_HEIGHT)/2.0 ) / biggerSize)*XY_SIZE;
            
            if( isInvertHeight )
            {
                yV = (1.0 - (float)IMG_VALUE[i][j]/255.0)*MAP_RANGE + BASE_HEIGHT;
            }
            else
            {
                yV = ((float)IMG_VALUE[i][j]/255.0)*MAP_RANGE + BASE_HEIGHT;
            }
            
            
            tempVertex[i][j][0] = xV;
            tempVertex[i][j][1] = gaussVertex[i][j] = yV;
            tempVertex[i][j][2] = zV;
        }//j
    }//i
    
    
    
    
    
    if( smoothness >= 0.1)
    {
        for( i = 0 ; i < IMG_WIDTH ; i++ )
        {
            for( j = 0 ; j < IMG_HEIGHT ; j++ )
            {
                GLfloat sumValue = 0.0;
                
                for( int a = -3 ; a <=3  ; a++ )
                {
                    for( int b = -3 ; b <= 3 ; b++ )
                    {
                        int accessX = i+a;
                        int accessY = j+b;
                        
                        if( accessX < 0 || accessY < 0 || accessX >= IMG_WIDTH || accessY >= IMG_HEIGHT )
                        {
                            tempGauss[a+3][b+3] = BASE_HEIGHT;
                        }
                        else
                        {
                            tempGauss[a+3][b+3] = gaussVertex[accessX][accessY];
                        }
                        
                        sumValue += tempGauss[a+3][b+3] * gaussCoef[a+3][b+3];
                        
                    }//b
                }//a
                
                tempVertex[i][j][1] = sumValue;
                
            }//j
        }//i
    }// if smooth
    
    
    
    
    baseCorner[0][0] = tempVertex[0][0][0];
    baseCorner[0][1] = 0.0;
    baseCorner[0][2] = tempVertex[0][0][2];
    
    baseCorner[1][0] = tempVertex[0][IMG_HEIGHT-1][0];
    baseCorner[1][1] = 0.0;
    baseCorner[1][2] = tempVertex[0][IMG_HEIGHT-1][2];
    
    baseCorner[2][0] = tempVertex[IMG_WIDTH-1][IMG_HEIGHT-1][0];
    baseCorner[2][1] = 0.0;
    baseCorner[2][2] = tempVertex[IMG_WIDTH-1][IMG_HEIGHT-1][2];
    
    baseCorner[3][0] = tempVertex[IMG_WIDTH-1][0][0];
    baseCorner[3][1] = 0.0;
    baseCorner[3][2] = tempVertex[IMG_WIDTH-1][0][2];
    
    baseCorner[4][0] = tempVertex[0][0][0];
    baseCorner[4][1] = tempVertex[0][0][1];
    baseCorner[4][2] = tempVertex[0][0][2];
    
    baseCorner[5][0] = tempVertex[0][IMG_HEIGHT-1][0];
    baseCorner[5][1] = tempVertex[0][IMG_HEIGHT-1][1];
    baseCorner[5][2] = tempVertex[0][IMG_HEIGHT-1][2];
    
    baseCorner[6][0] = tempVertex[IMG_WIDTH-1][IMG_HEIGHT-1][0];
    baseCorner[6][1] = tempVertex[IMG_WIDTH-1][IMG_HEIGHT-1][1];
    baseCorner[6][2] = tempVertex[IMG_WIDTH-1][IMG_HEIGHT-1][2];
    
    baseCorner[7][0] = tempVertex[IMG_WIDTH-1][0][0];
    baseCorner[7][1] = tempVertex[IMG_WIDTH-1][0][1];
    baseCorner[7][2] = tempVertex[IMG_WIDTH-1][0][2];

    
    
    // free memory
    if( sVert_Ptr != nil )
    { free( sVert_Ptr ); }
    if( sNorm_Ptr != nil )
    { free( sNorm_Ptr ); }
    if( sCoef_Ptr != nil )
    { free( sCoef_Ptr ); }
    
    if( LR_Vert_Ptr != nil )
    { free( LR_Vert_Ptr ); }
    if( LR_Norm_Ptr != nil )
    { free( LR_Norm_Ptr ); }
    if( LR_Coef_Ptr != nil )
    { free( LR_Coef_Ptr ); }
    
    if( TB_Vert_Ptr != nil )
    { free( TB_Vert_Ptr ); }
    if( TB_Norm_Ptr != nil )
    { free( TB_Norm_Ptr ); }
    if( TB_Coef_Ptr != nil )
    { free( TB_Coef_Ptr ); }
    
    if( cap_Vert_Ptr != nil )
    { free( cap_Vert_Ptr ); }
    if( cap_Norm_Ptr != nil )
    { free( cap_Norm_Ptr ); }
    if( cap_Coef_Ptr != nil )
    { free( cap_Coef_Ptr ); }
    
    
    
    // alloc memory
    int numOfLR = ((IMG_HEIGHT-1)*6 + IMG_HEIGHT*3)*2;
    int numOfTB = ((IMG_WIDTH-1)*6 + IMG_WIDTH*3)*2;
    
    
    // for STL export
    NUM_OF_Triangles = (IMG_WIDTH-1)*(IMG_HEIGHT-1)*2;
    NUM_OF_Triangles += ( (IMG_HEIGHT-1)*2 + IMG_HEIGHT )*2;
    NUM_OF_Triangles += ( (IMG_WIDTH-1)*2 + IMG_WIDTH )*2;
    NUM_OF_Triangles += 2;
    
    
    
    sVert_Ptr = (GLfloat*)malloc( (IMG_WIDTH-1)*(IMG_HEIGHT-1)*6*4*sizeof(GLfloat) );
    sNorm_Ptr = (GLfloat*)malloc( (IMG_WIDTH-1)*(IMG_HEIGHT-1)*6*3*sizeof(GLfloat) );
    sCoef_Ptr = (GLfloat*)malloc( (IMG_WIDTH-1)*(IMG_HEIGHT-1)*6*1*sizeof(GLfloat) );
    
    LR_Vert_Ptr = (GLfloat*)malloc( numOfLR * 4 * sizeof(GLfloat) );
    LR_Norm_Ptr = (GLfloat*)malloc( numOfLR * 3 * sizeof(GLfloat) );
    LR_Coef_Ptr = (GLfloat*)malloc( numOfLR * sizeof(GLfloat) );
    
    TB_Vert_Ptr = (GLfloat*)malloc( numOfTB * 4 * sizeof(GLfloat) );
    TB_Norm_Ptr = (GLfloat*)malloc( numOfTB * 3 * sizeof(GLfloat) );
    TB_Coef_Ptr = (GLfloat*)malloc( numOfTB * sizeof(GLfloat) );
    
    cap_Vert_Ptr = (GLfloat*)malloc( 6*4*sizeof(GLfloat) );
    cap_Norm_Ptr = (GLfloat*)malloc( 6*3*sizeof(GLfloat) );
    cap_Coef_Ptr = (GLfloat*)malloc( 6*sizeof(GLfloat) );
    
    
    
    // pointer for increment
    GLfloat* add_sVert_Ptr = sVert_Ptr;
    GLfloat* add_sNorm_Ptr = sNorm_Ptr;
    GLfloat* add_sCoef_Ptr = sCoef_Ptr;
    
    GLfloat* add_LR_Vert_Ptr = LR_Vert_Ptr;
    GLfloat* add_LR_Norm_Ptr = LR_Norm_Ptr;
    GLfloat* add_LR_Coef_Ptr = LR_Coef_Ptr;
    
    GLfloat* add_TB_Vert_Ptr = TB_Vert_Ptr;
    GLfloat* add_TB_Norm_Ptr = TB_Norm_Ptr;
    GLfloat* add_TB_Coef_Ptr = TB_Coef_Ptr;
    
    GLfloat* add_cap_Vert_Ptr = cap_Vert_Ptr;
    GLfloat* add_cap_Norm_Ptr = cap_Norm_Ptr;
    GLfloat* add_cap_Coef_Ptr = cap_Coef_Ptr;
    
    
    
    
    GLfloat forN[6][3];
    GLfloat vecA[3];
    GLfloat vecB[3];
    GLfloat crossVec[3];
    float cLength;
    GLfloat HALF_BASE = BASE_HEIGHT*0.5;
    
    GLfloat LNorm[3] = { -1.0, 0.0, 0.0 };
    GLfloat RNorm[3] = { 1.0, 0.0, 0.0 };
    GLfloat TNorm[3] = { 0.0, 0.0, -1.0 };
    GLfloat BNorm[3] = { 0.0, 0.0, 1.0 };
    GLfloat capNorm[3] = { 0.0, -1.0, 0.0 };
    
    // assign value
    for( i = 0 ; i < IMG_WIDTH-1 ; i++ )
    {
        for( j = 0 ; j < IMG_HEIGHT-1 ; j++ )
        {
            *add_sVert_Ptr = forN[0][0] = tempVertex[i][j][0];  add_sVert_Ptr++;
            *add_sVert_Ptr = forN[0][1] = tempVertex[i][j][1];  add_sVert_Ptr++;
            *add_sVert_Ptr = forN[0][2] = tempVertex[i][j][2];  add_sVert_Ptr++;
            *add_sVert_Ptr = 1.0;   add_sVert_Ptr++;
            *add_sCoef_Ptr = (tempVertex[i][j][1] - BASE_HEIGHT)/MAP_RANGE; add_sCoef_Ptr++;
            
            *add_sVert_Ptr = forN[1][0] = tempVertex[i][j+1][0];  add_sVert_Ptr++;
            *add_sVert_Ptr = forN[1][1] = tempVertex[i][j+1][1];  add_sVert_Ptr++;
            *add_sVert_Ptr = forN[1][2] = tempVertex[i][j+1][2];  add_sVert_Ptr++;
            *add_sVert_Ptr = 1.0;   add_sVert_Ptr++;
            *add_sCoef_Ptr = (tempVertex[i][j+1][1] - BASE_HEIGHT)/MAP_RANGE; add_sCoef_Ptr++;

            *add_sVert_Ptr = forN[2][0] = tempVertex[i+1][j][0];  add_sVert_Ptr++;
            *add_sVert_Ptr = forN[2][1] = tempVertex[i+1][j][1];  add_sVert_Ptr++;
            *add_sVert_Ptr = forN[2][2] = tempVertex[i+1][j][2];  add_sVert_Ptr++;
            *add_sVert_Ptr = 1.0;   add_sVert_Ptr++;
            *add_sCoef_Ptr = (tempVertex[i+1][j][1] - BASE_HEIGHT)/MAP_RANGE; add_sCoef_Ptr++;

            *add_sVert_Ptr = forN[3][0] = tempVertex[i+1][j][0];  add_sVert_Ptr++;
            *add_sVert_Ptr = forN[3][1] = tempVertex[i+1][j][1];  add_sVert_Ptr++;
            *add_sVert_Ptr = forN[3][2] = tempVertex[i+1][j][2];  add_sVert_Ptr++;
            *add_sVert_Ptr = 1.0;   add_sVert_Ptr++;
            *add_sCoef_Ptr = (tempVertex[i+1][j][1] - BASE_HEIGHT)/MAP_RANGE; add_sCoef_Ptr++;

            *add_sVert_Ptr = forN[4][0] = tempVertex[i][j+1][0];  add_sVert_Ptr++;
            *add_sVert_Ptr = forN[4][1] = tempVertex[i][j+1][1];  add_sVert_Ptr++;
            *add_sVert_Ptr = forN[4][2] = tempVertex[i][j+1][2];  add_sVert_Ptr++;
            *add_sVert_Ptr = 1.0;   add_sVert_Ptr++;
            *add_sCoef_Ptr = (tempVertex[i][j+1][1] - BASE_HEIGHT)/MAP_RANGE; add_sCoef_Ptr++;

            *add_sVert_Ptr = forN[5][0] = tempVertex[i+1][j+1][0];  add_sVert_Ptr++;
            *add_sVert_Ptr = forN[5][1] = tempVertex[i+1][j+1][1];  add_sVert_Ptr++;
            *add_sVert_Ptr = forN[5][2] = tempVertex[i+1][j+1][2];  add_sVert_Ptr++;
            *add_sVert_Ptr = 1.0;   add_sVert_Ptr++;
            *add_sCoef_Ptr = (tempVertex[i+1][j+1][1] - BASE_HEIGHT)/MAP_RANGE; add_sCoef_Ptr++;
            
            
            
            // norm 1
            for( int k = 0 ; k < 3 ; k++ )
            {
                vecA[k] = forN[0][k] - forN[1][k];
                vecB[k] = forN[2][k] - forN[1][k];
            }
            
            crossVec[0] = vecA[1]*vecB[2] - vecA[2]*vecB[1];
            crossVec[1] = vecA[2]*vecB[0] - vecA[0]*vecB[2];
            crossVec[2] = vecA[0]*vecB[1] - vecA[1]*vecB[0];
            cLength = 1.0 / sqrt( crossVec[0]*crossVec[0] + crossVec[1]*crossVec[1] + crossVec[2]*crossVec[2] );
            crossVec[0] *= cLength;
            crossVec[1] *= cLength;
            crossVec[2] *= cLength;
            
            for( int k = 0 ; k < 3 ; k++ )
            {
                *add_sNorm_Ptr = crossVec[0]; add_sNorm_Ptr++;
                *add_sNorm_Ptr = crossVec[1]; add_sNorm_Ptr++;
                *add_sNorm_Ptr = crossVec[2]; add_sNorm_Ptr++;
            }
            
            
            // norm 2
            for( int k = 0 ; k < 3 ; k++ )
            {
                vecA[k] = forN[3][k] - forN[4][k];
                vecB[k] = forN[5][k] - forN[4][k];
            }
            
            crossVec[0] = vecA[1]*vecB[2] - vecA[2]*vecB[1];
            crossVec[1] = vecA[2]*vecB[0] - vecA[0]*vecB[2];
            crossVec[2] = vecA[0]*vecB[1] - vecA[1]*vecB[0];
            cLength = 1.0 / sqrt( crossVec[0]*crossVec[0] + crossVec[1]*crossVec[1] + crossVec[2]*crossVec[2] );
            crossVec[0] *= cLength;
            crossVec[1] *= cLength;
            crossVec[2] *= cLength;

            for( int k = 0 ; k < 3 ; k++ )
            {
                *add_sNorm_Ptr = crossVec[0]; add_sNorm_Ptr++;
                *add_sNorm_Ptr = crossVec[1]; add_sNorm_Ptr++;
                *add_sNorm_Ptr = crossVec[2]; add_sNorm_Ptr++;
            }
            
        }
    }

    float tempCoef = 0.05;
    
    
    // L
    for( i = 0 ; i < IMG_HEIGHT-1 ; i++ )
    {
        //1
        *add_LR_Vert_Ptr = tempVertex[0][i][0]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = tempVertex[0][i][1]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = tempVertex[0][i][2]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = 1.0; add_LR_Vert_Ptr++;
        *add_LR_Coef_Ptr = tempCoef;    add_LR_Coef_Ptr++;
        //2
        *add_LR_Vert_Ptr = tempVertex[0][i][0]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = HALF_BASE;   add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = tempVertex[0][i][2]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = 1.0; add_LR_Vert_Ptr++;
        *add_LR_Coef_Ptr = tempCoef;    add_LR_Coef_Ptr++;
        //3
        *add_LR_Vert_Ptr = tempVertex[0][i+1][0]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = tempVertex[0][i+1][1]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = tempVertex[0][i+1][2]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = 1.0; add_LR_Vert_Ptr++;
        *add_LR_Coef_Ptr = tempCoef;    add_LR_Coef_Ptr++;
        //4
        *add_LR_Vert_Ptr = tempVertex[0][i+1][0]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = tempVertex[0][i+1][1]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = tempVertex[0][i+1][2]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = 1.0; add_LR_Vert_Ptr++;
        *add_LR_Coef_Ptr = tempCoef;    add_LR_Coef_Ptr++;
        //5
        *add_LR_Vert_Ptr = tempVertex[0][i][0]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = HALF_BASE;   add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = tempVertex[0][i][2]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = 1.0; add_LR_Vert_Ptr++;
        *add_LR_Coef_Ptr = tempCoef;    add_LR_Coef_Ptr++;
        //6
        *add_LR_Vert_Ptr = tempVertex[0][i+1][0]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = HALF_BASE;   add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = tempVertex[0][i+1][2];  add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = 1.0; add_LR_Vert_Ptr++;
        *add_LR_Coef_Ptr = tempCoef;    add_LR_Coef_Ptr++;

        
        
        // L downside
        *add_LR_Vert_Ptr = tempVertex[0][i][0]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = HALF_BASE; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = tempVertex[0][i][2]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = 1.0; add_LR_Vert_Ptr++;
        *add_LR_Coef_Ptr = tempCoef;    add_LR_Coef_Ptr++;

        
        *add_LR_Vert_Ptr = tempVertex[0][0][0]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = 0.0; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = tempVertex[0][0][2]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = 1.0; add_LR_Vert_Ptr++;
        *add_LR_Coef_Ptr = tempCoef;    add_LR_Coef_Ptr++;

        
        *add_LR_Vert_Ptr = tempVertex[0][i+1][0]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = HALF_BASE; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = tempVertex[0][i+1][2]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = 1.0; add_LR_Vert_Ptr++;
        *add_LR_Coef_Ptr = tempCoef;    add_LR_Coef_Ptr++;

        
        
        // L norm
        for( int k = 0 ; k < 6 ; k++ )
        {
            *add_LR_Norm_Ptr = LNorm[0]; add_LR_Norm_Ptr++;
            *add_LR_Norm_Ptr = LNorm[1]; add_LR_Norm_Ptr++;
            *add_LR_Norm_Ptr = LNorm[2]; add_LR_Norm_Ptr++;

        }
        
        // L norm downside
        for( int k = 0 ; k < 3 ; k++ )
        {
            *add_LR_Norm_Ptr = LNorm[0]; add_LR_Norm_Ptr++;
            *add_LR_Norm_Ptr = LNorm[1]; add_LR_Norm_Ptr++;
            *add_LR_Norm_Ptr = LNorm[2]; add_LR_Norm_Ptr++;

        }

    }
    
        // L last one triangle
    *add_LR_Vert_Ptr = tempVertex[0][0][0]; add_LR_Vert_Ptr++;
    *add_LR_Vert_Ptr = 0.0; add_LR_Vert_Ptr++;
    *add_LR_Vert_Ptr = tempVertex[0][0][2]; add_LR_Vert_Ptr++;
    *add_LR_Vert_Ptr = 1.0; add_LR_Vert_Ptr++;
    *add_LR_Coef_Ptr = tempCoef;    add_LR_Coef_Ptr++;

    
    *add_LR_Vert_Ptr = tempVertex[0][IMG_HEIGHT-1][0]; add_LR_Vert_Ptr++;
    *add_LR_Vert_Ptr = 0.0; add_LR_Vert_Ptr++;
    *add_LR_Vert_Ptr = tempVertex[0][IMG_HEIGHT-1][2]; add_LR_Vert_Ptr++;
    *add_LR_Vert_Ptr = 1.0; add_LR_Vert_Ptr++;
    *add_LR_Coef_Ptr = tempCoef;    add_LR_Coef_Ptr++;

    
    *add_LR_Vert_Ptr = tempVertex[0][IMG_HEIGHT-1][0]; add_LR_Vert_Ptr++;
    *add_LR_Vert_Ptr = HALF_BASE; add_LR_Vert_Ptr++;
    *add_LR_Vert_Ptr = tempVertex[0][IMG_HEIGHT-1][2]; add_LR_Vert_Ptr++;
    *add_LR_Vert_Ptr = 1.0; add_LR_Vert_Ptr++;
    *add_LR_Coef_Ptr = tempCoef;    add_LR_Coef_Ptr++;

    
    // L last one triangle norm
    for( int k = 0 ; k < 3 ; k++ )
    {
        *add_LR_Norm_Ptr = LNorm[0]; add_LR_Norm_Ptr++;
        *add_LR_Norm_Ptr = LNorm[1]; add_LR_Norm_Ptr++;
        *add_LR_Norm_Ptr = LNorm[2]; add_LR_Norm_Ptr++;

    }
    
    
    
    
    
    
    // R
    for( i = 0 ; i < IMG_HEIGHT-1 ; i++ )
    {
        //1
        *add_LR_Vert_Ptr = tempVertex[IMG_WIDTH-1][i][0]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = tempVertex[IMG_WIDTH-1][i][1]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = tempVertex[IMG_WIDTH-1][i][2]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = 1.0; add_LR_Vert_Ptr++;
        *add_LR_Coef_Ptr = tempCoef;    add_LR_Coef_Ptr++;

        //2
        *add_LR_Vert_Ptr = tempVertex[IMG_WIDTH-1][i+1][0]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = HALF_BASE;   add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = tempVertex[IMG_WIDTH-1][i+1][2]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = 1.0; add_LR_Vert_Ptr++;
        *add_LR_Coef_Ptr = tempCoef;    add_LR_Coef_Ptr++;

        //3
        *add_LR_Vert_Ptr = tempVertex[IMG_WIDTH-1][i][0]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = HALF_BASE; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = tempVertex[IMG_WIDTH-1][i][2]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = 1.0; add_LR_Vert_Ptr++;
        *add_LR_Coef_Ptr = tempCoef;    add_LR_Coef_Ptr++;

        //4
        *add_LR_Vert_Ptr = tempVertex[IMG_WIDTH-1][i][0]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = tempVertex[IMG_WIDTH-1][i][1]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = tempVertex[IMG_WIDTH-1][i][2]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = 1.0; add_LR_Vert_Ptr++;
        *add_LR_Coef_Ptr = tempCoef;    add_LR_Coef_Ptr++;

        //5
        *add_LR_Vert_Ptr = tempVertex[IMG_WIDTH-1][i+1][0]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = tempVertex[IMG_WIDTH-1][i+1][1];   add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = tempVertex[IMG_WIDTH-1][i+1][2]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = 1.0; add_LR_Vert_Ptr++;
        *add_LR_Coef_Ptr = tempCoef;    add_LR_Coef_Ptr++;

        //6
        *add_LR_Vert_Ptr = tempVertex[IMG_WIDTH-1][i+1][0]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = HALF_BASE;   add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = tempVertex[IMG_WIDTH-1][i+1][2];  add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = 1.0; add_LR_Vert_Ptr++;
        *add_LR_Coef_Ptr = tempCoef;    add_LR_Coef_Ptr++;

        
        
        // R downside
        *add_LR_Vert_Ptr = tempVertex[IMG_WIDTH-1][0][0]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = 0.0; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = tempVertex[IMG_WIDTH-1][0][2]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = 1.0; add_LR_Vert_Ptr++;
        *add_LR_Coef_Ptr = tempCoef;    add_LR_Coef_Ptr++;

        
        *add_LR_Vert_Ptr = tempVertex[IMG_WIDTH-1][i][0]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = HALF_BASE; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = tempVertex[IMG_WIDTH-1][i][2]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = 1.0; add_LR_Vert_Ptr++;
        *add_LR_Coef_Ptr = tempCoef;    add_LR_Coef_Ptr++;

        
        *add_LR_Vert_Ptr = tempVertex[IMG_WIDTH-1][i+1][0]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = HALF_BASE; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = tempVertex[IMG_WIDTH-1][i+1][2]; add_LR_Vert_Ptr++;
        *add_LR_Vert_Ptr = 1.0; add_LR_Vert_Ptr++;
        *add_LR_Coef_Ptr = tempCoef;    add_LR_Coef_Ptr++;

        
        
        // R norm
        for( int k = 0 ; k < 6 ; k++ )
        {
            *add_LR_Norm_Ptr = RNorm[0]; add_LR_Norm_Ptr++;
            *add_LR_Norm_Ptr = RNorm[1]; add_LR_Norm_Ptr++;
            *add_LR_Norm_Ptr = RNorm[2]; add_LR_Norm_Ptr++;
        }
        
        // R norm downside
        for( int k = 0 ; k < 3 ; k++ )
        {
            *add_LR_Norm_Ptr = RNorm[0]; add_LR_Norm_Ptr++;
            *add_LR_Norm_Ptr = RNorm[1]; add_LR_Norm_Ptr++;
            *add_LR_Norm_Ptr = RNorm[2]; add_LR_Norm_Ptr++;
        }
        
    }
    
    // R last one triangle
    *add_LR_Vert_Ptr = tempVertex[IMG_WIDTH-1][0][0]; add_LR_Vert_Ptr++;
    *add_LR_Vert_Ptr = 0.0; add_LR_Vert_Ptr++;
    *add_LR_Vert_Ptr = tempVertex[IMG_WIDTH-1][0][2]; add_LR_Vert_Ptr++;
    *add_LR_Vert_Ptr = 1.0; add_LR_Vert_Ptr++;
    *add_LR_Coef_Ptr = tempCoef;    add_LR_Coef_Ptr++;

    
    *add_LR_Vert_Ptr = tempVertex[IMG_WIDTH-1][IMG_HEIGHT-1][0]; add_LR_Vert_Ptr++;
    *add_LR_Vert_Ptr = HALF_BASE; add_LR_Vert_Ptr++;
    *add_LR_Vert_Ptr = tempVertex[IMG_WIDTH-1][IMG_HEIGHT-1][2]; add_LR_Vert_Ptr++;
    *add_LR_Vert_Ptr = 1.0; add_LR_Vert_Ptr++;
    *add_LR_Coef_Ptr = tempCoef;    add_LR_Coef_Ptr++;

    
    *add_LR_Vert_Ptr = tempVertex[IMG_WIDTH-1][IMG_HEIGHT-1][0]; add_LR_Vert_Ptr++;
    *add_LR_Vert_Ptr = 0.0; add_LR_Vert_Ptr++;
    *add_LR_Vert_Ptr = tempVertex[IMG_WIDTH-1][IMG_HEIGHT-1][2]; add_LR_Vert_Ptr++;
    *add_LR_Vert_Ptr = 1.0; add_LR_Vert_Ptr++;
    *add_LR_Coef_Ptr = tempCoef;    add_LR_Coef_Ptr++;

    
    // R last one triangle norm
    for( int k = 0 ; k < 3 ; k++ )
    {
        *add_LR_Norm_Ptr = RNorm[0]; add_LR_Norm_Ptr++;
        *add_LR_Norm_Ptr = RNorm[1]; add_LR_Norm_Ptr++;
        *add_LR_Norm_Ptr = RNorm[2]; add_LR_Norm_Ptr++;

    }

    
    
    
    // T
    for( i = 0 ; i < IMG_WIDTH-1 ; i++ )
    {
        //1
        *add_TB_Vert_Ptr = tempVertex[i][0][0]; add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = tempVertex[i][0][1]; add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = tempVertex[i][0][2]; add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = 1.0; add_TB_Vert_Ptr++;
        *add_TB_Coef_Ptr = tempCoef; add_TB_Coef_Ptr++;
        //2
        *add_TB_Vert_Ptr = tempVertex[i+1][0][0]; add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = tempVertex[i+1][0][1]; add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = tempVertex[i+1][0][2]; add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = 1.0; add_TB_Vert_Ptr++;
        *add_TB_Coef_Ptr = tempCoef; add_TB_Coef_Ptr++;

        //3
        *add_TB_Vert_Ptr = tempVertex[i][0][0]; add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = HALF_BASE; add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = tempVertex[i][0][2]; add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = 1.0; add_TB_Vert_Ptr++;
        *add_TB_Coef_Ptr = tempCoef; add_TB_Coef_Ptr++;

        //4
        *add_TB_Vert_Ptr = tempVertex[i][0][0]; add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = HALF_BASE; add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = tempVertex[i][0][2]; add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = 1.0; add_TB_Vert_Ptr++;
        *add_TB_Coef_Ptr = tempCoef; add_TB_Coef_Ptr++;

        //5
        *add_TB_Vert_Ptr = tempVertex[i+1][0][0]; add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = tempVertex[i+1][0][1]; add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = tempVertex[i+1][0][2]; add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = 1.0; add_TB_Vert_Ptr++;
        *add_TB_Coef_Ptr = tempCoef; add_TB_Coef_Ptr++;

        //6
        *add_TB_Vert_Ptr = tempVertex[i+1][0][0]; add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = HALF_BASE; add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = tempVertex[i+1][0][2]; add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = 1.0; add_TB_Vert_Ptr++;
        *add_TB_Coef_Ptr = tempCoef; add_TB_Coef_Ptr++;

        
        
        
        // T downside
        *add_TB_Vert_Ptr = tempVertex[0][0][0]; add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = 0.0; add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = tempVertex[0][0][2]; add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = 1.0; add_TB_Vert_Ptr++;
        *add_TB_Coef_Ptr = tempCoef; add_TB_Coef_Ptr++;

        
        *add_TB_Vert_Ptr = tempVertex[i][0][0]; add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = HALF_BASE; add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = tempVertex[i][0][2]; add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = 1.0; add_TB_Vert_Ptr++;
        *add_TB_Coef_Ptr = tempCoef; add_TB_Coef_Ptr++;

        
        *add_TB_Vert_Ptr = tempVertex[i+1][0][0]; add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = HALF_BASE; add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = tempVertex[i+1][0][2]; add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = 1.0; add_TB_Vert_Ptr++;
        *add_TB_Coef_Ptr = tempCoef; add_TB_Coef_Ptr++;

        
        
        for( int k = 0 ; k < 6 ; k++ )
        {
            *add_TB_Norm_Ptr = TNorm[0]; add_TB_Norm_Ptr++;
            *add_TB_Norm_Ptr = TNorm[1]; add_TB_Norm_Ptr++;
            *add_TB_Norm_Ptr = TNorm[2]; add_TB_Norm_Ptr++;
        }
        for( int k = 0 ; k < 3 ; k++ )
        {
            *add_TB_Norm_Ptr = TNorm[0]; add_TB_Norm_Ptr++;
            *add_TB_Norm_Ptr = TNorm[1]; add_TB_Norm_Ptr++;
            *add_TB_Norm_Ptr = TNorm[2]; add_TB_Norm_Ptr++;
        }
    }
    
        // T last triangle
    *add_TB_Vert_Ptr = tempVertex[0][0][0]; add_TB_Vert_Ptr++;
    *add_TB_Vert_Ptr = 0.0; add_TB_Vert_Ptr++;
    *add_TB_Vert_Ptr = tempVertex[0][0][2]; add_TB_Vert_Ptr++;
    *add_TB_Vert_Ptr = 1.0; add_TB_Vert_Ptr++;
    *add_TB_Coef_Ptr = tempCoef; add_TB_Coef_Ptr++;

    
    *add_TB_Vert_Ptr = tempVertex[IMG_WIDTH-1][0][0]; add_TB_Vert_Ptr++;
    *add_TB_Vert_Ptr = HALF_BASE; add_TB_Vert_Ptr++;
    *add_TB_Vert_Ptr = tempVertex[IMG_WIDTH-1][0][2]; add_TB_Vert_Ptr++;
    *add_TB_Vert_Ptr = 1.0; add_TB_Vert_Ptr++;
    *add_TB_Coef_Ptr = tempCoef; add_TB_Coef_Ptr++;

    
    *add_TB_Vert_Ptr = tempVertex[IMG_WIDTH-1][0][0]; add_TB_Vert_Ptr++;
    *add_TB_Vert_Ptr = 0.0; add_TB_Vert_Ptr++;
    *add_TB_Vert_Ptr = tempVertex[IMG_WIDTH-1][0][2]; add_TB_Vert_Ptr++;
    *add_TB_Vert_Ptr = 1.0; add_TB_Vert_Ptr++;
    *add_TB_Coef_Ptr = tempCoef; add_TB_Coef_Ptr++;

    
    
    for( int k = 0 ; k < 3 ; k++ )
    {
        *add_TB_Norm_Ptr = TNorm[0]; add_TB_Norm_Ptr++;
        *add_TB_Norm_Ptr = TNorm[1]; add_TB_Norm_Ptr++;
        *add_TB_Norm_Ptr = TNorm[2]; add_TB_Norm_Ptr++;
    }
    
    
    
    
    
    // B
    for( i = 0 ; i < IMG_WIDTH-1 ; i++ )
    {
        //1
        *add_TB_Vert_Ptr = tempVertex[i][IMG_HEIGHT-1][0];  add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = tempVertex[i][IMG_HEIGHT-1][1];  add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = tempVertex[i][IMG_HEIGHT-1][2];  add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = 1.0; add_TB_Vert_Ptr++;
        *add_TB_Coef_Ptr = tempCoef; add_TB_Coef_Ptr++;

        //2
        *add_TB_Vert_Ptr = tempVertex[i][IMG_HEIGHT-1][0];  add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = HALF_BASE;  add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = tempVertex[i][IMG_HEIGHT-1][2];  add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = 1.0; add_TB_Vert_Ptr++;
        *add_TB_Coef_Ptr = tempCoef; add_TB_Coef_Ptr++;

        //3
        *add_TB_Vert_Ptr = tempVertex[i+1][IMG_HEIGHT-1][0];  add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = tempVertex[i+1][IMG_HEIGHT-1][1];  add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = tempVertex[i+1][IMG_HEIGHT-1][2];  add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = 1.0; add_TB_Vert_Ptr++;
        *add_TB_Coef_Ptr = tempCoef; add_TB_Coef_Ptr++;

        //4
        *add_TB_Vert_Ptr = tempVertex[i+1][IMG_HEIGHT-1][0];  add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = tempVertex[i+1][IMG_HEIGHT-1][1];  add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = tempVertex[i+1][IMG_HEIGHT-1][2];  add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = 1.0; add_TB_Vert_Ptr++;
        *add_TB_Coef_Ptr = tempCoef; add_TB_Coef_Ptr++;

        //5
        *add_TB_Vert_Ptr = tempVertex[i][IMG_HEIGHT-1][0];  add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = HALF_BASE;  add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = tempVertex[i][IMG_HEIGHT-1][2];  add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = 1.0; add_TB_Vert_Ptr++;
        *add_TB_Coef_Ptr = tempCoef; add_TB_Coef_Ptr++;

        //6
        *add_TB_Vert_Ptr = tempVertex[i+1][IMG_HEIGHT-1][0];  add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = HALF_BASE;  add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = tempVertex[i+1][IMG_HEIGHT-1][2];  add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = 1.0; add_TB_Vert_Ptr++;
        *add_TB_Coef_Ptr = tempCoef; add_TB_Coef_Ptr++;

        
        
        
        // B downside
        *add_TB_Vert_Ptr = tempVertex[0][IMG_HEIGHT-1][0];  add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = 0.0;  add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = tempVertex[0][IMG_HEIGHT-1][2];  add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = 1.0; add_TB_Vert_Ptr++;
        *add_TB_Coef_Ptr = tempCoef; add_TB_Coef_Ptr++;

        
        *add_TB_Vert_Ptr = tempVertex[i+1][IMG_HEIGHT-1][0];  add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = HALF_BASE;  add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = tempVertex[i+1][IMG_HEIGHT-1][2];  add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = 1.0; add_TB_Vert_Ptr++;
        *add_TB_Coef_Ptr = tempCoef; add_TB_Coef_Ptr++;

        
        *add_TB_Vert_Ptr = tempVertex[i][IMG_HEIGHT-1][0];  add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = HALF_BASE;  add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = tempVertex[i][IMG_HEIGHT-1][2];  add_TB_Vert_Ptr++;
        *add_TB_Vert_Ptr = 1.0; add_TB_Vert_Ptr++;
        *add_TB_Coef_Ptr = tempCoef; add_TB_Coef_Ptr++;

        
        
        for( int k = 0 ; k < 6 ; k++ )
        {
            *add_TB_Norm_Ptr = BNorm[0]; add_TB_Norm_Ptr++;
            *add_TB_Norm_Ptr = BNorm[1]; add_TB_Norm_Ptr++;
            *add_TB_Norm_Ptr = BNorm[2]; add_TB_Norm_Ptr++;
        }
        for( int k = 0 ; k < 3 ; k++ )
        {
            *add_TB_Norm_Ptr = BNorm[0]; add_TB_Norm_Ptr++;
            *add_TB_Norm_Ptr = BNorm[1]; add_TB_Norm_Ptr++;
            *add_TB_Norm_Ptr = BNorm[2]; add_TB_Norm_Ptr++;
        }
    }
    
    
    // B last triangle
    *add_TB_Vert_Ptr = tempVertex[0][IMG_HEIGHT-1][0]; add_TB_Vert_Ptr++;
    *add_TB_Vert_Ptr = 0.0; add_TB_Vert_Ptr++;
    *add_TB_Vert_Ptr = tempVertex[0][IMG_HEIGHT-1][2]; add_TB_Vert_Ptr++;
    *add_TB_Vert_Ptr = 1.0; add_TB_Vert_Ptr++;
    *add_TB_Coef_Ptr = tempCoef; add_TB_Coef_Ptr++;

    *add_TB_Vert_Ptr = tempVertex[IMG_WIDTH-1][IMG_HEIGHT-1][0]; add_TB_Vert_Ptr++;
    *add_TB_Vert_Ptr = 0.0; add_TB_Vert_Ptr++;
    *add_TB_Vert_Ptr = tempVertex[IMG_WIDTH-1][IMG_HEIGHT-1][2]; add_TB_Vert_Ptr++;
    *add_TB_Vert_Ptr = 1.0; add_TB_Vert_Ptr++;
    *add_TB_Coef_Ptr = tempCoef; add_TB_Coef_Ptr++;

    *add_TB_Vert_Ptr = tempVertex[IMG_WIDTH-1][IMG_HEIGHT-1][0]; add_TB_Vert_Ptr++;
    *add_TB_Vert_Ptr = HALF_BASE; add_TB_Vert_Ptr++;
    *add_TB_Vert_Ptr = tempVertex[IMG_WIDTH-1][IMG_HEIGHT-1][2]; add_TB_Vert_Ptr++;
    *add_TB_Vert_Ptr = 1.0; add_TB_Vert_Ptr++;
    *add_TB_Coef_Ptr = tempCoef; add_TB_Coef_Ptr++;

    
    for( int k = 0 ; k < 3 ; k++ )
    {
        *add_TB_Norm_Ptr = BNorm[0]; add_TB_Norm_Ptr++;
        *add_TB_Norm_Ptr = BNorm[1]; add_TB_Norm_Ptr++;
        *add_TB_Norm_Ptr = BNorm[2]; add_TB_Norm_Ptr++;
    }
    
    
    // cap
    *add_cap_Vert_Ptr = tempVertex[0][0][0]; add_cap_Vert_Ptr++;
    *add_cap_Vert_Ptr = 0.0; add_cap_Vert_Ptr++;
    *add_cap_Vert_Ptr = tempVertex[0][0][2]; add_cap_Vert_Ptr++;
    *add_cap_Vert_Ptr = 1.0; add_cap_Vert_Ptr++;
    *add_cap_Coef_Ptr = tempCoef; add_cap_Coef_Ptr++;
    
    *add_cap_Vert_Ptr = tempVertex[IMG_WIDTH-1][0][0]; add_cap_Vert_Ptr++;
    *add_cap_Vert_Ptr = 0.0; add_cap_Vert_Ptr++;
    *add_cap_Vert_Ptr = tempVertex[IMG_WIDTH-1][0][2]; add_cap_Vert_Ptr++;
    *add_cap_Vert_Ptr = 1.0; add_cap_Vert_Ptr++;
    *add_cap_Coef_Ptr = tempCoef; add_cap_Coef_Ptr++;

    *add_cap_Vert_Ptr = tempVertex[0][IMG_HEIGHT-1][0]; add_cap_Vert_Ptr++;
    *add_cap_Vert_Ptr = 0.0; add_cap_Vert_Ptr++;
    *add_cap_Vert_Ptr = tempVertex[0][IMG_HEIGHT-1][2]; add_cap_Vert_Ptr++;
    *add_cap_Vert_Ptr = 1.0; add_cap_Vert_Ptr++;
    *add_cap_Coef_Ptr = tempCoef; add_cap_Coef_Ptr++;

    *add_cap_Vert_Ptr = tempVertex[0][IMG_HEIGHT-1][0]; add_cap_Vert_Ptr++;
    *add_cap_Vert_Ptr = 0.0; add_cap_Vert_Ptr++;
    *add_cap_Vert_Ptr = tempVertex[0][IMG_HEIGHT-1][2]; add_cap_Vert_Ptr++;
    *add_cap_Vert_Ptr = 1.0; add_cap_Vert_Ptr++;
    *add_cap_Coef_Ptr = tempCoef; add_cap_Coef_Ptr++;

    *add_cap_Vert_Ptr = tempVertex[IMG_WIDTH-1][0][0]; add_cap_Vert_Ptr++;
    *add_cap_Vert_Ptr = 0.0; add_cap_Vert_Ptr++;
    *add_cap_Vert_Ptr = tempVertex[IMG_WIDTH-1][0][2]; add_cap_Vert_Ptr++;
    *add_cap_Vert_Ptr = 1.0; add_cap_Vert_Ptr++;
    *add_cap_Coef_Ptr = tempCoef; add_cap_Coef_Ptr++;

    *add_cap_Vert_Ptr = tempVertex[IMG_WIDTH-1][IMG_HEIGHT-1][0]; add_cap_Vert_Ptr++;
    *add_cap_Vert_Ptr = 0.0; add_cap_Vert_Ptr++;
    *add_cap_Vert_Ptr = tempVertex[IMG_WIDTH-1][IMG_HEIGHT-1][2]; add_cap_Vert_Ptr++;
    *add_cap_Vert_Ptr = 1.0; add_cap_Vert_Ptr++;
    *add_cap_Coef_Ptr = tempCoef; add_cap_Coef_Ptr++;

    for( int k = 0 ; k < 6 ; k++ )
    {
        *add_cap_Norm_Ptr = capNorm[0]; add_cap_Norm_Ptr++;
        *add_cap_Norm_Ptr = capNorm[1]; add_cap_Norm_Ptr++;
        *add_cap_Norm_Ptr = capNorm[2]; add_cap_Norm_Ptr++;
    }
    
    
    
}// calculate

@end