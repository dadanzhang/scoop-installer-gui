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
    "vscode",
    "terraform"
)

# 创建主窗体
$form = New-Object System.Windows.Forms.Form
$form.Text = "Scoop 一键安装工具"
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
$envProgressBar.Location = New-Object System.Drawing.Point(20, 550)
$envProgressBar.Size = New-Object System.Drawing.Size(720, 20)
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
        return $false
    }
    
    if (Test-ChinesePath $path) {
        $pathValidLabel.Text = "✅ 路径格式正确"
        $pathValidLabel.ForeColor = [System.Drawing.Color]::Green
        $setPathButton.Enabled = $true
        return $true
    }
    else {
        $pathValidLabel.Text = "❌ 路径包含中文或格式不正确"
        $pathValidLabel.ForeColor = [System.Drawing.Color]::Red
        $setPathButton.Enabled = $false
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
    }
    elseif ($currentPolicy -eq "RemoteSigned" -or $currentPolicy -eq "Unrestricted" -or $currentPolicy -eq "Bypass") {
        Add-EnvLog "✅ 执行策略检测通过: $currentPolicy"
        Add-EnvLog "🎉 可以正常使用Scoop安装工具"
        $fixPolicyButton.Enabled = $false
        $setPathButton.Enabled = $true
        
        Update-PathValidation
    }
    else {
        Add-EnvLog "❓ 未知的执行策略: $currentPolicy"
        Add-EnvLog "💡 建议: 点击'修复执行策略'按钮设置为推荐值"
        $fixPolicyButton.Enabled = $true
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
        Check-ExecutionPolicy
    }
    catch {
        Add-EnvLog "❌ 修复失败: $($_.Exception.Message)"
        Add-EnvLog "💡 请尝试以管理员身份运行此脚本"
        $fixPolicyButton.Enabled = $true
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

# 安装 Scoop 函数
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
        Add-EnvLog "→ 执行安装命令: irm get.scoop.sh | iex"
        
        # 使用后台作业安装
        $installJob = Start-Job -ScriptBlock {
            param($Path)
            $env:SCOOP = $Path
            Invoke-RestMethod get.scoop.sh | Invoke-Expression
            return $LASTEXITCODE
        } -ArgumentList $dirTextBox.Text.Trim()
        
        # 等待安装完成
        while ($installJob.State -eq "Running") {
            Start-Sleep -Milliseconds 500
            [System.Windows.Forms.Application]::DoEvents()
        }
        
        $result = Receive-Job -Job $installJob
        Remove-Job -Job $installJob
        
        if ($result -eq 0 -or (Test-ScoopInstalled)) {
            Add-EnvLog "✅ Scoop 安装成功！"
            $addBucketButton.Enabled = $true
            $installExtrasButton.Enabled = $true
            $installToolsButton.Enabled = $true
            return $true
        }
        else {
            Add-EnvLog "❌ Scoop 安装失败，请检查网络连接"
            $installScoopButton.Enabled = $true
            return $false
        }
    }
    catch {
        Add-EnvLog "❌ 安装过程中出现错误: $($_.Exception.Message)"
        $installScoopButton.Enabled = $true
        return $false
    }
    finally {
        $envProgressBar.Visible = $false
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

$browseButton.Add_Click({
    Show-FolderBrowser
})

# 文本框内容变化时实时验证
$dirTextBox.Add_TextChanged({
    Update-PathValidation
})

# 启动时自动检测和初始化
Add-EnvLog "🚀 Scoop 一键安装工具已启动"
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