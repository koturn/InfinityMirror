Shader "koturn/InfinityMirror/KoturnSDF"
{
    Properties
    {
        // ------------------------------------------------------------
        [Header(Shape and Color)]
        [Space(8)]

        _EdgeWidth ("Edge width", Range(0.0, 1.0)) = 0.05

        [Vector3]
        _CoeffsA ("Coefficient vector A", Vector) = (2.0, 10.0, 6.0, 0.0)

        [Vector3]
        _CoeffsB ("Coefficient vector B", Vector) = (1.0, 2.0, 1.0, 0.0)

        _Color ("Tint color for Main texture", Color) = (1.0, 1.0, 1.0, 1.0)

        [Toggle(_HUESHIFT_ON)]
        _HueShift ("Hue Shift", Int) = 0
        _HueShiftSpeed ("Hue Shift Speed", Range(0.0, 100.0)) = 1.0

        // ------------------------------------------------------------
        [Header(Ray Marching Parameters)]
        [Space(8)]

        [IntRange]
        _MaxLoop ("Maximum loop count", Range(1, 128)) = 16
        _StepDepth ("Step depth", Range(0.0, 32.0)) = 0.15
        _ColorCoeff ("Color coefficient", Range(0.0, 10.0)) = 1.0

        [ToggleOff(_OVERCLIP_OFF)]
        _OverClip ("Clip overshooting position", Int) = 0

        // ------------------------------------------------------------
        [Header(Lighting Parameters)]
        [Space(8)]

        [KeywordEnum(Unity Lambert, Unity Blinn Phong, Unity Standard, Unity Standard Specular, Unlit)]
        _Lighting ("Lighting method", Int) = 2

        _Glossiness ("Smoothness", Range(0.0, 1.0)) = 0.5
        _Metallic ("Metallic", Range(0.0, 1.0)) = 0.0

        _SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1.0)
        _SpecPower ("Specular Power", Range(0.0, 128.0)) = 16.0

        [KeywordEnum(Off, On, Additive Only)]
        _VRCLightVolumes ("VRC Light Volumes", Int) = 1

        [KeywordEnum(Off, On, Dominant Dir)]
        _VRCLightVolumesSpecular ("VRC Light Volumes Specular", Int) = 0

        [Toggle(_LTCGI_ON)]
        _LTCGI ("LTCGI", Int) = 0


        // ------------------------------------------------------------
        [Header(Rendering Parameters)]
        [Space(8)]

        [Toggle(_FLIPNORMAL_ON)]
        _FlipNormal ("Flip Backface Normal", Int) = 0

        [ToggleOff(_SVDEPTH_OFF)]
        _SvDepth ("Enable depth ouput", Int) = 0

        [ToggleOff(_FORWARDADD_OFF)]
        _ForwardAdd ("Enable ForwardAdd Pass", Int) = 1

        [Enum(UnityEngine.Rendering.CullMode)]
        _Cull ("Culling Mode", Int) = 2  // Default: Back

        [Enum(UnityEngine.Rendering.CompareFunction)]
        _ZTest ("ZTest", Int) = 4  // Default: LEqual

        [Enum(False, 0, True, 1)]
        _ZClip ("ZClip", Int) = 1  // Default: True

        _OffsetFactor ("Offset Factor", Range(-1.0, 1.0)) = 0
        _OffsetUnit ("Offset Units", Range(-1.0, 1.0)) = 0

        [ColorMask]
        _ColorMask ("Color Mask", Int) = 15  // Default: RGBA

        [Enum(Off, 0, On, 1)]
        _AlphaToMask ("Alpha To Mask", Int) = 0  // Default: Off


        // ------------------------------------------------------------
        [Header(Stencil Parameters)]
        [Space(8)]

        [IntRange]
        _StencilRef ("Stencil Reference Value", Range(0, 255)) = 0

        [IntRange]
        _StencilReadMask ("Stencil ReadMask Value", Range(0, 255)) = 255

        [IntRange]
        _StencilWriteMask ("Stencil WriteMask Value", Range(0, 255)) = 255

        [Enum(UnityEngine.Rendering.CompareFunction)]
        _StencilComp ("Stencil Compare Function", Int) = 8  // Default: Always

        [Enum(UnityEngine.Rendering.StencilOp)]
        _StencilPass ("Stencil Pass", Int) = 0  // Default: Keep

        [Enum(UnityEngine.Rendering.StencilOp)]
        _StencilFail ("Stencil Fail", Int) = 0  // Default: Keep

        [Enum(UnityEngine.Rendering.StencilOp)]
        _StencilZFail ("Stencil ZFail", Int) = 0  // Default: Keep
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "Queue" = "Geometry"
            // "DisableBatching" = "True"
            // "IgnoreProjector" = "False"
            "PreviewType" = "Plane"
            "VRCFallback" = "Hidden"
            "LTCGI" = "_LTCGI"
        }

        ZTest [_ZTest]
        ZClip [_ZClip]
        Offset [_OffsetFactor], [_OffsetUnit]
        ColorMask [_ColorMask]
        AlphaToMask [_AlphaToMask]

        Stencil
        {
            Ref [_StencilRef]
            ReadMask [_StencilReadMask]
            WriteMask [_StencilWriteMask]
            Comp [_StencilComp]
            Pass [_StencilPass]
            Fail [_StencilFail]
            ZFail [_StencilZFail]
        }

        CGINCLUDE
        #pragma target 3.0

        #define NO_TEXTURE
        #define RAYMARCH rayMarch
        bool rayMarch(float3 rayDir, float stepDepth, float2 uv, out int rayStep);
        #include "InfinityMirrorCore.cginc"


        //! Maximum loop count
        uniform int _MaxLoop;
        //! Edge width.
        uniform float _EdgeWidth;
        //! Coefficient vector A.
        uniform float3 _CoeffsA;
        //! Coefficient vector B.
        uniform float3 _CoeffsB;


        bool checkHit(float2 p);
        float map(float2 p);


        /*!
         * @brief Ray marching on tangent space.
         * @param [in] rayDir  Ray direction.
         * @param [in] stepDepth  Ray step length.
         * @param [in] uv  UV-coordinate.
         * @param [out] rayStep  Number of ray steps.
         * @return True if the ray hits, otherwise false.
         */
        bool rayMarch(float3 rayDir, float stepDepth, float2 uv, out int rayStep)
        {
            rayStep = 0;

            for (rayStep = 0; rayStep < _MaxLoop; rayStep++) {
                UNITY_FLATTEN
                if (checkHit(uv)) {
                    return true;
                }
                uv.xy += rayDir.xy * stepDepth;
            }

            return false;
        }


        /*!
         * @brief Check whether the ray hits object or not.
         * @param [in] p  Position.
         * @return True if the rays hits, otherwise false.
         */
        bool checkHit(float2 p)
        {
            if (any(abs(p * 2.0 - 1.0) > (1.0 - _EdgeWidth.xx * 2.0))) {
                return true;
            }
            return map(p) < 0.0;
        }


        /*!
         * @brief 2D-SDF of koturn's mark.
         * @param [in] p  Position.
         * @return Signed Distance to the koturn's mark.
         */
        float map(float2 p)
        {
            p = p * 10.0 - 5.0;
            const float2 pp = p * p;
            const float sumXY = p.x + p.y;
            const float a = abs(pp.x + pp.y - _CoeffsA.x * sumXY - _CoeffsA.y) + sumXY - _CoeffsA.z;

            const float2 absP = abs(p);
            const float b = max(absP.x, absP.y - _CoeffsB.x) + (_CoeffsB.y * abs(absP.x - absP.y) - _CoeffsB.z);

            return a / b;
        }
        ENDCG


        Pass
        {
            Name "FORWARD_BASE"
            Tags
            {
                "LightMode" = "ForwardBase"
            }

            Cull [_Cull]
            Blend One Zero
            ZWrite On

            CGPROGRAM
            #pragma vertex vertInfinityMirror
            #pragma fragment fragInfinityMirror

            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #pragma shader_feature_local_fragment _ _HUESHIFT_ON
            #pragma shader_feature_local_fragment _ _SVDEPTH_OFF
            #pragma shader_feature_local_fragment _ _OVERCLIP_OFF
            #pragma shader_feature_local_fragment _LIGHTING_UNITY_LAMBERT _LIGHTING_UNITY_BLINN_PHONG _LIGHTING_UNITY_STANDARD _LIGHTING_UNITY_STANDARD_SPECULAR _LIGHTING_UNLIT
            #pragma shader_feature_local_fragment _ _FLIPNORMAL_ON
            #pragma shader_feature_local_fragment _VRCLIGHTVOLUMES_OFF _VRCLIGHTVOLUMES_ON _VRCLIGHTVOLUMES_ADDITIVE_ONLY
            #pragma shader_feature_local_fragment _VRCLIGHTVOLUMESSPECULAR_OFF _VRCLIGHTVOLUMESSPECULAR_ON _VRCLIGHTVOLUMESSPECULAR_DOMINANT_DIR
            #pragma shader_feature_local_fragment _ _LTCGI_ON
            ENDCG
        }

        Pass
        {
            Name "FORWARD_ADD"
            Tags
            {
                "LightMode" = "ForwardAdd"
            }

            Cull [_Cull]
            Blend One One
            ZWrite Off

            CGPROGRAM
            #pragma vertex vertInfinityMirror
            #pragma fragment fragInfinityMirror

            // #pragma multi_compile_fwdadd
            #pragma multi_compile_fwdadd_fullshadow
            #pragma multi_compile_fog
            #pragma shader_feature_local _ _FORWARDADD_OFF
            #pragma shader_feature_local_fragment _ _HUESHIFT_ON
            #pragma shader_feature_local_fragment _ _SVDEPTH_OFF
            #pragma shader_feature_local_fragment _ _OVERCLIP_OFF
            #pragma shader_feature_local_fragment _LIGHTING_UNITY_LAMBERT _LIGHTING_UNITY_BLINN_PHONG _LIGHTING_UNITY_STANDARD _LIGHTING_UNITY_STANDARD_SPECULAR _LIGHTING_UNLIT
            #pragma shader_feature_local_fragment _ _FLIPNORMAL_ON
            ENDCG
        }

        Pass
        {
            Name "DEFERRED"
            Tags
            {
                "LightMode" = "Deferred"
            }

            Cull [_Cull]
            Blend Off
            ZWrite On

            CGPROGRAM
            #pragma vertex vertInfinityMirror
            #pragma fragment fragInfinityMirror

            #pragma exclude_renderers nomrt

            #pragma multi_compile_prepassfinal
            #pragma multi_compile_fog
            #pragma shader_feature_local_fragment _ _HUESHIFT_ON
            #pragma shader_feature_local_fragment _ _SVDEPTH_OFF
            #pragma shader_feature_local_fragment _ _OVERCLIP_OFF
            #pragma shader_feature_local_fragment _LIGHTING_UNITY_LAMBERT _LIGHTING_UNITY_BLINN_PHONG _LIGHTING_UNITY_STANDARD _LIGHTING_UNITY_STANDARD_SPECULAR _LIGHTING_UNLIT
            #pragma shader_feature_local_fragment _ _FLIPNORMAL_ON
            ENDCG
        }

        Pass
        {
            Name "SHADOW_CASTER"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }

            Cull Back
            Blend Off
            ZWrite On

            CGPROGRAM
            #pragma vertex vertInfinityMirrorShadowCaster
            #pragma fragment fragInfinityMirrorShadowCaster

            #pragma multi_compile_shadowcaster
            ENDCG
        }
    }

    CustomEditor "Koturn.InfinityMirror.Inspectors.KoturnSDFGUI"
}
