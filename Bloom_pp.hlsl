//--------------------------------------------------------------------------------------
// Bloom Post-Processing Pixel Shader
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

// Post-processing shader that applies a bloom effect where the light bleeds out and creates a blurry glow effect around the light-intesive areas
float4 main(PostProcessingInput input) : SV_Target
{
    float4 finalColor = SceneTexture.Sample(PointSample, input.sceneUV.xy); // Sample the scene texture at the current pixel
    float3 BasicColor = (0.1, 0.1, 0.1); 

    // Depending on how many times the scene texture is sampled, the bloom effect will be more or less intense
    finalColor += SceneTexture.Sample(PointSample, input.sceneUV.xy);
    finalColor += SceneTexture.Sample(PointSample, input.sceneUV.xy);
    finalColor += SceneTexture.Sample(PointSample, input.sceneUV.xy);

    float Brightness = finalColor.r + finalColor.g + finalColor.b;
    finalColor.rgb += BasicColor;

    float3 color = SceneTexture.Sample(PointSample, input.sceneUV.xy) * finalColor; // Sample the scene texture then multiply it by the final color to get the bloom effect

    finalColor.rgb = color * 1.5f; // Added a multiplier to make the bloom effect more visible and the scene less light

    // Final output 
    return float4(finalColor.rgb, 1.0f);
}