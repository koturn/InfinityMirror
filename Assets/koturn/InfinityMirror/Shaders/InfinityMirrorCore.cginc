#ifndef INFINITY_MIRROR_CORE_INCLUDED
#define INFINITY_MIRROR_CORE_INCLUDED


#include "include/AltUnityCG.cginc"
#include "include/AltUnityStandardUtils.cginc"
#include "include/VertCommon.cginc"
#include "include/LightingUtils.cginc"


#if defined(SHADER_API_D3D11_9X)
#    undef _FLIPNORMAL_ON
#endif  // defined(SHADER_API_D3D11_9X)

#if defined(_SVDEPTH_GREATEREQUAL)
#    if SHADER_TARGET >= 45
#        define DEPTH_SEMANTICS SV_DepthGreaterEqual
#    else
#        define DEPTH_SEMANTICS SV_Depth
#    endif  // SHADER_TARGET >= 45
#elif defined(_SVDEPTH_LESSEQUAL)
#    if SHADER_TARGET >= 45
#        define DEPTH_SEMANTICS SV_DepthLessEqual
#    else
#        define DEPTH_SEMANTICS SV_Depth
#    endif  // SHADER_TARGET >= 45
#else
#    define DEPTH_SEMANTICS SV_Depth
#endif  // defined(_SVDEPTH_ON)


/*!
 * @brief Output of fragment shader.
 * @see frag
 */
struct fout_infmirror
{
    //! Output color of the pixel.
    half4 color : SV_Target;
#if (defined(_SVDEPTH_ON) || defined(_SVDEPTH_LESSEQUAL) || defined(_SVDEPTH_GREATEREQUAL)) && (!defined(SHADOWS_CUBE) || defined(SHADOWS_CUBE_IN_DEPTH_TEX))
    //! Depth of the pixel.
    float depth : DEPTH_SEMANTICS;
#endif  // (defined(_SVDEPTH_ON) || defined(_SVDEPTH_LESSEQUAL) || defined(_SVDEPTH_GREATEREQUAL)) && (!defined(SHADOWS_CUBE) || defined(SHADOWS_CUBE_IN_DEPTH_TEX))
};

/*!
 * @brief G-Buffer data which is output of fragDeferred.
 * @see fragDeferred
 */
struct gbuffer_infmirror
{
    //! Diffuse and occlustion. (rgb: diffuse, a: occlusion)
    half4 diffuse : SV_Target0;
    //! Specular and smoothness. (rgb: specular, a: smoothness)
    half4 specular : SV_Target1;
    //! Normal. (rgb: normal, a: unused)
    half4 normal : SV_Target2;
    //! Emission. (rgb: emission, a: unused)
    half4 emission : SV_Target3;
#if defined(_SVDEPTH_ON) || defined(_SVDEPTH_LESSEQUAL) || defined(_SVDEPTH_GREATEREQUAL)
    //! Depth of the pixel.
    float depth : DEPTH_SEMANTICS;
#endif  // defined(_SVDEPTH_ON) || defined(_SVDEPTH_LESSEQUAL) || defined(_SVDEPTH_GREATEREQUAL)
};

#if defined(SHADER_API_GLCORE) || defined(SHADER_API_GLES) || defined(SHADER_API_D3D9)
typedef fixed face_t;
#    define FACE_SEMANTICS VFACE
#else
typedef bool face_t;
#    define FACE_SEMANTICS SV_IsFrontFace
#endif  // defined(SHADER_API_GLCORE) || defined(SHADER_API_GLES) || defined(SHADER_API_D3D9)


UNITY_INSTANCING_BUFFER_START(InfinityMirrorProps)
//! Tint color for Main texture.
UNITY_DEFINE_INSTANCED_PROP(float4, _Color)
//! Hue Shift Speed.
UNITY_DEFINE_INSTANCED_PROP(float, _HueShiftSpeed)
//! Step depth.
UNITY_DEFINE_INSTANCED_PROP(float, _StepDepth)
//! Color coefficient.
UNITY_DEFINE_INSTANCED_PROP(float, _ColorCoeff)
UNITY_INSTANCING_BUFFER_END(InfinityMirrorProps)


float getDepth(float4 clipPos);
bool isFacing(face_t face);
half3 rgb2hsv(half3 rgb);
half3 hsv2rgb(half3 hsv);
half3 rgbAddHue(half3 rgb, half hue);


#if defined(UNITY_PASS_FORWARDADD) && (defined(_FORWARDADD_OFF) || defined(_LIGHTING_UNLIT))
/*!
 * @brief Fragment shader function.
 * @param [in] fi  Input data from vertex shader
 * @return Output of each texels (fout_raymarching).
 */
half4 fragInfinityMirror() : SV_Target
{
    return half4(0.0, 0.0, 0.0, 0.0);
}
#else
#    if defined(_FLIPNORMAL_ON)
#        if defined(UNITY_PASS_DEFERRED)
/*!
 * @brief Fragment shader function.
 * @param [in] fi  Input data from vertex shader.
 * @param [in] facing  Facing parameter.
 * @return G-Buffer data.
 */
gbuffer_infmirror fragInfinityMirror(v2f_infmirror fi, face_t facing : FACE_SEMANTICS)
#        else
/*!
 * @brief Fragment shader function.
 * @param [in] fi  Input data from vertex shader.
 * @param [in] facing  Facing parameter.
 * @return Color and depth of texel.
 */
fout_infmirror fragInfinityMirror(v2f_infmirror fi, face_t facing : FACE_SEMANTICS)
#        endif  // defined(UNITY_PASS_DEFERRED)
#    else
#        if defined(UNITY_PASS_DEFERRED)
/*!
 * @brief Fragment shader function.
 * @param [in] fi  Input data from vertex shader.
 * @return G-Buffer data.
 */
gbuffer_infmirror fragInfinityMirror(v2f_infmirror fi)
#        else
/*!
 * @brief Fragment shader function.
 * @param [in] fi  Input data from vertex shader.
 * @return Color and depth of texel.
 */
fout_infmirror fragInfinityMirror(v2f_infmirror fi)
#        endif  // defined(UNITY_PASS_DEFERRED)
#    endif  // defined(_FLIPNORMAL_ON)
{
    UNITY_SETUP_INSTANCE_ID(fi);
    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(fi);

#    if defined(_FLIPNORMAL_ON)
    fi.normal = isFacing(facing) ? fi.normal : -fi.normal;
#    endif  // defined(_FLIPNORMAL_ON)

    const float3 rayDir = normalize(fi.rayDirVec);
    const float3 tangentRayDir = float3(
        dot(fi.tangent, rayDir),
        dot(fi.binormal, rayDir),
        dot(fi.normal, rayDir));
    const float3 objectRayDir = mul((float3x3)unity_WorldToObject, rayDir);
    const float stepDepth = UNITY_ACCESS_INSTANCED_PROP(InfinityMirrorProps, _StepDepth) * rsqrt(dot(objectRayDir, objectRayDir));

    int rayStep = 0;
    const bool isHit = RAYMARCH(tangentRayDir, stepDepth, fi.uv, /* out */ rayStep);

    if (!isHit) {
#    if !defined(_OVERCLIP_OFF)
        discard;
#    endif  // !defined(_OVERCLIP_OFF)
    }

#    if defined(_HUESHIFT_ON)
    half4 color = UNITY_ACCESS_INSTANCED_PROP(InfinityMirrorProps, _Color);
    color.rgb = rgbAddHue(_Color.rgb, _Time * UNITY_ACCESS_INSTANCED_PROP(InfinityMirrorProps, _HueShiftSpeed));
#    else
    half4 color = UNITY_ACCESS_INSTANCED_PROP(InfinityMirrorProps, _Color);
#    endif  // defined(_HUESHIFT_ON)
    color *= UNITY_ACCESS_INSTANCED_PROP(InfinityMirrorProps, _ColorCoeff) * rayStep;

    const float3 finalWorldPos = fi.worldPos + rayDir * stepDepth * rayStep;

#    if defined(UNITY_PASS_DEFERRED)
    gbuffer_infmirror gb;
    UNITY_INITIALIZE_OUTPUT(gbuffer_infmirror, gb);
#    endif  // defined(UNITY_PASS_DEFERRED)

    UNITY_BRANCH
    if (isHit) {
#    if defined(LIGHTMAP_ON)
#        if defined(DYNAMICLIGHTMAP_ON)
        const float4 lmap = fi.lmap;
#        else
        const float4 lmap = float4(fi.lmap, 0.0, 0.0);
#        endif  // defined(DYNAMICLIGHTMAP_ON)
        const half3 ambient = half3(0.0, 0.0, 0.0);
#    elif defined(UNITY_SHOULD_SAMPLE_SH)
        const float4 lmap = float4(0.0, 0.0, 0.0, 0.0);
        const half3 ambient = fi.ambient;
#    else
        const float4 lmap = float4(0.0, 0.0, 0.0, 0.0);
        const half3 ambient = half3(0.0, 0.0, 0.0);
#    endif  // defined(LIGHTMAP_ON)
        UNITY_LIGHT_ATTENUATION(atten, fi, finalWorldPos);
#    if defined(UNITY_PASS_DEFERRED)
        color = calcLightingUnityDeferred(color, finalWorldPos, fi.normal, atten, lmap, ambient, /* out */ gb.diffuse, /* out */ gb.specular, /* out */ gb.normal);
#    else
        color = calcLightingUnity(color, finalWorldPos, fi.normal, atten, lmap, ambient);
#    endif  // defined(UNITY_PASS_DEFERRED)
    }

    const float4 clipPos = UnityWorldToClipPos(finalWorldPos);

    UNITY_APPLY_FOG(clipPos.z, color);

#    if defined(UNITY_PASS_DEFERRED)
    gb.emission = color;
#        if defined(_SVDEPTH_ON) || defined(_SVDEPTH_LESSEQUAL) || defined(_SVDEPTH_GREATEREQUAL)
    gb.depth = getDepth(clipPos);
#        endif  // defined(_SVDEPTH_ON) || defined(_SVDEPTH_LESSEQUAL) || defined(_SVDEPTH_GREATEREQUAL)
    return gb;
#    else
    fout_infmirror fo;
    fo.color = color;
#        if (defined(_SVDEPTH_ON) || defined(_SVDEPTH_LESSEQUAL) || defined(_SVDEPTH_GREATEREQUAL)) && (!defined(SHADOWS_CUBE) || defined(SHADOWS_CUBE_IN_DEPTH_TEX))
    fo.depth = getDepth(clipPos);
#        endif  // (defined(_SVDEPTH_ON) || defined(_SVDEPTH_LESSEQUAL) || defined(_SVDEPTH_GREATEREQUAL)) && (!defined(SHADOWS_CUBE) || defined(SHADOWS_CUBE_IN_DEPTH_TEX))
    return fo;
#    endif  // defined(UNITY_PASS_DEFERRED)
}
#endif  // defined(UNITY_PASS_FORWARDADD) && (defined(_FORWARDADD_OFF) || defined(_LIGHTING_UNLIT))


/*!
 * @brief Fragment shader function for ShadowCaster pass.
 * @param [in] fi  Input data from vertex shader.
 * @return Color of texel.
 */
fixed4 fragInfinityMirrorShadowCaster(v2f_infmirror_shadowcaster fi) : SV_Target
{
    UNITY_SETUP_INSTANCE_ID(fi);
    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(fi);

    SHADOW_CASTER_FRAGMENT(fi)
}



/*!
 * @brief Get depth from projected position.
 * @param [in] clipPos  Clip space position.
 * @return Depth value.
 */
float getDepth(float4 clipPos)
{
    const float depth = clipPos.z / clipPos.w;
#if defined(SHADER_API_GLCORE) \
    || defined(SHADER_API_OPENGL) \
    || defined(SHADER_API_GLES) \
    || defined(SHADER_API_GLES3)
    // [-1.0, 1.0] -> [0.0, 1.0]
    // Near: -1.0
    // Far: -1.0
    return depth * 0.5 + 0.5;
#else
    // [0.0, 1.0] -> [0.0, 1.0] (No conversion)
    // Near: 1.0
    // Far: 0.0
    return depth;
#endif
}


/*!
 * @brief Identify whether surface is facing the camera or facing away from the camera.
 * @param [in] facing  Facing variable (fixed or bool).
 * @return True if surface facing the camera, otherwise false.
 */
bool isFacing(face_t facing)
{
#if defined(SHADER_API_GLCORE) || defined(SHADER_API_GLES) || defined(SHADER_API_D3D9)
    return facing >= 0.0;
#else
    return facing;
#endif  // defined(SHADER_API_GLCORE) || defined(SHADER_API_GLES) || defined(SHADER_API_D3D9)
}


/*!
 * @brief Convert from RGB to HSV.
 *
 * @param [in] rgb  Three-dimensional vector of RGB.
 * @return Three-dimensional vector of HSV.
 */
half3 rgb2hsv(half3 rgb)
{
    static const half4 k = half4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    static const half e = 1.0e-5;

#if 1
    // Optimized version.
    const bool b1 = rgb.g < rgb.b;
    half4 p = half4(b1 ? rgb.bg : rgb.gb, b1 ? k.wz : k.xy);

    const bool b2 = rgb.r < p.x;
    p.xyz = b2 ? p.xyw : p.yzx;
    const half4 q = b2 ? half4(p.xyz, rgb.r) : half4(rgb.r, p.xyz);

    const half d = q.x - min(q.w, q.y);
    const half2 hs = half2(q.w - q.y, d) / half2(6.0 * d + e, q.x + e);

    return half3(abs(q.z + hs.x), hs.y, q.x);
#else
    const half4 p = rgb.g < rgb.b ? half4(rgb.bg, k.wz) : half4(rgb.gb, k.xy);
    const half4 q = rgb.r < p.x ? half4(p.xyw, rgb.r) : half4(rgb.r, p.yzx);
    const half d = q.x - min(q.w, q.y);
    return half3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
#endif
}


/*!
 * @brief Convert from HSV to RGB.
 *
 * @param [in] hsv  Three-dimensional vector of HSV.
 * @return Three-dimensional vector of RGB.
 */
half3 hsv2rgb(half3 hsv)
{
    static const half4 k = half4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);

    const half3 p = abs(frac(hsv.xxx + k.xyz) * 6.0 - k.www);
    return hsv.z * lerp(k.xxx, saturate(p - k.xxx), hsv.y);
}


/*!
 * @brief Add hue to RGB color.
 *
 * @param [in] rgb  Three-dimensional vector of RGB.
 * @param [in] hue  Scalar of hue.
 * @return Three-dimensional vector of RGB.
 */
half3 rgbAddHue(half3 rgb, half hue)
{
    half3 hsv = rgb2hsv(rgb);
    hsv.x += hue;
    return hsv2rgb(hsv);
}


#endif  // INFINITY_MIRROR_CORE_INCLUDED
