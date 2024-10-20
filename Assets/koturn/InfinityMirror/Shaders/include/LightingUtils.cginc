#ifndef LIGHTINGUTILS_INCLUDED
#define LIGHTINGUTILS_INCLUDED


half4 calcLightingUnity(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap);
half4 calcLightingUnity(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, half3 ambient);
half4 calcLightingUnityDeferred(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, out half4 diffuse, out half4 specular, out half4 normal);
half4 calcLightingUnityDeferred(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, half3 ambient, out half4 diffuse, out half4 specular, out half4 normal);

#if !defined(LIGHTINGUTILS_OMIT_OLD_LIGHTING)
#include "Lighting.cginc"
half4 calcLightingUnityLambert(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap);
half4 calcLightingUnityLambert(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, half3 ambient);
half4 calcLightingUnityLambertDeferred(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, out half4 diffuse, out half4 specular, out half4 normal);
half4 calcLightingUnityLambertDeferred(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, half3 ambient, out half4 diffuse, out half4 specular, out half4 normal);
half4 calcLightingUnityBlinnPhong(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap);
half4 calcLightingUnityBlinnPhong(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, half3 ambient);
half4 calcLightingUnityBlinnPhongDeferred(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, out half4 diffuse, out half4 specular, out half4 normal);
half4 calcLightingUnityBlinnPhongDeferred(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, half3 ambient, out half4 diffuse, out half4 specular, out half4 normal);
#endif  // !defined(LIGHTINGUTILS_OMIT_OLD_LIGHTING)

#if !defined(LIGHTINGUTILS_OMIT_PBS_LIGHTING)
#include "UnityPBSLighting.cginc"
half4 calcLightingUnityStandard(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap);
half4 calcLightingUnityStandard(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, half3 ambient);
half4 calcLightingUnityStandardDeferred(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, out half4 diffuse, out half4 specular, out half4 normal);
half4 calcLightingUnityStandardDeferred(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, half3 ambient, out half4 diffuse, out half4 specular, out half4 normal);
half4 calcLightingUnityStandardSpecular(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap);
half4 calcLightingUnityStandardSpecular(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, half3 ambient);
half4 calcLightingUnityStandardSpecularDeferred(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, out half4 diffuse, out half4 specular, out half4 normal);
half4 calcLightingUnityStandardSpecularDeferred(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, half3 ambient, out half4 diffuse, out half4 specular, out half4 normal);
#endif  // !defined(LIGHTINGUTILS_OMIT_PBS_LIGHTING)

#include "UnityLightingCommon.cginc"

half3 calcAmbient(float3 worldPos, float3 worldNormal);
UnityGI getGI(float3 worldPos, half atten);
UnityGIInput getGIInput(UnityLight light, float3 worldPos, float3 worldNormal, float3 worldViewDir, half atten, float4 lmap, half3 ambient);


#if !defined(UNITY_LIGHTING_COMMON_INCLUDED)
//! Color of light.
uniform fixed4 _LightColor0;
#endif  // !defined(UNITY_LIGHTING_COMMON_INCLUDED)

#if !defined(UNITY_LIGHTING_COMMON_INCLUDED) && !defined(UNITY_STANDARD_SHADOW_INCLUDED)
//! Specular color.
uniform half4 _SpecColor;
#endif  // !defined(UNITY_LIGHTING_COMMON_INCLUDED) && !defined(UNITY_STANDARD_SHADOW_INCLUDED)

//! Specular power.
uniform float _SpecPower;
//! Value of smoothness.
uniform half _Glossiness;
//! Value of Metallic.
uniform half _Metallic;


/*!
 * Calculate lighting using functions provided from Unity Library.
 * @param [in] color  Base color.
 * @param [in] worldPos  World coordinate.
 * @param [in] worldNormal  Normal in world space.
 * @param [in] atten  Light attenuation.
 * @param [in] lmap  Light map parameters.
 * @return Color with lighting applied.
 */
half4 calcLightingUnity(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap)
{
#if !defined(LIGHTINGUTILS_OMIT_OLD_LIGHTING) && defined(_LIGHTING_UNITY_LAMBERT)
    return calcLightingUnityLambert(color, worldPos, worldNormal, atten, lmap);
#elif !defined(LIGHTINGUTILS_OMIT_OLD_LIGHTING) && defined(_LIGHTING_UNITY_BLINN_PHONG)
    return calcLightingUnityBlinnPhong(color, worldPos, worldNormal, atten, lmap);
#elif !defined(LIGHTINGUTILS_OMIT_PBS_LIGHTING) && defined(_LIGHTING_UNITY_STANDARD)
    return calcLightingUnityStandard(color, worldPos, worldNormal, atten, lmap);
#elif !defined(LIGHTINGUTILS_OMIT_PBS_LIGHTING) && defined(_LIGHTING_UNITY_STANDARD_SPECULAR)
    return calcLightingUnityStandardSpecular(color, worldPos, worldNormal, atten, lmap);
#else  // Assume _LIGHTING_UNLIT
    return color;
#endif  // defined(_LIGHTING_LAMBERT)
}


/*!
 * Calculate lighting using functions provided from Unity Library.
 * @param [in] color  Base color.
 * @param [in] worldPos  World coordinate.
 * @param [in] worldNormal  Normal in world space.
 * @param [in] atten  Light attenuation.
 * @param [in] lmap  Light map parameters.
 * @param [in] ambient  Ambient light.
 * @return Color with lighting applied.
 */
half4 calcLightingUnity(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, half3 ambient)
{
#if !defined(LIGHTINGUTILS_OMIT_OLD_LIGHTING) && defined(_LIGHTING_UNITY_LAMBERT)
    return calcLightingUnityLambert(color, worldPos, worldNormal, atten, lmap, ambient);
#elif !defined(LIGHTINGUTILS_OMIT_OLD_LIGHTING) && defined(_LIGHTING_UNITY_BLINN_PHONG)
    return calcLightingUnityBlinnPhong(color, worldPos, worldNormal, atten, lmap, ambient);
#elif !defined(LIGHTINGUTILS_OMIT_PBS_LIGHTING) && defined(_LIGHTING_UNITY_STANDARD)
    return calcLightingUnityStandard(color, worldPos, worldNormal, atten, lmap, ambient);
#elif !defined(LIGHTINGUTILS_OMIT_PBS_LIGHTING) && defined(_LIGHTING_UNITY_STANDARD_SPECULAR)
    return calcLightingUnityStandardSpecular(color, worldPos, worldNormal, atten, lmap, ambient);
#else  // Assume _LIGHTING_UNLIT
    return color;
#endif  // defined(_LIGHTING_LAMBERT)
}


/*!
 * Calculate lighting using functions provided from Unity Library.
 * @param [in] color  Base color.
 * @param [in] worldPos  World coordinate.
 * @param [in] worldNormal  Normal in world space.
 * @param [in] atten  Light attenuation.
 * @param [in] lmap  Light map parameters.
 * @param [out] diffuse  Diffuse and occulusion. (rgb: diffuse, a: occlusion)
 * @param [out] specular  Specular and smoothness. (rgb: specular, a: smoothness)
 * @param [out] normal  Encoded normal. (rgb: normal, a: unused)
 * @return Emission color.
 */
half4 calcLightingUnityDeferred(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, out half4 diffuse, out half4 specular, out half4 normal)
{
#if !defined(LIGHTINGUTILS_OMIT_OLD_LIGHTING) && defined(_LIGHTING_UNITY_LAMBERT)
    return calcLightingUnityLambertDeferred(color, worldPos, worldNormal, atten, lmap, /* out */ diffuse, /* out */ specular, /* out */ normal);
#elif !defined(LIGHTINGUTILS_OMIT_OLD_LIGHTING) && defined(_LIGHTING_UNITY_BLINN_PHONG)
    return calcLightingUnityBlinnPhongDeferred(color, worldPos, worldNormal, atten, lmap, /* out */ diffuse, /* out */ specular, /* out */ normal);
#elif !defined(LIGHTINGUTILS_OMIT_PBS_LIGHTING) && defined(_LIGHTING_UNITY_STANDARD)
    return calcLightingUnityStandardDeferred(color, worldPos, worldNormal, atten, lmap, /* out */ diffuse, /* out */ specular, /* out */ normal);
#elif !defined(LIGHTINGUTILS_OMIT_PBS_LIGHTING) && defined(_LIGHTING_UNITY_STANDARD_SPECULAR)
    return calcLightingUnityStandardSpecularDeferred(color, worldPos, worldNormal, atten, lmap, /* out */ diffuse, /* out */ specular, /* out */ normal);
#else  // Assume _LIGHTING_UNLIT
    diffuse = half4(0.0, 0.0, 0.0, 1.0);
    specular = half4(0.0, 0.0, 0.0, 0.0);
    normal = half4(worldNormal * 0.5 + 0.5, 1.0);
    return half4(color.rgb, 0.0);
#endif  // defined(_LIGHTING_LAMBERT)
}


/*!
 * Calculate lighting using functions provided from Unity Library.
 * @param [in] color  Base color.
 * @param [in] worldPos  World coordinate.
 * @param [in] worldNormal  Normal in world space.
 * @param [in] atten  Light attenuation.
 * @param [in] lmap  Light map parameters.
 * @param [in] ambient  Ambient light.
 * @param [out] diffuse  Diffuse and occulusion. (rgb: diffuse, a: occlusion)
 * @param [out] specular  Specular and smoothness. (rgb: specular, a: smoothness)
 * @param [out] normal  Encoded normal. (rgb: normal, a: unused)
 * @return Emission color.
 */
half4 calcLightingUnityDeferred(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, half3 ambient, out half4 diffuse, out half4 specular, out half4 normal)
{
#if !defined(LIGHTINGUTILS_OMIT_OLD_LIGHTING) && defined(_LIGHTING_UNITY_LAMBERT)
    return calcLightingUnityLambertDeferred(color, worldPos, worldNormal, atten, lmap, ambient, /* out */ diffuse, /* out */ specular, /* out */ normal);
#elif !defined(LIGHTINGUTILS_OMIT_OLD_LIGHTING) && defined(_LIGHTING_UNITY_BLINN_PHONG)
    return calcLightingUnityBlinnPhongDeferred(color, worldPos, worldNormal, atten, lmap, ambient, /* out */ diffuse, /* out */ specular, /* out */ normal);
#elif !defined(LIGHTINGUTILS_OMIT_PBS_LIGHTING) && defined(_LIGHTING_UNITY_STANDARD)
    return calcLightingUnityStandardDeferred(color, worldPos, worldNormal, atten, lmap, ambient, /* out */ diffuse, /* out */ specular, /* out */ normal);
#elif !defined(LIGHTINGUTILS_OMIT_PBS_LIGHTING) && defined(_LIGHTING_UNITY_STANDARD_SPECULAR)
    return calcLightingUnityStandardSpecularDeferred(color, worldPos, worldNormal, atten, lmap, ambient, /* out */ diffuse, /* out */ specular, /* out */ normal);
#else  // Assume _LIGHTING_UNLIT
    diffuse = half4(0.0, 0.0, 0.0, 1.0);
    specular = half4(0.0, 0.0, 0.0, 0.0);
    normal = half4(worldNormal * 0.5 + 0.5, 1.0);
    return half4(color.rgb, 0.0);
#endif  // defined(_LIGHTING_LAMBERT)
}


#if !defined(LIGHTINGUTILS_OMIT_OLD_LIGHTING)
/*!
 * Calculate lighting with Lambert Reflection Model, same as Surface Shader with Lambert.
 * @param [in] color  Base color.
 * @param [in] worldPos  World coordinate.
 * @param [in] worldNormal  Normal in world space.
 * @param [in] atten  Light attenuation.
 * @param [in] lmap  Light map parameters.
 * @return Color with lighting applied.
 */
half4 calcLightingUnityLambert(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap)
{
    return calcLightingUnityLambert(color, worldPos, worldNormal, atten, lmap, calcAmbient(worldPos, worldNormal));
}


/*!
 * Calculate lighting with Lambert Reflection Model, same as Surface Shader with Lambert.
 * @param [in] color  Base color.
 * @param [in] worldPos  World coordinate.
 * @param [in] worldNormal  Normal in world space.
 * @param [in] atten  Light attenuation.
 * @param [in] lmap  Light map parameters.
 * @param [in] ambient  Ambient light.
 * @return Color with lighting applied.
 */
half4 calcLightingUnityLambert(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, half3 ambient)
{
    SurfaceOutput so;
    UNITY_INITIALIZE_OUTPUT(SurfaceOutput, so);
    so.Albedo = color.rgb;
    so.Normal = worldNormal;
    so.Emission = half3(0.0, 0.0, 0.0);
    // so.Specular = 0.0;  // Unused
    // so.Gloss = 0.0;  // Unused
    so.Alpha = color.a;

    UnityGI gi = getGI(worldPos, atten);

#if defined(UNITY_PASS_FORWARDBASE)
    const float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
#    if !defined(LIGHTMAP_ON) && !defined(DYNAMICLIGHTMAP_ON)
    lmap = float4(0.0, 0.0, 0.0, 0.0);
#    endif  // !defined(LIGHTMAP_ON) && !defined(DYNAMICLIGHTMAP_ON)
    UnityGIInput giInput = getGIInput(gi.light, worldPos, worldNormal, worldViewDir, atten, lmap, ambient);
    LightingLambert_GI(so, giInput, gi);
#endif  // defined(UNITY_PASS_FORWARDBASE)

    half4 outColor = LightingLambert(so, gi);
    outColor.rgb += so.Emission;

    return outColor;
}


/*!
 * Calculate lighting with Lambert Reflection Model, same as Surface Shader with Lambert.
 * @param [in] color  Base color.
 * @param [in] worldPos  World coordinate.
 * @param [in] worldNormal  Normal in world space.
 * @param [in] atten  Light attenuation.
 * @param [in] lmap  Light map parameters.
 * @param [out] diffuse  Diffuse and occulusion. (rgb: diffuse, a: occlusion)
 * @param [out] specular  Specular and smoothness. (rgb: specular, a: smoothness)
 * @param [out] normal  Encoded normal. (rgb: normal, a: unused)
 * @return Emission color.
 */
half4 calcLightingUnityLambertDeferred(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, out half4 diffuse, out half4 specular, out half4 normal)
{
    return calcLightingUnityLambertDeferred(color, worldPos, worldNormal, atten, lmap, calcAmbient(worldPos, worldNormal), /* out */ diffuse, /* out */ specular, /* out */ normal);
}


/*!
 * Calculate lighting with Lambert Reflection Model, same as Surface Shader with Lambert.
 * @param [in] color  Base color.
 * @param [in] worldPos  World coordinate.
 * @param [in] worldNormal  Normal in world space.
 * @param [in] atten  Light attenuation.
 * @param [in] lmap  Light map parameters.
 * @param [in] ambient  Ambient light.
 * @param [out] diffuse  Diffuse and occulusion. (rgb: diffuse, a: occlusion)
 * @param [out] specular  Specular and smoothness. (rgb: specular, a: smoothness)
 * @param [out] normal  Encoded normal. (rgb: normal, a: unused)
 * @return Emission color.
 */
half4 calcLightingUnityLambertDeferred(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, half3 ambient, out half4 diffuse, out half4 specular, out half4 normal)
{
    SurfaceOutput so;
    UNITY_INITIALIZE_OUTPUT(SurfaceOutput, so);
    so.Albedo = color.rgb;
    so.Normal = worldNormal;
    so.Emission = half3(0.0, 0.0, 0.0);
    // so.Specular = 0.0;  // Unused
    // so.Gloss = 0.0;  // Unused
    so.Alpha = color.a;

    UnityGI gi = getGI(worldPos, atten);

    const float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
#if !defined(LIGHTMAP_ON) && !defined(DYNAMICLIGHTMAP_ON)
    lmap = float4(0.0, 0.0, 0.0, 0.0);
#endif  // !defined(LIGHTMAP_ON) && !defined(DYNAMICLIGHTMAP_ON)
    UnityGIInput giInput = getGIInput(gi.light, worldPos, worldNormal, worldViewDir, atten, lmap, ambient);
    LightingLambert_GI(so, giInput, gi);

    half4 emission = LightingLambert_Deferred(so, gi, /* out */ diffuse, /* out */ specular, /* out */ normal);
#if !defined(UNITY_HDR_ON)
    emission.rgb = exp2(-emission.rgb);
#endif  // !defined(UNITY_HDR_ON)

    return emission;
}


/*!
 * Calculate lighting with Blinn-Phong Reflection Model, same as Surface Shader with Lambert.
 * @param [in] color  Base color.
 * @param [in] worldPos  World coordinate.
 * @param [in] worldNormal  Normal in world space.
 * @param [in] atten  Light attenuation.
 * @param [in] lmap  Light map parameters.
 * @return Color with lighting applied.
 */
half4 calcLightingUnityBlinnPhong(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap)
{
    return calcLightingUnityBlinnPhong(color, worldPos, worldNormal, atten, lmap, calcAmbient(worldPos, worldNormal));
}


/*!
 * Calculate lighting with Blinn-Phong Reflection Model, same as Surface Shader with Lambert.
 * @param [in] color  Base color.
 * @param [in] worldPos  World coordinate.
 * @param [in] worldNormal  Normal in world space.
 * @param [in] atten  Light attenuation.
 * @param [in] lmap  Light map parameters.
 * @param [in] ambient  Ambient light.
 * @return Color with lighting applied.
 */
half4 calcLightingUnityBlinnPhong(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, half3 ambient)
{
    SurfaceOutput so;
    UNITY_INITIALIZE_OUTPUT(SurfaceOutput, so);
    so.Albedo = color.rgb;
    so.Normal = worldNormal;
    so.Emission = half3(0.0, 0.0, 0.0);
    so.Specular = _SpecPower / 128.0;
    so.Gloss = _Glossiness;
    so.Alpha = color.a;

    UnityGI gi = getGI(worldPos, atten);

    const float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
#if defined(UNITY_PASS_FORWARDBASE)
#    if !defined(LIGHTMAP_ON) && !defined(DYNAMICLIGHTMAP_ON)
    lmap = float4(0.0, 0.0, 0.0, 0.0);
#    endif  // !defined(LIGHTMAP_ON) && !defined(DYNAMICLIGHTMAP_ON)
    UnityGIInput giInput = getGIInput(gi.light, worldPos, worldNormal, worldViewDir, atten, lmap, ambient);
    LightingBlinnPhong_GI(so, giInput, gi);
#endif  // defined(UNITY_PASS_FORWARDBASE)

    half4 outColor = LightingBlinnPhong(so, worldViewDir, gi);
    outColor.rgb += so.Emission;

    return outColor;
}


/*!
 * Calculate lighting with Blinn-Phong Reflection Model, same as Surface Shader with Lambert.
 * @param [in] color  Base color.
 * @param [in] worldPos  World coordinate.
 * @param [in] worldNormal  Normal in world space.
 * @param [in] atten  Light attenuation.
 * @param [in] lmap  Light map parameters.
 * @param [out] diffuse  Diffuse and occulusion. (rgb: diffuse, a: occlusion)
 * @param [out] specular  Specular and smoothness. (rgb: specular, a: smoothness)
 * @param [out] normal  Encoded normal. (rgb: normal, a: unused)
 * @return Emission color.
 */
half4 calcLightingUnityBlinnPhongDeferred(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, out half4 diffuse, out half4 specular, out half4 normal)
{
    return calcLightingUnityBlinnPhongDeferred(color, worldPos, worldNormal, atten, lmap, calcAmbient(worldPos, worldNormal), /* out */ diffuse, /* out */ specular, /* out */ normal);
}


/*!
 * Calculate lighting with Blinn-Phong Reflection Model, same as Surface Shader with Lambert.
 * @param [in] color  Base color.
 * @param [in] worldPos  World coordinate.
 * @param [in] worldNormal  Normal in world space.
 * @param [in] atten  Light attenuation.
 * @param [in] lmap  Light map parameters.
 * @param [in] ambient  Ambient light.
 * @param [out] diffuse  Diffuse and occulusion. (rgb: diffuse, a: occlusion)
 * @param [out] specular  Specular and smoothness. (rgb: specular, a: smoothness)
 * @param [out] normal  Encoded normal. (rgb: normal, a: unused)
 * @return Emission color.
 */
half4 calcLightingUnityBlinnPhongDeferred(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, half3 ambient, out half4 diffuse, out half4 specular, out half4 normal)
{
    SurfaceOutput so;
    UNITY_INITIALIZE_OUTPUT(SurfaceOutput, so);
    so.Albedo = color.rgb;
    so.Normal = worldNormal;
    so.Emission = half3(0.0, 0.0, 0.0);
    so.Specular = _SpecPower / 128.0;
    so.Gloss = _Glossiness;
    so.Alpha = color.a;

    UnityGI gi = getGI(worldPos, atten);

    const float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
#if !defined(LIGHTMAP_ON) && !defined(DYNAMICLIGHTMAP_ON)
    lmap = float4(0.0, 0.0, 0.0, 0.0);
#endif  // !defined(LIGHTMAP_ON) && !defined(DYNAMICLIGHTMAP_ON)
    UnityGIInput giInput = getGIInput(gi.light, worldPos, worldNormal, worldViewDir, atten, lmap, ambient);
    LightingBlinnPhong_GI(so, giInput, gi);

    half4 emission = LightingBlinnPhong_Deferred(so, worldViewDir, gi, /* out */ diffuse, /* out */ specular, /* out */ normal);
#if !defined(UNITY_HDR_ON)
    emission.rgb = exp2(-emission.rgb);
#endif  // !defined(UNITY_HDR_ON)

    return emission;
}
#endif  // !defined(LIGHTINGUTILS_OMIT_OLD_LIGHTING)


#if !defined(LIGHTINGUTILS_OMIT_PBS_LIGHTING)
/*!
 * Calculate lighting with Unity PBS, same as Surface Shader with UnityStandard.
 * @param [in] color  Base color.
 * @param [in] worldPos  World coordinate.
 * @param [in] worldNormal  Normal in world space.
 * @param [in] atten  Light attenuation.
 * @param [in] lmap  Light map parameters.
 * @return Color with lighting applied.
 */
half4 calcLightingUnityStandard(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap)
{
    return calcLightingUnityStandard(color, worldPos, worldNormal, atten, lmap, calcAmbient(worldPos, worldNormal));
}


/*!
 * Calculate lighting with Unity PBS, same as Surface Shader with UnityStandard.
 * @param [in] color  Base color.
 * @param [in] worldPos  World coordinate.
 * @param [in] worldNormal  Normal in world space.
 * @param [in] atten  Light attenuation.
 * @param [in] lmap  Light map parameters.
 * @param [in] ambient  Ambient light.
 * @return Color with lighting applied.
 */
half4 calcLightingUnityStandard(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, half3 ambient)
{
    SurfaceOutputStandard so;
    UNITY_INITIALIZE_OUTPUT(SurfaceOutputStandard, so);
    so.Albedo = color.rgb;
    so.Normal = worldNormal;
    so.Emission = half3(0.0, 0.0, 0.0);
    so.Metallic = _Metallic;
    so.Smoothness = _Glossiness;
    so.Occlusion = 1.0;
    so.Alpha = color.a;

    UnityGI gi = getGI(worldPos, atten);

    const float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
#if defined(UNITY_PASS_FORWARDBASE)
#    if !defined(LIGHTMAP_ON) && !defined(DYNAMICLIGHTMAP_ON)
    lmap = float4(0.0, 0.0, 0.0, 0.0);
#    endif  // !defined(LIGHTMAP_ON) && !defined(DYNAMICLIGHTMAP_ON)
    UnityGIInput giInput = getGIInput(gi.light, worldPos, worldNormal, worldViewDir, atten, lmap, ambient);
    LightingStandard_GI(so, giInput, gi);
#endif  // defined(UNITY_PASS_FORWARDBASE)

    half4 outColor = LightingStandard(so, worldViewDir, gi);
    outColor.rgb += so.Emission;

    return outColor;
}


/*!
 * Calculate lighting with Unity PBS, same as Surface Shader with UnityStandard.
 * @param [in] color  Base color.
 * @param [in] worldPos  World coordinate.
 * @param [in] worldNormal  Normal in world space.
 * @param [in] atten  Light attenuation.
 * @param [in] lmap  Light map parameters.
 * @param [out] diffuse  Diffuse and occulusion. (rgb: diffuse, a: occlusion)
 * @param [out] specular  Specular and smoothness. (rgb: specular, a: smoothness)
 * @param [out] normal  Encoded normal. (rgb: normal, a: unused)
 * @return Emission color.
 */
half4 calcLightingUnityStandardDeferred(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, out half4 diffuse, out half4 specular, out half4 normal)
{
    return calcLightingUnityStandardDeferred(color, worldPos, worldNormal, atten, lmap, calcAmbient(worldPos, worldNormal), /* out */ diffuse, /* out */ specular, /* out */ normal);
}


/*!
 * Calculate lighting with Unity PBS, same as Surface Shader with UnityStandard.
 * @param [in] color  Base color.
 * @param [in] worldPos  World coordinate.
 * @param [in] worldNormal  Normal in world space.
 * @param [in] atten  Light attenuation.
 * @param [in] lmap  Light map parameters.
 * @param [in] ambient  Ambient light.
 * @param [out] diffuse  Diffuse and occulusion. (rgb: diffuse, a: occlusion)
 * @param [out] specular  Specular and smoothness. (rgb: specular, a: smoothness)
 * @param [out] normal  Encoded normal. (rgb: normal, a: unused)
 * @return Emission color.
 */
half4 calcLightingUnityStandardDeferred(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, half3 ambient, out half4 diffuse, out half4 specular, out half4 normal)
{
    SurfaceOutputStandard so;
    UNITY_INITIALIZE_OUTPUT(SurfaceOutputStandard, so);
    so.Albedo = color.rgb;
    so.Normal = worldNormal;
    so.Emission = half3(0.0, 0.0, 0.0);
    so.Metallic = _Metallic;
    so.Smoothness = _Glossiness;
    so.Occlusion = 1.0;
    so.Alpha = color.a;

    UnityGI gi = getGI(worldPos, atten);

    const float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
#if !defined(LIGHTMAP_ON) && !defined(DYNAMICLIGHTMAP_ON)
    lmap = float4(0.0, 0.0, 0.0, 0.0);
#endif  // !defined(LIGHTMAP_ON) && !defined(DYNAMICLIGHTMAP_ON)
    UnityGIInput giInput = getGIInput(gi.light, worldPos, worldNormal, worldViewDir, atten, lmap, ambient);
    LightingStandard_GI(so, giInput, gi);

    half4 emission = LightingStandard_Deferred(so, worldViewDir, gi, /* out */ diffuse, /* out */ specular, /* out */ normal);
#if !defined(UNITY_HDR_ON)
    emission.rgb = exp2(-emission.rgb);
#endif  // !defined(UNITY_HDR_ON)

    return emission;
}


/*!
 * Calculate lighting with Unity PBS Specular, same as Surface Shader with UnityStandardSpecular.
 * @param [in] color  Base color.
 * @param [in] worldPos  World coordinate.
 * @param [in] worldNormal  Normal in world space.
 * @param [in] atten  Light attenuation.
 * @param [in] lmap  Light map parameters.
 * @return Color with lighting applied.
 */
half4 calcLightingUnityStandardSpecular(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap)
{
    return calcLightingUnityStandardSpecular(color, worldPos, worldNormal, atten, lmap, calcAmbient(worldPos, worldNormal));
}


/*!
 * Calculate lighting with Unity PBS Specular, same as Surface Shader with UnityStandardSpecular.
 * @param [in] color  Base color.
 * @param [in] worldPos  World coordinate.
 * @param [in] worldNormal  Normal in world space.
 * @param [in] atten  Light attenuation.
 * @param [in] lmap  Light map parameters.
 * @param [in] ambient  Ambient light.
 * @return Color with lighting applied.
 */
half4 calcLightingUnityStandardSpecular(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, half3 ambient)
{
    SurfaceOutputStandardSpecular so;
    UNITY_INITIALIZE_OUTPUT(SurfaceOutputStandardSpecular, so);
    so.Albedo = color.rgb;
    so.Specular = _SpecColor.rgb;
    so.Normal = worldNormal;
    so.Emission = half3(0.0, 0.0, 0.0);
    so.Smoothness = _Glossiness;
    so.Occlusion = 1.0;
    so.Alpha = color.a;

    UnityGI gi = getGI(worldPos, atten);

    const float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
#if defined(UNITY_PASS_FORWARDBASE)
#    if !defined(LIGHTMAP_ON) && !defined(DYNAMICLIGHTMAP_ON)
    lmap = float4(0.0, 0.0, 0.0, 0.0);
#    endif  // !defined(LIGHTMAP_ON) && !defined(DYNAMICLIGHTMAP_ON)
    UnityGIInput giInput = getGIInput(gi.light, worldPos, worldNormal, worldViewDir, atten, lmap, ambient);
    LightingStandardSpecular_GI(so, giInput, gi);
#endif  // defined(UNITY_PASS_FORWARDBASE)

    half4 outColor = LightingStandardSpecular(so, worldViewDir, gi);
    outColor.rgb += so.Emission;

    return outColor;
}


/*!
 * Calculate lighting with Unity PBS Specular, same as Surface Shader with UnityStandardSpecular.
 * @param [in] color  Base color.
 * @param [in] worldPos  World coordinate.
 * @param [in] worldNormal  Normal in world space.
 * @param [in] atten  Light attenuation.
 * @param [in] lmap  Light map parameters.
 * @param [out] diffuse  Diffuse and occulusion. (rgb: diffuse, a: occlusion)
 * @param [out] specular  Specular and smoothness. (rgb: specular, a: smoothness)
 * @param [out] normal  Encoded normal. (rgb: normal, a: unused)
 * @return Emission color.
 */
half4 calcLightingUnityStandardSpecularDeferred(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, out half4 diffuse, out half4 specular, out half4 normal)
{
    return calcLightingUnityStandardSpecularDeferred(color, worldPos, worldNormal, atten, lmap, calcAmbient(worldPos, worldNormal), /* out */ diffuse, /* out */ specular, /* out */ normal);
}


/*!
 * Calculate lighting with Unity PBS Specular, same as Surface Shader with UnityStandardSpecular.
 * @param [in] color  Base color.
 * @param [in] worldPos  World coordinate.
 * @param [in] worldNormal  Normal in world space.
 * @param [in] atten  Light attenuation.
 * @param [in] lmap  Light map parameters.
 * @param [in] ambient  Ambient light.
 * @param [out] diffuse  Diffuse and occulusion. (rgb: diffuse, a: occlusion)
 * @param [out] specular  Specular and smoothness. (rgb: specular, a: smoothness)
 * @param [out] normal  Encoded normal. (rgb: normal, a: unused)
 * @return Emission color.
 */
half4 calcLightingUnityStandardSpecularDeferred(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, half3 ambient, out half4 diffuse, out half4 specular, out half4 normal)
{
    SurfaceOutputStandardSpecular so;
    UNITY_INITIALIZE_OUTPUT(SurfaceOutputStandardSpecular, so);
    so.Albedo = color.rgb;
    so.Specular = _SpecColor.rgb;
    so.Normal = worldNormal;
    so.Emission = half3(0.0, 0.0, 0.0);
    so.Smoothness = _Glossiness;
    so.Occlusion = 1.0;
    so.Alpha = color.a;

    UnityGI gi = getGI(worldPos, atten);

    const float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
#if !defined(LIGHTMAP_ON) && !defined(DYNAMICLIGHTMAP_ON)
    lmap = float4(0.0, 0.0, 0.0, 0.0);
#endif  // !defined(LIGHTMAP_ON) && !defined(DYNAMICLIGHTMAP_ON)
    UnityGIInput giInput = getGIInput(gi.light, worldPos, worldNormal, worldViewDir, atten, lmap, ambient);
    LightingStandardSpecular_GI(so, giInput, gi);

    half4 emission = LightingStandardSpecular_Deferred(so, worldViewDir, gi, /* out */ diffuse, /* out */ specular, /* out */ normal);
#if !defined(UNITY_HDR_ON)
    emission.rgb = exp2(-emission.rgb);
#endif  // !defined(UNITY_HDR_ON)

    return emission;
}
#endif  // !defined(LIGHTINGUTILS_OMIT_PBS_LIGHTING)


/*!
 * @brief Calculate ambient light.
 * @param [in] worldPos  World coordinate.
 * @param [in] worldNormal  Normal in world space.
 * @return Ambient light.
 */
half3 calcAmbient(float3 worldPos, float3 worldNormal)
{
#if !defined(LIGHTMAP_ON) && UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
    // Approximated illumination from non-important point lights
#    if defined(VERTEXLIGHT_ON)
    const half3 ambient = Shade4PointLights(
        unity_4LightPosX0,
        unity_4LightPosY0,
        unity_4LightPosZ0,
        unity_LightColor[0].rgb,
        unity_LightColor[1].rgb,
        unity_LightColor[2].rgb,
        unity_LightColor[3].rgb,
        unity_4LightAtten0,
        worldPos,
        worldNormal);
#    else
    const half3 ambient = half3(0.0, 0.0, 0.0);
#    endif  // defined(VERTEXLIGHT_ON)
    return ShadeSHPerVertex(worldNormal, ambient);
#else
    return half3(0.0, 0.0, 0.0);
#endif  // !defined(LIGHTMAP_ON) && UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
}


/*!
 * @brief Get initial instance of UnityGI.
 * @param [in] worldPos  World coordinate.
 * @param [in] atten  Light attenuation.
 * @return Initial instance of UnityGI.
 */
UnityGI getGI(float3 worldPos, half atten)
{
    UnityGI gi;
    UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
#if defined(UNITY_PASS_FORWARDBASE)
    gi.light.color = _LightColor0.rgb;
#elif defined(UNITY_PASS_DEFERRED)
    gi.light.color = half3(0.0, 0.0, 0.0);
#else
    gi.light.color = _LightColor0.rgb * atten;
#endif  // defined(UNITY_PASS_FORWARDBASE)
#if defined(UNITY_PASS_DEFERRED)
    gi.light.dir = half3(0.0, 1.0, 0.0);
#elif !defined(USING_LIGHT_MULTI_COMPILE)
    gi.light.dir = normalize(_WorldSpaceLightPos0.xyz - worldPos * _WorldSpaceLightPos0.w);
#elif defined(USING_DIRECTIONAL_LIGHT)
    // Avoid normalize() because _WorldSpaceLightPos0 is already normalized for DirectionalLight.
    gi.light.dir = _WorldSpaceLightPos0.xyz;
#else
    gi.light.dir = normalize(_WorldSpaceLightPos0.xyz - worldPos);
#endif  // defined(UNITY_PASS_DEFERRED)
    gi.indirect.diffuse = half3(0.0, 0.0, 0.0);
    gi.indirect.specular = half3(0.0, 0.0, 0.0);

    return gi;
}


/*!
 * @brief Get initial instance of UnityGIInput.
 * @param [in] light  The lighting parameter which contains color and direction of the light.
 * @param [in] worldPos  World coordinate.
 * @param [in] worldNormal  Normal in world space.
 * @param [in] worldViewDir  View direction in world space.
 * @param [in] atten  Light attenuation.
 * @param [in] lmap  Light map parameters.
 * @param [in] ambient  Ambient light.
 * @return Initial instance of UnityGIInput.
 */
UnityGIInput getGIInput(UnityLight light, float3 worldPos, float3 worldNormal, float3 worldViewDir, half atten, float4 lmap, half3 ambient)
{
    UnityGIInput giInput;
    UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);
    giInput.light = light;
    giInput.worldPos = worldPos;
    giInput.worldViewDir = worldViewDir;
    giInput.atten = atten;

#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
    giInput.lightmapUV = lmap;
#else
    giInput.lightmapUV = float4(0.0, 0.0, 0.0, 0.0);
#endif  // defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)

// #if UNITY_SHOULD_SAMPLE_SH
//     giInput.ambient = ShadeSHPerPixel(worldNormal, 0.0, giInput.worldPos);
// #else
//     giInput.ambient = half3(0.0, 0.0, 0.0);
// #endif  // UNITY_SHOULD_SAMPLE_SH
#if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
    giInput.ambient = ambient;
#else
    giInput.ambient = half3(0.0, 0.0, 0.0);
#endif  // UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL

#if !defined(_LIGHTING_UNITY_LAMBERT) && !defined(_LIGHTING_UNITY_BLINN_PHONG)
    giInput.probeHDR[0] = unity_SpecCube0_HDR;
    giInput.probeHDR[1] = unity_SpecCube1_HDR;
#    if defined(UNITY_SPECCUBE_BLENDING) || defined(UNITY_SPECCUBE_BOX_PROJECTION)
    giInput.boxMin[0] = unity_SpecCube0_BoxMin;
#    endif  // defined(UNITY_SPECCUBE_BLENDING) || defined(UNITY_SPECCUBE_BOX_PROJECTION)
#    if defined(UNITY_SPECCUBE_BOX_PROJECTION)
    giInput.boxMax[0] = unity_SpecCube0_BoxMax;
    giInput.probePosition[0] = unity_SpecCube0_ProbePosition;
    giInput.boxMax[1] = unity_SpecCube1_BoxMax;
    giInput.boxMin[1] = unity_SpecCube1_BoxMin;
    giInput.probePosition[1] = unity_SpecCube1_ProbePosition;
#    endif  // defined(UNITY_SPECCUBE_BOX_PROJECTION)
#endif  // !defined(_LIGHTING_UNITY_LAMBERT) && !defined(_LIGHTING_UNITY_BLINN_PHONG)

    return giInput;
}


#endif  // LIGHTINGUTILS_INCLUDED
