using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using LuaFramework;
using System;

public class UpdateManager : Manager {

    private List<string> downloadFiles = new List<string>();

    /// <summary>
    /// 更新流程启动
    /// 1-检测本地资源-》解压或者跳过
    /// 2-获取最新资源列表
    /// 3-对比检测更新
    /// </summary>
    public void UpdateStart()
    {
        CheckExtractResource();
    }

    /// <summary>
    /// 检测本地资源
    /// </summary>
    void CheckExtractResource()
    {
        bool isExists = Directory.Exists(Util.DataPath) &&
          Directory.Exists(Util.DataPath + "lua/") && File.Exists(Util.DataPath + "files.txt");
        if (isExists || AppConst.DebugMode)
        {
            StartCoroutine(OnUpdateResource());
            return;   //文件已经解压过了，自己可添加检查文件列表逻辑
        }
        StartCoroutine(OnExtractResource());    //启动释放协程 
    }

    /// <summary>
    /// 释放资源
    /// </summary>
    /// <returns></returns>
    IEnumerator OnExtractResource()
    {
        string dataPath = Util.DataPath;  //数据目录
        string resPath = Util.AppContentPath(); //游戏包资源目录

        if (Directory.Exists(dataPath)) Directory.Delete(dataPath, true);
        Directory.CreateDirectory(dataPath);

        string infile = resPath + "files.txt";
        string outfile = dataPath + "files.txt";
        if (File.Exists(outfile)) File.Delete(outfile);

        string message = "正在解包文件:>files.txt";
        Debug.Log(infile);
        Debug.Log(outfile);
        if (Application.platform == RuntimePlatform.Android)
        {
            WWW www = new WWW(infile);
            yield return www;

            if (www.isDone)
            {
                File.WriteAllBytes(outfile, www.bytes);
            }
            yield return 0;
        }
        else File.Copy(infile, outfile, true);
        yield return new WaitForEndOfFrame();

        //释放所有文件到数据目录
        string[] files = File.ReadAllLines(outfile);
        foreach (var file in files)
        {
            string[] fs = file.Split('|');
            infile = resPath + fs[0];  //
            outfile = dataPath + fs[0];

            message = "正在解包文件:>" + fs[0];
            Debug.Log("正在解包文件:>" + infile);
            facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, message);

            string dir = Path.GetDirectoryName(outfile);
            if (!Directory.Exists(dir)) Directory.CreateDirectory(dir);

            if (Application.platform == RuntimePlatform.Android)
            {
                WWW www = new WWW(infile);
                yield return www;

                if (www.isDone)
                {
                    File.WriteAllBytes(outfile, www.bytes);
                }
                yield return 0;
            }
            else
            {
                if (File.Exists(outfile))
                {
                    File.Delete(outfile);
                }
                File.Copy(infile, outfile, true);
            }
            yield return new WaitForEndOfFrame();
        }
        message = "解包完成!!!";
        facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, message);
        yield return new WaitForSeconds(0.1f);

        message = string.Empty;
        //释放完成，开始启动更新资源
        StartCoroutine(OnUpdateResource());
    }

    /// <summary>
    /// 启动更新下载，这里只是个思路演示，此处可启动线程下载更新
    /// </summary>
    IEnumerator OnUpdateResource()
    {
        if (!AppConst.UpdateMode)
        {
            OnResourceInited();
            yield break;
        }
        string dataPath = Util.DataPath;  //数据目录
        string url = AppConst.WebUrlTest;
        string message = string.Empty;
        string random = DateTime.Now.ToString("yyyymmddhhmmss");
        string listUrl = url + "files.txt?v=" + random;
        Debug.LogWarning("LoadUpdate---->>>" + listUrl);

        //Emanon(2016.9.27)处理超时
        float startTime = Time.time;
        WWW www = new WWW(listUrl);
        while (!www.isDone && www.error == null)
        {
            if (Time.time - startTime > 3f)
            {
                message = "超时";
                Debug.Log(message);
                OnResourceInited();
                yield break;
            }
            yield return null;
        }

        if (www.error != null)
        {
            OnUpdateFailed(string.Empty);
            message = "更新失败";
            facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, message);
            Debug.Log(message + ":" + www.error);
            OnResourceInited();
            yield break;
        }

        if (!Directory.Exists(dataPath))
        {
            Directory.CreateDirectory(dataPath);
        }
        File.WriteAllBytes(dataPath + "files.txt", www.bytes);
        string filesText = www.text;
        string[] files = filesText.Split('\n');

        for (int i = 0; i < files.Length; i++)
        {
            if (string.IsNullOrEmpty(files[i])) continue;
            string[] keyValue = files[i].Split('|');
            string f = keyValue[0];
            string localfile = (dataPath + f).Trim();
            string path = Path.GetDirectoryName(localfile);
            if (!Directory.Exists(path))
            {
                Directory.CreateDirectory(path);
            }
            string fileUrl = url + f + "?v=" + random;
            bool canUpdate = !File.Exists(localfile);
            if (!canUpdate)
            {
                string remoteMd5 = keyValue[1].Trim();
                string localMd5 = Util.md5file(localfile);
                canUpdate = !remoteMd5.Equals(localMd5);
                if (canUpdate) File.Delete(localfile);
            }
            if (canUpdate)
            {   //本地缺少文件
                Debug.Log(fileUrl);
                message = "downloading>>" + fileUrl;
                facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, message);
                /*
                www = new WWW(fileUrl); yield return www;
                if (www.error != null) {
                    OnUpdateFailed(path);   //
                    yield break;
                }
                File.WriteAllBytes(localfile, www.bytes);
                 */
                //这里都是资源文件，用线程下载
                BeginDownload(fileUrl, localfile);
                while (!(IsDownOK(localfile))) { yield return new WaitForEndOfFrame(); }
            }
        }
        yield return new WaitForEndOfFrame();

        message = "更新完成!!";
        facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, message);

        OnResourceInited();
    }

    

    /// <summary>
    /// 更新失败
    /// </summary>
    /// <param name="file"></param>
    void OnUpdateFailed(string file)
    {
        string message = "更新失败!>" + file;
        facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, message);
    }

    /// <summary>
    /// 是否下载完成
    /// </summary>
    bool IsDownOK(string file)
    {
        return downloadFiles.Contains(file);
    }

    /// <summary>
    /// 线程下载
    /// </summary>
    void BeginDownload(string url, string file)
    {     //线程下载
        object[] param = new object[2] { url, file };

        ThreadEvent ev = new ThreadEvent();
        ev.Key = NotiConst.UPDATE_DOWNLOAD;
        ev.evParams.AddRange(param);
        ThreadManager.AddEvent(ev, OnThreadCompleted);   //线程下载
    }

    /// <summary>
    /// 线程完成
    /// </summary>
    /// <param name="data"></param>
    void OnThreadCompleted(NotiData data)
    {
        switch (data.evName)
        {
            case NotiConst.UPDATE_EXTRACT:  //解压一个完成
                //
                break;
            case NotiConst.UPDATE_DOWNLOAD: //下载一个完成
                downloadFiles.Add(data.evParam.ToString());
                break;
        }
    }

    /// <summary>
    /// 资源初始化结束
    /// </summary>
    public void OnResourceInited()
    {
        Debug.Log("资源初始化完成");
#if ASYNC_MODE
            ResManager.Initialize(AppConst.AssetDir, delegate() {
                Debug.Log("Initialize OK!!!");
                this.OnInitialize();
            });
#else
        //更新完成
        facade.SendMessageCommand(NotiConst.UPDATE_OVER, "");
        Debug.Log("同步模式");
        ResManager.Initialize();
        GameManager.OnInitialize();
#endif
    }

}
