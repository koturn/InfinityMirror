using UnityEditor;


namespace Koturn.InfinityMirror.Inspectors
{
    /// <summary>
    /// Custom editor for "koturn/InfinityMirror/KoturnSDF".
    /// </summary>
    public sealed class KoturnSDFGUI : InfinityMirrorBaseGUI
    {
        /// <summary>
        /// Property name of "_EdgeWidth".
        /// </summary>
        private const string PropNameEdgeWidth = "_EdgeWidth";
        /// <summary>
        /// Property name of "_CoeffsA".
        /// </summary>
        private const string PropNameCoeffsA = "_CoeffsA";
        /// <summary>
        /// Property name of "_CoeffsB".
        /// </summary>
        private const string PropNameCoeffsB = "_CoeffsB";

        /// <inheritdoc/>
        protected override void DrawShapeProperties(MaterialEditor me, MaterialProperty[] mps)
        {
            ShaderProperty(me, mps, PropNameEdgeWidth);
            ShaderProperty(me, mps, PropNameCoeffsA);
            ShaderProperty(me, mps, PropNameCoeffsB);
        }
    }
}
