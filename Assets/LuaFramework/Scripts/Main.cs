using UnityEngine;
using System.Collections;

namespace LuaFramework {
    public class Main : MonoBehaviour {

        void Start() {
            AppFacade.Instance.StartUp();   //启动游戏
        }

    }
}