//--------------------------------------------------------------------------------------
// Gaussian Blur Vertical Post-Processing Pixel Shader
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

// Post-processing shader that applies a vertical Gaussian blur to the scene
float4 main(PostProcessingInput input) : SV_Target
{
    // Gaussian blur weights and offsets for 5 samples 
    const float offset[5] = { 0.0, 1.0, 2.0, 3.0, 4.0 };
    const float weight[5] = { 0.2270270270, 0.1945945946, 0.1216216216, 0.0540540541, 0.0162162162 }; 

    float3 colour = SceneTexture.Sample(PointSample, input.sceneUV).rgb * weight[0]; // Sample the texture at the current UV coordinate and multiply by the weight
    float3 fragmentColour = float3(0.0f, 0.0f, 0.0f);                                // The colour of the current fragment

    float gBlurAmount = 3.0f; // The amount of blur to apply to the scene, range 1-10, (10 = very blurry, 1 = hardly any blur)

    // Vertical Blur, so we only need to offset the x coordinate of the texture which is the yStep 
    float xStep = 0.0f;
    float yStep = 1.0f;

    // Sample the texture 5 times, with different offsets and weights, and add them all together
    for (int i = 1; i < 5; i++)
    {
        float2 normalizedOffset = float2(xStep * offset[i], yStep * offset[i] * gBlurAmount) / gViewportHeight;

        fragmentColour +=
        SceneTexture.Sample(PointSample, input.sceneUV + normalizedOffset) * weight[i] +
        SceneTexture.Sample(PointSample, input.sceneUV - normalizedOffset) * weight[i];
    }

    // Add the blurred colour to the original colour of the scene and return it to output to the screen
    colour += fragmentColour;
    return float4(colour, 1.0);
}