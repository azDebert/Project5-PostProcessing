//--------------------------------------------------------------------------------------
// Underwater Effect Post-Processing Pixel Shader
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

// Post-processing shader that applies an underwater tint and effect to the scene texture
float4 main(PostProcessingInput input) : SV_Target
{
	const float effectStrength = 0.01f; // Strength of the effect
	const float3 tintColour = { 0.1, 0.6, 0.9 }; // Blue colour to tint the scene texture with

	// Calculates alpha to display the effect in a softened circle. This could be done using a texture instead of calculations
	// Uses the second set of area texture coordinates, which range from (0,0) to (1,1) over the area being processed
	const float softEdge = 0.25f; // Softness of the edge of the circle
	float2 centreVector = input.areaUV - float2(0.5f, 0.5f);  
	float centreLengthSquared = dot(centreVector, centreVector); 

	// It is a combination of sine waves in x and y dimensions, therefore it can be reused for an underwater effect
	float SinX = sin(input.areaUV.x * radians(1440.0f) + gHeatHazeTimer * 3.0f);
	float SinY = sin(input.areaUV.y * radians(3600.0f) + gHeatHazeTimer * 3.7f); 

	// Offset for scene texture UV based on haze effect
	// Adjust size of UV offset based on the constant EffectStrength, the overall size of area being processed, and the alpha value calculated above
	float2 underwaterOffset = float2(SinY, SinX) * effectStrength * 1.0f * gArea2DSize;

	// Get pixel from scene texture, offset using haze
	float3 colour = SceneTexture.Sample(PointSample, input.sceneUV + underwaterOffset).rgb * tintColour;

	return float4(colour, 1.0f);
}