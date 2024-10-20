namespace Koturn.InfinityMirror.Enums
{
    /// <summary>
    /// Lighting methods.
    /// </summary>
    public enum LightingMethod
    {
        /// <summary>
        /// Lighting with Lambert Reflection Model.
        /// </summary>
        UnityLambert = 0,
        /// <summary>
        /// Lighting with Blinn-Phong Reflection Model.
        /// </summary>
        UnityBlinnPhong = 1,
        /// <summary>
        /// Lighting with Unity PBS.
        /// </summary>
        UnityStandard = 2,
        /// <summary>
        /// Lighting with Unity PBS Specular.
        /// </summary>
        UnityStandardSpecular = 3,
        /// <summary>
        /// No lighting.
        /// </summary>
        Unlit = 4
    }
}
