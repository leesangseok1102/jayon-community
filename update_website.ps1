# =====================================================
# 자연돌봄공동체 홈페이지 자동 업데이트 스크립트
# 사용법: 공익재단 폴더에 새 파일 추가 후 이 스크립트 실행
# =====================================================

param(
  [int]$DaysBack = 1  # 최근 며칠 내 수정된 파일 확인 (기본: 1일)
)

$SOURCE = "C:\Users\USER\OneDrive\바탕 화면\공익재단"
$SITE   = "C:\Users\USER\OneDrive\바탕 화면\자연돌봄공동체홈페이지"
$LOG    = "$SITE\update_log.txt"

# 최근 수정된 파일 찾기
$cutoff = (Get-Date).AddDays(-$DaysBack)
$newFiles = Get-ChildItem $SOURCE -Recurse -File |
  Where-Object { $_.LastWriteTime -ge $cutoff } |
  Sort-Object LastWriteTime -Descending

if ($newFiles.Count -eq 0) {
  Write-Host "새로 수정된 파일이 없습니다. (최근 $DaysBack 일 기준)"
  exit 0
}

Write-Host "=== 새로 수정된 파일 $($newFiles.Count)개 발견 ==="
$newFiles | ForEach-Object {
  Write-Host "  [$($_.LastWriteTime.ToString('MM-dd HH:mm'))] $($_.Name)"
}

# 로그에 기록
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
"[$timestamp] 업데이트 감지: $($newFiles.Count)개 파일" | Add-Content $LOG
$newFiles | ForEach-Object { "  - $($_.Name)" | Add-Content $LOG }

Write-Host "`n위 파일들의 내용을 Claude Code에서 확인하여 홈페이지를 업데이트해 주세요."
Write-Host "파일 목록이 클립보드에 복사됩니다..."

$fileList = $newFiles | ForEach-Object { $_.FullName }
$fileList -join "`n" | Set-Clipboard

Write-Host "`n클립보드에 복사됨. Claude Code 채팅창에 붙여넣기 하세요."
