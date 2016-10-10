/*
 * 额外添加 Emanon
 * 用于帮tolua打补丁
 */

using UnityEngine;
using System.Collections;
using System;
using UnityEngine.UI;
using System.Reflection;

public static class LuaTool
{

    public static Type RectTransform = typeof(RectTransform);

    public static Type Text = typeof(Text);

    public static Type ContentSizeFitter = typeof(ContentSizeFitter);

    public static Type InputField = typeof(InputField);

    public static void SetHorizontalFitMod(ContentSizeFitter content, int mod)
    {
        if (mod < 0 || mod > 2)
            Debug.LogWarning("UnityType.SetHorizontalFitMod范围外的值");

        content.horizontalFit = (UnityEngine.UI.ContentSizeFitter.FitMode)mod;
    }

    public static void SetVerticalFitMod(ContentSizeFitter content, int mod)
    {
        if (mod < 0 || mod > 2)
            Debug.LogWarning("UnityType.SetVerticalFitMod范围外的值");

        content.verticalFit = (UnityEngine.UI.ContentSizeFitter.FitMode)mod;
    }

    public static void SetImageType(Image image, int mod)
    {
        if (mod < 0 || mod > 3)
            Debug.LogWarning("UnitType.SetImageType收到范围外的值");

        image.type = (Image.Type)mod;
    }

    /// <summary>
    /// Lua的扩展方法，用类名参数增加组件
    /// </summary>
    /// <param name="go"></param>
    /// <param name="type"></param>
    public static void AddComponent(GameObject go, string type)
    {
        var t = Type.GetType(type);

        if (t == null)
        {
            Debug.LogError(string.Format("{0}类型不存在!!!", type));
            return;
        }

        var classType = typeof(GameObject);

        MethodInfo mi = GetGenericMethod(classType, "AddComponent", t);
        var temp = mi.Invoke(go, new object[] { });
    }

    private static MethodInfo GetGenericMethod(Type type, string name, params Type[] types)
    {
        foreach (MethodInfo mi in type.GetMethods(BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance))
        {
            if (mi.Name != name) continue;
            if (!mi.IsGenericMethod) continue;
            if (mi.GetGenericArguments().Length != types.Length) continue;

            return mi.MakeGenericMethod(types);
        }

        throw new MissingMethodException();
    }

}
