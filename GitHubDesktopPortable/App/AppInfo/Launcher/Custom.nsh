${SegmentFile}

${SegmentPre}
	${If} ${FileExists} "$PROFILE\.gitconfig"
		Rename "$PROFILE\.gitconfig" "$PROFILE\.gitconfig-BackupByGitHubDesktopPortable"
	${EndIf}
!macroend
${SegmentPost}
	${If} ${FileExists} "$PROFILE\.gitconfig-BackupByGitHubDesktopPortable"
		Rename "$PROFILE\.gitconfig-BackupByGitHubDesktopPortable" "$PROFILE\.gitconfig"
	${EndIf}
!macroend
