//--------------------------------------------------------------------------------------
// Retro Effect Post-Processing Pixel Shader
//--------------------------------------------------------------------------------------

#include "Common.hlsli"

//--------------------------------------------------------------------------------------
// Textures (texture maps)
//--------------------------------------------------------------------------------------

// The scene has been rendered to a texture, these variables allow access to that texture
Texture2D    SceneTexture : register(t0);
SamplerState PointSample  : register(s0); // We don't usually want to filter (bilinear, trilinear etc.) the scene texture when
// post-processing so this sampler will use "point sampling" - no filtering


//--------------------------------------------------------------------------------------
// Shader code
//--------------------------------------------------------------------------------------

// Post-processing shader that outputs a retro effect by increasing pixel size and reducing colour depth
float4 main(PostProcessingInput input) : SV_Target
{
	float2 pixelSize = float2(120.0f, 90.0f); // 4:3 resolution
	float3 colourDepth = float3(16.0f, 16.0f, 16.0f); // RGB colour depth (higher = more colours) 

	float2 uv = floor(input.sceneUV * pixelSize) / pixelSize; 
	float3 colour = SceneTexture.Sample(PointSample, uv).rgb; // Sample the scene texture at the current pixel
	colour = floor(colour * colourDepth) / colourDepth; // Reduce the colour depth

	// Final output
	return float4(colour, 1.0f);
}