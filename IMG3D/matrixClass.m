//
//  matrixClass.m
//  ModelViewProjection_Test
//
//  Created by 渡辺 圭介 on 11/03/03.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "matrixClass.h"


@implementation matrixClass

- (id)init
{
	self = [super init];
	
	
	MATRIX[ 0] = 1.0;	MATRIX[ 4] = 0.0;	MATRIX[ 8] = 0.0;	MATRIX[12] = 0.0;
	MATRIX[ 1] = 0.0;	MATRIX[ 5] = 1.0;	MATRIX[ 9] = 0.0;	MATRIX[13] = 0.0;
	MATRIX[ 2] = 0.0;	MATRIX[ 6] = 0.0;	MATRIX[10] = 1.0;	MATRIX[14] = 0.0;
	MATRIX[ 3] = 0.0;	MATRIX[ 7] = 0.0;	MATRIX[11] = 0.0;	MATRIX[15] = 1.0;
	
	INVERSE[ 0] = 1.0;	INVERSE[ 4] = 0.0;	INVERSE[ 8] = 0.0;	INVERSE[12] = 0.0;
	INVERSE[ 1] = 0.0;	INVERSE[ 5] = 1.0;	INVERSE[ 9] = 0.0;	INVERSE[13] = 0.0;
	INVERSE[ 2] = 0.0;	INVERSE[ 6] = 0.0;	INVERSE[10] = 1.0;	INVERSE[14] = 0.0;
	INVERSE[ 3] = 0.0;	INVERSE[ 7] = 0.0;	INVERSE[11] = 0.0;	INVERSE[15] = 1.0;
	
	return self;
}


- (void)initMatrix
{
	MATRIX[ 0] = 1.0;	MATRIX[ 4] = 0.0;	MATRIX[ 8] = 0.0;	MATRIX[12] = 0.0;
	MATRIX[ 1] = 0.0;	MATRIX[ 5] = 1.0;	MATRIX[ 9] = 0.0;	MATRIX[13] = 0.0;
	MATRIX[ 2] = 0.0;	MATRIX[ 6] = 0.0;	MATRIX[10] = 1.0;	MATRIX[14] = 0.0;
	MATRIX[ 3] = 0.0;	MATRIX[ 7] = 0.0;	MATRIX[11] = 0.0;	MATRIX[15] = 1.0;

	INVERSE[ 0] = 1.0;	INVERSE[ 4] = 0.0;	INVERSE[ 8] = 0.0;	INVERSE[12] = 0.0;
	INVERSE[ 1] = 0.0;	INVERSE[ 5] = 1.0;	INVERSE[ 9] = 0.0;	INVERSE[13] = 0.0;
	INVERSE[ 2] = 0.0;	INVERSE[ 6] = 0.0;	INVERSE[10] = 1.0;	INVERSE[14] = 0.0;
	INVERSE[ 3] = 0.0;	INVERSE[ 7] = 0.0;	INVERSE[11] = 0.0;	INVERSE[15] = 1.0;
}



- (void)rotate_Xdeg:(float)degree
{
	float radian = degree * 0.0174532925;
	
	float MTX_rotX[16];
	
	MTX_rotX[0] = 1.0;	MTX_rotX[4] = 0.0;			MTX_rotX[8] = 0.0;				MTX_rotX[12] = 0.0;
	MTX_rotX[1] = 0.0;	MTX_rotX[5] = cosf(radian);	MTX_rotX[9] = -sinf(radian);	MTX_rotX[13] = 0.0;
	MTX_rotX[2] = 0.0;	MTX_rotX[6] = sinf(radian);	MTX_rotX[10] = cosf(radian);	MTX_rotX[14] = 0.0;
	MTX_rotX[3] = 0.0;	MTX_rotX[7] = 0.0;			MTX_rotX[11] = 0.0;				MTX_rotX[15] = 1.0;
	
	[self calculate_matrix:MTX_rotX];
}
- (void)rotate_Ydeg:(float)degree
{
	float radian = degree * 0.0174532925;
	float MTX_rotY[16];

	MTX_rotY[0] = cosf(radian);		MTX_rotY[4] = 0.0;	MTX_rotY[8] = sinf(radian);		MTX_rotY[12] = 0.0;
	MTX_rotY[1] = 0.0;				MTX_rotY[5] = 1.0;	MTX_rotY[9] = 0.0;				MTX_rotY[13] = 0.0;
	MTX_rotY[2] = -sinf(radian);	MTX_rotY[6] = 0.0;	MTX_rotY[10] = cosf(radian);	MTX_rotY[14] = 0.0;
	MTX_rotY[3] = 0.0;				MTX_rotY[7] = 0.0;	MTX_rotY[11] = 0.0;				MTX_rotY[15] = 1.0;
	
	[self calculate_matrix:MTX_rotY];
}
- (void)rotate_Zdeg:(float)degree
{
	float radian = degree * 0.0174532925;
	float MTX_rotZ[16];

	MTX_rotZ[0] = cosf(radian);	MTX_rotZ[4] = -sinf(radian);	MTX_rotZ[8] = 0.0;		MTX_rotZ[12] = 0.0;
	MTX_rotZ[1] = sinf(radian);	MTX_rotZ[5] = cosf(radian);		MTX_rotZ[9] = 0.0;		MTX_rotZ[13] = 0.0;
	MTX_rotZ[2] = 0.0;			MTX_rotZ[6] = 0.0;				MTX_rotZ[10] = 1.0;		MTX_rotZ[14] = 0.0;
	MTX_rotZ[3] = 0.0;			MTX_rotZ[7] = 0.0;				MTX_rotZ[11] = 0.0;		MTX_rotZ[15] = 1.0;
	
	[self calculate_matrix:MTX_rotZ];
}



- (void)translate_x:(float)tx y:(float)ty z:(float)tz
{
	float M_trans[16];
	
	M_trans[0] = 1.0;	M_trans[4] = 0.0;	M_trans[8] = 0.0;	M_trans[12] = tx;
	M_trans[1] = 0.0;	M_trans[5] = 1.0;	M_trans[9] = 0.0;	M_trans[13] = ty;
	M_trans[2] = 0.0;	M_trans[6] = 0.0;	M_trans[10] = 1.0;	M_trans[14] = tz;
	M_trans[3] = 0.0;	M_trans[7] = 0.0;	M_trans[11] = 0.0;	M_trans[15] = 1.0;
	
	[self calculate_matrix:M_trans];
}

- (void)scale_x:(float)xf y:(float)yf z:(float)zf
{
	float M_scale[16];
	
	M_scale[0] = xf;	M_scale[4] = 0.0;	M_scale[8] = 0.0;	M_scale[12] = 0.0;
	M_scale[1] = 0.0;	M_scale[5] = yf;	M_scale[9] = 0.0;	M_scale[13] = 0.0;
	M_scale[2] = 0.0;	M_scale[6] = 0.0;	M_scale[10] = zf;	M_scale[14] = 0.0;
	M_scale[3] = 0.0;	M_scale[7] = 0.0;	M_scale[11] = 0.0;	M_scale[15] = 1.0;
	
	[self calculate_matrix:M_scale];
}


- (void)lookAt_Ex:(float)eyeX Ey:(float)eyeY Ez:(float)eyeZ
			   Vx:(float)viewX Vy:(float)viewY Vz:(float)viewZ
			   Hx:(float)headX Hy:(float)headY Hz:(float)headZ
{
	float xVec[3];
	float yVec[3];
	float zVec[3];
	
	float normWeight;
	
	zVec[0] = eyeX - viewX;
	zVec[1] = eyeY - viewY;
	zVec[2] = eyeZ - viewZ;
	
	normWeight = 1.0 / sqrt(zVec[0]*zVec[0] + zVec[1]*zVec[1] + zVec[2]*zVec[2]);
	
	zVec[0] *= normWeight;
	zVec[1] *= normWeight;
	zVec[2] *= normWeight;
	
	xVec[0] = headY*zVec[2] - headZ*zVec[1];
	xVec[1] = headZ*zVec[0] - headX*zVec[2];
	xVec[2] = headX*zVec[1] - headY*zVec[0];
	
	normWeight = 1.0 / sqrt(xVec[0]*xVec[0] + xVec[1]*xVec[1] + xVec[2]*xVec[2]);
	xVec[0] *= normWeight;
	xVec[1] *= normWeight;
	xVec[2] *= normWeight;
	
	yVec[0] = zVec[1]*xVec[2] - zVec[2]*xVec[1]; 
	yVec[1] = zVec[2]*xVec[0] - zVec[0]*xVec[2];
	yVec[2] = zVec[0]*xVec[1] - zVec[1]*xVec[0];
	
	normWeight = 1.0 / sqrt(yVec[0]*yVec[0] + yVec[1]*yVec[1] + yVec[2]*yVec[2]);
	yVec[0] *= normWeight;
	yVec[1] *= normWeight;
	yVec[2] *= normWeight;
	
	float M_LookAt[16];
	
	M_LookAt[0] = 1.0;	M_LookAt[4] = 0.0;	M_LookAt[8] = 0.0;		M_LookAt[12] = -eyeX;
	M_LookAt[1] = 0.0;	M_LookAt[5] = 1.0;	M_LookAt[9] = 0.0;		M_LookAt[13] = -eyeY;
	M_LookAt[2] = 0.0;	M_LookAt[6] = 0.0;	M_LookAt[10] = 1.0;		M_LookAt[14] = -eyeZ;
	M_LookAt[3] = 0.0;	M_LookAt[7] = 0.0;	M_LookAt[11] = 0.0;		M_LookAt[15] = 1.0;
	
	[self calculate_matrix:M_LookAt];
	
	M_LookAt[0] = xVec[0];	M_LookAt[4] = xVec[1];	M_LookAt[8] = xVec[2];	M_LookAt[12] = 0.0;
	M_LookAt[1] = yVec[0];	M_LookAt[5] = yVec[1];	M_LookAt[9] = yVec[2];	M_LookAt[13] = 0.0;
	M_LookAt[2] = zVec[0];	M_LookAt[6] = zVec[1];	M_LookAt[10] = zVec[2];	M_LookAt[14] = 0.0;
	M_LookAt[3] = 0.0;		M_LookAt[7] = 0.0;		M_LookAt[11] = 0.0;		M_LookAt[15] = 1.0;
	
	[self calculate_matrix:M_LookAt];
}



- (void)perspective_fovy:(float)degree aspect:(float)ratio near:(float)N far:(float)F
{
	float radian = degree * 0.0174532925;
	float COEF = 1.0 / tanf(radian*0.5);
	float A = ( N + F ) / ( N - F );
	float B = ( 2.0*N*F ) / ( N - F );
	
	float M_Proj[16];
	
	M_Proj[0] = COEF/ratio;	M_Proj[4] = 0.0f;	M_Proj[8] = 0.0f;	M_Proj[12] = 0.0f;
	M_Proj[1] = 0.0f;		M_Proj[5] = COEF;	M_Proj[9] = 0.0f;	M_Proj[13] = 0.0f;
	M_Proj[2] = 0.0f;		M_Proj[6] = 0.0f;	M_Proj[10] = A;		M_Proj[14] = B;
	M_Proj[3] = 0.0f;		M_Proj[7] = 0.0f;	M_Proj[11] = -1.0f;	M_Proj[15] = 0.0;
	
	[self calculate_matrix:M_Proj];
}





- (void)calculate_matrix:(float*)matrix
{
	float Lm[16];
	float Rm[16];
	float* ptr_L = matrix;
	
	int i;
	
	for( i = 0 ; i < 16 ; i++ )
	{
		Lm[i] = *ptr_L;
		ptr_L++;
		
		Rm[i] = MATRIX[i];
	}
	
	MATRIX[0] = Lm[0]*Rm[0] + Lm[4]*Rm[1] + Lm[8]*Rm[2] + Lm[12]*Rm[3];
	MATRIX[1] = Lm[1]*Rm[0] + Lm[5]*Rm[1] + Lm[9]*Rm[2] + Lm[13]*Rm[3];
	MATRIX[2] = Lm[2]*Rm[0] + Lm[6]*Rm[1] + Lm[10]*Rm[2] + Lm[14]*Rm[3];
	MATRIX[3] = Lm[3]*Rm[0] + Lm[7]*Rm[1] + Lm[11]*Rm[2] + Lm[15]*Rm[3];

	MATRIX[4] = Lm[0]*Rm[4] + Lm[4]*Rm[5] + Lm[8]*Rm[6] + Lm[12]*Rm[7];
	MATRIX[5] = Lm[1]*Rm[4] + Lm[5]*Rm[5] + Lm[9]*Rm[6] + Lm[13]*Rm[7];
	MATRIX[6] = Lm[2]*Rm[4] + Lm[6]*Rm[5] + Lm[10]*Rm[6] + Lm[14]*Rm[7];
	MATRIX[7] = Lm[3]*Rm[4] + Lm[7]*Rm[5] + Lm[11]*Rm[6] + Lm[15]*Rm[7];

	MATRIX[8] = Lm[0]*Rm[8] + Lm[4]*Rm[9] + Lm[8]*Rm[10] + Lm[12]*Rm[11];
	MATRIX[9] = Lm[1]*Rm[8] + Lm[5]*Rm[9] + Lm[9]*Rm[10] + Lm[13]*Rm[11];
	MATRIX[10] = Lm[2]*Rm[8] + Lm[6]*Rm[9] + Lm[10]*Rm[10] + Lm[14]*Rm[11];
	MATRIX[11] = Lm[3]*Rm[8] + Lm[7]*Rm[9] + Lm[11]*Rm[10] + Lm[15]*Rm[11];

	MATRIX[12] = Lm[0]*Rm[12] + Lm[4]*Rm[13] + Lm[8]*Rm[14] + Lm[12]*Rm[15];
	MATRIX[13] = Lm[1]*Rm[12] + Lm[5]*Rm[13] + Lm[9]*Rm[14] + Lm[13]*Rm[15];
	MATRIX[14] = Lm[2]*Rm[12] + Lm[6]*Rm[13] + Lm[10]*Rm[14] + Lm[14]*Rm[15];
	MATRIX[15] = Lm[3]*Rm[12] + Lm[7]*Rm[13] + Lm[11]*Rm[14] + Lm[15]*Rm[15];
}


- (float*)getMatrix
{
	return MATRIX;
}




- (float*)inverse_matrix:(float*)matPtr
{
    int i;
    
    double inMat[16];
    float* ptr = matPtr;

    for( i = 0 ; i < 16 ; i++ )
    {
        inMat[i] = (double)(*ptr);
        ptr++;
    }
    
    double det = inMat[0]*inMat[5]*inMat[10]*inMat[15]  + inMat[0]*inMat[9]*inMat[14]*inMat[7]  +   inMat[0]*inMat[13]*inMat[6]*inMat[11] +
                 inMat[4]+inMat[1]*inMat[14]*inMat[11]  + inMat[4]*inMat[9]*inMat[2]*inMat[15]  +   inMat[4]*inMat[13]*inMat[10]*inMat[3] +
                 inMat[8]*inMat[1]*inMat[6]*inMat[15]   + inMat[8]*inMat[5]*inMat[14]*inMat[3]  +   inMat[8]*inMat[13]*inMat[2]*inMat[7]  +
                 inMat[12]*inMat[1]*inMat[10]*inMat[7]  + inMat[12]*inMat[5]*inMat[2]*inMat[11] +   inMat[12]*inMat[9]*inMat[6]*inMat[3]  -
                 inMat[0]*inMat[5]*inMat[14]*inMat[11]  - inMat[0]*inMat[9]*inMat[6]*inMat[15]  -   inMat[0]*inMat[13]*inMat[10]*inMat[7] -
                 inMat[4]*inMat[1]*inMat[10]*inMat[15]  - inMat[4]*inMat[9]*inMat[14]*inMat[3]  -   inMat[4]*inMat[13]*inMat[2]*inMat[11] -
                 inMat[8]*inMat[1]*inMat[14]*inMat[7]   - inMat[8]*inMat[5]*inMat[2]*inMat[15]  -   inMat[8]*inMat[13]*inMat[6]*inMat[3]  -
                 inMat[12]*inMat[1]*inMat[6]*inMat[11]  - inMat[12]*inMat[5]*inMat[10]*inMat[3] -   inMat[12]*inMat[9]*inMat[2]*inMat[7];
    
    
    if( det == 0.0 )
    {
        INVERSE[ 0] = 1.0;  INVERSE[ 4] = 0.0;  INVERSE[ 8] = 0.0;  INVERSE[12] = 0.0;
        INVERSE[ 1] = 0.0;  INVERSE[ 5] = 1.0;  INVERSE[ 9] = 0.0;  INVERSE[13] = 0.0;
        INVERSE[ 2] = 0.0;  INVERSE[ 6] = 0.0;  INVERSE[10] = 1.0;  INVERSE[14] = 0.0;
        INVERSE[ 3] = 0.0;  INVERSE[ 7] = 0.0;  INVERSE[11] = 0.0;  INVERSE[15] = 1.0;
    }
    else
    {
        INVERSE[0] = inMat[5]*(inMat[10]*inMat[15] - inMat[14]*inMat[11]) +
                     inMat[9]*(inMat[14]*inMat[7] - inMat[6]*inMat[15]) +
                     inMat[13]*(inMat[6]*inMat[11] - inMat[10]*inMat[7]);
        
        INVERSE[1] = inMat[9]*(inMat[14]*inMat[3] - inMat[2]*inMat[15]) +
                     inMat[13]*(inMat[2]*inMat[11] - inMat[10]*inMat[3]) +
                     inMat[1]*(inMat[10]*inMat[15] - inMat[14]*inMat[11]);
        
        INVERSE[2] = inMat[13]*(inMat[2]*inMat[7] - inMat[6]*inMat[3]) +
                     inMat[1]*(inMat[6]*inMat[15] - inMat[14]*inMat[7]) +
                     inMat[5]*(inMat[14]*inMat[3] - inMat[2]*inMat[15]);
        
        INVERSE[3] = inMat[1]*(inMat[6]*inMat[11] - inMat[10]*inMat[7]) +
                     inMat[5]*(inMat[10]*inMat[3] - inMat[2]*inMat[11]) + 
                     inMat[9]*(inMat[2]*inMat[7] - inMat[6]*inMat[3]);
        
        //*************************
        INVERSE[4] = inMat[6]*(inMat[11]*inMat[12] - inMat[15]*inMat[8]) +
                     inMat[10]*(inMat[15]*inMat[4] - inMat[7]*inMat[13]) +
                     inMat[14]*(inMat[7]*inMat[8] - inMat[11]*inMat[4]);
        
        INVERSE[5] = inMat[10]*(inMat[15]*inMat[0] - inMat[3]*inMat[12]) +
                     inMat[14]*(inMat[3]*inMat[8] - inMat[11]*inMat[0]) +
                     inMat[2]*(inMat[11]*inMat[12] - inMat[15]*inMat[8]);
        
        INVERSE[6] = inMat[14]*(inMat[3]*inMat[4] - inMat[7]*inMat[0]) +
                     inMat[2]*(inMat[7]*inMat[12] - inMat[15]*inMat[4]) +
                     inMat[6]*(inMat[15]*inMat[0] - inMat[3]*inMat[12]);
        
        INVERSE[7] = inMat[2]*(inMat[7]*inMat[8] -inMat[11]*inMat[4]) + 
                     inMat[6]*(inMat[11]*inMat[0] - inMat[3]*inMat[8]) +
                     inMat[10]*(inMat[3]*inMat[4] - inMat[7]*inMat[0]);
        //***************************
        INVERSE[8] = inMat[7]*(inMat[8]*inMat[13] - inMat[12]*inMat[9]) +
                     inMat[11]*(inMat[12]*inMat[5] - inMat[4]*inMat[13]) +
                     inMat[15]*(inMat[4]*inMat[9] - inMat[8]*inMat[5]);
        
        INVERSE[9] = inMat[11]*(inMat[12]*inMat[1] - inMat[0]*inMat[13]) +
                     inMat[15]*(inMat[0]*inMat[9] - inMat[8]*inMat[1]) + 
                     inMat[3]*(inMat[8]*inMat[13] - inMat[12]*inMat[9]);
        
        INVERSE[10] =   inMat[15]*(inMat[0]*inMat[5] - inMat[4]*inMat[1]) +
                        inMat[3]*(inMat[4]*inMat[13] - inMat[12]*inMat[5]) + 
                        inMat[7]*(inMat[12]*inMat[1] - inMat[0]*inMat[13]);
        
        INVERSE[11] =   inMat[3]*(inMat[4]*inMat[9] - inMat[8]*inMat[5]) +
                        inMat[7]*(inMat[8]*inMat[1] - inMat[0]*inMat[9]) +
                        inMat[11]*(inMat[0]*inMat[5] - inMat[4]*inMat[1]);
        //****************************
        INVERSE[12] =   inMat[4]*(inMat[9]*inMat[14] - inMat[13]*inMat[10]) +
                        inMat[8]*(inMat[13]*inMat[6] - inMat[5]*inMat[14]) +
                        inMat[12]*(inMat[5]*inMat[10] - inMat[9]*inMat[6]);
        
        INVERSE[13] =   inMat[8]*(inMat[13]*inMat[2] - inMat[1]*inMat[14]) +
                        inMat[12]*(inMat[1]*inMat[10] - inMat[9]*inMat[2]) +
                        inMat[0]*(inMat[9]*inMat[14] - inMat[13]*inMat[10]);
        
        INVERSE[14] =   inMat[12]*(inMat[1]*inMat[6] - inMat[5]*inMat[2]) + 
                        inMat[0]*(inMat[5]*inMat[14] - inMat[13]*inMat[6]) + 
                        inMat[4]*(inMat[13]*inMat[2] - inMat[1]*inMat[14]);
        
        INVERSE[15] =   inMat[0]*(inMat[5]*inMat[10] - inMat[9]*inMat[6]) +
                        inMat[4]*(inMat[9]*inMat[2] - inMat[1]*inMat[10]) + 
                        inMat[8]*(inMat[1]*inMat[6] - inMat[5]*inMat[2]);
    }
    
    return INVERSE;
}

- (void)calculate_vec4:(float*)vec4
{
    float* in_Ptr = vec4;
    float* culc_Ptr = vec4;
    float value[4];
    float result[4];
    
    value[0] = *culc_Ptr; culc_Ptr++;
    value[1] = *culc_Ptr; culc_Ptr++;
    value[2] = *culc_Ptr; culc_Ptr++;
    value[3] = *culc_Ptr;
    
    result[0] = MATRIX[0]*value[0] + MATRIX[4]*value[1] + MATRIX[ 8]*value[2] + MATRIX[12]*value[3];
    result[1] = MATRIX[1]*value[0] + MATRIX[5]*value[1] + MATRIX[ 9]*value[2] + MATRIX[13]*value[3];
    result[2] = MATRIX[2]*value[0] + MATRIX[6]*value[1] + MATRIX[10]*value[2] + MATRIX[14]*value[3];
    result[3] = MATRIX[3]*value[0] + MATRIX[7]*value[1] + MATRIX[11]*value[2] + MATRIX[15]*value[3];
    
    *in_Ptr = result[0];    in_Ptr++;
    *in_Ptr = result[1];    in_Ptr++;
    *in_Ptr = result[2];    in_Ptr++;
    *in_Ptr = result[3];
}



- (void)calculate_vec3:(float*)vec3
{
    float* in_Ptr = vec3;
    float* culc_Ptr = vec3;
    float value[4];
    float result[3];

    value[0] = *culc_Ptr; culc_Ptr++;
    value[1] = *culc_Ptr; culc_Ptr++;
    value[2] = *culc_Ptr;
    value[3] = 1.0f;

    result[0] = MATRIX[0]*value[0] + MATRIX[4]*value[1] + MATRIX[ 8]*value[2] + MATRIX[12]*value[3];
    result[1] = MATRIX[1]*value[0] + MATRIX[5]*value[1] + MATRIX[ 9]*value[2] + MATRIX[13]*value[3];
    result[2] = MATRIX[2]*value[0] + MATRIX[6]*value[1] + MATRIX[10]*value[2] + MATRIX[14]*value[3];
    
    *in_Ptr = result[0];    in_Ptr++;
    *in_Ptr = result[1];    in_Ptr++;
    *in_Ptr = result[2];
}


@end
