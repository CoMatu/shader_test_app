#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float iTime;                 // shader playback time (in seconds) 3
uniform sampler2D image1;          // input channel. XX = 2D/Cube
uniform sampler2D image2;          // input channel. XX = 2D/Cube

out vec4 fragColor;

void main()
{
     vec2 iResolution = uSize;
     vec2 fragCoord = FlutterFragCoord();

     vec2 uv = fragCoord.xy / iResolution.xy;

     vec4 c1 = texture(image1, uv);
     vec4 c2 = texture(image2, uv);
    if(iTime < 3)
     {
        fragColor = c1 * (1 - iTime/3) + c2 * iTime/3;
     }
    if(iTime >=3)
    {
        fragColor = c2;
    }



    // vec2 uv = fragCoord.xy / iResolution.xy;
    // float dur = 4.;
    // float dim = 7.;
    // vec2 v = uv;
    // v.y=1.-v.y;

    // vec2 x = mod(1.-v.xx, 1./dim)+floor(v*dim)/dim;
    // /// абсолютные значения
    // float a = .5*(abs(x.x)+abs(x.y));
    // // округление
    // float b = fract(iTime/dur);
    // a=a>b?0.:1.;
    // bool mt = mod(floor(iTime/dur),2.)==0.;
    // float cd = a;
    // if (mt)
    // {
    // 	cd=1.-cd;    
    // }

    // fragColor = mix(vec4(a),(mix(texture(image1, uv), texture(image2, uv), cd)), 1.0);
 

}