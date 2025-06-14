#ifndef LIGHTINGUTILS_INCLUDED
#define LIGHTINGUTILS_INCLUDED


#if !defined(LIGHTINGUTILS_BUFFER_NAME)
#    define LIGHTINGUTILS_BUFFER_NAME LightingUtilsProps
#endif  // !defined(LIGHTINGUTILS_BUFFER_NAME)

#if defined(LIGHTINGUTILS_DISABLE_INSTANCING)
#    define LIGHTINGUTILS_INSTANCING_BUFFER_START
#    define LIGHTINGUTILS_INSTANCING_BUFFER_END
#    define LIGHTINGUTILS_DEFINE_INSTANCED_PROP(type, var) uniform type var;
#    define LIGHTINGUTILS_ACCESS_INSTANCED_PROP(var) var
#else
#    define LIGHTINGUTILS_INSTANCING_BUFFER_START UNITY_INSTANCING_BUFFER_START(LIGHTINGUTILS_BUFFER_NAME)
#    define LIGHTINGUTILS_INSTANCING_BUFFER_END UNITY_INSTANCING_BUFFER_END(LIGHTINGUTILS_BUFFER_NAME)
#    define LIGHTINGUTILS_DEFINE_INSTANCED_PROP(type, var) UNITY_DEFINE_INSTANCED_PROP(type, var)
#    define LIGHTINGUTILS_ACCESS_INSTANCED_PROP(var) UNITY_ACCESS_INSTANCED_PROP(LIGHTINGUTILS_BUFFER_NAME, var)
#endif  // defined(LIGHTINGUTILS_DISABLE_INSTANCING)

#if !defined(LIGHTINGUTILS_VARNAME_SPEC_POWER)
#    define LIGHTINGUTILS_VARNAME_SPEC_POWER _SpecPower
#endif  // !defined(LIGHTINGUTILS_VARNAME_SPEC_POWER)
#if !defined(LIGHTINGUTILS_SPEC_POWER)
#    define LIGHTINGUTILS_SPEC_POWER LIGHTINGUTILS_ACCESS_INSTANCED_PROP(LIGHTINGUTILS_VARNAME_SPEC_POWER)
#endif  // !defined(LIGHTINGUTILS_SPEC_POWER)
#if !defined(LIGHTINGUTILS_VARNAME_GLOSSINESS)
#    define LIGHTINGUTILS_VARNAME_GLOSSINESS _Glossiness
#endif  // !defined(LIGHTINGUTILS_VARNAME_GLOSSINESS)
#if !defined(LIGHTINGUTILS_GLOSSINESS)
#    define LIGHTINGUTILS_GLOSSINESS LIGHTINGUTILS_ACCESS_INSTANCED_PROP(LIGHTINGUTILS_VARNAME_GLOSSINESS)
#endif  // !defined(LIGHTINGUTILS_GLOSSINESS)
#if !defined(LIGHTINGUTILS_VARNAME_METALLIC)
#    define LIGHTINGUTILS_VARNAME_METALLIC _Metallic
#endif  // !defined(LIGHTINGUTILS_VARNAME_METALLIC)
#if !defined(LIGHTINGUTILS_METALLIC)
#    define LIGHTINGUTILS_METALLIC LIGHTINGUTILS_ACCESS_INSTANCED_PROP(LIGHTINGUTILS_VARNAME_METALLIC)
#endif  // !defined(LIGHTINGUTILS_METALLIC)


half4 calcLightingUnity(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, half3 ambient);
half4 calcLightingUnityDeferred(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, half3 ambient, out half4 diffuse, out half4 specular, out half4 normal);

#if !defined(LIGHTINGUTILS_OMIT_OLD_LIGHTING)
#include "Lighting.cginc"
half4 calcLightingUnityLambert(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, half3 ambient);
half4 calcLightingUnityLambertDeferred(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, half3 ambient, out half4 diffuse, out half4 specular, out half4 normal);
half4 calcLightingUnityBlinnPhong(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, half3 ambient);
half4 calcLightingUnityBlinnPhongDeferred(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, half3 ambient, out half4 diffuse, out half4 specular, out half4 normal);
#endif  // !defined(LIGHTINGUTILS_OMIT_OLD_LIGHTING)

#if !defined(LIGHTINGUTILS_OMIT_PBS_LIGHTING)
#include "UnityPBSLighting.cginc"
half4 calcLightingUnityStandard(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, half3 ambient);
half4 calcLightingUnityStandardDeferred(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, half3 ambient, out half4 diffuse, out half4 specular, out half4 normal);
half4 calcLightingUnityStandardSpecular(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, half3 ambient);
half4 calcLightingUnityStandardSpecularDeferred(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, half3 ambient, out half4 diffuse, out half4 specular, out half4 normal);
#endif  // !defined(LIGHTINGUTILS_OMIT_PBS_LIGHTING)

#include "UnityLightingCommon.cginc"
#if defined(_VRCLIGHTVOLUMES_ON) || defined(_VRCLIGHTVOLUMES_ADDITIVE_ONLY) || defined(_VRCLIGHTVOLUMESSPECULAR_ON) || defined(_VRCLIGHTVOLUMESSPECULAR_DOMINANT_DIR)
// #    include "LightVolumes.cginc"
#    include "LightVolumes.cginc"
#endif  // defined(_VRCLIGHTVOLUMES_ON) || defined(_VRCLIGHTVOLUMES_ADDITIVE_ONLY) || defined(_VRCLIGHTVOLUMESSPECULAR_ON) || defined(_VRCLIGHTVOLUMESSPECULAR_DOMINANT_DIR)
#if defined(UNITY_PASS_FORWARDBASE) && defined(_LTCGI_ON)
#    define LTCGI_AVATAR_MODE
#    if defined(_LIGHTING_UNITY_LAMBERT)
#        define LTCGI_SPECULAR_OFF
#    endif  // defined(_LIGHTING_UNITY_LAMBERT)
#    include "Packages/at.pimaker.ltcgi/Shaders/LTCGI.cginc"
#endif  // defined(UNITY_PASS_FORWARDBASE) && defined(_LTCGI_ON)

UnityGI getGI(float3 worldPos, half atten);
UnityGIInput getGIInput(UnityLight light, float3 worldPos, float3 worldNormal, float3 worldViewDir, half atten, float4 lmap, half3 ambient);
half3 calcLightVolumeAmbientAndSpecular(half3 albedo, float3 worldPos, float3 worldNormal, float3 worldViewDir, half glossiness, half metallic, half occlusion);


#if !defined(UNITY_LIGHTING_COMMON_INCLUDED)
//! Color of light.
uniform fixed4 _LightColor0;
#endif  // !defined(UNITY_LIGHTING_COMMON_INCLUDED)

#if !defined(UNITY_LIGHTING_COMMON_INCLUDED) && !defined(UNITY_STANDARD_SHADOW_INCLUDED)
//! Specular color.
uniform half4 _SpecColor;
#endif  // !defined(UNITY_LIGHTING_COMMON_INCLUDED) && !defined(UNITY_STANDARD_SHADOW_INCLUDED)

LIGHTINGUTILS_INSTANCING_BUFFER_START
//! Specular power.
LIGHTINGUTILS_DEFINE_INSTANCED_PROP(float, LIGHTINGUTILS_VARNAME_SPEC_POWER)
//! Value of smoothness.
LIGHTINGUTILS_DEFINE_INSTANCED_PROP(half, LIGHTINGUTILS_VARNAME_GLOSSINESS)
//! Value of Metallic.
LIGHTINGUTILS_DEFINE_INSTANCED_PROP(half, LIGHTINGUTILS_VARNAME_METALLIC)
LIGHTINGUTILS_INSTANCING_BUFFER_END


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
 * @param [in] ambient  Ambient light.
 * @return Color with lighting applied.
 */
half4 calcLightingUnityLambert(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, half3 ambient)
{
    SurfaceOutput so;
    UNITY_INITIALIZE_OUTPUT(SurfaceOutput, so);
    so.Albedo = color.rgb;
    so.Normal = worldNormal;
    so.Emission = fixed3(0.0, 0.0, 0.0);
    // so.Specular = 0.0;  // Unused
    // so.Gloss = 0.0;  // Unused
    so.Alpha = color.a;

    UnityGI gi = getGI(worldPos, atten);

    const float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
#if defined(UNITY_PASS_FORWARDBASE)
#    if !defined(LIGHTMAP_ON) && !defined(DYNAMICLIGHTMAP_ON)
    lmap = float4(0.0, 0.0, 0.0, 0.0);
#    endif  // !defined(LIGHTMAP_ON) && !defined(DYNAMICLIGHTMAP_ON)
    UnityGIInput giInput = getGIInput(gi.light, worldPos, worldNormal, worldViewDir, atten, lmap, ambient);
    LightingLambert_GI(so, giInput, gi);
#endif  // defined(UNITY_PASS_FORWARDBASE)

#if UNITY_SHOULD_SAMPLE_SH && !defined(LIGHTMAP_ON) && (defined(_VRCLIGHTVOLUMES_ON) || defined(_VRCLIGHTVOLUMES_ADDITIVE_ONLY) || defined(_VRCLIGHTVOLUMESSPECULAR_ON) || defined(_VRCLIGHTVOLUMESSPECULAR_DOMINANT_DIR))
    if (_UdonLightVolumeEnabled && _UdonLightVolumeCount != 0) {
        gi.indirect.diffuse = half3(0.0, 0.0, 0.0);
        so.Emission += calcLightVolumeAmbientAndSpecular(color.rgb, worldPos, worldNormal, worldViewDir, 0.0, 0.0, 1.0);
    }
#endif  // UNITY_SHOULD_SAMPLE_SH && !defined(LIGHTMAP_ON) && (defined(_VRCLIGHTVOLUMES_ON) || defined(_VRCLIGHTVOLUMES_ADDITIVE_ONLY) || defined(_VRCLIGHTVOLUMESSPECULAR_ON) || defined(_VRCLIGHTVOLUMESSPECULAR_DOMINANT_DIR))
#if defined(UNITY_PASS_FORWARDBASE) && defined(_LTCGI_ON)
    float3 ltcgiDiffuse = float3(0.0, 0.0, 0.0);
    float3 ltcgiSpecular = float3(0.0, 0.0, 0.0);  // unused
    LTCGI_Contribution(
       worldPos,
       worldNormal,
       worldViewDir,
       1.0,
       float2(0.0, 0.0),
       /* inout */ ltcgiDiffuse,
       /* inout */ ltcgiSpecular);
    so.Emission += color.rgb * ltcgiDiffuse;
#endif  // defined(UNITY_PASS_FORWARDBASE) && defined(_LTCGI_ON)

    half4 outColor = LightingLambert(so, gi);
#if defined(UNITY_PASS_FORWARDBASE)
    outColor.rgb += so.Emission;
#endif  // defined(UNITY_PASS_FORWARDBASE)

    return outColor;
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
    so.Emission = fixed3(0.0, 0.0, 0.0);
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
 * @param [in] ambient  Ambient light.
 * @return Color with lighting applied.
 */
half4 calcLightingUnityBlinnPhong(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, half3 ambient)
{
    const half glossiness = LIGHTINGUTILS_GLOSSINESS;

    SurfaceOutput so;
    UNITY_INITIALIZE_OUTPUT(SurfaceOutput, so);
    so.Albedo = color.rgb;
    so.Normal = worldNormal;
    so.Emission = fixed3(0.0, 0.0, 0.0);
    so.Specular = LIGHTINGUTILS_SPEC_POWER / 128.0;
    so.Gloss = glossiness;
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

#if UNITY_SHOULD_SAMPLE_SH && !defined(LIGHTMAP_ON) && (defined(_VRCLIGHTVOLUMES_ON) || defined(_VRCLIGHTVOLUMES_ADDITIVE_ONLY) || defined(_VRCLIGHTVOLUMESSPECULAR_ON) || defined(_VRCLIGHTVOLUMESSPECULAR_DOMINANT_DIR))
    if (_UdonLightVolumeEnabled && _UdonLightVolumeCount != 0) {
        gi.indirect.diffuse = half3(0.0, 0.0, 0.0);
        so.Emission += calcLightVolumeAmbientAndSpecular(color.rgb, worldPos, worldNormal, worldViewDir, glossiness, 0.0, 1.0);
    }
#endif  // UNITY_SHOULD_SAMPLE_SH && !defined(LIGHTMAP_ON) && (defined(_VRCLIGHTVOLUMES_ON) || defined(_VRCLIGHTVOLUMES_ADDITIVE_ONLY) || defined(_VRCLIGHTVOLUMESSPECULAR_ON) || defined(_VRCLIGHTVOLUMESSPECULAR_DOMINANT_DIR))
#if defined(UNITY_PASS_FORWARDBASE) && defined(_LTCGI_ON)
    float3 ltcgiDiffuse = float3(0.0, 0.0, 0.0);
    float3 ltcgiSpecular = float3(0.0, 0.0, 0.0);
    LTCGI_Contribution(
       worldPos,
       worldNormal,
       worldViewDir,
       1.0 - glossiness,
       float2(0.0, 0.0),
       /* inout */ ltcgiDiffuse,
       /* inout */ ltcgiSpecular);
    so.Emission += color.rgb * ltcgiDiffuse + ltcgiSpecular;
#endif  // defined(UNITY_PASS_FORWARDBASE) && defined(_LTCGI_ON)

    half4 outColor = LightingBlinnPhong(so, worldViewDir, gi);
#if defined(UNITY_PASS_FORWARDBASE)
    outColor.rgb += so.Emission;
#endif  // defined(UNITY_PASS_FORWARDBASE)

    return outColor;
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
    so.Emission = fixed3(0.0, 0.0, 0.0);
    so.Specular = LIGHTINGUTILS_SPEC_POWER / 128.0;
    so.Gloss = LIGHTINGUTILS_GLOSSINESS;
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
 * @param [in] ambient  Ambient light.
 * @return Color with lighting applied.
 */
half4 calcLightingUnityStandard(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, half3 ambient)
{
    const half glossiness = LIGHTINGUTILS_GLOSSINESS;
    const half metallic = LIGHTINGUTILS_METALLIC;

    SurfaceOutputStandard so;
    UNITY_INITIALIZE_OUTPUT(SurfaceOutputStandard, so);
    so.Albedo = color.rgb;
    so.Normal = worldNormal;
    so.Emission = half3(0.0, 0.0, 0.0);
    so.Metallic = metallic;
    so.Smoothness = glossiness;
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

#if UNITY_SHOULD_SAMPLE_SH && !defined(LIGHTMAP_ON) && (defined(_VRCLIGHTVOLUMES_ON) || defined(_VRCLIGHTVOLUMES_ADDITIVE_ONLY) || defined(_VRCLIGHTVOLUMESSPECULAR_ON) || defined(_VRCLIGHTVOLUMESSPECULAR_DOMINANT_DIR))
    if (_UdonLightVolumeEnabled && _UdonLightVolumeCount != 0) {
        gi.indirect.diffuse = half3(0.0, 0.0, 0.0);
        so.Emission += calcLightVolumeAmbientAndSpecular(color.rgb, worldPos, worldNormal, worldViewDir, glossiness, metallic, 1.0);
    }
#endif  // UNITY_SHOULD_SAMPLE_SH && !defined(LIGHTMAP_ON) && (defined(_VRCLIGHTVOLUMES_ON) || defined(_VRCLIGHTVOLUMES_ADDITIVE_ONLY) || defined(_VRCLIGHTVOLUMESSPECULAR_ON) || defined(_VRCLIGHTVOLUMESSPECULAR_DOMINANT_DIR))
#if defined(UNITY_PASS_FORWARDBASE) && defined(_LTCGI_ON)
    float3 ltcgiDiffuse = float3(0.0, 0.0, 0.0);
    float3 ltcgiSpecular = float3(0.0, 0.0, 0.0);
    LTCGI_Contribution(
       worldPos,
       worldNormal,
       worldViewDir,
       1.0 - glossiness,
       float2(0.0, 0.0),
       /* inout */ ltcgiDiffuse,
       /* inout */ ltcgiSpecular);
    so.Emission += color.rgb * ltcgiDiffuse + ltcgiSpecular;
#endif  // defined(UNITY_PASS_FORWARDBASE) && defined(_LTCGI_ON)

    half4 outColor = LightingStandard(so, worldViewDir, gi);
#if defined(UNITY_PASS_FORWARDBASE)
    outColor.rgb += so.Emission;
#endif  // defined(UNITY_PASS_FORWARDBASE)

    return outColor;
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
    so.Metallic = LIGHTINGUTILS_METALLIC;
    so.Smoothness = LIGHTINGUTILS_GLOSSINESS;
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
 * @param [in] ambient  Ambient light.
 * @return Color with lighting applied.
 */
half4 calcLightingUnityStandardSpecular(half4 color, float3 worldPos, float3 worldNormal, half atten, float4 lmap, half3 ambient)
{
    const half glossiness = LIGHTINGUTILS_GLOSSINESS;

    SurfaceOutputStandardSpecular so;
    UNITY_INITIALIZE_OUTPUT(SurfaceOutputStandardSpecular, so);
    so.Albedo = color.rgb;
    so.Specular = _SpecColor.rgb;
    so.Normal = worldNormal;
    so.Emission = half3(0.0, 0.0, 0.0);
    so.Smoothness = LIGHTINGUTILS_GLOSSINESS;
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

#if UNITY_SHOULD_SAMPLE_SH && !defined(LIGHTMAP_ON) && (defined(_VRCLIGHTVOLUMES_ON) || defined(_VRCLIGHTVOLUMES_ADDITIVE_ONLY) || defined(_VRCLIGHTVOLUMESSPECULAR_ON) || defined(_VRCLIGHTVOLUMESSPECULAR_DOMINANT_DIR))
    if (_UdonLightVolumeEnabled && _UdonLightVolumeCount != 0) {
        gi.indirect.diffuse = half3(0.0, 0.0, 0.0);
        so.Emission += calcLightVolumeAmbientAndSpecular(color.rgb, worldPos, worldNormal, worldViewDir, glossiness, 0.0, 1.0);
    }
#endif  // UNITY_SHOULD_SAMPLE_SH && !defined(LIGHTMAP_ON) && (defined(_VRCLIGHTVOLUMES_ON) || defined(_VRCLIGHTVOLUMES_ADDITIVE_ONLY) || defined(_VRCLIGHTVOLUMESSPECULAR_ON) || defined(_VRCLIGHTVOLUMESSPECULAR_DOMINANT_DIR))
#if defined(UNITY_PASS_FORWARDBASE) && defined(_LTCGI_ON)
    float3 ltcgiDiffuse = float3(0.0, 0.0, 0.0);
    float3 ltcgiSpecular = float3(0.0, 0.0, 0.0);
    LTCGI_Contribution(
       worldPos,
       worldNormal,
       worldViewDir,
       1.0 - glossiness,
       float2(0.0, 0.0),
       /* inout */ ltcgiDiffuse,
       /* inout */ ltcgiSpecular);
    so.Emission += color.rgb * ltcgiDiffuse + ltcgiSpecular;
#endif  // defined(UNITY_PASS_FORWARDBASE) && defined(_LTCGI_ON)

    half4 outColor = LightingStandardSpecular(so, worldViewDir, gi);
#if defined(UNITY_PASS_FORWARDBASE)
    outColor.rgb += so.Emission;
#endif  // defined(UNITY_PASS_FORWARDBASE)

    return outColor;
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
    so.Smoothness = LIGHTINGUTILS_GLOSSINESS;
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


void calcSHComponents(float3 worldPos, out float3 L0, out float3 L1r, out float3 L1g, out float3 L1b)
{
#if defined(_VRCLIGHTVOLUMES_ON)
    LightVolumeSH(worldPos, /* out */ L0, /* out */ L1r, /* out */ L1g, /* out */ L1b);
#elif defined(_VRCLIGHTVOLUMES_ADDITIVE)
    LightVolumeAdditiveSH(worldPos, /* out */ L0, /* out */ L1r, /* out */ L1g, /* out */ L1b);
#else
    L0 = float3(unity_SHAr.w, unity_SHAg.w, unity_SHAb.w);
    L1r = unity_SHAr.xyz;
    L1g = unity_SHAg.xyz;
    L1b = unity_SHAb.xyz;
#endif  // defined(_VRCLIGHTVOLUMES_ON)
}


/*!
 * @brief Calculate ambient of VRC Light Volumes.
 * @param [in] albedo  Albedo.
 * @param [in] worldPos  World coordinate.
 * @param [in] worldNormal  Normal in world space.
 * @param [in] worldViewDir  View direction in world space.
 * @param [in] glossiness  Smoothness.
 * @param [in] metallic  Metallic.
 * @param [in] occlusion  Occlusion.
 * @return Ambient color.
 */
half3 calcLightVolumeAmbientAndSpecular(half3 albedo, float3 worldPos, float3 worldNormal, float3 worldViewDir, half glossiness, half metallic, half occlusion)
{
#if defined(_VRCLIGHTVOLUMES_ON) || defined(_VRCLIGHTVOLUMES_ADDITIVE_ONLY) || defined(_VRCLIGHTVOLUMESSPECULAR_ON) || defined(_VRCLIGHTVOLUMESSPECULAR_DOMINANT_DIR)
    half3 emission;

    float3 L0, L1r, L1g, L1b;
#    if defined(_VRCLIGHTVOLUMES_ADDITIVE)
    LightVolumeAdditiveSH(worldPos, /* out */ L0, /* out */ L1r, /* out */ L1g, /* out */ L1b);
#    elif defined(_VRCLIGHTVOLUMES_ON)
    LightVolumeSH(worldPos, /* out */ L0, /* out */ L1r, /* out */ L1g, /* out */ L1b);
#    else
    L0 = float3(unity_SHAr.w, unity_SHAg.w, unity_SHAb.w);
    L1r = unity_SHAr.xyz;
    L1g = unity_SHAg.xyz;
    L1b = unity_SHAb.xyz;
#    endif  // defined(_VRCLIGHTVOLUMES_ADDITIVE)

    const float3 lvAmbient = LightVolumeEvaluate(worldNormal, L0, L1r, L1g, L1b) * albedo;
    float3 ambientAndSpecular = lvAmbient - lvAmbient * metallic;

#    if (defined(_VRCLIGHTVOLUMESSPECULAR_ON) || defined(_VRCLIGHTVOLUMESSPECULAR_DOMINANT_DIR)) && (defined(_LIGHTING_UNITY_STANDARD) || defined(_LIGHTING_UNITY_STANDARD_SPECULAR) || defined(_LIGHTING_UNITY_BLINN_PHONG))
#        if defined(_VRCLIGHTVOLUMESSPECULAR_DOMINANT_DIR)
    ambientAndSpecular += LightVolumeSpecularDominant(albedo, glossiness, metallic, worldNormal, worldViewDir, L0, L1r, L1g, L1b) * occlusion;
#        else
    ambientAndSpecular += LightVolumeSpecular(albedo, glossiness, metallic, worldNormal, worldViewDir, L0, L1r, L1g, L1b) * occlusion;
#        endif  // defined(_VRCLIGHTVOLUMESSPECULAR_DOMINANT_DIR)
#    endif  // (defined(_VRCLIGHTVOLUMESSPECULAR_ON) || defined(_VRCLIGHTVOLUMESSPECULAR_DOMINANT_DIR)) && (defined(_LIGHTING_UNITY_STANDARD) || defined(_LIGHTING_UNITY_STANDARD_SPECULAR) || defined(_LIGHTING_UNITY_BLINN_PHONG))

    return ambientAndSpecular * occlusion;
#else
    return half3(0.0, 0.0, 0.0);
#endif  // defined(_VRCLIGHTVOLUMES_ON) || defined(_VRCLIGHTVOLUMES_ADDITIVE_ONLY) || defined(_VRCLIGHTVOLUMESSPECULAR_ON) || defined(_VRCLIGHTVOLUMESSPECULAR_DOMINANT_DIR)
}


#endif  // !defined(LIGHTINGUTILS_INCLUDED)
