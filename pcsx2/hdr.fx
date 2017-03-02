/*
  HDR Shader
  
  Your display needs to be in HDR mode for this to look good at all 
*/

#ifdef SHADER_MODEL // make safe to include in resource file to enforce dependency

Texture2D Texture;
SamplerState TextureSampler;

struct PS_INPUT
{
	float4 p : SV_Position;
	float2 t : TEXCOORD0;
};

struct PS_OUTPUT
{
	float4 c : SV_Target0;
};

float gamma = 2.2;

float3 Uncharted2ToneMapping(float3 color)
{
  float A = 0.15;
  float B = 0.50;
  float C = 0.10;
  float D = 0.20;
  float E = 0.02;
  float F = 0.30;
  float W = 11.2;
  float exposure = 2.;
  color *= exposure;
  color = ((color * (A * color + C * B) + D * E) / (color * (A * color + B) + D * F)) - E / F;
  float white = ((W * (A * W + C * B) + D * E) / (W * (A * W + B) + D * F)) - E / F;
  color /= white;
  //color = pow(color, float3(1. / gamma, 1. / gamma, 1. / gamma));
  color.r = pow(color.r, 1.0 / 2.2);
  color.g = pow(color.g, 1.0 / 2.2);
  color.b = pow(color.b, 1.0 / 2.2);

  return color;
}

PS_OUTPUT ps_main(PS_INPUT input)
{
	PS_OUTPUT output;
	
	float3 c0 = Texture.Sample(TextureSampler, input.t).xyz;
  c0 = Uncharted2ToneMapping(c0);

  output.c.a = 1.0;
  output.c.xyz = c0.xyz;
		
	return output; 
}

#endif

