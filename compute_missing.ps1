$manifest = Get-Content 'c:\Users\ASUS\Downloads\yt\Logs\playlist_PLxbwE86jKRgMpuZuLBivzlM8s2Dk5lXBQ_manifest.txt'
$archive = @()
if(Test-Path 'c:\Users\ASUS\Downloads\yt\Logs\downloaded_videos.txt'){
    $archive = Get-Content 'c:\Users\ASUS\Downloads\yt\Logs\downloaded_videos.txt'
}
$indices = @()
for($i=0;$i -lt $manifest.Count;$i++){
    $id = ($manifest[$i] -split '\|')[0].Trim()
    if(-not ($archive -contains ('youtube ' + $id))){ $indices += ($i+1) }
}
if($indices.Count -gt 0){ Write-Output ($indices -join ',') } else { Write-Output 'NONE' }