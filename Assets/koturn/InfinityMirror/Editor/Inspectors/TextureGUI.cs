using UnityEditor;


namespace Koturn.InfinityMirror.Inspectors
{
    /// <summary>
    /// Custom editor for "koturn/InfinityMirror/Texture".
    /// </summary>
    public sealed class TextureGUI : InfinityMirrorBaseGUI
    {
        /// <summary>
        /// Property name of "_MainTex".
        /// </summary>
        private const string PropNameMainTex = "_MainTex";

        /// <inheritdoc/>
        protected override void DrawShapeProperties(MaterialEditor me, MaterialProperty[] mps)
        {
            ShaderProperty(me, mps, PropNameMainTex);
        }
    }
}
