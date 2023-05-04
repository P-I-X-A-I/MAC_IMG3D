attribute vec4 position;
attribute vec3 normal;
attribute float heightCoef;

uniform mat4 mvp_Matrix;
uniform vec3 eyeVec;
uniform vec3 baseColor;
uniform float specCoef;

varying vec4 colorVarying;

uniform vec3 lightVec;
void main()
{
    gl_Position = mvp_Matrix * position;
    
    
    float convertCoef = heightCoef*0.8+0.2;
    
    
    vec3 convEyevec = normalize(eyeVec - position.xyz);
    vec3 halfVec = normalize( convEyevec + lightVec );
    
    //vec3 halfVec = normalize( eyeVec + lightVec );
    
    float luminance = dot( normal, halfVec );
    
    luminance = max( 0.0, luminance ) * specCoef * heightCoef;
    luminance = pow( luminance, 2.5 );
    
    colorVarying = vec4( baseColor.r * convertCoef + luminance,
                         baseColor.g * convertCoef + luminance,
                         baseColor.b * convertCoef + luminance,
                         1.0
                        );
    
}