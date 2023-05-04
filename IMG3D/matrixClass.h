//
//  matrixClass.h
//  ModelViewProjection_Test
//
//  Created by 渡辺 圭介 on 11/03/03.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface matrixClass : NSObject {
	
	float MATRIX[16];
    float INVERSE[16];
}

- (void)rotate_Xdeg:(float)degree;
- (void)rotate_Ydeg:(float)degree;
- (void)rotate_Zdeg:(float)degree;

- (void)translate_x:(float)tx y:(float)ty z:(float)tz;

- (void)scale_x:(float)xf y:(float)yf z:(float)zf;

- (void)lookAt_Ex:(float)eyeX Ey:(float)eyeY Ez:(float)eyeZ
			   Vx:(float)viewX Vy:(float)viewY Vz:(float)viewZ
			   Hx:(float)headX Hy:(float)headY Hz:(float)headZ;


- (void)perspective_fovy:(float)degree aspect:(float)ratio near:(float)N far:(float)F;

- (void)initMatrix;
- (float*)getMatrix;

- (void)calculate_matrix:(float*)matrix;

- (float*)inverse_matrix:(float*)matPtr;

- (void)calculate_vec4:(float*)vec4;
- (void)calculate_vec3:(float*)vec3;
@end
