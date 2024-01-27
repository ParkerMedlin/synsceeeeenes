// SaturdayShader Week 16 : Zebre
// by Joseph Fiola (http://www.joefiola.com)
// 2015-12-05
// Based on Patricio Gonzalez Vivo's "Wood Texture" example on http://patriciogonzalezvivo.com/2015/thebookofshaders/edit.html#11/wood.frag @patriciogv ( patriciogonzalezvivo.com ) - 2015





#ifdef GL_ES
precision mediump float;
#endif


float random (in vec2 st) { 
    return fract(sin(dot(st.xy,
                         vec2(randomAmt.x,randomAmt.y))) 
                * randomMultiply);
}

// Value noise by Inigo Quilez - iq/2013
// https://www.shadertoy.com/view/lsf3WH
float noise(vec2 st) {

    vec2 i = floor(st);
	vec2 f = fract(st);


    vec2 u = f*f*(3.0-2.0*f);
    return mix( mix( random( i + vec2(0.0,0.0) ), 
                     random( i + vec2(1.0,0.0) ), u.x),
                mix( random( i + vec2(0.0,1.0) ), 
                     random( i + vec2(1.0,1.0) ), u.x), u.y);
}


mat2 rotate2d(float angle){
    return mat2(cos(angle *xyNoiseFactor.x),-sin(angle),
                sin(angle * xyNoiseFactor.y),cos(angle));
}


float lines(in vec2 pos, float b){
    float scale = lineScale;
    pos *= scale;
    return smoothstep(0.0,
                    .5+b*.5,
                    abs((sin(pos.x*3.1415)+b*2.0))* brightness);
}


vec4 renderMain() { 
 	vec4 out_FragColor = vec4(0.0);

    vec2 st = _xy.xy/RENDERSIZE.xy;
    st -= vec2(origin);
    st.y *= RENDERSIZE.y/RENDERSIZE.x;

    vec2 pos = st.yx*vec2(xyStretch);

    float pattern = pos.x;

    // Add noise
    pos = rotate2d( noise(pos) ) * pos * harmonic + (TIME * lineOffsetSpeed);
    
    // Draw lines
    pattern = lines(pos,0.5);
    
    //adjust contrast
	pattern += smoothstep(0.0+contrast+contrastShift,1.0-contrast+contrastShift, pattern);

    out_FragColor = vec4(vec3(pattern),1.0);

return out_FragColor; 
 } 

