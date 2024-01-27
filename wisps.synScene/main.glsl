// SaturdayShader Week 30 : Wisps
// by Joseph Fiola (http://www.joefiola.com)
// 2016-03-12

// Based on Week 29 Saturday Shader + "WAVES" Shadertoy by bonniem
// https://www.shadertoy.com/view/4dsGzH

#define TWO_PI 6.28318530718

mat2 rotate2d(float _angle){
    return mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}

vec4 renderMain() { 
 	vec4 out_FragColor = vec4(0.0);

	vec2 uv = _xy.xy / RENDERSIZE.xy;
	uv -= vec2(pos);
	uv.x *= RENDERSIZE.x/RENDERSIZE.y;
	uv *= zoom; // Scale the coordinate system
	uv = rotate2d(rotateCanvas*-TWO_PI) * uv; 
	
	
	// waves
	vec3 wave_color = vec3(0.0);
	
	float wave_width = 0.01;
	//uv  = -1.0 + 2.0 * uv;
	//uv.y += 0.1;
	for(float i = 0.0; i < 200.0; i++) {
		
		uv = rotate2d(twisted*-TWO_PI) * uv; 
		if (lines <= i) break;
		
		uv.y +=  sin(sin((TIME/12+syn_BassTime/20.) * PI)*12.*sin(uv.x + i*mod1 + (scroll * TWO_PI) ) * amp + (mod2 * PI));

		
		if(lines * linesStartOffset - 1.0 <= i) {
			wave_width = abs(1.0 / (50.0 * uv.y * glow));
			wave_color += vec3(wave_width, wave_width, wave_width);
		}
	}
	
	out_FragColor = vec4(wave_color, 1.0);

return out_FragColor; 
 } 
