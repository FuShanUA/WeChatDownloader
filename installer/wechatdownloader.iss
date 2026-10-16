#define MyAppName "WeChatDownloader"
#define MyAppVersion "1.0.11"
#define MyAppPublisher "FuShanUA"
#define MyAppURL "https://github.com/FuShanUA/WeChatDownloader"
#define MyAppExeName "WeChatDownloader.exe"

[Setup]
AppId={{A9E5F66E-2F9C-4468-98ED-366CCA453E74}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}/issues
AppUpdatesURL={#MyAppURL}/releases
AppCopyright=Copyright (c) 2026 {#MyAppPublisher}
AppComments=WeChat Channels downloader
AppReadmeFile={app}\WINDOWS_TEST.md
DefaultDirName={localappdata}\Programs\{#MyAppName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
OutputDir=..\dist
OutputBaseFilename=WeChatDownloader-Setup
SetupIconFile=..\assets\wechat_downloader_icon.ico
UninstallDisplayIcon={app}\{#MyAppExeName}
UninstallDisplayName={#MyAppName}
LicenseFile=..\LICENSE
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=lowest
MinVersion=10.0
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
SetupLogging=yes
CloseApplications=yes
RestartApplications=yes

[Languages]
Name: "chinesesimplified"; MessagesFile: "compiler:Languages\ChineseSimplified.isl"

[Tasks]
Name: "desktopicon"; Description: "创建桌面快捷方式"; GroupDescription: "附加任务:"; Flags: checkedonce

[Files]
Source: "..\dist\WeChatDownloader.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\1-一键安装.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\2-启动 WeChatDownloader.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\WINDOWS_TEST.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\LICENSE"; DestDir: "{app}"; DestName: "LICENSE.txt"; Flags: ignoreversion

[Icons]
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; WorkingDir: "{app}"; Tasks: desktopicon
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; WorkingDir: "{app}"
Name: "{group}\一键安装依赖"; Filename: "{app}\1-一键安装.bat"; WorkingDir: "{app}"
Name: "{group}\启动 WeChatDownloader"; Filename: "{app}\2-启动 WeChatDownloader.bat"; WorkingDir: "{app}"

[Run]
Filename: "{app}\1-一键安装.bat"; Description: "安装依赖并配置证书"; Flags: postinstall skipifsilent unchecked; WorkingDir: "{app}"
Filename: "{app}\{#MyAppExeName}"; Description: "启动 {#MyAppName}"; Flags: postinstall skipifsilent unchecked; WorkingDir: "{app}"
