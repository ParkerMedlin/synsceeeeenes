// First
void firstPass( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 position = _uv;
	vec4 mediaColor = _textureMedia(position);
	float grey = dot(mediaColor.rgb, vec3(0.299, 0.587, 0.114));
	
	fragColor = vec4(mediaColor);
}



vec4 renderMain () {
  vec4 fragColor = vec4(0.0);
  float blurTime = (1.0+0.5*sin(syn_Time*0.1)+0.5*sin(syn_Time*0.0177))*0.5;
  if (PASSINDEX == 0.0){
    firstPass(fragColor, gl_FragCoord.xy);
    return fragColor;
  }
//   else if (PASSINDEX == 1.0){
//     secondPass(fragColor, gl_FragCoord.xy);
//     return fragColor;
//   }
//    else if (PASSINDEX == 2.0){
//     mainImage(fragColor, gl_FragCoord.xy);
//     return fragColor;
//   }   
//   else if (PASSINDEX == 3.0){
//     return vertBlurPass();
//   }
//   else if (PASSINDEX == 4.0){
//     return horBlurPass()-tiltShiftZone*0.05;
//   }

  return vec4(1.0, 0.0, 0.0, 1.0);
}

