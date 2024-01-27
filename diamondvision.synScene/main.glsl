


////////////////////////////////////////////////////////////////////
// DiamondVision  by mojovideotech
//
// based on :
// glslsandbox.com\/e#46411.0
//
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0
////////////////////////////////////////////////////////////////////

#ifdef GL_ES
precision highp float;
#endif

#define    	c30    	0.866025     	// cos 30
#define    	twPI   	6.2831853       // two PI, 2*PI
#define		PIphi	2.3999632		// PI*phi
#define 	sqPI 	1.7724538		// square root of PI
#define 	phi   	1.6180339*GRAT	// golden ratio
#define 	cucuphi	1.0549232		// cube root of cube root of phi
#define		ePI		0.8652559		// e/PI
#define 	time2	TIME/20. + syn_BassTime/4*Speed+55.0
#define     R       1.0

vec2 rotate(in vec2 r, in float o) { return vec2(cos(o)*r.x*Rot + sin(o)*r.y, -sin(o)*r.x + cos(o)*r.y*Rat)*Bat; }

float torus(in vec3 pos, in vec2 tor) { 
	vec2 qt = abs(vec2(max(abs(pos.x), abs(pos.z))-tor.x, pos.y));
	return max(qt.x, qt.y)-tor.y;
}

float trap(in vec3 tp) {
	return abs(min(torus(tp, vec2(ePI, 0.125)), max(abs(tp.z)-0.125, abs(tp.x)-0.125)))-0.005;
}

float map(in vec3 pm) {
	float c = dot(abs((pm.yz)),vec2(0.5))-0.05;
	vec3 m = abs(1.0-mod(pm,2.0));
	m.yz = rotate(m.yz, sqrt(time2));
	float e = 9999.999, f = 1.0 * W;
	for (float i = 0.0; i < 4.0; i++) {
		m.xz = rotate(m.xz, radians(i*0.333+time2));
		m.zy = rotate(m.yz, radians((i+i)*0.667+time2*phi));
		m = abs(1.0-mod(m+i/3.0,2.0));
		m *=abs(sqrt(m)*sqPI);
		f *= 0.5;
		e = min(e, trap(m) * f);
	}
	return max(e, -c);
}

vec3 hsv(in float h, in float s, in float v) {
	return mix(vec3(1.0), clamp((abs(fract(h + vec3(3.0, 2.0, 1.0) / 3.0) * 6.0 - 3.0) - 1.0), 0.0 , 1.0), s) * v;
}

vec3 intersect(in vec3 rayOrigin, in vec3 rayDir) {
	float d = 1.0, it = 0.0;
	vec3 p = rayOrigin, col = vec3(0.0);
	float md = phi+sin(time2*0.5)*0.25;
	for (int i = 0; i < 50; i++) {		
		if (d < 0.000999) continue;
		d = map(p);
		p += d*rayDir; 
		md = min(md, d);
		it++;
	}
	if (d < 0.001) {
		float x = (it/49.0);
		float y = (d-0.01)/0.01/(49.0);
		float z = (0.01-d)/0.01/49.0;
		float q = 1.0-x-y*2.+z;
		col = hsv(q*0.2+0.5*R, 1.0-q*ePI, q+Ty);
	} 
		col += hsv(d, 1.0, 1.0)*md*28.0;
	return col;
}

vec4 renderMain() { 
 	vec4 out_FragColor = vec4(0.0);

	vec2 ps = -1.0 + 2.0 * _xy.xy / RENDERSIZE.xy;
	ps.x *= RENDERSIZE.x / RENDERSIZE.y;
	vec3 up = vec3(0, -1, 0);
	vec3 cd = vec3(1, 0, 0);
	vec3 co = vec3(time2*0.1, 0, 0);
	vec3 uw = normalize(cross(up, co));
	vec3 vw = normalize(cross(cd, uw));
	vec3 rd = normalize(uw * ps.x + vw * ps.y + cd*(1.0-length(ps)*phi));
	out_FragColor = vec4(vec3(intersect(co, rd)),1.0);

return out_FragColor; 
 } 
 