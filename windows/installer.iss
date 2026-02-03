; Inno Setup 脚本 - Photo Refractor Windows 安装包
; 编译时通过 /DReleaseDir="<path>" 传入构建输出目录

#ifndef ReleaseDir
#define ReleaseDir "..\build\windows\x64\runner\Release"
#endif

[Setup]
AppId={{A1B2C3D4-E5F6-7890-ABCD-EF1234567890}
AppName=Photo Refractor
AppVersion=1.0.0
AppPublisher=com.example
DefaultDirName={autopf}\Photo Refractor
DefaultGroupName=Photo Refractor
OutputDir=Output
OutputBaseFilename=photo_refractor_Setup
Compression=lzma2
SolidCompression=yes
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
SetupIconFile=runner\resources\app_icon.ico
UninstallDisplayIcon={app}\photo_refractor.exe

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "{#ReleaseDir}\*"; DestDir: "{app}"; Flags: recursesubdirs ignoreversion

[Icons]
Name: "{autoprograms}\Photo Refractor"; Filename: "{app}\photo_refractor.exe"
Name: "{autodesktop}\Photo Refractor"; Filename: "{app}\photo_refractor.exe"

[Run]
Filename: "{app}\photo_refractor.exe"; Description: "Launch Photo Refractor"; Flags: nowait postinstall skipifsilent
