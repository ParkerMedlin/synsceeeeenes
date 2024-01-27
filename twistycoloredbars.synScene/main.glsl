bool sparse = (sparse_bool > 0.5); 
bool rot = (rot_bool > 0.5); 


////////////////////////////////////////////////////////////
// TwistyColoredBars  by mojovideotech
//
// based on :
// Twisting Bars  by @hintz
// glslsandbox.com/\e#42684.4
//
// Creative Commons Attribution-NonCommercial-ShareAlike 3.0
////////////////////////////////////////////////////////////


vec4 renderMain() { 
 	vec4 out_FragColor = vec4(0.0);

	vec2 o = ((_xy.xy - RENDERSIZE.xy/2.0)*scale)/RENDERSIZE.y;
	if (rot) o.xy = o.yx; 
	float T = TIME * rate, p = 0.5+floor(5.0*o.x), q;
	if (sparse) q = 0.4; 
		else q = 0.2; 
	o.x = mod(o.x, q) - 0.1;
	o.y+=p;
	vec4 s = 0.1*cos(1.6*vec4(0,1,2,3)+p*phase*T+sin(o.y*loops+p*loops+cos(T))),
	e = s.yzwx, 
	f = min(o.x-s,e-o.x);
	out_FragColor = dot(clamp(-1.0+f*RENDERSIZE.y,0.0,1.0),28.0*(s-e))*(s-0.22)+f*0.5;

return out_FragColor; 
 } 
