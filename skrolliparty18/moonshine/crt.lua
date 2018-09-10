--[[
Public domain:

Copyright (C) 2017 by Matthias Richter <vrld@vrld.org>

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.
]]--

return function(moonshine)
  -- Barrel distortion adapted from Daniel Oaks (see commit cef01b67fd)
  -- Added feather to mask out outside of distorted texture
  local distortionFactor
  local shader = love.graphics.newShader[[
    extern number time;

    vec2 curve(vec2 uv)
    {
      uv = (uv - 0.5) * 2.0;
      uv *= 1.1;  
      uv.x *= 1.0 + pow((abs(uv.y) / 5.0), 2.0);
      uv.y *= 1.0 + pow((abs(uv.x) / 4.0), 2.0);
      uv  = (uv / 2.0) + 0.5;
      uv =  uv *0.92 + 0.04;
      return uv;
    }
    vec4 effect(vec4 color, Image tex, vec2 uv, vec2 px) {

        vec2 q = uv;
  
        uv.x-=0.05;
        uv.y-=0.05;


        number iTime = time;
        vec2 iResolution = px;


        uv = curve( uv );
        uv *=1.1;
        vec3 oricol = Texel(tex, vec2(q.x,q.y) ).xyz;
        vec3 col;
      number x =  sin(0.3*iTime+uv.y*21.0)*sin(0.7*iTime+uv.y*29.0)*sin(0.3+0.33*iTime+uv.y*31.0)*0.0017;

        col.r = Texel(tex,vec2(x+uv.x+0.001,uv.y+0.001)).x+0.05;
        col.g = Texel(tex,vec2(x+uv.x+0.000,uv.y-0.002)).y+0.05;
        col.b = Texel(tex,vec2(x+uv.x-0.002,uv.y+0.000)).z+0.05;
        col.r += 0.08*Texel(tex,0.75*vec2(x+0.025, -0.027)+vec2(uv.x+0.001,uv.y+0.001)).x;
        col.g += 0.05*Texel(tex,0.75*vec2(x+-0.022, -0.02)+vec2(uv.x+0.000,uv.y-0.002)).y;
        col.b += 0.08*Texel(tex,0.75*vec2(x+-0.02, -0.018)+vec2(uv.x-0.002,uv.y+0.000)).z;

        col = clamp(col*0.6+0.4*col*col*1.0,0.0,1.0);

        number vig = (0.0 + 1.0*16.0*uv.x*uv.y*(1.0-uv.x)*(1.0-uv.y));
      col *= vec3(pow(vig,0.3));

        col *= vec3(0.95,1.05,0.95);
      col *= 2.8;

      number scans = clamp( 0.35+0.35*sin(3.5*iTime+uv.y*1000.5), 0.0, 1.0);
      
      number s = pow(scans,1.7);
      col = col*vec3( 0.4+0.7*s) ;

        col *= 1.0+0.01*sin(110.0*iTime);
      if (uv.x < 0.0 || uv.x > 1.0)
        col *= 0.0;
      if (uv.y < 0.0 || uv.y > 1.0)
        col *= 0.0;
      
      col*=1.0-0.65*vec3(clamp((mod(uv.x, 2.0)-1.0)*2.0,0.0,1.0));
      
        number comp = smoothstep( 0.1, 0.9, sin(iTime) );
     
      // Remove the next line to stop cross-fade between original and postprocess
    //  col = mix( col, oricol, comp );

        return vec4(col,1.0);
    }
  ]]










  local setters = {}


  setters.time = function(v) shader:send("time", v) end

  local defaults = {
    time = 0.
  }

  return moonshine.Effect{
    name = "crt",
    shader = shader,
    setters = setters,
    defaults = defaults
  }
end
