

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float rchar(vec2 outer, vec2 inner, float globalTime) {
	//return float(rand(floor(inner * 2.0) + outer) > 0.9);
	
	vec2 seed = floor(inner * 4.0) + outer.y;
	if (rand(vec2(outer.y, 23.0)) > 0.98) {
		seed += floor((globalTime + rand(vec2(outer.y, 49.0))) * 3.0);
	}
	
	return float(rand(seed) > 0.5);
}

vec4 renderMain() { 
 	vec4 out_FragColor = vec4(0.0);

	
	float DROP_SIZE = 10.0-DropSize;
	
	vec2 position = _xy.xy / RENDERSIZE.xy;
	vec2 uv = vec2(position.x, position.y);
    position.x /= RENDERSIZE.x / RENDERSIZE.y;
	float globalTime = TIME * rainSpeed;
	
	float scaledown = DROP_SIZE;
	float rx = _xy.x / (40.0 * scaledown);
	float mx = 40.0*scaledown*fract(position.x * 30.0 * scaledown);
	vec4 result = vec4(0);
	
	if (mx > 12.0 * scaledown) {
		result = vec4(0.0);
	} else 
	{
        float x = floor(rx);
		float r1x = floor(_xy.x / (15.0));
		

		float ry = position.y*600.0 + rand(vec2(x, x * 3.0)) * 100000.0 + globalTime* rand(vec2(r1x, 23.0)) * 120.0;
		float my = mod(ry, 15.0);
		if (my > 12.0 * scaledown) {
			result = vec4(0.0);
		} else {
		
			float y = floor(ry / 15.0);
			
			float b = rchar(vec2(rx, floor((ry) / 15.0)), vec2(mx, my) / 12.0, globalTime);
			float col = max(mod(-y, 24.0) - 4.0, 0.0) / 20.0;
			vec3 c = col < 0.8 ? vec3(0.0, col / 0.8, 0.0) : mix(vec3(0.0, 1.0, 0.0), vec3(1.0), (col - 0.8) / 0.2);
			
			result = vec4(c * b, 1.0)  ;
		}
	}
	
	position.x += 0.05;

	scaledown = DROP_SIZE;
	rx = _xy.x / (40.0 * scaledown);
	mx = 40.0*scaledown*fract(position.x * 30.0 * scaledown);
	
	if (mx > 12.0 * scaledown) {
		result += vec4(0.0);
	} else 
	{
        float x = floor(rx);
		float r1x = floor(_xy.x / (12.0));
		

		float ry = position.y*700.0 + rand(vec2(x, x * 3.0)) * 100000.0 + globalTime* rand(vec2(r1x, 23.0)) * 120.0;
		float my = mod(ry, 15.0);
		if (my > 12.0 * scaledown) {
			result += vec4(0.0);
		} else {
		
			float y = floor(ry / 15.0);
			
			float b = rchar(vec2(rx, floor((ry) / 15.0)), vec2(mx, my) / 12.0, globalTime);
			float col = max(mod(-y, 24.0) - 4.0, 0.0) / 20.0;
			vec3 c = col < 0.8 ? vec3(0.0, col / 0.8, 0.0) : mix(vec3(0.0, 1.0, 0.0), vec3(1.0), (col - 0.8) / 0.2);
			
			result += vec4(c * b, 1.0)  ;
		}
	}


	
	result = result * length(IMG_NORM_PIXEL(syn_UserImage,uv).rgb) + 0.22 * vec4(0.,IMG_NORM_PIXEL(syn_UserImage,uv).g,0.,1.);
	if(result.b < 0.5)
	result.b = result.g * 0.5 ;
	out_FragColor = result;

return out_FragColor; 
 } 

