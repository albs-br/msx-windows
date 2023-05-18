	; OLDKEY:	equ $fbda ; Previous state of the keyboard matrix (11b)
	; NEWKEY:	equ $fbe5 ; Current state of the keyboard matrix (11b)
	; 	; $fbda, $fbe5 ; 7 6 5 4 3 2 1 0
	; 	; $fbdb, $fbe6 ; ; ] [ \ = - 9 8
	; 	; $fbdc, $fbe7 ; B A pound / . , ` '
	; 	; $fbdd, $fbe8 ; J I H G F E D C
	; 	; $fbde, $fbe9 ; R Q P O N M L K
	; 	; $fbdf, $fbea ; Z Y X W V U T S
	; 	; $fbe0, $fbeb ; F3 F2 F1 CODE CAP GRAPH CTRL SHIFT
	; 	; $fbe1, $fbec ; CR SEL BS STOP TAB ESC F5 F4
	; 	; $fbe2, $fbed ; RIGHT DOWN UP LEFT DEL INS HOME SPACE
	; 	; $fbe3, $fbee ; 4 3 2 1 0 none none none
	; 	; $fbe4, $fbef ; . , - 9 8 7 6 5