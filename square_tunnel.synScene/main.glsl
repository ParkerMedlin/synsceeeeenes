

vec4 renderMain() { 
 	vec4 out_FragColor = vec4(0.0);

	
	vec2 R = RENDERSIZE.xy;
	vec2 U = _xy.xy;
    U = (U+U-R)/R.x;
    float t = rot_speed*(TIME-(rot_offset * 100.)), r = 1.0, c,s;
    
    vec4 O;
    //O -= O;
    for( int i=0; i< 49; i++){
	    U *= mat2(c=cos(t),s=sin(t),-s,c),
        r /= abs(c) + abs(s),
        O = smoothstep(3./R.y, 0., max(abs(U.x),abs(U.y)) - r) - O;
    }
    
	out_FragColor = O;

return out_FragColor; 
 } 
