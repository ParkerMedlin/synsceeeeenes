


//Archimedes spiral, antialiased

#ifdef GL_ES
precision mediump float;
#endif



const float EPSILON = 0.1;

vec2 perspective(vec2 scaled) {
	float z = 1.2-scaled.y+cos((scaled.x)*scaled.y*6.)*.1;
	return vec2((scaled.x-.5)/z,sin((scaled.x-.5)*10./z)*.2+1./z)*.5;
}

float getval(vec2 car) {
	float r = sqrt(car.x * car.x + car.y * car.y);
	float theta = atan(car.y, car.x);
	
	return fract(TIME) * 2. + theta / (2. * PI) - r * 16.;
}

vec4 renderMain() { 
 	vec4 out_FragColor = vec4(0.0);

	vec2 mousepersp = perspective(mouse);
	vec2 vec = perspective(_xy.xy / RENDERSIZE.xy) - mousepersp;
	float val = getval(vec);
	float valx = getval(perspective((_xy.xy + vec2(.01,0)) / RENDERSIZE.xy) - mousepersp)-val;
	float valy = getval(perspective((_xy.xy + vec2(0,.01)) / RENDERSIZE.xy) - mousepersp)-val;
	float aa = sqrt(valx*valx+valy*valy)*250.;
	aa = aa > 100. ? 0. : tan(min(aa,PI*.4999))*.3;
	
	vec3 color = vec3(sqrt((1.-smoothstep(EPSILON-aa, EPSILON+aa, abs(fract(val)-.5)))/(1.+dot(vec,vec)*20.)));
	
	out_FragColor = vec4(color, 1.0);

return out_FragColor; 
 } 
