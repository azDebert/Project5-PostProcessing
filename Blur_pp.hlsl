//--------------------------------------------------------------------------------------
// Blur Post-Processing Pixel Shader
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

// Post-processing shader that blurs the scene texture 
float4 main(PostProcessingInput input) : SV_Target
{
	float4 colour;
    float j; // Used for the blur
	const float blurQuality = 64; // The higher the number, the better the quality of the blur 

	// Blur the scene texture by sampling the scene texture multiple times and averaging the colour values
	for (float i = 0.0f; i < 1.0f; i += (1 / blurQuality))
	{
		j = 0.9 + i * 0.1f;
		colour += SceneTexture.Sample(PointSample, input.sceneUV * j + 0.5f - 0.5f * j);
	}

	// Divide the colour by the blurQuality to get the average colour
	colour /= blurQuality;
	
	//colour.a = 0.1f
	return colour;
}