<h1 align="center">墨鱼去开屏广告</h1>

<h4 align="center">转换自墨鱼 Quantumult X 去开屏广告规则的 Surge 模块</h4>

## 功能
去除部分 App 首页启动广告和部分应用内广告。

## 来源
- QX 源规则：https://ddgksf2013.top/rewrite/StartUpAds.conf
- 获取方式：`curl -A "Quantumult X" https://ddgksf2013.top/rewrite/StartUpAds.conf -v`
- 源规则更新时间：2026-06-02

## How to use
### 模块安装链接
> **稳定版 :** https://raw.githubusercontent.com/zyhclh/Surge-public/main/Module/Spec/StartUpAds/Moore/StartUpAds.sgmodule<br>

### 安装方式
打开 Surge -> 模块 -> 安装新模块 -> 复制粘贴上方的安装链接 -> 完成!

## 说明
本模块由 Quantumult X rewrite 规则转换而来，保留原作者信息和远端脚本引用。QX 的 `reject-200`、`reject-dict`、`reject-img` 已转换为 Surge 请求脚本返回对应响应。使用前请在 Surge 中开启 MitM 并安装证书。
