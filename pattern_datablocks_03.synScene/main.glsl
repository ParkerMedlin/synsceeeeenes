bool polar_on = (polar_on_bool > 0.5); 

#ifdef GL_ES
precision highp float;
#endif
#define TWO_PI 6.28318530718
#define seed2 seed+218.0
#define seed1 seed+3578.1
#define seed3 seed+45378.0
#define offset1 (offset<5.0)?offset*5.1:1.0
#define offset2 (offset>5.0)?(offset-5.0)*0.01:0.0
///////////////////////////////////////////
// based on :www.patriciogonzalezvivo.com/2015/thebookofshaders/10/ikeda-03.frag from :thebookofshaders.com  by Patricio Gonzalez Vivo
///////////////////////////////////////////
float ranf(in float x) { return fract(sin(x)*1e4);}
float rant(in vec2 st) { return fract(sin(dot(st.xy, vec2(seed1,seed2)))*seed3);}
float random(in float x){ return fract(sin(x)*seed); } // original value was 43758.5453
float random(in vec2 st){ return fract(sin(dot(st.xy,vec2(seed*0.5,seed*2.0))) * seed); }  // 12.9898,	78.233,  & 43758.5453
float pattern(vec2 st, vec2 v, float t) {    vec2 p = floor(st+v);    return step(t, rant(100.+p*.000001)+ranf(p.x)*0.5 );}
mat2 rotate2d(float _angle){
    return mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}
float randomChar(vec2 outer,vec2 inner){
    //float grid = grid.x;
    vec2 margin = grid2; //vec2(xScale,yScale);
    vec2 borders = step(margin,inner)*step(margin,1.-inner);
    vec2 ipos = floor(inner*grid.x);
    vec2 fpos = fract(inner*grid.y);
    return step(0.5,random(outer*64.+ipos)) * borders.x * borders.y * step(shift,fpos.x) * step(shift,fpos.y);
}
vec4 renderMain() { 
 	vec4 out_FragColor = vec4(0.0);

    vec2 st = _xy.xy/RENDERSIZE.xy;
    st.x *= RENDERSIZE.x/RENDERSIZE.y;
    //st -= vec2(0.5 * RENDERSIZE.x/RENDERSIZE.y, 0.5);
	st -= center;
 
    vec2 polar ;  
	//st -= 0.5;    
    polar.x = atan(st.x - 0.5, st.y - 0.5) * 5.;
    polar.y = length(st - 0.5);
    st = polar_on?mix(st,polar,curve):st;
    
    st *= grid;  

    vec2 ipos = floor(st);  
    vec2 fpos = fract(st); 
                
//    ipos -= vec2(0.,floor(TIME*rate*random(ipos.x+1.)));
    
    vec2 vel = vec2(TIME*rate*max(grid.x,grid.y)); 
    //st *= grid2;   
    vel *= vec2(-1.,0.0) * ranf(1.0+ipos.y); 
    vel*= grid2;
    vec2 off1 = vec2(offset1,0.);
    vec2 off2 = vec2(offset2,0.);
    
    vec3 color = vec3(0.0);
    color.r = pattern(st+off1,vel,0.5+density/RENDERSIZE.x);
    color.g = pattern(st,vel,0.5+density/RENDERSIZE.x);
    color.b = pattern(st-off2,vel,0.5+density/RENDERSIZE.x); 
    color *= step(shift,fpos.y);
    out_FragColor = vec4(color,1.0);

return out_FragColor; 
 } 
