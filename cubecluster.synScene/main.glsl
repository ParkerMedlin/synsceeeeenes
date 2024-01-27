

///////////////////////////////////////////
// CubeCluster (wip)  by mojovideotech
//
// Creative Commons Attribution-NonCommercial-ShareAlike 3.0
//
// based on :
// glslsandbox.com/e#31945.2
///////////////////////////////////////////

#ifdef GL_ES
precision mediump float;
#endif

#define	phi	1.618033988749895


bool intersects(vec3 ro, vec3 rd, vec3 box_center, float box_size, out float t_intersection)
{
    vec3 t1 = (box_center - vec3(box_size) - ro)/rd;
    vec3 t2 = (box_center + vec3(box_size) - ro)/rd;
    vec3 t_min = min(t1, t2);
    vec3 t_max = max(t1, t2);
    float t_near = max(t_min.x, max(t_min.y, t_min.z));
    float t_far = min(t_max.x, min(t_max.y, t_max.z));
    if (t_near > t_far || t_far < 1.0) return false;
    t_intersection = t_near;
    return true;
}

mat3 camera(vec3 e, vec3 la) {
    vec3 roll = vec3(0, 1, 0);
    vec3 f = normalize(la - e);
    vec3 r = normalize(cross(roll, f));
    vec3 u = normalize(mix(cross(e, f),cross(f, r),0.75));
    return mat3(r, u, f);
}

vec4 renderMain() {
 	vec4 out_FragColor = vec4(0.0);

	const float INFINITY = 1e3,cluster_size = 5.0, EPSILON = .05;
    float a = rate+syn_BassTime/4, t_intersection = INFINITY, inside = 0.0;
    vec2 uv = (2.5*_xy.xy - RENDERSIZE)/min(RENDERSIZE.x, RENDERSIZE.y);
    vec3 ro = 8.0*vec3(cos(a), sin(0.5*syn_Time/4), -sin(a));
    vec3 rd = camera(ro, vec3(0))*normalize(vec3(uv, 2.));
    for (float i = 0.; i < cluster_size; i++) {
        for (float j = 0.; j < cluster_size; j++) {
            for (float k = 0.; k < cluster_size; k++) {
                vec3 p = 2.0*(vec3(i, j, k) - 0.5*vec3(cluster_size-3.0,cluster_size,cluster_size-2.0));
				float l = length(p), s = .1 + .6*pow(.5 + .5*sin(rate*rate*syn_Time/4*phi - j*l),k+0.5), t = 0.;
                if (intersects(ro, rd, p, s, t) && t < t_intersection) {
                    t_intersection = t;
                    vec3 n = ro + rd*t_intersection - p;
                    vec3 normal = smoothstep(vec3(s - EPSILON), vec3(s), n) * sin(clamp(syn_HighHits*5, .75, 7.)/10*PI) + smoothstep(vec3(s - EPSILON), vec3(s), -n);
                    inside = smoothstep(1.05, 1.0, normal.x + normal.y + normal.z)*clamp(syn_BPMSin2,0.75,1.);
                }
            }
        }
    }
    vec4 c;
    if (t_intersection == INFINITY)
        c = mix(vec4(.0, .0, .5, 1.), vec4(0.025, 0., 0., 0.5), 0.25*length(uv));
    else
        c = inside*vec4(1.0, sin(syn_Time/4), 0.0, 1.);

    out_FragColor = c;

return out_FragColor; 
 } 
