# Time-stamp: "2024-10-30 19:22:52 (ywatanabe)"
# File: .win-bin/switch_IME_to_English.ps1 

(set-input-method nil)

$WM_IME_CONTROL = 0x0283
$IMC_SETOPENSTATUS = 0x0006

Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class IME {
        [DllImport("imm32.dll")]
        public static extern IntPtr ImmGetDefaultIMEWnd(IntPtr hWnd);
        [DllImport("user32.dll")]
        public static extern IntPtr SendMessage(IntPtr hWnd, uint Msg, int wParam, int lParam);
    }
"@

$hwnd = [System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle
$ime_hwnd = [IME]::ImmGetDefaultIMEWnd($hwnd)
[IME]::SendMessage($ime_hwnd, $WM_IME_CONTROL, $IMC_SETOPENSTATUS, 0)


# Add-Type -AssemblyName "Microsoft.Windows.Common-Controls"
# $TSF = New-Object -ComObject "TSF.InputScope"
# $TSF.InputScopeValue = 3  # AlphanumericHalfWidth

################################################################################
# # For changing installed list itself
# $LanguageList = Get-WinUserLanguageList
# $LanguageList.Clear()
# $LanguageList.Add("en-US")
# $LanguageList.Add("ja")
# Set-WinUserLanguageList $LanguageList -Force
################################################################################

################################################################################
# # For changing current language list; but this may not change to English as a current source
# Function Get-CurrentInputLanguage {
#     $ScriptBlock = {
#         Add-Type -AssemblyName System.Windows.Forms
#         [System.Windows.Forms.InputLanguage]::CurrentInputLanguage
#     }
#     $Job = Start-Job -ScriptBlock $ScriptBlock
#     $Null = Wait-Job -Job $Job
#     $CurrentLanguage = Receive-Job -Job $Job
#     Remove-Job -Job $Job
#     Return $CurrentLanguage
# }

# $ret = Get-CurrentInputLanguage
# $currentLang = $ret.Culture.Name

# if ( $currentLang -ne 'en-US' ) {
# 	Set-WinUserLanguageList -LanguageList  en-US, ja -force
# }
################################################################################


# Set-ExecutionPolicy RemoteSigned # Run as administrator
# powershell.exe /home/ywatanabe/.dotfiles/.win-bin/switch_IME_to_English.ps1
# powershell.exe -ExecutionPolicy Bypass -File /home/ywatanabe/.dotfiles/.win-bin/switch_IME_to_English.ps1