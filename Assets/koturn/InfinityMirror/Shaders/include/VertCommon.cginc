#ifndef VERT_COMMON_INCLUDED
#define VERT_COMMON_INCLUDED


#include "AutoLight.cginc"


/*!
 * @brief Input data type for vertex shader function, vert().
 * @see vertInfinityMirror
 */
struct appdata_infmirror
{
    //! Object space position of the vertex.
    float4 vertex : POSITION;
    //! Object space tangent of the vertex.
    float4 tangent : TANGENT;
    //! Normal vector of the vertex.
    float3 normal : NORMAL;
    //! UV coordinate of the vertex.
    float4 texcoord : TEXCOORD0;
#if defined(LIGHTMAP_ON)
    //! Lightmap coordinate.
    float4 texcoord1 : TEXCOORD1;
#endif  // defined(LIGHTMAP_ON)
#if defined(DYNAMICLIGHTMAP_ON)
    //! Dynamic Lightmap coordinate.
    float4 texcoord2 : TEXCOORD2;
#endif  // defined(DYNAMICLIGHTMAP_ON)
    UNITY_VERTEX_INPUT_INSTANCE_ID
};


/*!
 * @brief Input of the vertex shader, vertShadowCaster().
 * @see vertInfinityMirrorShadowCaster
 */
struct appdata_infmirror_shadowcaster
{
    //! Object space position of the vertex.
    float4 vertex : POSITION;
#if !defined(SHADOWS_CUBE) || defined(SHADOWS_CUBE_IN_DEPTH_TEX)
    //! Normal vector of the vertex.
    float3 normal : NORMAL;
#endif
    //! instanceID for single pass instanced rendering.
    UNITY_VERTEX_INPUT_INSTANCE_ID
};


/*!
 * @brief Output of the vertex shader, vert()
 * and input of fragment shader, frag().
 * @see vert
 * @see frag
 */
struct v2f_infmirror
{
    //! Clip space position.
    float4 pos : SV_POSITION;
    //! UV coordinate.
    float2 uv : TEXCOORD0;
    //! World space position.
    float3 worldPos: TEXCOORD1;
    //! World space normal.
    float3 normal : TEXCOORD2;
    //! World space tangent.
    float3 tangent : TEXCOORD3;
    //! World space normal.
    float3 binormal : TEXCOORD4;
    //! Unnormalized world space ray direction.
    float3 rayDirVec : TEXCOORD5;
#if defined(LIGHTMAP_ON)
#    if defined(DYNAMICLIGHTMAP_ON)
    //! Lightmap and Dynamic Lightmap coordinate.
    float4 lmap: TEXCOORD7;
#    else
    //! Lightmap coordinate.
    float2 lmap: TEXCOORD7;
#    endif  // defined(DYNAMICLIGHTMAP_ON)
#elif defined(UNITY_SHOULD_SAMPLE_SH)
    //! Ambient light color.
    half3 ambient: TEXCOORD7;
#endif  // defined(LIGHTMAP_ON)
    //! Members abourt ligting coordinates, _LightCoord and _ShadowCoord.
    UNITY_LIGHTING_COORDS(8, 9)
    //! Member abourt fog coordinates, _fogCoord.
    UNITY_FOG_COORDS(10)
    //! Instance ID for single pass instanced rendering, instanceID.
    UNITY_VERTEX_INPUT_INSTANCE_ID
    //! Stereo target eye index for single pass instanced rendering, stereoTargetEyeIndex.
    UNITY_VERTEX_OUTPUT_STEREO
};


/*!
 * @brief Output of the vertex shader, vertShadowCaster()
 * and input of fragment shader, fragShadowCaster().
 * @see vertInfinityMirrorShadowCaster
 * @see fragInfinityMirrorShadowCaster
 */
struct v2f_infmirror_shadowcaster
{
    //! Shadow caster members.
    V2F_SHADOW_CASTER;
    //! instanceID for single pass instanced rendering.
    UNITY_VERTEX_INPUT_INSTANCE_ID
    //! stereoTargetEyeIndex for single pass instanced rendering.
    UNITY_VERTEX_OUTPUT_STEREO
};


//! Main texture.
UNITY_DECLARE_TEX2D(_MainTex);
//! Tiling and offset values of _MainTex.
uniform float4 _MainTex_ST;


/*!
 * @brief Vertex shader function.
 * @param [in] v  Input data.
 * @return Interpolation source data for fragment shader function, frag().
 */
v2f_infmirror vertInfinityMirror(appdata_infmirror v)
{
    v2f_infmirror o;
    UNITY_INITIALIZE_OUTPUT(v2f_infmirror, o);

    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_TRANSFER_INSTANCE_ID(v, o);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

    // World
    const float3 vertPos = mul(unity_ObjectToWorld, v.vertex).xyz;
    const float3 rayDirVec = vertPos - _WorldSpaceCameraPos;
    const float3 normal = UnityObjectToWorldNormal(v.normal);
    const float3 tangent = mul(unity_ObjectToWorld, v.tangent.xyz);
    const float3 binormal = cross(normal, tangent) * v.tangent.w * unity_WorldTransformParams.w;
    o.rayDirVec = float3(
        dot(tangent, rayDirVec),
        dot(binormal, rayDirVec),
        dot(normal, rayDirVec));
    o.normal = normal;
    o.tangent = tangent;
    o.binormal = binormal;

    o.pos = UnityObjectToClipPos(v.vertex);
    #if defined(NO_TEXTURE)
    o.uv = v.texcoord;
    #else
    o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
    #endif
    o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

    half4 ambientOrLightmapUV = half4(0.0, 0.0, 0.0, 0.0);
    // Static lightmaps
    #if defined(LIGHTMAP_ON)
    o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
    #    if defined(DYNAMICLIGHTMAP_ON)
    o.lmap.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
    #    endif  // defined(DYNAMICLIGHTMAP_ON)
    #elif UNITY_SHOULD_SAMPLE_SH
    #    if defined(VERTEXLIGHT_ON)
    // Approximated illumination from non-important point lights
    o.ambient.rgb = Shade4PointLights(
        unity_4LightPosX0,
        unity_4LightPosY0,
        unity_4LightPosZ0,
        unity_LightColor[0].rgb,
        unity_LightColor[1].rgb,
        unity_LightColor[2].rgb,
        unity_LightColor[3].rgb,
        unity_4LightAtten0,
        o.worldPos,
        v.normal);
    #    endif  // defined(VERTEXLIGHT_ON)
    o.ambient.rgb = ShadeSHPerVertex(v.normal, o.ambient.rgb);
    #endif  // defined(LIGHTMAP_ON)

    // UNITY_TRANSFER_LIGHTING(o, v.uv2);
    UNITY_TRANSFER_FOG(o, o.pos);

    return o;
}


/*!
 * @brief Vertex shader function for ShadowCaster pass.
 * @param [in] v  Input data.
 * @return Interpolation source data for fragment shader function, fragShadowCaster().
 */
v2f_infmirror_shadowcaster vertInfinityMirrorShadowCaster(appdata_infmirror_shadowcaster v)
{
    v2f_infmirror_shadowcaster o;
    UNITY_INITIALIZE_OUTPUT(v2f_infmirror_shadowcaster, o);

    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_TRANSFER_INSTANCE_ID(v, o);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

    TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)

    return o;
}


#endif  // VERT_COMMON_INCLUDED
