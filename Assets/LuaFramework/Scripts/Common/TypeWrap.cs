using UnityEngine;
using System.Collections;

public class TypeWrap
{
    //只具备特殊价值的方法
	public GameObject GameObject(Object[] objs)
    {
        return objs[0] as GameObject;
    }
}
