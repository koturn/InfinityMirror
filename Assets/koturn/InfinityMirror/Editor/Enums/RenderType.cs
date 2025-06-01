namespace Koturn.InfinityMirror.Enums
{
    /// <summary>
    /// Render Type.
    /// </summary>
    /// <remarks>
    /// <seealso href="https://docs.unity3d.com/Manual/SL-ShaderReplacement.html"/>
    /// </remarks>
    public enum RenderType
    {
        /// <summary>
        /// Most of the shaders (Normal, Self Illuminated, Reflective, terrain shaders).
        /// </summary>
        Opaque,
        /// <summary>
        /// Most semitransparent shaders (Transparent, Particle, Font, terrain additive pass shaders).
        /// </summary>
        Transparent,
        /// <summary>
        /// Masked transparency shaders (Transparent Cutout, two pass vegetation shaders).
        /// </summary>
        TransparentCutout,
        /// <summary>
        /// Skybox shaders.
        /// </summary>
        Background,
        /// <summary>
        /// GUITexture, Halo, Flare shaders.
        /// </summary>
        Overlay,
        /// <summary>
        /// Terrain engine tree bark.
        /// </summary>
        TreeOpaque,
        /// <summary>
        /// Terrain engine tree leaves.
        /// </summary>
        TreeTransparentCutout,
        /// <summary>
        /// Terrain engine billboarded trees.
        /// </summary>
        TreeBillboard,
        /// <summary>
        /// Terrain engine grass.
        /// </summary>
        Grass,
        /// <summary>
        /// Terrain engine billboarded grass.
        /// </summary>
        GrassBillboard
    }
}
