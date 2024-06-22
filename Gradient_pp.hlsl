//--------------------------------------------------------------------------------------
// Colour Gradient Post-Processing Pixel Shader
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

// Post-processing shader that applies a blue to yellow vertical colour gradient to the scene texture
float4 main(PostProcessingInput input) : SV_Target
{
	float4 colour = SceneTexture.Sample(PointSample, input.sceneUV); // Sample the scene texture
	float4 gradient = lerp(float4(0, 0, 1, 1), float4(1, 1, 0, 1), input.sceneUV.y); // Lerp to mix two colours together

	// Final output colour is the scene texture colour multiplied by the gradient colour
	return colour * gradient;
}