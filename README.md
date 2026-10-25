# Plain Craft Launcher (PCL) 本地固定版

第三方基于 PCL 2.14.0.0 独立修改的本地版本，不是官方发行版。
原作者：龙腾猫跃；[原作者赞助链接](https://meloong.com/afd/a/LTCat)。
保留上游 `LICENCE`、署名、蓝色主题和正版购买提示。

[下载发行包](https://github.com/stoneorwater/PCL-LocalFrozen/releases) · [上游原始说明](README-upstream.md) · [许可与第三方组件](THIRD-PARTY-NOTICES.md)

## 使用

1. 将程序包完整解压到独立文件夹，运行 `PCL-LocalFrozen.exe`。需要 Windows 64 位及 .NET Framework 4.8。
2. 下载游戏或在“启动 → 版本选择 → 文件夹列表”中添加已有 `.minecraft` 文件夹。
3. 首次使用会重新显示协议和固定版说明。原启动器的账号、设置没有自动迁移。

不要覆盖原有可用的启动器备份。
程序使用独立注册表配置 `PCLLocalFrozen214`、独立默认临时缓存 `PCLLocalFrozen214` 和独立单实例锁；同文件夹内的 `PCL/Setup.ini`、游戏数据仍按上游方式处理，因此建议使用独立目录。

## 修改范围

- 删除启动器更新检查、替换/重启更新接口和启动时的公告/联网配置任务。
- 拒绝旧 `--update` 命令行入口，退出码为 1，不使用传入路径替换文件。
- 移除更新/公告设置、检查更新按钮、读取旧公告缓存的新版判断和相关强制更新提示。
- 保留自定义主页中“检查更新”事件的兼容识别，但只显示本地提示，不联网、不下载、不执行更新。
- 导出整合包时始终复制当前固定版程序，不再下载或使用缓存中的官方 `Latest.exe`。
- 保留游戏、Java、加载器、Mod、资源包、整合包下载代码；没有屏蔽这些服务的网络访问。
- 增加便携 .NET SDK 的 WPF 构建兼容配置。

“移除更新”指启动器自身更新，不包括游戏版本提示、Mod 更新和游戏下载补全。
这不是完全离线版。自定义主页、帮助、游戏和资源服务仍可能联网；外部服务将来的接口变化可能影响可用性。

## 已知差异

上游公开源码本身没有官方版的私有凭据及部分功能，本包未提取或借用它们。

- 微软正版登录：需要你自己已获相应授权的 OAuth Client ID。源码从进程环境变量 `PCL_MS_CLIENT_ID` 读取。
- CurseForge：需要你自己的 API Key。源码从进程环境变量 `PCL_CURSEFORGE_API_KEY` 读取。缺省时 CurseForge 请求不可用；Modrinth 使用独立接口。
- 官方联机服务：依赖远程配置，本固定版会明确报告不可用。通过游戏自身加入服务器等功能不属于该官方联机服务。
- 主题、土豆码、百宝箱等功能与上游公开源码保持相应限制。
- 无签名的自行编译程序，没有官方签名或官方自动更新支持。

设置上述环境变量后重新启动程序即可读取，不需要重新编译。不要把凭据写进公开源码、截图或共享脚本。
这里只说明配置入口，不保证新申请的 Client ID 自动获得 Minecraft 服务端访问权限。正版登录、CurseForge、所有整合包和所有加载器组合未逐项验证。

## 源码来源

- 上游：`https://github.com/Meloong-Git/PCL`
- 固定提交：`5ef81e490ae46b1100d61e33d0183094c7a80ca8`（2.14.0.0 正式版）
- MeloongCore：`https://github.com/Meloong-Git/MeloongCore`
- 固定子模块提交：`c774ae4c85fd94e0eaa171db21e78a65870df19b`
- 在 `tangge233/PCL2` 和 `PCL-Community/PCL2-Language` 的 Fork 网络也核对到了同一旧提交。

修改版源码包已包含固定版本 MeloongCore 源码，不依赖 Fork 将来是否保留旧提交。
源码包排除了 Git 元数据、构建缓存、编译产物、上游历史补丁目录 `patches/` 和上游官方程序包 `最新正式版.zip`；保留全部构建源码和构建资源。原始源码备份包同样排除发行附件，源码内容未修改。
`changes.patch` 记录对上游现有文件的修改；新增构建脚本及本说明随修改版源码包提供。

## 许可与署名

本项目免费分发，遵循原样保留的 [LICENCE](LICENCE) 中的《PCL 分发有限许可》和《PCL 存储库合理使用指南》。这是自定义许可的源码可见项目，不将整个项目重新许可为 MIT、GPL 或 CC BY-SA。指南明确声明其不是法律文件或协议，并对遵守指南的善意合理使用作出不追究责任的承诺；分发许可本身授予的是原样副本的有限分发权，两者不应混同。

本修改版独立维护，不代表原作者或获得其背书。关于页面首位保留龙腾猫跃署名和赞助链接，保持蓝色主题、原版购买及赞助劝导，不提供官方赞助解锁功能。第三方组件遵循各自许可，详见 THIRD-PARTY-NOTICES.md。

## 构建

Git 克隆时使用 `git clone --recurse-submodules https://github.com/stoneorwater/PCL-LocalFrozen.git`。GitHub 自动生成的源码 ZIP 不含子模块，请下载本项目提供的完整源码包，或按上述固定提交补齐 MeloongCore。

已实测 Windows x64 .NET SDK 10.0.402，目标仍是 .NET Framework 4.8。

```powershell
./Build-LocalFrozen.ps1 -DotNetPath 'C:/path/to/dotnet.exe'
```

脚本将 NuGet 包和 SDK 用户目录保存在源码目录下的 `.build/`，需要联网还原依赖。
可省略 `-DotNetPath` 使用 PATH 中的 `dotnet`；仅安装运行时不足以构建。
产物为 `Plain Craft Launcher 2/bin/Plain Craft Launcher 2.exe`，可重命名为 `PCL-LocalFrozen.exe`。
运行时不要求安装 .NET 10；它只用于源码编译。
