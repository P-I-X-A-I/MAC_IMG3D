attribute vec4 position;
attribute vec4 color;

uniform mat4 mvp_Matrix;

varying vec4 colorVarying;

void main()
{
    gl_Position = mvp_Matrix * position;
    
    colorVarying = color;
}