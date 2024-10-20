#ifndef ALT_UNITY_STANDARD_UTILS_INCLUDED
#define ALT_UNITY_STANDARD_UTILS_INCLUDED


#include "UnityStandardUtils.cginc"


#define BoxProjectedCubemapDirection BoxProjectedCubemapDirectionAlt


float3 BoxProjectedCubemapDirectionAlt(float3 worldRefDir, float3 worldPos, float4 probePos, float4 boxMin, float4 boxMax);


/*!
 * @brief Obtain reflection direction considering box projection.
 *
 * This function is more efficient than BoxProjectedCubemapDirection() in UnityStandardUtils.cginc.
 *
 * @param [in] worldRefDir  Refrection dir (must be normalized).
 * @param [in] worldPos  World coordinate.
 * @param [in] probePos  Position of Refrection probe.
 * @param [in] boxMin  Position of Refrection probe.
 * @param [in] boxMax  Position of Refrection probe.
 * @return Refrection direction considering box projection.
 */
float3 BoxProjectedCubemapDirectionAlt(float3 worldRefDir, float3 worldPos, float4 probePos, float4 boxMin, float4 boxMax)
{
    // UNITY_SPECCUBE_BOX_PROJECTION is defined if
    // "Reflection Probes Box Projection" of GraphicsSettings is enabled.
#if defined(UNITY_SPECCUBE_BOX_PROJECTION)
    // probePos.w == 1.0 if Box Projection is enabled.
    UNITY_BRANCH
    if (probePos.w > 0.0) {
        const float3 magnitudes = ((worldRefDir > float3(0.0, 0.0, 0.0) ? boxMax.xyz : boxMin.xyz) - worldPos) / worldRefDir;
        return worldRefDir * min(magnitudes.x, min(magnitudes.y, magnitudes.z)) + (worldPos - probePos.xyz);
    } else {
        return worldRefDir;
    }
#else
    return worldRefDir;
#endif  // defined(UNITY_SPECCUBE_BOX_PROJECTION)
}


#endif  // ALT_UNITY_STANDARD_UTILS_INCLUDED
