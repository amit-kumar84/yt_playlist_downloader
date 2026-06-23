$manifestPath = 'c:\Users\ASUS\Downloads\yt\Logs\playlist_PLxbwE86jKRgMpuZuLBivzlM8s2Dk5lXBQ_manifest.txt'
$archivePath = 'c:\Users\ASUS\Downloads\yt\Logs\downloaded_videos.txt'
$manifest = @(); $archive = @()
if(Test-Path $manifestPath){ $manifest = Get-Content $manifestPath }
if(Test-Path $archivePath){ $archive = Get-Content $archivePath }
Write-Output "manifest_count=$($manifest.Count)"
Write-Output "archive_count=$($archive.Count)"
Write-Output "last_manifest_line=$(if($manifest.Count -gt 0){$manifest[-1]} else {''})"
Write-Output "last_archive_line=$(if($archive.Count -gt 0){$archive[-1]} else {''})"
$indices = @()
for($i=0;$i -lt $manifest.Count;$i++){
    $id = ($manifest[$i] -split '\|')[0].Trim()
    if(-not ($archive -contains ('youtube ' + $id))){ $indices += ($i+1) }
}
Write-Output ("missing_count=$($indices.Count)")
if($indices.Count -gt 0){
    Write-Output ("missing_indices=" + ($indices -join ','))
} else {
    Write-Output "missing_indices=NONE"
}