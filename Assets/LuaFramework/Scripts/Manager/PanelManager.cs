using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using LuaInterface;

namespace LuaFramework {
    public class PanelManager : Manager {
        private Transform parent;
        private Transform popup;

        Transform Parent {
            get {
                if (parent == null) {
                    GameObject go = GameObject.Find("Canvas/UIPanel");
                    if (go != null) parent = go.transform;
                }
                return parent;
            }
        }

        Transform Popup
        {
            get{
                if (popup == null)
                {
                    GameObject go = GameObject.Find("Canvas/Popup");
                    if (go != null) popup = go.transform;
                }
                return popup;
            }
        }


#if ASYNC_MODE
        /// <summary>
        /// 创建面板，请求资源管理器
        /// </summary>
        /// <param name="type"></param>
        public void CreatePanel(string name, LuaFunction func = null) {
            string assetName = name + "Panel";
            string abName = name.ToLower() + AppConst.ExtName;

            ResManager.LoadPrefab(abName, assetName, delegate(UnityEngine.Object[] objs) {
                if (objs.Length == 0) return;
                // Get the asset.
                GameObject prefab = objs[0] as GameObject;

                if (Parent.FindChild(name) != null || prefab == null) {
                    return;
                }
                GameObject go = Instantiate(prefab) as GameObject;
                go.name = assetName;
                go.layer = LayerMask.NameToLayer("Default");
                go.transform.SetParent(Parent);
                go.transform.localScale = Vector3.one;
                go.transform.localPosition = Vector3.zero;
                go.AddComponent<LuaBehaviour>();

                if (func != null) func.Call(go);
                Debug.LogWarning("CreatePanel::>> " + name + " " + prefab);
            });
        }
#else
        /// <summary>
        /// 创建面板，请求资源管理器
        /// </summary>
        /// <param name="type"></param>
        public void CreatePanel(string abName, LuaFunction func = null) {
            string assetName = abName + "Panel";
            CreatePanel(abName, assetName, func);
        }

        /// <summary>
        /// 创建面板，请求资源管理器
        /// </summary>
        /// <param name="type"></param>
        public void CreatePanel(string abName, string assetName, LuaFunction func = null)
        {
            assetName += "Panel";
            GameObject prefab = ResManager.LoadAsset<GameObject>(abName, assetName);
            if (Parent.FindChild(abName) != null || prefab == null)
            {
                Debug.Log("找不到资源:" + abName + "." + assetName);
                return;
            }
            GameObject go = Instantiate(prefab) as GameObject;
            go.name = assetName;
            go.layer = LayerMask.NameToLayer("Default");
            go.transform.SetParent(Parent, false);
            go.transform.localScale = Vector3.one;
            go.transform.localPosition = Vector3.zero;
            go.AddComponent<LuaBehaviour>();

            if (func != null) func.Call(go);
            Debug.LogWarning("CreatePanel::>> " + abName + " " + prefab);
        }

        /// <summary>
        /// 创建小弹窗类型的置顶界面
        /// </summary>
        /// <param name="abName"></param>
        /// <param name="assetName"></param>
        /// <param name="func"></param>
        public void CreatePopup(string abName, string assetName, LuaFunction func = null)
        {
            assetName += "Panel";
            GameObject prefab = ResManager.LoadAsset<GameObject>(abName, assetName);
            if (Parent.FindChild(abName) != null || prefab == null)
            {
                Debug.Log("找不到资源:" + abName + "." + assetName);
                return;
            }
            GameObject go = Instantiate(prefab) as GameObject;
            go.name = assetName;
            go.layer = LayerMask.NameToLayer("Default");
            go.transform.SetParent(Popup, false);
            go.transform.localScale = Vector3.one;
            go.transform.localPosition = Vector3.zero;
            go.AddComponent<LuaBehaviour>();

            if (func != null) func.Call(go);
            Debug.LogWarning("CreatePanel::>> " + abName + " " + prefab);
        }

    /// <summary>
    /// 生成预设实例
    /// </summary>
    /// <param name="abName">资源包名</param>
    /// <param name="assetName">资源文件名</param>
    public void CreateObject(string abName, string assetName, LuaFunction func = null)
        {
            GameObject prefab = ResManager.LoadAsset<GameObject>(abName, assetName);
            if (prefab == null)
            {
                Debug.LogError("找不到" + abName + "." + assetName);
                return;
            }
            GameObject go = Instantiate(prefab) as GameObject;
            go.name = assetName;
            go.AddComponent<LuaBehaviour>();

            if (func != null) func.Call(go);
        }

#endif
    }
}