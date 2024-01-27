

/* 
   References
   https://www.shadertoy.com/view/MsXSRn runes
   https://www.shadertoy.com/view/4djSRW hash22
   https://www.shadertoy.com/view/MlKcDD Quadratic Bezier
*/

vec2 hash22(vec2 p)
{
	vec3 p3 = fract(vec3(p.xyx) * vec3(.1031, .1030, .0973));
    p3 += dot(p3, p3.yzx+33.33);
    return fract((p3.xx+p3.yz)*p3.zy);
}

float dot2( in vec2 v ) { return dot(v,v); }

float cro( in vec2 a, in vec2 b ) { return a.x*b.y - a.y*b.x; }

float sdBezier( in vec2 pos, in vec2 A, in vec2 B, in vec2 C )
{    
    vec2 a = B - A;
    vec2 b = A - 2.0*B + C;
    vec2 c = a * 2.0;
    vec2 d = A - pos;
    float kk = 1.0/dot(b,b);
    float kx = kk * dot(a,b);
    float ky = kk * (2.0*dot(a,a)+dot(d,b)) / 3.0;
    float kz = kk * dot(d,a);      
    float res = 0.0;
    float p = ky - kx*kx;
    float p3 = p*p*p;
    float q = kx*(2.0*kx*kx-3.0*ky) + kz;
    float h = q*q + 4.0*p3;
    if( h >= 0.0) 
    { 
        h = sqrt(h);
        vec2 x = (vec2(h,-h)-q)/2.0;
        vec2 uv = sign(x)*pow(abs(x), vec2(1.0/3.0));
        float t = clamp( uv.x+uv.y-kx, 0.0, 1.0 );
        res = dot2(d + (c + b*t)*t);
    }
    else
    {
        float z = sqrt(-p);
        float v = acos( q/(p*z*2.0) ) / 3.0;
        float m = cos(v);
        float n = sin(v)*1.732050808;
        vec3  t = clamp(vec3(m+m,-n-m,n-m)*z-kx,0.0,1.0);
        res = min( dot2(d+(c+b*t.x)*t.x),
                   dot2(d+(c+b*t.y)*t.y) );
    }
    return sqrt( res );
}


float ThickLine(vec2 uv, vec2 posA, vec2 posB, vec2 posC)
{
	return smoothstep(.04,.01,sdBezier(uv, posA, posB, posC));
}

float Rune(vec2 uv, int strokes, float scale, vec2 snaps) {
	float finalLine = 0.0;
	vec2 seed = floor(uv)-hash22(vec2(1));
	uv = fract(uv);
	for (int i = 0; i < strokes; i++)	
	{
		vec2 posA = hash22(floor(seed+1.5));
		vec2 posB = hash22(floor(seed+2.0));
		vec2 posC = hash22(floor(seed+3.5));
		seed += 3.0;
		posA = fract(posA * 128.0);
		posB = fract(posB * 128.0);
        posC = fract(posC * 128.0);
		if (i == 0) posA.y = 0.0;
		if (i == 1) posA.x = 0.999;
		if (i == 2) posA.x = 0.0;
		if (i == 3) posA.y = 0.999;
		posA = (floor(posA * snaps) + 0.5) / snaps;
		//posB = (floor(posB * snaps) + 0.5) / snaps;
        posC = (floor(posC * snaps) + 0.5) / snaps;
		finalLine = max(finalLine, ThickLine(uv, posA, posB, posC));
	}
	return finalLine;
}

vec4 renderMainImage() {
	vec4 O = vec4(0.0);
	vec2 I = _xy;

    vec2 p = (7.*I - RENDERSIZE.xy ) / RENDERSIZE.y ;
    
    p.x += TIME;

    O = vec4(Rune(p,4,syn_BassLevel*2.0,vec2(2.0,3.0)));
	return O; 
 } 


vec4 renderMain(){
	if(PASSINDEX == 0){
		return renderMainImage();
	}
}