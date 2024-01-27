

// ContinuaVariation by mojovideotech
// glslsandbox.com/e#32770.3

// ======================================
// Corrente Continua - 1k intro (win32)
// Zerothehero of Topopiccione
// 25/jul/2012
//@zerothehero: better formulas, visually improved
// mod by mojovideotech
// ======================================

#ifdef GL_ES
precision mediump float;
#endif

const float di = 0.5772156649;
const float dh = 0.69314718;
const float twpi = 6.2831853;
	
mat2 rotate2d(float _angle){
    return mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}

vec4 renderMain() { 
 	vec4 out_FragColor = vec4(0.0);

	float t = syn_Time;
	float tt = syn_Time/4*0.005;
	vec2 p = ((_xy.xy / RENDERSIZE.xy )-0.5)*27.;
	p.x *= RENDERSIZE.x/RENDERSIZE.y;
	float a=0.,b=0.,c=0.,d=0.,e=0.;
	for (int i=-4; i<4; i++) {
		p = rotate2d(tt*-twpi)*p;
		float x = (p.x*di-p.y*dh*0.125);
		float y = (p.x*di*0.125+p.y*dh);
		c = (sin(x+t*(float(i))/18.0)+b+y+4.0)*(sin(syn_BassHits * PI)+1.5);
		d = (cos(y+t*(float(i))/20.0)+x+a+3.0)*(sin(syn_HighLevel * PI)+1.5);
		e = (sin(y+t*(float(i))/17.5)+x-e+1.0);
		a -= .25/(c*c); //color of the blue string
		b += .5/(d*d); //color of the pink string
		e += .125;
	}
	out_FragColor = vec4(log(-e+a+b-1.)/8.-0.2,log(-e-a-b-1.)/8.-0.2,log(e-a+b-1.)/5.-0.1, 1.0) ;


return out_FragColor; 
 } 
