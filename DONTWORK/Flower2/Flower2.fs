/*{
    "CATEGORIES": [
        "Automatically Converted",
        "Shadertoy"
    ],
    "DESCRIPTION": "Automatically converted from https://www.shadertoy.com/view/MltSRf by TLC123.  ray marching flower\nRay marcher by Inigo Quilez\nI only made flower function\nadded comments",
    "IMPORTED": [
    ],
    "INPUTS": [
        {
            "NAME": "iMouse",
            "TYPE": "point2D"
        },
        {
            "NAME": "draaiomas",
            "TYPE": "float"
        },
        {
            "DEFAULT": 0,
            "MAX": 20,
            "MIN": 0,
            "NAME": "trigger",
            "TYPE": "float"
        },
        {
            "DEFAULT": 0,
            "MAX": 10,
            "MIN": 0,
            "NAME": "draaixas",
            "TYPE": "float"
        }
    ],
    "ISFVSN": "2"
}
*/


// Created by inigo quilez - iq/2013
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

// A list of usefull distance function to simple primitives, and an example on how to 
// do some interesting boolean operations, repetition and displacement.
//
// More info here: http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm

float sdPlane(vec3 p) {
	return p.y;
}

float sdSphere(vec3 p, float s) {
	return length(p) - s;
}

float sdBox(vec3 p, vec3 b) {
	vec3 d = abs(p) - b;
	return min(max(d.x, max(d.y, d.z)), 0.0) + length(max(d, 0.0));
}

float sdEllipsoid( in vec3 p, in vec3 r) {
	return (length(p / r) - 1.0) * min(min(r.x, r.y), r.z);
}

float udRoundBox(vec3 p, vec3 b, float r) {
	return length(max(abs(p) - b, 0.0)) - r;
}

float sdTorus(vec3 p, vec2 t) {
	return length(vec2(length(p.xz) - t.x, p.y)) - t.y;
}

 

float sdCylinder(vec3 p, vec2 h) {
	vec2 d = abs(vec2(length(p.xz), p.y)) - h;
	return min(max(d.x, d.y), 0.0) + length(max(d, 0.0));
}

float sdCone( in vec3 p, in vec3 c) {
	vec2 q = vec2(length(p.xz), p.y);
	float d1 = -q.y - c.z;
	float d2 = max(dot(q, c.xy), q.y);
	return length(max(vec2(d1, d2), 0.0)) + min(max(d1, d2), 0.);
}

float sdConeSection( in vec3 p, in float h, in float r1, in float r2) {
	float d1 = -p.y - h;
	float q = p.y - h;
	float si = 0.5 * (r1 - r2) / h;
	float d2 = max(sqrt(dot(p.xz, p.xz) * (1.0 - si * si)) + q * si - r2, q);
	return length(max(vec2(d1, d2), 0.0)) + min(max(d1, d2), 0.);
}

float length2(vec2 p) {
	return sqrt(p.x * p.x + p.y * p.y);
}

float length6(vec2 p) {
	p = p * p * p;
	p = p * p;
	return pow(p.x + p.y, 1.0 / 6.0);
}

float length8(vec2 p) {
	p = p * p;
	p = p * p;
	p = p * p;
	return pow(p.x + p.y, 1.0 / 8.0);
}

float sdTorus82(vec3 p, vec2 t) {
	vec2 q = vec2(length2(p.xz) - t.x, p.y);
	return length8(q) - t.y;
}

float sdTorus88(vec3 p, vec2 t) {
	vec2 q = vec2(length8(p.xz) - t.x, p.y);
	return length8(q) - t.y;
}

float sdCylinder6(vec3 p, vec2 h) {
	return max(length6(p.xz) - h.x, abs(p.y) - h.y);
}

float flower(vec3 p, float r) {
	float q = length(p);
	p -= vec3(sin(p.x * 15.1), sin(p.y * 25.1), sin(p.z * 15.0)) * 0.01; //some space warping
	vec3 n = normalize(p);
	q = length(p); // distance before flowerwarp

	float rho = atan(length(vec2(n.x, n.z)), n.y) * 20.0+trigger + q * 15.01; //vertical part of  cartesian to polar with some q warp
	float theta = atan(n.x, n.z) * 6.0 + p.y * 3.0 + rho * 1.50; //horizontal part plus some warp by z(bend up) and by rho(twist)
	return length(p) - (r + sin(theta) * 0.3 * (1.3 - abs(dot(n, vec3(0, 1, 0)))) //the 1-abs(dot()) is limiting the warp effect at poles
		+ sin(rho -(draaiomas* TIME) * 2.0) * 0.3 * (1.3 - abs(dot(n, vec3(0, 1, 0))))); // 1.3-abs(dot()means putting some back in 
}

float TTorus(vec3 p, vec2 t) {
	vec2 q = vec2(length(p.xz) - t.x, p.y);
	return length(q) - t.y;
}

float ChamferBox(vec3 p, vec3 b, float ch) {
	p = max(abs(p) - b, 0.0); // + vec3(ch, ch, ch);
	if ((p.x - ch) > (p.y + p.z)) {
		return length(p - vec3(ch, 0, 0));
	}
	else if ((p.y - ch) > (p.x + p.z)) {
		return length(p - vec3(0, ch, 0));
	}
	else if ((p.z - ch) > (p.y + p.x)) {
		return length(p - vec3(0, 0, ch));
	}
	else {
		return
		max(dot(vec3(0.57735, 0.57735, 0.57735), p) / 0.7967329 - ch * 0.7967329,
			max(dot(vec3(0.0, 0.707107, 0.707107), p) - ch * 0.7967329,
				max(dot(vec3(0.707107, 0.0, 0.707107), p) - ch * 0.7967329,
					dot(vec3(0.707107, 0.707107, 0.0), p) - ch * 0.7967329))) + 0.005;
	}
}
//----------------------------------------------------------------------

float opS(float d1, float d2) {
	return max(-d2, d1);
}

vec2 opU(vec2 d1, vec2 d2) {
	return (d1.x < d2.x) ? d1 : d2;
}

vec3 opRep(vec3 p, vec3 c) {
	return mod(p, c) - 0.5 * c;
}

vec3 opTwist(vec3 p) {
	float c = cos(10.0 * p.y + 10.0);
	float s = sin(10.0 * p.y + 10.0);
	mat2 m = mat2(c, -s, s, c);
	return vec3(m * p.xz, p.y);
}

//----------------------------------------------------------------------

vec2 map( in vec3 pos) {

	return vec2(flower(pos, 0.750), 15.1);

}

vec2 castRay( in vec3 ro, in vec3 rd) {
	float tmin = 1.0;
	float tmax = 20.0;

	#if 0
    {
        float tp1 = (0.0 - ro.y) / rd.y;
	if (tp1 > 0.0) tmax = min(tmax, tp1);
	float tp2 = (1.6 - ro.y) / rd.y;
	if (tp2 > 0.0) {
		if (ro.y > 1.6) tmin = max(tmin, tp2);
		else tmax = min(tmax, tp2);
	}
    #	endif

	float precis = 0.1;
	float t = tmin;
	float m = -1.0;
	for (int i = 0; i < 400; i++) {
		vec2 res = map(ro + rd * t);
		if (res.x < precis || t > tmax) break;
		t += res.x * 0.05;
		m = res.y;
	}

	if (t > tmax) m = -1.0;
	return vec2(t, m);
}

float softshadow( in vec3 ro, in vec3 rd, in float mint, in float tmax) {
	float res = 1.0;
	float t = mint;
	for (int i = 0; i < 16; i++) {
		float h = map(ro + rd * t).x;
		res = min(res, 8.0 * h / t);
		t += clamp(h, 0.02, 0.10);
		if (h < 0.001 || t > tmax) break;
	}
	return clamp(res, 0.0, 1.0);

}

vec3 calcNormal( in vec3 pos) {
	vec3 eps = vec3(0.001, 0.0, 0.0);
	vec3 nor = vec3(
		map(pos + eps.xyy).x - map(pos - eps.xyy).x,
		map(pos + eps.yxy).x - map(pos - eps.yxy).x,
		map(pos + eps.yyx).x - map(pos - eps.yyx).x);
	return normalize(nor);
}

float calcAO( in vec3 pos, in vec3 nor) {
	float occ = 0.0;
	float sca = 1.0;
	for (int i = 0; i < 15; i++) {
		float hr = 0.05 + 0.12 * float(i) / 4.0;
		vec3 aopos = nor * hr + pos;
		float dd = map(aopos).x;
		occ += -(dd - hr) * sca;
		sca *= 0.95;
	}
	return clamp(1.0 - 3.0 * occ, 0.0, 1.0);
}

float hit = 1.0;

vec3 render( in vec3 ro, in vec3 rd) {
	vec3 col = vec3(0.7, 0.9, 1.0) + rd.y * 0.8;
	vec2 res = castRay(ro, rd);
	float t = res.x;
	float m = res.y;
	if (m > -0.5) {
		vec3 pos = ro + t * rd;
		vec3 nor = calcNormal(pos);
		vec3 ref = reflect(rd, nor);

		// material        
		col = 0.50 + 0.3 * sin(vec3(2.3 - pos.y / 2.0, 2.15 - pos.y / 4.0, -1.30) * (m - 1.0));

		if (m < 1.5) {

			float f = mod(floor(5.0 * pos.z) + floor(5.0 * pos.x), 2.0);
			col = 0.4 + 0.1 * f * vec3(1.0);
		}

		// lighitng        
		float occ = calcAO(pos, nor);
		vec3 lig = normalize(vec3(-0.6, 0.7, -0.5));
		float amb = 0.0; // clamp( 0.5+0.5*nor.y, 0.0, 1.0 );
		float dif = clamp(dot(nor, lig), 0.0, 1.0);
		float bac = 0.0; // clamp( dot( nor, normalize(vec3(-lig.x,0.0,-lig.z))), 0.0, 1.0 )*clamp( 1.0-pos.y,0.0,1.0);
		float dom = smoothstep(-0.1, 0.1, ref.y);
		float fre = 0.750; //pow( clamp(1.0+dot(nor,rd),0.0,1.0), 2.0 );
		float spe = 0.0; //pow(clamp( dot( ref, lig ), 0.0, 1.0 ),16.0);

		//dif *= softshadow( pos, lig, 0.02, 2.5 );
		//dom *= softshadow( pos, ref, 0.02, 2.5 );

		vec3 lin = vec3(0.0);
		lin += 1.20 * dif * vec3(1.00, 0.85, 0.55);
		lin += 1.20 * spe * vec3(1.00, 0.85, 0.55) * dif;
		lin += 0.20 * amb * vec3(0.50, 0.70, 1.00) * occ;
		lin += 0.30 * dom * vec3(0.50, 0.70, 1.00) * occ;
		lin += 0.30 * bac * vec3(0.25, 0.25, 0.25) * occ;
		lin += 0.40 * fre * vec3(1.00, 1.00, 1.00) * occ;
		col = col * lin;

		col = mix(col, vec3(0.8, 0.9, 1.0), 1.0 - exp(-0.002 * t * t));

	}
	
	else hit = 0.0;

	return vec3(clamp(col, 0.0, 1.0));
}

mat3 setCamera( in vec3 ro, in vec3 ta, float cr) {
	vec3 cw = normalize(ta - ro);
	vec3 cp = vec3(sin(cr), cos(cr), 0.0);
	vec3 cu = normalize(cross(cw, cp));
	vec3 cv = normalize(cross(cu, cw));
	return mat3(cu, cv, cw);
}

void main() {

	vec2 q = gl_FragCoord.xy / RENDERSIZE.xy;
	vec2 p = -1.0 + 2.0 * q;
	p.x *= RENDERSIZE.x / RENDERSIZE.y;
	vec2 mo = iMouse.xy / RENDERSIZE.xy;
	float time = 15.0 + TIME * 3.0;
	// camera	
	vec3 ro = vec3(0.0, 3.0+draaixas, 4.0+(trigger/15.));
	//vec3( -0.5+3.5*cos(0.1*time + 6.0*mo.x),1.0+3.5*sin(6.0* mo.y), 0.0 + 3.5*sin(0.1*time + 6.0*mo.x)-3.5*cos(  6.0*-mo.y) );
	vec3 ta = vec3(-0.1, 0, 0.30);
	// camera-to-world transformation
	mat3 ca = setCamera(ro, ta, 0.0);
	// ray direction
	vec3 rd = ca * normalize(vec3(p.xy, 3.0));
	// render	
	vec3 col = render(ro, rd);
	col = pow(col, vec3(0.4545));
	gl_FragColor = vec4(col, hit);
}
