# Build.ps1 - 打包脚本
param(
    [string]$InputFile = "ScoopInstaller.ps1",
    [string]$OutputFile = "ScoopInstaller.exe",
    [string]$IconFile = ""
)

# 检查输入文件是否存在
if (-not (Test-Path $InputFile)) {
    Write-Error "输入文件 $InputFile 不存在"
    exit 1
}

# 打包命令
$params = @{
    inputFile = $InputFile
    outputFile = $OutputFile
    title = "Scoop 一键安装工具"
    description = "Scoop 开发环境一键安装工具"
    company = "Scoop Installer"
    product = "Scoop Installer"
    copyright = "Copyright © 2024"
    version = "1.0.0.0"
    requireAdmin = $true
    noConsole = $false
}

# 如果有图标文件，添加图标参数
if ($IconFile -and (Test-Path $IconFile)) {
    $params.iconFile = $IconFile
}

# 执行打包
Invoke-PS2EXE @params

Write-Host "✅ 打包完成: $OutputFile" -ForegroundColor Green