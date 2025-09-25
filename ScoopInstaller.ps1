Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# 默认工具清单
$defaultTools = @(
    "git",
    "openjdk", 
    "maven",
    "nodejs",
    "python",
    "curl",
    "terraform"
)

# 创建主窗体
$form = New-Object System.Windows.Forms.Form
$form.Text = "Scoop 一键安装工具 (国内镜像版)"
$form.Size = New-Object System.Drawing.Size(800, 700)
$form.StartPosition = "CenterScreen"
$form.MaximizeBox = $false

# 创建选项卡控件
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Location = New-Object System.Drawing.Point(10, 10)
$tabControl.Size = New-Object System.Drawing.Size(770, 650)
$form.Controls.Add($tabControl)

# 第一个选项卡：环境设置
$envTab = New-Object System.Windows.Forms.TabPage
$envTab.Text = "环境设置"
$tabControl.Controls.Add($envTab)

# 第二个选项卡：工具安装
$toolsTab = New-Object System.Windows.Forms.TabPage
$toolsTab.Text = "工具安装"
$tabControl.Controls.Add($toolsTab)

# ========== 环境设置选项卡内容 ==========
# 安装目录设置区域
$dirLabel = New-Object System.Windows.Forms.Label
$dirLabel.Text = "Scoop 安装目录:"
$dirLabel.Location = New-Object System.Drawing.Point(20, 20)
$dirLabel.Size = New-Object System.Drawing.Size(120, 20)
$envTab.Controls.Add($dirLabel)

$defaultDir = "D:\Applications\Scoop"
$dirTextBox = New-Object System.Windows.Forms.TextBox
$dirTextBox.Text = $defaultDir
$dirTextBox.Location = New-Object System.Drawing.Point(140, 20)
$dirTextBox.Size = New-Object System.Drawing.Size(300, 20)
$envTab.Controls.Add($dirTextBox)

$browseButton = New-Object System.Windows.Forms.Button
$browseButton.Text = "浏览"
$browseButton.Location = New-Object System.Drawing.Point(450, 18)
$browseButton.Size = New-Object System.Drawing.Size(60, 25)
$envTab.Controls.Add($browseButton)

$dirWarningLabel = New-Object System.Windows.Forms.Label
$dirWarningLabel.Text = "⚠️ 请使用英文路径，不要包含中文"
$dirWarningLabel.ForeColor = [System.Drawing.Color]::OrangeRed
$dirWarningLabel.Location = New-Object System.Drawing.Point(20, 45)
$dirWarningLabel.Size = New-Object System.Drawing.Size(300, 20)
$envTab.Controls.Add($dirWarningLabel)

# 路径验证标签
$pathValidLabel = New-Object System.Windows.Forms.Label
$pathValidLabel.Text = ""
$pathValidLabel.Location = New-Object System.Drawing.Point(20, 70)
$pathValidLabel.Size = New-Object System.Drawing.Size(300, 20)
$envTab.Controls.Add($pathValidLabel)

# 网络设置区域
$networkLabel = New-Object System.Windows.Forms.Label
$networkLabel.Text = "网络设置:"
$networkLabel.Location = New-Object System.Drawing.Point(520, 20)
$networkLabel.Size = New-Object System.Drawing.Size(100, 20)
$envTab.Controls.Add($networkLabel)

$useMirrorCheckBox = New-Object System.Windows.Forms.CheckBox
$useMirrorCheckBox.Text = "使用国内镜像"
$useMirrorCheckBox.Location = New-Object System.Drawing.Point(520, 45)
$useMirrorCheckBox.Size = New-Object System.Drawing.Size(120, 20)
$useMirrorCheckBox.Checked = $true
$envTab.Controls.Add($useMirrorCheckBox)

# 环境检测按钮
$checkEnvButton = New-Object System.Windows.Forms.Button
$checkEnvButton.Text = "检测环境"
$checkEnvButton.Location = New-Object System.Drawing.Point(20, 100)
$checkEnvButton.Size = New-Object System.Drawing.Size(100, 30)
$envTab.Controls.Add($checkEnvButton)

$fixPolicyButton = New-Object System.Windows.Forms.Button
$fixPolicyButton.Text = "修复执行策略"
$fixPolicyButton.Location = New-Object System.Drawing.Point(140, 100)
$fixPolicyButton.Size = New-Object System.Drawing.Size(120, 30)
$fixPolicyButton.Enabled = $false
$envTab.Controls.Add($fixPolicyButton)

$setPathButton = New-Object System.Windows.Forms.Button
$setPathButton.Text = "设置安装路径"
$setPathButton.Location = New-Object System.Drawing.Point(280, 100)
$setPathButton.Size = New-Object System.Drawing.Size(120, 30)
$setPathButton.Enabled = $false
$envTab.Controls.Add($setPathButton)

$installScoopButton = New-Object System.Windows.Forms.Button
$installScoopButton.Text = "安装 Scoop"
$installScoopButton.Location = New-Object System.Drawing.Point(420, 100)
$installScoopButton.Size = New-Object System.Drawing.Size(100, 30)
$installScoopButton.Enabled = $false
$envTab.Controls.Add($installScoopButton)

$addBucketButton = New-Object System.Windows.Forms.Button
$addBucketButton.Text = "添加国内源"
$addBucketButton.Location = New-Object System.Drawing.Point(540, 100)
$addBucketButton.Size = New-Object System.Drawing.Size(100, 30)
$addBucketButton.Enabled = $false
$envTab.Controls.Add($addBucketButton)

# 一键安装按钮
$oneClickInstallButton = New-Object System.Windows.Forms.Button
$oneClickInstallButton.Text = "一键安装（推荐）"
$oneClickInstallButton.Location = New-Object System.Drawing.Point(20, 550)
$oneClickInstallButton.Size = New-Object System.Drawing.Size(150, 40)
$oneClickInstallButton.BackColor = [System.Drawing.Color]::LightGreen
$oneClickInstallButton.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 9, [System.Drawing.FontStyle]::Bold)
$envTab.Controls.Add($oneClickInstallButton)

# 环境设置日志
$envLogTextBox = New-Object System.Windows.Forms.TextBox
$envLogTextBox.Multiline = $true
$envLogTextBox.ScrollBars = "Vertical"
$envLogTextBox.ReadOnly = $true
$envLogTextBox.Location = New-Object System.Drawing.Point(20, 140)
$envLogTextBox.Size = New-Object System.Drawing.Size(720, 400)
$envTab.Controls.Add($envLogTextBox)

# 环境设置进度条
$envProgressBar = New-Object System.Windows.Forms.ProgressBar
$envProgressBar.Location = New-Object System.Drawing.Point(180, 560)
$envProgressBar.Size = New-Object System.Drawing.Size(560, 20)
$envProgressBar.Visible = $false
$envTab.Controls.Add($envProgressBar)

# ========== 工具安装选项卡内容 ==========
# 工具选择区域
$toolsGroup = New-Object System.Windows.Forms.GroupBox
$toolsGroup.Text = "选择要安装的开发工具"
$toolsGroup.Location = New-Object System.Drawing.Point(20, 20)
$toolsGroup.Size = New-Object System.Drawing.Size(350, 300)
$toolsTab.Controls.Add($toolsGroup)

# 工具复选框列表
$toolsCheckBoxes = @{}
$yPos = 20
foreach ($tool in $defaultTools) {
    $checkBox = New-Object System.Windows.Forms.CheckBox
    $checkBox.Text = $tool
    $checkBox.Location = New-Object System.Drawing.Point(20, $yPos)
    $checkBox.Size = New-Object System.Drawing.Size(120, 20)
    $checkBox.Checked = $true
    $toolsGroup.Controls.Add($checkBox)
    $toolsCheckBoxes[$tool] = $checkBox
    $yPos += 25
}

# 全选/全不选按钮
$selectAllButton = New-Object System.Windows.Forms.Button
$selectAllButton.Text = "全选"
$selectAllButton.Location = New-Object System.Drawing.Point(150, 20)
$selectAllButton.Size = New-Object System.Drawing.Size(60, 25)
$toolsGroup.Controls.Add($selectAllButton)

$selectNoneButton = New-Object System.Windows.Forms.Button
$selectNoneButton.Text = "全不选"
$selectNoneButton.Location = New-Object System.Drawing.Point(220, 20)
$selectNoneButton.Size = New-Object System.Drawing.Size(60, 25)
$toolsGroup.Controls.Add($selectNoneButton)

# 自定义工具添加区域
$customGroup = New-Object System.Windows.Forms.GroupBox
$customGroup.Text = "添加自定义工具"
$customGroup.Location = New-Object System.Drawing.Point(20, 330)
$customGroup.Size = New-Object System.Drawing.Size(350, 100)
$toolsTab.Controls.Add($customGroup)

$customToolLabel = New-Object System.Windows.Forms.Label
$customToolLabel.Text = "工具名称 (Scoop包名):"
$customToolLabel.Location = New-Object System.Drawing.Point(20, 25)
$customToolLabel.Size = New-Object System.Drawing.Size(150, 20)
$customGroup.Controls.Add($customToolLabel)

$customToolTextBox = New-Object System.Windows.Forms.TextBox
$customToolTextBox.Location = New-Object System.Drawing.Point(20, 50)
$customToolTextBox.Size = New-Object System.Drawing.Size(200, 20)
$customGroup.Controls.Add($customToolTextBox)

$addCustomButton = New-Object System.Windows.Forms.Button
$addCustomButton.Text = "添加"
$addCustomButton.Location = New-Object System.Drawing.Point(230, 48)
$addCustomButton.Size = New-Object System.Drawing.Size(60, 25)
$customGroup.Controls.Add($addCustomButton)

# 安装控制区域
$installToolsButton = New-Object System.Windows.Forms.Button
$installToolsButton.Text = "安装选中工具"
$installToolsButton.Location = New-Object System.Drawing.Point(400, 20)
$installToolsButton.Size = New-Object System.Drawing.Size(120, 40)
$installToolsButton.Enabled = $false
$toolsTab.Controls.Add($installToolsButton)

$installExtrasButton = New-Object System.Windows.Forms.Button
$installExtrasButton.Text = "添加 Extras Bucket"
$installExtrasButton.Location = New-Object System.Drawing.Point(400, 70)
$installExtrasButton.Size = New-Object System.Drawing.Size(120, 40)
$installExtrasButton.Enabled = $false
$toolsTab.Controls.Add($installExtrasButton)

# 工具安装日志
$toolsLogTextBox = New-Object System.Windows.Forms.TextBox
$toolsLogTextBox.Multiline = $true
$toolsLogTextBox.ScrollBars = "Vertical"
$toolsLogTextBox.ReadOnly = $true
$toolsLogTextBox.Location = New-Object System.Drawing.Point(400, 120)
$toolsLogTextBox.Size = New-Object System.Drawing.Size(350, 400)
$toolsTab.Controls.Add($toolsLogTextBox)

# 工具安装进度条
$toolsProgressBar = New-Object System.Windows.Forms.ProgressBar
$toolsProgressBar.Location = New-Object System.Drawing.Point(400, 530)
$toolsProgressBar.Size = New-Object System.Drawing.Size(350, 20)
$toolsProgressBar.Visible = $false
$toolsTab.Controls.Add($toolsProgressBar)

# 添加日志函数（环境选项卡）
function Add-EnvLog {
    param([string]$Message)
    $timestamp = Get-Date -Format "HH:mm:ss"
    $envLogTextBox.AppendText("[$timestamp] $Message`r`n")
    $envLogTextBox.SelectionStart = $envLogTextBox.Text.Length
    $envLogTextBox.ScrollToCaret()
    $envLogTextBox.Refresh()
}

# 添加日志函数（工具选项卡）
function Add-ToolsLog {
    param([string]$Message)
    $timestamp = Get-Date -Format "HH:mm:ss"
    $toolsLogTextBox.AppendText("[$timestamp] $Message`r`n")
    $toolsLogTextBox.SelectionStart = $toolsLogTextBox.Text.Length
    $toolsLogTextBox.ScrollToCaret()
    $toolsLogTextBox.Refresh()
}

# 检查路径是否包含中文
function Test-ChinesePath {
    param([string]$Path)
    
    if ($Path -match "[一-龥]") {
        return $false
    }
    
    try {
        [System.IO.Path]::GetFullPath($Path) | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

# 更新路径验证状态
function Update-PathValidation {
    $path = $dirTextBox.Text.Trim()
    
    if ([string]::IsNullOrWhiteSpace($path)) {
        $pathValidLabel.Text = "❌ 路径不能为空"
        $pathValidLabel.ForeColor = [System.Drawing.Color]::Red
        $setPathButton.Enabled = $false
        $oneClickInstallButton.Enabled = $false
        return $false
    }
    
    if (Test-ChinesePath $path) {
        $pathValidLabel.Text = "✅ 路径格式正确"
        $pathValidLabel.ForeColor = [System.Drawing.Color]::Green
        $setPathButton.Enabled = $true
        $oneClickInstallButton.Enabled = $true
        return $true
    }
    else {
        $pathValidLabel.Text = "❌ 路径包含中文或格式不正确"
        $pathValidLabel.ForeColor = [System.Drawing.Color]::Red
        $setPathButton.Enabled = $false
        $oneClickInstallButton.Enabled = $false
        return $false
    }
}

# 设置 Scoop 安装路径
function Set-ScoopPath {
    param([string]$Path)
    
    Add-EnvLog "🛠️ 正在设置 Scoop 安装路径..."
    
    try {
        [Environment]::SetEnvironmentVariable('SCOOP', $Path, 'User')
        $env:SCOOP = $Path
        
        Add-EnvLog "✅ Scoop 安装路径已设置为: $Path"
        Add-EnvLog "📁 环境变量 SCOOP = $Path"
        
        $installScoopButton.Enabled = $true
        
        return $true
    }
    catch {
        Add-EnvLog "❌ 设置路径失败: $($_.Exception.Message)"
        return $false
    }
}

# 检测执行策略函数
function Check-ExecutionPolicy {
    Add-EnvLog "🔍 正在检测PowerShell执行策略..."
    
    $currentPolicy = Get-ExecutionPolicy
    
    if ($currentPolicy -eq "Restricted") {
        Add-EnvLog "❌ 检测到执行策略: Restricted (受限制)"
        Add-EnvLog "⚠️  当前设置阻止运行Scoop安装脚本"
        Add-EnvLog "💡 解决方案: 点击'修复执行策略'按钮自动修复"
        $fixPolicyButton.Enabled = $true
        return $false
    }
    elseif ($currentPolicy -eq "RemoteSigned" -or $currentPolicy -eq "Unrestricted" -or $currentPolicy -eq "Bypass") {
        Add-EnvLog "✅ 执行策略检测通过: $currentPolicy"
        Add-EnvLog "🎉 可以正常使用Scoop安装工具"
        $fixPolicyButton.Enabled = $false
        $setPathButton.Enabled = $true
        
        Update-PathValidation
        return $true
    }
    else {
        Add-EnvLog "❓ 未知的执行策略: $currentPolicy"
        Add-EnvLog "💡 建议: 点击'修复执行策略'按钮设置为推荐值"
        $fixPolicyButton.Enabled = $true
        return $false
    }
}

# 修复执行策略函数
function Fix-ExecutionPolicy {
    Add-EnvLog "🛠️  正在修复PowerShell执行策略..."
    $fixPolicyButton.Enabled = $false
    $envProgressBar.Visible = $true
    $envProgressBar.Style = "Marquee"
    
    try {
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        Add-EnvLog "✅ 执行策略修复命令已执行"
        Add-EnvLog "🔄 重新检测执行策略..."
        Start-Sleep -Seconds 1
        
        if (Check-ExecutionPolicy) {
            return $true
        } else {
            Add-EnvLog "❌ 修复后检测仍然失败"
            $fixPolicyButton.Enabled = $true
            return $false
        }
    }
    catch {
        Add-EnvLog "❌ 修复失败: $($_.Exception.Message)"
        Add-EnvLog "💡 请尝试以管理员身份运行此脚本"
        $fixPolicyButton.Enabled = $true
        return $false
    }
    finally {
        $envProgressBar.Visible = $false
    }
}

# 检查 Scoop 是否已安装
function Test-ScoopInstalled {
    try {
        $scoopVersion = scoop --version 2>$null
        return $true
    }
    catch {
        return $false
    }
}

# 测试网络连接
function Test-NetworkConnection {
    param([string]$Url)
    
    try {
        $request = [System.Net.WebRequest]::Create($Url)
        $request.Timeout = 10000 # 10秒超时
        $response = $request.GetResponse()
        $response.Close()
        return $true
    }
    catch {
        return $false
    }
}

# 下载文件函数（支持重试）
function Download-FileWithRetry {
    param([string]$Url, [string]$OutputPath, [int]$MaxRetries = 3)
    
    for ($i = 1; $i -le $MaxRetries; $i++) {
        try {
            Add-EnvLog "→ 尝试下载 ($i/$MaxRetries): $Url"
            
            # 使用WebClient下载
            $webClient = New-Object System.Net.WebClient
            $webClient.DownloadFile($Url, $OutputPath)
            
            if (Test-Path $OutputPath -PathType Leaf) {
                $fileSize = (Get-Item $OutputPath).Length
                if ($fileSize -gt 0) {
                    Add-EnvLog "✅ 下载成功，文件大小: $($fileSize) 字节"
                    return $true
                }
            }
        }
        catch {
            Add-EnvLog "⚠️ 下载失败: $($_.Exception.Message)"
            if ($i -lt $MaxRetries) {
                Add-EnvLog "🔄 等待3秒后重试..."
                Start-Sleep -Seconds 3
            }
        }
    }
    
    return $false
}

# 安装 Scoop 函数（使用国内镜像源）
function Install-Scoop {
    if ([string]::IsNullOrEmpty($env:SCOOP)) {
        Add-EnvLog "❌ 请先设置 Scoop 安装路径"
        return $false
    }
    
    if (Test-ScoopInstalled) {
        Add-EnvLog "✅ Scoop 已经安装，跳过安装步骤"
        $addBucketButton.Enabled = $true
        $installExtrasButton.Enabled = $true
        $installToolsButton.Enabled = $true
        return $true
    }
    
    Add-EnvLog "📦 开始安装 Scoop..."
    $installScoopButton.Enabled = $false
    $envProgressBar.Visible = $true
    $envProgressBar.Style = "Marquee"
    
    try {
        # 检查是否使用国内镜像
        $useMirror = $useMirrorCheckBox.Checked
        
        if ($useMirror) {
            Add-EnvLog "🌐 使用国内镜像源安装..."
            return Install-Scoop-WithMirror
        } else {
            Add-EnvLog "🌐 使用官方源安装..."
            return Install-Scoop-Official
        }
    }
    catch {
        Add-EnvLog "❌ 安装过程中出现错误: $($_.Exception.Message)"
        Add-EnvLog "💡 建议: 检查网络连接，或尝试使用国内镜像"
        $installScoopButton.Enabled = $true
        return $false
    }
    finally {
        $envProgressBar.Visible = $false
    }
}

# 使用国内镜像安装 Scoop
function Install-Scoop-WithMirror {
    $installScriptPath = Join-Path $env:TEMP "scoop-install.ps1"
    
    # 国内镜像源列表（按优先级排序）
    $mirrors = @(
        @{Name = "Gitee镜像"; Url = "https://gitee.com/scoop-installer/install/raw/master/install.ps1"},
        @{Name = "GitHub代理"; Url = "https://ghproxy.com/https://raw.githubusercontent.com/ScoopInstaller/Install/master/install.ps1"},
        @{Name = "FastGit镜像"; Url = "https://raw.fastgit.org/ScoopInstaller/Install/master/install.ps1"}
    )
    
    # 尝试从各个镜像源下载
    $downloadSuccess = $false
    foreach ($mirror in $mirrors) {
        Add-EnvLog "→ 尝试从 $($mirror.Name) 下载..."
        
        if (Download-FileWithRetry -Url $mirror.Url -OutputPath $installScriptPath) {
            $downloadSuccess = $true
            break
        }
    }
    
    if (-not $downloadSuccess) {
        Add-EnvLog "❌ 所有镜像源下载失败，尝试官方源..."
        return Install-Scoop-Official
    }
    
    # 修改安装脚本使用国内镜像
    Add-EnvLog "→ 配置使用国内镜像源..."
    try {
        $scriptContent = Get-Content $installScriptPath -Raw -ErrorAction Stop
        
        # 替换GitHub地址为国内镜像
        $scriptContent = $scriptContent -replace 'https://github.com/ScoopInstaller/Scoop', 'https://gitee.com/scoop-installer/scoop'
        $scriptContent = $scriptContent -replace 'https://raw.githubusercontent.com/ScoopInstaller/', 'https://gitee.com/scoop-installer/'
        
        Set-Content -Path $installScriptPath -Value $scriptContent -Force -ErrorAction Stop
        Add-EnvLog "✅ 镜像配置完成"
    }
    catch {
        Add-EnvLog "⚠️ 镜像配置失败，但继续安装: $($_.Exception.Message)"
    }
    
    # 运行安装脚本
    Add-EnvLog "→ 运行 Scoop 安装脚本..."
    
    try {
        # 设置环境变量
        $env:SCOOP = $dirTextBox.Text.Trim()
        [Environment]::SetEnvironmentVariable('SCOOP', $dirTextBox.Text.Trim(), 'User')
        
        # 运行下载的安装脚本
        & $installScriptPath -RunAsAdmin:$false
        
        # 检查安装是否成功
        Start-Sleep -Seconds 3
        if (Test-ScoopInstalled) {
            Add-EnvLog "✅ Scoop 安装成功！"
            Add-EnvLog "🎉 版本信息: $(scoop --version)"
            
            # 配置Scoop使用国内镜像
            Configure-ScoopMirror
            
            $addBucketButton.Enabled = $true
            $installExtrasButton.Enabled = $true
            $installToolsButton.Enabled = $true
            return $true
        }
        else {
            Add-EnvLog "❌ Scoop 安装失败，尝试备用方法..."
            return Install-Scoop-Backup
        }
    }
    finally {
        # 清理临时文件
        if (Test-Path $installScriptPath) {
            Remove-Item $installScriptPath -Force -ErrorAction SilentlyContinue
        }
    }
}

# 使用官方源安装 Scoop
function Install-Scoop-Official {
    $installScriptPath = Join-Path $env:TEMP "scoop-install.ps1"
    
    # 官方源
    $officialUrl = "https://raw.githubusercontent.com/ScoopInstaller/Install/master/install.ps1"
    
    Add-EnvLog "→ 从官方源下载安装脚本..."
    if (-not (Download-FileWithRetry -Url $officialUrl -OutputPath $installScriptPath)) {
        Add-EnvLog "❌ 官方源下载失败，尝试备用方法..."
        return Install-Scoop-Backup
    }
    
    # 运行安装脚本
    Add-EnvLog "→ 运行 Scoop 安装脚本..."
    
    try {
        # 设置环境变量
        $env:SCOOP = $dirTextBox.Text.Trim()
        [Environment]::SetEnvironmentVariable('SCOOP', $dirTextBox.Text.Trim(), 'User')
        
        # 运行下载的安装脚本
        & $installScriptPath -RunAsAdmin:$false
        
        # 检查安装是否成功
        Start-Sleep -Seconds 3
        if (Test-ScoopInstalled) {
            Add-EnvLog "✅ Scoop 安装成功！"
            Add-EnvLog "🎉 版本信息: $(scoop --version)"
            
            $addBucketButton.Enabled = $true
            $installExtrasButton.Enabled = $true
            $installToolsButton.Enabled = $true
            return $true
        }
        else {
            Add-EnvLog "❌ Scoop 安装失败，尝试备用方法..."
            return Install-Scoop-Backup
        }
    }
    finally {
        # 清理临时文件
        if (Test-Path $installScriptPath) {
            Remove-Item $installScriptPath -Force -ErrorAction SilentlyContinue
        }
    }
}

# 备用安装方法
function Install-Scoop-Backup {
    Add-EnvLog "🔄 尝试备用安装方法..."
    
    try {
        # 方法1: 使用scoop-cn提供的离线安装
        Add-EnvLog "→ 尝试使用 scoop-cn 离线安装..."
        
        # 设置环境变量
        $env:SCOOP = $dirTextBox.Text.Trim()
        [Environment]::SetEnvironmentVariable('SCOOP', $dirTextBox.Text.Trim(), 'User')
        
        # 使用scoop-cn的安装命令
        $installCommand = @"
iex (new-object net.webclient).downloadstring('https://gitee.com/glsnames/scoop-installer/raw/master/bin/install.ps1')
"@
        
        Invoke-Expression $installCommand
        
        # 检查安装是否成功
        Start-Sleep -Seconds 3
        if (Test-ScoopInstalled) {
            Add-EnvLog "✅ 备用安装方法成功！"
            
            # 配置国内镜像
            Configure-ScoopMirror
            
            $addBucketButton.Enabled = $true
            $installExtrasButton.Enabled = $true
            $installToolsButton.Enabled = $true
            return $true
        }
        else {
            throw "备用安装方法验证失败"
        }
    }
    catch {
        Add-EnvLog "❌ 备用安装方法失败: $($_.Exception.Message)"
        Show-ManualDownloadInstructions
        return $false
    }
}

# # 配置Scoop使用国内镜像
# function Configure-ScoopMirror {
#     Add-EnvLog "🔄 配置Scoop使用国内镜像..."
    
#     try {
#         # 添加scoop-cn国内源
#         scoop bucket add scoop-cn https://gitee.com/duzyn/scoop-cn 2>$null
#         Add-EnvLog "✅ 已添加 scoop-cn 国内源"
        
#         # 配置git使用代理（可选）
#         git config --global url."https://ghproxy.com/https://github.com".insteadOf "https://github.com" 2>$null
        
#         Add-EnvLog "✅ Scoop镜像配置完成"
#         return $true
#     }
#     catch {
#         Add-EnvLog "⚠️ 镜像配置失败，但不影响基本使用: $($_.Exception.Message)"
#         return $false
#     }
# }

# 显示手动下载说明
function Show-ManualDownloadInstructions {
    Add-EnvLog "========================================"
    Add-EnvLog "📋 手动安装说明:"
    Add-EnvLog "1. 访问 https://gitee.com/scoop-installer/install"
    Add-EnvLog "2. 下载 install.ps1 文件到当前目录"
    Add-EnvLog "3. 手动运行: .\install.ps1 -ScoopDir '$($dirTextBox.Text)'"
    Add-EnvLog "4. 或使用 scoop-cn 离线安装"
    Add-EnvLog "========================================"
    
    # 显示对话框提示
    $result = [System.Windows.Forms.MessageBox]::Show(
        "自动安装失败，是否打开手动安装说明页面？", 
        "安装失败", 
        [System.Windows.Forms.MessageBoxButtons]::YesNo, 
        [System.Windows.Forms.MessageBoxIcon]::Information
    )
    
    if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
        Start-Process "https://gitee.com/scoop-installer/install"
    }
}

# 添加国内源
function Add-ScoopBucket {
    Add-EnvLog "🌐 正在添加 Scoop 国内源..."
    $addBucketButton.Enabled = $false
    $envProgressBar.Visible = $true
    $envProgressBar.Style = "Marquee"
    
    try {
        if (-not (Test-ScoopInstalled)) {
            Add-EnvLog "❌ 请先安装 Scoop"
            return $false
        }
        
        Add-EnvLog "→ 添加国内源: scoop bucket add scoop-cn https://gitee.com/duzyn/scoop-cn"
        $result = scoop bucket add scoop-cn https://gitee.com/duzyn/scoop-cn 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Add-EnvLog "✅ 国内源添加成功！"
            return $true
        }
        else {
            if ($result -like "*already exists*") {
                Add-EnvLog "✅ scoop-cn 国内源已存在"
                return $true
            }
            else {
                Add-EnvLog "❌ 添加国内源失败: $result"
                $addBucketButton.Enabled = $true
                return $false
            }
        }
    }
    catch {
        Add-EnvLog "❌ 添加国内源过程中出现错误: $($_.Exception.Message)"
        $addBucketButton.Enabled = $true
        return $false
    }
    finally {
        $envProgressBar.Visible = $false
    }
}

# 添加 Extras Bucket
function Add-ExtrasBucket {
    Add-ToolsLog "📚 正在添加 Extras Bucket..."
    $installExtrasButton.Enabled = $false
    $toolsProgressBar.Visible = $true
    $toolsProgressBar.Style = "Marquee"
    
    try {
        if (-not (Test-ScoopInstalled)) {
            Add-ToolsLog "❌ 请先安装 Scoop"
            return $false
        }
        
        Add-ToolsLog "→ 添加 Extras Bucket: scoop bucket add extras"
        $result = scoop bucket add extras 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Add-ToolsLog "✅ Extras Bucket 添加成功！"
            Add-ToolsLog "🎉 现在可以访问更多软件包"
            return $true
        }
        else {
            if ($result -like "*already exists*") {
                Add-ToolsLog "✅ Extras Bucket 已存在"
                return $true
            }
            else {
                Add-ToolsLog "❌ 添加 Extras Bucket 失败: $result"
                $installExtrasButton.Enabled = $true
                return $false
            }
        }
    }
    catch {
        Add-ToolsLog "❌ 添加 Extras Bucket 过程中出现错误: $($_.Exception.Message)"
        $installExtrasButton.Enabled = $true
        return $false
    }
    finally {
        $toolsProgressBar.Visible = $false
    }
}

# 安装选中的工具
function Install-SelectedTools {
    $selectedTools = @()
    foreach ($tool in $toolsCheckBoxes.Keys) {
        if ($toolsCheckBoxes[$tool].Checked) {
            $selectedTools += $tool
        }
    }
    
    if ($selectedTools.Count -eq 0) {
        Add-ToolsLog "⚠️ 请至少选择一个工具进行安装"
        return
    }
    
    Add-ToolsLog "🚀 开始安装选中的工具: $($selectedTools -join ', ')"
    $installToolsButton.Enabled = $false
    $toolsProgressBar.Visible = $true
    $toolsProgressBar.Style = "Continuous"
    $toolsProgressBar.Value = 0
    
    $successCount = 0
    $totalCount = $selectedTools.Count
    
    for ($i = 0; $i -lt $totalCount; $i++) {
        $tool = $selectedTools[$i]
        $progress = [int](($i / $totalCount) * 100)
        $toolsProgressBar.Value = $progress
        
        Add-ToolsLog "📦 正在安装 $tool ... ($($i+1)/$totalCount)"
        
        try {
            $result = scoop install $tool 2>&1
            if ($LASTEXITCODE -eq 0) {
                Add-ToolsLog "✅ $tool 安装成功"
                $successCount++
            }
            else {
                if ($result -like "*already installed*") {
                    Add-ToolsLog "✅ $tool 已经安装"
                    $successCount++
                }
                else {
                    Add-ToolsLog "❌ $tool 安装失败: $result"
                }
            }
        }
        catch {
            Add-ToolsLog "❌ $tool 安装过程中出现错误: $($_.Exception.Message)"
        }
        
        # 更新进度
        $toolsProgressBar.Value = [int]((($i + 1) / $totalCount) * 100)
        [System.Windows.Forms.Application]::DoEvents()
    }
    
    $toolsProgressBar.Value = 100
    Add-ToolsLog "🎉 工具安装完成！成功: $successCount/$totalCount"
    
    if ($successCount -eq $totalCount) {
        Add-ToolsLog "✅ 所有工具都安装成功！"
    }
    else {
        Add-ToolsLog "⚠️ 部分工具安装失败，可以尝试重新安装"
    }
    
    $installToolsButton.Enabled = $true
    $toolsProgressBar.Visible = $false
}

# 添加自定义工具
function Add-CustomTool {
    $toolName = $customToolTextBox.Text.Trim()
    
    if ([string]::IsNullOrWhiteSpace($toolName)) {
        [System.Windows.Forms.MessageBox]::Show("请输入工具名称", "提示")
        return
    }
    
    if ($toolsCheckBoxes.ContainsKey($toolName)) {
        [System.Windows.Forms.MessageBox]::Show("该工具已存在", "提示")
        return
    }
    
    # 创建新的复选框
    $checkBox = New-Object System.Windows.Forms.CheckBox
    $checkBox.Text = $toolName
    $checkBox.Location = New-Object System.Drawing.Point(20, $yPos)
    $checkBox.Size = New-Object System.Drawing.Size(120, 20)
    $checkBox.Checked = $true
    $toolsGroup.Controls.Add($checkBox)
    $toolsCheckBoxes[$toolName] = $checkBox
    
    # 更新工具组高度
    $yPos += 25
    $toolsGroup.Height = [Math]::Max(300, $yPos + 20)
    
    Add-ToolsLog "✅ 已添加自定义工具: $toolName"
    $customToolTextBox.Text = ""
}

# 全选工具
function Select-AllTools {
    foreach ($checkBox in $toolsCheckBoxes.Values) {
        $checkBox.Checked = $true
    }
    Add-ToolsLog "✅ 已选择所有工具"
}

# 全不选工具
function Select-NoneTools {
    foreach ($checkBox in $toolsCheckBoxes.Values) {
        $checkBox.Checked = $false
    }
    Add-ToolsLog "✅ 已取消选择所有工具"
}

# 一键安装功能
function OneClick-Install {
    if (-not (Update-PathValidation)) {
        Add-EnvLog "❌ 请先修正路径问题"
        return
    }
    
    Add-EnvLog "🚀 开始一键安装流程..."
    Add-EnvLog "========================================"
    
    # 禁用所有按钮
    $checkEnvButton.Enabled = $false
    $fixPolicyButton.Enabled = $false
    $setPathButton.Enabled = $false
    $installScoopButton.Enabled = $false
    $addBucketButton.Enabled = $false
    $oneClickInstallButton.Enabled = $false
    $oneClickInstallButton.Text = "安装中..."
    
    $envProgressBar.Visible = $true
    $envProgressBar.Style = "Continuous"
    
    try {
        # 步骤1: 检测执行策略
        $envProgressBar.Value = 10
        Add-EnvLog "## 步骤 1: 检测 PowerShell 执行策略"
        if (-not (Check-ExecutionPolicy)) {
            Add-EnvLog "## 自动修复执行策略"
            if (-not (Fix-ExecutionPolicy)) {
                throw "执行策略修复失败"
            }
        }
        
        # 步骤2: 设置安装路径
        $envProgressBar.Value = 30
        Add-EnvLog "## 步骤 2: 设置 Scoop 安装路径"
        if (-not (Set-ScoopPath -Path $dirTextBox.Text.Trim())) {
            throw "安装路径设置失败"
        }
        
        # 步骤3: 安装 Scoop
        $envProgressBar.Value = 50
        Add-EnvLog "## 步骤 3: 安装 Scoop"
        if (-not (Install-Scoop)) {
            throw "Scoop 安装失败"
        }
        
        # # 步骤4: 添加 Extras Bucket
        # $envProgressBar.Value = 70
        # Add-EnvLog "## 步骤 4: 添加 Extras Bucket"
        
        # 切换到工具选项卡执行此步骤
        $tabControl.SelectedTab = $toolsTab
        # Add-ToolsLog "📚 正在添加 Extras Bucket..."
        
        # $result = scoop bucket add extras 2>&1
        # if ($LASTEXITCODE -eq 0) {
        #     Add-ToolsLog "✅ Extras Bucket 添加成功！"
        # }
        # elseif ($result -like "*already exists*") {
        #     Add-ToolsLog "✅ Extras Bucket 已存在"
        # }
        # else {
        #     Add-ToolsLog "⚠️ Extras Bucket 添加失败，但继续安装工具"
        # }
        
        # 步骤5: 安装默认工具
        $envProgressBar.Value = 80
        Add-ToolsLog "## 步骤 5: 安装默认开发工具"
        
        $selectedTools = $defaultTools
        $successCount = 0
        $totalCount = $selectedTools.Count
        
        for ($i = 0; $i -lt $totalCount; $i++) {
            $tool = $selectedTools[$i]
            $progress = 80 + [int]((($i + 1) / $totalCount) * 15)
            $envProgressBar.Value = $progress
            
            Add-ToolsLog "📦 正在安装 $tool ... ($($i+1)/$totalCount)"
            
            try {
                $result = scoop install $tool 2>&1
                if ($LASTEXITCODE -eq 0) {
                    Add-ToolsLog "✅ $tool 安装成功"
                    $successCount++
                }
                else {
                    if ($result -like "*already installed*") {
                        Add-ToolsLog "✅ $tool 已经安装"
                        $successCount++
                    }
                    else {
                        Add-ToolsLog "❌ $tool 安装失败: $result"
                    }
                }
            }
            catch {
                Add-ToolsLog "❌ $tool 安装过程中出现错误: $($_.Exception.Message)"
            }
            
            [System.Windows.Forms.Application]::DoEvents()
        }
        
        # 完成
        $envProgressBar.Value = 100
        Add-ToolsLog "========================================"
        Add-ToolsLog "🎉 一键安装完成！"
        Add-ToolsLog "✅ 成功安装 $successCount/$totalCount 个工具"
        Add-ToolsLog "📖 您现在可以使用所有安装的开发工具了"
        
        # 显示完成提示
        [System.Windows.Forms.MessageBox]::Show(
            "一键安装完成！`n`nScoop 已成功安装到: $($dirTextBox.Text)`n`n成功安装 $successCount/$totalCount 个开发工具。", 
            "安装完成", 
            [System.Windows.Forms.MessageBoxButtons]::OK, 
            [System.Windows.Forms.MessageBoxIcon]::Information
        )
        
        # 切换回环境选项卡
        $tabControl.SelectedTab = $envTab
    }
    catch {
        Add-EnvLog "❌ 一键安装失败: $($_.Exception.Message)"
        [System.Windows.Forms.MessageBox]::Show(
            "安装过程中出现错误: $($_.Exception.Message)`n`n请查看日志了解详细信息。", 
            "安装失败", 
            [System.Windows.Forms.MessageBoxButtons]::OK, 
            [System.Windows.Forms.MessageBoxIcon]::Error
        )
    }
    finally {
        # 重新启用按钮
        $checkEnvButton.Enabled = $true
        $setPathButton.Enabled = $true
        $installScoopButton.Enabled = $true
        $addBucketButton.Enabled = $true
        $oneClickInstallButton.Enabled = $true
        $oneClickInstallButton.Text = "一键安装（推荐）"
        $envProgressBar.Visible = $false
        
        # 更新修复按钮状态
        $currentPolicy = Get-ExecutionPolicy
        $fixPolicyButton.Enabled = ($currentPolicy -eq "Restricted")
        
        # 更新路径验证
        Update-PathValidation
    }
}

# 浏览文件夹对话框
function Show-FolderBrowser {
    $folderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderDialog.Description = "选择 Scoop 安装目录"
    $folderDialog.SelectedPath = if (Test-Path $defaultDir) { $defaultDir } else { "C:\" }
    
    if ($folderDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $dirTextBox.Text = $folderDialog.SelectedPath
        Update-PathValidation
    }
}

# 按钮点击事件
$checkEnvButton.Add_Click({
    Add-EnvLog "=== 开始环境检测 ==="
    Check-ExecutionPolicy
    Add-EnvLog "=== 环境检测完成 ==="
})

$fixPolicyButton.Add_Click({
    Fix-ExecutionPolicy
})

$setPathButton.Add_Click({
    if (Update-PathValidation) {
        if (Set-ScoopPath -Path $dirTextBox.Text.Trim()) {
            if (Test-ScoopInstalled) {
                Add-EnvLog "✅ 检测到 Scoop 已安装"
                $installExtrasButton.Enabled = $true
                $installToolsButton.Enabled = $true
                $installScoopButton.Text = "重新安装 Scoop"
            }
        }
    }
})

$installScoopButton.Add_Click({
    Install-Scoop
})

$addBucketButton.Add_Click({
    Add-ScoopBucket
})

$installExtrasButton.Add_Click({
    Add-ExtrasBucket
})

$installToolsButton.Add_Click({
    Install-SelectedTools
})

$addCustomButton.Add_Click({
    Add-CustomTool
})

$selectAllButton.Add_Click({
    Select-AllTools
})

$selectNoneButton.Add_Click({
    Select-NoneTools
})

$oneClickInstallButton.Add_Click({
    OneClick-Install
})

$browseButton.Add_Click({
    Show-FolderBrowser
})

# 文本框内容变化时实时验证
$dirTextBox.Add_TextChanged({
    Update-PathValidation
})

# 启动时自动检测和初始化
Add-EnvLog "🚀 Scoop 一键安装工具已启动 (国内镜像版)"
Add-EnvLog "⏳ 开始自动环境检测..."
Check-ExecutionPolicy

# 检查是否已安装 Scoop
if (Test-ScoopInstalled) {
    Add-EnvLog "✅ 检测到 Scoop 已安装"
    $installExtrasButton.Enabled = $true
    $installToolsButton.Enabled = $true
    $installScoopButton.Text = "重新安装 Scoop"
}

# 显示窗体
$form.ShowDialog()