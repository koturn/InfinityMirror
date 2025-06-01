using System;
using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;
using Koturn.InfinityMirror.Enums;


namespace Koturn.InfinityMirror.Inspectors
{
    /// <summary>
    /// Custom editor for common properties.
    /// </summary>
    public abstract class InfinityMirrorBaseGUI : ShaderGUI
    {
        /// <summary>
        /// Property name of "_Color".
        /// </summary>
        private const string PropNameColor = "_Color";
        /// <summary>
        /// Property name of "_HueShift".
        /// </summary>
        private const string PropNameHueShift = "_HueShift";
        /// <summary>
        /// Property name of "_HueShiftSpeed".
        /// </summary>
        private const string PropNameHueShiftSpeed = "_HueShiftSpeed";
        /// <summary>
        /// Property name of "_MaxLoop".
        /// </summary>
        private const string PropNameMaxLoop = "_MaxLoop";
        /// <summary>
        /// Property name of "_StepDepth".
        /// </summary>
        private const string PropNameStepDepth = "_StepDepth";
        /// <summary>
        /// Property name of "_ColorCoeff".
        /// </summary>
        private const string PropNameColorCoeff = "_ColorCoeff";
        /// <summary>
        /// Property name of "_OverClip".
        /// </summary>
        private const string PropNameOverClip = "_OverClip";
        /// <summary>
        /// Property name of "_Lighting".
        /// </summary>
        private const string PropNameLighting = "_Lighting";
        /// <summary>
        /// Property name of "_Glossiness".
        /// </summary>
        private const string PropNameGlossiness = "_Glossiness";
        /// <summary>
        /// Property name of "_Metallic".
        /// </summary>
        private const string PropNameMetallic = "_Metallic";
        /// <summary>
        /// Property name of "_SpecColor".
        /// </summary>
        private const string PropNameSpecColor = "_SpecColor";
        /// <summary>
        /// Property name of "_SpecPower".
        /// </summary>
        private const string PropNameSpecPower = "_SpecPower";
#if VRC_SDK_VRCSDK3
        /// <summary>
        /// Property name of "_VRCLightVolumes".
        /// </summary>
        private const string PropNameVRCLightVolumes = "_VRCLightVolumes";
        /// <summary>
        /// Property name of "_VRCLightVolumesSpecular".
        /// </summary>
        private const string PropNameVRCLightVolumesSpecular = "_VRCLightVolumesSpecular";
        /// <summary>
        /// Property name of "_LTCGI".
        /// </summary>
        private const string PropNameLTCGI = "_LTCGI";
#endif  // VRC_SDK_VRCSDK3
        /// <summary>
        /// Property name of "_FlipNormal".
        /// </summary>
        private const string PropNameFlipNormal = "_FlipNormal";
        /// <summary>
        /// Property name of "_SvDepth".
        /// </summary>
        private const string PropNameSvDepth = "_SvDepth";
        /// <summary>
        /// Property name of "_ForwardAdd".
        /// </summary>
        private const string PropNameForwardAdd = "_ForwardAdd";
        /// <summary>
        /// Property name of "_Cull".
        /// </summary>
        private const string PropNameCull = "_Cull";
        /// <summary>
        /// Property name of "_ZTest".
        /// </summary>
        private const string PropNameZTest = "_ZTest";
        /// <summary>
        /// Property name of "_ZClip".
        /// </summary>
        private const string PropNameZClip = "_ZClip";
        /// <summary>
        /// Property name of "_OffsetFactor".
        /// </summary>
        private const string PropNameOffsetFactor = "_OffsetFactor";
        /// <summary>
        /// Property name of "_OffsetUnit".
        /// </summary>
        private const string PropNameOffsetUnit = "_OffsetUnit";
        /// <summary>
        /// Property name of "_ColorMask".
        /// </summary>
        private const string PropNameColorMask = "_ColorMask";
        /// <summary>
        /// Property name of "_AlphaToMask".
        /// </summary>
        private const string PropNameAlphaToMask = "_AlphaToMask";
        /// <summary>
        /// Property name of "_StencilRef".
        /// </summary>
        private const string PropNameStencilRef = "_StencilRef";
        /// <summary>
        /// Property name of "_StencilReadMask".
        /// </summary>
        private const string PropNameStencilReadMask = "_StencilReadMask";
        /// <summary>
        /// Property name of "_StencilWriteMask".
        /// </summary>
        private const string PropNameStencilWriteMask = "_StencilWriteMask";
        /// <summary>
        /// Property name of "_StencilComp".
        /// </summary>
        private const string PropNameStencilComp = "_StencilComp";
        /// <summary>
        /// Property name of "_StencilPass".
        /// </summary>
        private const string PropNameStencilPass = "_StencilPass";
        /// <summary>
        /// Property name of "_StencilFail".
        /// </summary>
        private const string PropNameStencilFail = "_StencilFail";
        /// <summary>
        /// Property name of "_StencilZFail".
        /// </summary>
        private const string PropNameStencilZFail = "_StencilZFail";
        /// <summary>
        /// Tag name of "RenderType".
        /// </summary>
        private const string TagRenderType = "RenderType";

        /// <summary>
        /// Current editor UI mode.
        /// </summary>
        private static EditorMode _editorMode;
        /// <summary>
        /// Key list of cache of MaterialPropertyHandlers.
        /// </summary>
        private static List<string> _propStringList;
        /// <summary>
        /// Editor UI mode names.
        /// </summary>
        private static readonly string[] _editorModeNames;
        /// <summary>
        /// Stencil property names.
        /// </summary>
        private static readonly string[] _stencilPropNames;

        /// <summary>
        /// Initialize <see cref="_editorMode"/>, <see cref="_editorModeNames"/> and <see cref="_stencilPropNames"/>.
        /// </summary>
        static InfinityMirrorBaseGUI()
        {
            _editorMode = (EditorMode)(-1);
            _editorModeNames = Enum.GetNames(typeof(EditorMode));
            _stencilPropNames = new []
            {
                PropNameStencilRef,
                PropNameStencilReadMask,
                PropNameStencilWriteMask,
                PropNameStencilComp,
                PropNameStencilPass,
                PropNameStencilFail,
                PropNameStencilZFail
            };
        }


        /// <summary>
        /// Draw property items.
        /// </summary>
        /// <param name="me">The <see cref="MaterialEditor"/> that are calling this <see cref="OnGUI(MaterialEditor, MaterialProperty[])"/> (the 'owner').</param>
        /// <param name="mps">Material properties of the current selected shader.</param>
        public override void OnGUI(MaterialEditor me, MaterialProperty[] mps)
        {
            if (!Enum.IsDefined(typeof(EditorMode), _editorMode))
            {
                MaterialPropertyUtil.ClearDecoratorDrawers(((Material)me.target).shader, mps);
                _editorMode = EditorMode.Custom;
            }
            using (var ccScope = new EditorGUI.ChangeCheckScope())
            {
                _editorMode = (EditorMode)GUILayout.Toolbar((int)_editorMode, _editorModeNames);
                if (ccScope.changed)
                {
                    if (_propStringList != null)
                    {
                        MaterialPropertyUtil.ClearPropertyHandlerCache(_propStringList);
                    }

                    var shader = ((Material)me.target).shader;
                    if (_editorMode == EditorMode.Custom)
                    {
                        _propStringList = MaterialPropertyUtil.ClearDecoratorDrawers(shader, mps);
                    }
                    else
                    {
                        _propStringList = MaterialPropertyUtil.ClearCustomDrawers(shader, mps);
                    }
                }
            }
            if (_editorMode == EditorMode.Default)
            {
                base.OnGUI(me, mps);
                return;
            }

            EditorGUILayout.LabelField("Shape & Color", EditorStyles.boldLabel);
            using (new EditorGUI.IndentLevelScope())
            using (new EditorGUILayout.VerticalScope(GUI.skin.box))
            {
                DrawShapeProperties(me, mps);
                ShaderProperty(me, mps, PropNameColor, false);
                var mpHueShift = FindAndDrawProperty(me, mps, PropNameHueShift, false);
                using (new EditorGUI.IndentLevelScope())
                using (new EditorGUI.DisabledScope(mpHueShift.floatValue < 0.5f))
                {
                    ShaderProperty(me, mps, PropNameHueShiftSpeed, false);
                }
            }

            EditorGUILayout.LabelField("Ray Marching Parameters", EditorStyles.boldLabel);
            using (new EditorGUI.IndentLevelScope())
            using (new EditorGUILayout.VerticalScope(GUI.skin.box))
            {
                ShaderProperty(me, mps, PropNameMaxLoop, false);
                ShaderProperty(me, mps, PropNameStepDepth, false);
                ShaderProperty(me, mps, PropNameColorCoeff, false);
                using (var ccScope = new EditorGUI.ChangeCheckScope())
                {
                    var mpOverClip = FindAndDrawProperty(me, mps, PropNameOverClip, false);
                    if (ccScope.changed)
                    {
                        RenderType renderType;
                        RenderQueue renderQueue;
                        if (mpOverClip == null || mpOverClip.floatValue >= 0.5f)
                        {
                            renderType = RenderType.TransparentCutout;
                            renderQueue = RenderQueue.AlphaTest;
                        }
                        else
                        {
                            renderType = RenderType.Opaque;
                            renderQueue = RenderQueue.Geometry;
                        }
                        foreach (var material in me.targets.Cast<Material>())
                        {
                            SetRenderTypeTag(material, renderType);
                            SetRenderQueue(material, renderQueue);
                        }
                    }
                }
            }

            EditorGUILayout.Space();

            EditorGUILayout.LabelField("Lighting Parameters", EditorStyles.boldLabel);
            using (new EditorGUI.IndentLevelScope())
            using (new EditorGUILayout.VerticalScope(GUI.skin.box))
            {
                var mpLighting = FindAndDrawProperty(me, mps, PropNameLighting, false);
                var lightingMethod = (LightingMethod)(mpLighting == null ? -1 : (int)mpLighting.floatValue);

                using (new EditorGUI.IndentLevelScope())
                using (new EditorGUI.DisabledScope(lightingMethod == LightingMethod.UnityLambert || lightingMethod == LightingMethod.Unlit))
                {
                    ShaderProperty(me, mps, PropNameGlossiness, false);
                    using (new EditorGUI.DisabledScope(lightingMethod != LightingMethod.UnityStandard))
                    {
                        ShaderProperty(me, mps, PropNameMetallic, false);
                    }
                    using (new EditorGUI.DisabledScope(lightingMethod != LightingMethod.UnityBlinnPhong && lightingMethod != LightingMethod.UnityStandardSpecular))
                    {
                        ShaderProperty(me, mps, PropNameSpecColor, false);
                    }
                    using (new EditorGUI.DisabledScope(lightingMethod != LightingMethod.UnityBlinnPhong))
                    {
                        ShaderProperty(me, mps, PropNameSpecPower, false);
                    }
                }

#if VRC_SDK_VRCSDK3
                ShaderProperty(me, mps, PropNameVRCLightVolumes, false);
                using (new EditorGUI.DisabledScope(lightingMethod == LightingMethod.UnityLambert || lightingMethod == LightingMethod.Unlit))
                {
                    ShaderProperty(me, mps, PropNameVRCLightVolumesSpecular, false);
                }
                ShaderProperty(me, mps, PropNameLTCGI, false);
#endif  // VRC_SDK_VRCSDK3
            }

            EditorGUILayout.Space();

            EditorGUILayout.LabelField("Rendering Options", EditorStyles.boldLabel);
            using (new EditorGUI.IndentLevelScope())
            using (new EditorGUILayout.VerticalScope(GUI.skin.box))
            {
                ShaderProperty(me, mps, PropNameFlipNormal, false);
                ShaderProperty(me, mps, PropNameSvDepth, false);
                ShaderProperty(me, mps, PropNameForwardAdd, false);

                var mpCull = FindAndDrawProperty(me, mps, PropNameCull, false);

                ShaderProperty(me, mps, PropNameZTest, false);
                ShaderProperty(me, mps, PropNameZClip, false);
                DrawOffsetProperties(me, mps, PropNameOffsetFactor, PropNameOffsetUnit);
                ShaderProperty(me, mps, PropNameColorMask, false);
                ShaderProperty(me, mps, PropNameAlphaToMask, false);

                EditorGUILayout.Space();
                DrawStencilProperties(me, mps);
                EditorGUILayout.Space();
                DrawAdvancedOptions(me, mps);
            }
        }


        /// <summary>
        /// Draw shape property items.
        /// </summary>
        /// <param name="me">The <see cref="MaterialEditor"/> that are calling this <see cref="OnGUI(MaterialEditor, MaterialProperty[])"/> (the 'owner').</param>
        /// <param name="mps">Material properties of the current selected shader.</param>
        protected abstract void DrawShapeProperties(MaterialEditor me, MaterialProperty[] mps);


        /// <summary>
        /// Draw default item of specified shader property.
        /// </summary>
        /// <param name="me">A <see cref="MaterialEditor"/>.</param>
        /// <param name="mps"><see cref="MaterialProperty"/> array.</param>
        /// <param name="propName">Name of shader property.</param>
        /// <param name="isMandatory">If <c>true</c> then this method will throw an exception
        /// if a property with <paramref name="propName"/> was not found.</param>
        protected static void ShaderProperty(MaterialEditor me, MaterialProperty[] mps, string propName, bool isMandatory = true)
        {
            var prop = FindProperty(propName, mps, isMandatory);
            if (prop != null)
            {
                ShaderProperty(me, prop);
            }
        }

        /// <summary>
        /// Draw default item of specified shader property.
        /// </summary>
        /// <param name="me">A <see cref="MaterialEditor"/>.</param>
        /// <param name="mp">Target <see cref="MaterialProperty"/>.</param>
        protected static void ShaderProperty(MaterialEditor me, MaterialProperty mp)
        {
            if (mp != null)
            {
                me.ShaderProperty(mp, mp.displayName);
            }
        }

        /// <summary>
        /// Draw default item of specified shader property and return the property.
        /// </summary>
        /// <param name="me">A <see cref="MaterialEditor"/>.</param>
        /// <param name="mps"><see cref="MaterialProperty"/> array.</param>
        /// <param name="propName">Name of shader property.</param>
        /// <param name="isMandatory">If <c>true</c> then this method will throw an exception
        /// if a property with <paramref name="propName"/> was not found.</param>
        /// <return>Found property.</return>
        protected static MaterialProperty FindAndDrawProperty(MaterialEditor me, MaterialProperty[] mps, string propName, bool isMandatory = true)
        {
            var prop = FindProperty(propName, mps, isMandatory);
            if (prop != null)
            {
                ShaderProperty(me, prop);
            }

            return prop;
        }

        /// <summary>
        /// Find properties which has specified names.
        /// </summary>
        /// <param name="propNames">Names of shader property.</param>
        /// <param name="mps"><see cref="MaterialProperty"/> array.</param>
        /// <param name="isMandatory">If <c>true</c> then this method will throw an exception
        /// if one of properties with <paramref name="propNames"/> was not found.</param>
        /// <return>Found properties.</return>
        protected static List<MaterialProperty> FindProperties(string[] propNames, MaterialProperty[] mps, bool isMandatory = true)
        {
            var mpList = new List<MaterialProperty>(propNames.Length);
            foreach (var propName in propNames)
            {
                var prop = FindProperty(propName, mps, isMandatory);
                if (prop != null)
                {
                    mpList.Add(prop);
                }
            }

            return mpList;
        }

        /// <summary>
        /// Draw inspector items of "Offset".
        /// </summary>
        /// <param name="me">A <see cref="MaterialEditor"/></param>
        /// <param name="mps"><see cref="MaterialProperty"/> array</param>
        /// <param name="propNameFactor">Property name for the first argument of "Offset"</param>
        /// <param name="propNameUnit">Property name for the second argument of "Offset"</param>
        private static void DrawOffsetProperties(MaterialEditor me, MaterialProperty[] mps, string propNameFactor, string propNameUnit)
        {
            var propFactor = FindProperty(propNameFactor, mps, false);
            var propUnit = FindProperty(propNameUnit, mps, false);
            if (propFactor == null || propUnit == null)
            {
                return;
            }
            EditorGUILayout.LabelField("Offset");
            using (new EditorGUI.IndentLevelScope())
            {
                ShaderProperty(me, propFactor);
                ShaderProperty(me, propUnit);
            }
        }

        /// <summary>
        /// Draw inspector items of Stencil.
        /// </summary>
        /// <param name="me">A <see cref="MaterialEditor"/></param>
        /// <param name="mps"><see cref="MaterialProperty"/> array</param>
        private static void DrawStencilProperties(MaterialEditor me, MaterialProperty[] mps)
        {
            var stencilProps = FindProperties(_stencilPropNames, mps, false);

            if (stencilProps.Count == 0)
            {
                return;
            }

            EditorGUILayout.LabelField("Stencil", EditorStyles.boldLabel);
            using (new EditorGUI.IndentLevelScope())
            using (new EditorGUILayout.VerticalScope(GUI.skin.box))
            {
                foreach (var prop in stencilProps)
                {
                    me.ShaderProperty(prop, prop.displayName);
                }
            }
        }

        /// <summary>
        /// Set render queue value if the value is differ from the default.
        /// </summary>
        /// <param name="material">Target material.</param>
        /// <param name="renderQueue"><see cref="RenderQueue"/> to set.</param>
        private static void SetRenderTypeTag(Material material, RenderType renderType)
        {
            // Set to default and get the default.
            material.SetOverrideTag(TagRenderType, string.Empty);
            var defaultTagval = material.GetTag(TagRenderType, false, "Transparent");

            // Set specified render type value if the value differs from the default.
            var renderTypeValue = renderType.ToString();
            if (renderTypeValue != defaultTagval)
            {
                material.SetOverrideTag(TagRenderType, renderTypeValue);
            }
        }

        /// <summary>
        /// Set render queue value if the value is differ from the default.
        /// </summary>
        /// <param name="material">Target material.</param>
        /// <param name="renderQueue"><see cref="RenderQueue"/> to set.</param>
        private static void SetRenderQueue(Material material, RenderQueue renderQueue)
        {
            // Set to default and get the default.
            material.renderQueue = -1;
            var defaultRenderQueue = material.renderQueue;

            // Set specified render queue value if the value differs from the default.
            var renderQueueValue = (int)renderQueue;
            if (defaultRenderQueue != renderQueueValue)
            {
                material.renderQueue = renderQueueValue;
            }
        }

        /// <summary>
        /// Draw inspector items of advanced options.
        /// </summary>
        /// <param name="me">A <see cref="MaterialEditor"/>.</param>
        /// <param name="mps"><see cref="MaterialProperty"/> array.</param>
        private static void DrawAdvancedOptions(MaterialEditor me, MaterialProperty[] mps)
        {
            EditorGUILayout.LabelField("Advanced Options", EditorStyles.boldLabel);
            using (new EditorGUI.IndentLevelScope())
            using (new EditorGUILayout.VerticalScope(GUI.skin.box))
            {
                me.RenderQueueField();
#if UNITY_5_6_OR_NEWER
                me.EnableInstancingField();
                me.DoubleSidedGIField();
#endif  // UNITY_5_6_OR_NEWER
            }
        }
    }
}
