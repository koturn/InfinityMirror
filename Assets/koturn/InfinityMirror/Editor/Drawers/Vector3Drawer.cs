using UnityEditor;
using UnityEngine;


namespace Koturn.InfinityMirror.Drawers
{
    /// <summary>
    /// Custom <see cref="MaterialPropertyDrawer"/> for 3D vector.
    /// </summary>
    public sealed class Vector3Drawer : MaterialPropertyDrawer
    {
        /// <summary>
        /// <param name="position">Rectangle on the screen to use for the property GUI.</param>
        /// <param name="prop">The <see cref="MaterialProperty"/> to make the custom GUI for.</param>
        /// <param name="label">The label of this property.</param>
        /// <param name="editor">Current material editor.</param>
        /// </summary>
        public override void OnGUI(Rect position, MaterialProperty prop, GUIContent label, MaterialEditor editor)
        {
            using (var ccScope = new EditorGUI.ChangeCheckScope())
            {
                EditorGUI.showMixedValue = prop.hasMixedValue;
                var vec = EditorGUI.Vector3Field(position, label, prop.vectorValue);
                EditorGUI.showMixedValue = false;
                if (ccScope.changed)
                {
                    prop.vectorValue = new Vector4(vec.x, vec.y, vec.z, prop.vectorValue.w);
                }
            }
        }
    }
}
