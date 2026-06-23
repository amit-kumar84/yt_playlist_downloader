$dir = 'c:\Users\ASUS\Downloads\yt\Downloads\Free CCNA v1.1 200-301 ｜ Complete Course 2026'
$files = Get-ChildItem -Path $dir -File -ErrorAction SilentlyContinue
$nums = @()
foreach($f in $files){ if($f.Name -match '^(\d{1,3})'){ $nums += [int]$Matches[1] } }
if($nums.Count -gt 0){ Write-Output "max_index=$(($nums | Sort-Object -Unique | Select-Object -Last 1))" } else { Write-Output 'max_index=NONE' }