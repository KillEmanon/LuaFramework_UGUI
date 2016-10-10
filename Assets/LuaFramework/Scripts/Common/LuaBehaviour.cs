using UnityEngine;
using LuaInterface;
using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine.UI;

namespace LuaFramework
{
    public class LuaBehaviour : View
    {
        private string ScriptName = null;
        private string data = null;
        private Dictionary<int, LuaFunction> buttons = new Dictionary<int, LuaFunction>();
        private LuaFunction update;

        protected void Awake()
        {
            Util.CallMethod(name, "Awake", gameObject);
        }

        protected void Start()
        {
            Util.CallMethod(ScriptName, "Start");
        }

        protected void OnClick()
        {
            Util.CallMethod(ScriptName, "OnClick");
        }

        protected void OnClickEvent(GameObject go)
        {
            Util.CallMethod(ScriptName, "OnClick", go);
        }

        public void SetScriptName(string name)
        {
            ScriptName = name;
        }

        /// <summary>
        /// 添加单击事件
        /// </summary>
        public void AddClick(GameObject go, LuaFunction luafunc)
        {
            if (go == null || luafunc == null) return;
            buttons.Add(go.GetInstanceID(), luafunc);
            go.GetComponent<Button>().onClick.AddListener(
                delegate ()
                {
                    luafunc.Call(go);
                }
            );
        }

        public void AddClick(Button btn, LuaFunction luafunc)
        {
            if (btn == null || luafunc == null) return;
            buttons.Add(btn.GetInstanceID(), luafunc);
            btn.onClick.AddListener(
                delegate ()
                {
                    luafunc.Call(btn.gameObject);
                }
            );
        }

        /// <summary>
        /// 删除单击事件
        /// </summary>
        /// <param name="go"></param>
        public void RemoveClick(GameObject go)
        {
            if (go == null) return;
            LuaFunction luafunc = null;
            if (buttons.TryGetValue(go.GetInstanceID(), out luafunc))
            {
                luafunc.Dispose();
                luafunc = null;
                buttons.Remove(go.GetInstanceID());
            }
        }

        /// <summary>
        /// 清除单击事件
        /// </summary>
        public void ClearClick()
        {
            foreach (var de in buttons)
            {
                if (de.Value != null)
                {
                    de.Value.Dispose();
                }
            }
            buttons.Clear();
        }

        /// <summary>
        /// 增加更新事件
        /// </summary>
        public void OpenUpdate(LuaFunction luafunc)
        {
            update = luafunc;
        }

        public void CloseUpdate()
        {
            update = null;
        }

        //-----------------------------------------------------------------
        protected void OnDestroy()
        {
            ClearClick();
#if ASYNC_MODE
            string abName = name.ToLower().Replace("panel", "");
            ResManager.UnloadAssetBundle(abName + AppConst.ExtName);
#endif
            Util.ClearMemory();
            Debug.Log("~" + name + " was destroy!");
        }
    }
}