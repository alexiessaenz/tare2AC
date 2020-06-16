org	100h

section .text

	call 	texto  	;iniciamos modo texto
	call 	pagina  	;iniciamos la pangina indicada
		
	call 	cursor		;gato
	call 	phrase1

	call 	cursor		;ingrese blabla..
	call 	phrase2
	call	w_strng

	call	lupi		;los 5 caracteres

	xor 	si, si 	;lo mimso que: mov si, 0000h
;---------------------
cursor: mov	ah, 01h
	mov 	ch, 00000000b
	mov 	cl, 00001110b
		;   IRGB
	int 	10h
	ret

w_char:	mov 	ah, 09h
	mov 	al, cl
	mov 	bh, 1h
	mov 	bl, 01000000b
	mov 	cx, 1h
	int 	10h
	ret



m_cursr1:mov 	ah, 02h
	mov 	dx, di  ; columna
	mov 	dh, 17d ; fila
	mov 	bh, 1h
	int 	10h
	ret

phrase1:mov 	di, 43d
	mov	si, 0d
lupi1:	mov 	cl, [msg1+di-43d]
	
	call    m_cursr1
	call 	w_char
	inc	di
	;inc	si
	cmp 	di, len1
	jb	lupi1
	ret
;---------------
;---------------------


w_char2:mov 	ah, 09h
	mov 	al, cl
	mov 	bh, 1h
	mov 	bl, 00001111b
	mov 	cx, 1h
	int 	10h
	ret



m_cursr:mov 	ah, 02h
	mov 	dx, di  ; columna
	mov 	dh, 2d ; fila
	mov 	bh, 1h
	int 	10h
	ret

phrase2:mov 	di, 22d
	mov	si, 0d
lupi2:	mov 	cl, [msg2+di-22d]
	
	call    m_cursr
	call 	w_char2
	inc	di
	;inc	si
	cmp 	di, len2
	jb	lupi2
	ret
;---------------
lupi:	call 	kb
	cmp 	al, "$" ;   "h o l a $"
			;si; 0 1 2 3 4
	je	mostrar
	mov	[300h+si], al ; CS:0300h en adelante
	inc 	si
	jmp 	lupi



mostrar:call 	w_strng

	call 	kb	; solo detenemos la ejecución

	int 	20h

texto:	mov 	ah, 00h
	mov	al, 03h
	int 	10h
	ret
pagina:	mov 	ah, 05h
	mov	al, 01h
	int 	10h
	ret

kb:	mov	ah, 00h ;subrutina que detiene la ejecución hasta recibir
	int 	16h	;algun carácter en el buffer del teclado
	ret		;este carácter lo guarda en el registro AL

w_strng:mov	ah, 13h
	mov 	al, 01h ; asigna a todos los caracteres el atributo de BL,
			; actualiza la posición del cursor
	mov 	bh, 01h ; número de página 
	mov	bl, 01100100b ; atributo de caracter 00001111 0000fondo 1111caracter
	mov	cx, si ; tamaño del string (SI, porque todavía guarda la última posición)
	mov	dl, 43d ; columna inicial
	mov	dh, 17d	; fila inicial
	; Como esta interrupción saca el string de ES:BP, tenemos que poner los valores correcpondientes
	push 	cs ; Segmento actual en el que está guardado nuestro string
	pop	es ; Puntero al segmento que queremos 
	mov	bp, 300h ; Dirección inicial de nuestra cadena de texto
	; ES:BP equals CS:300h 
	int 10h
	ret

section .data
msg1	db 	"GATO "
len1	equ	$-msg1+43d    ;col 43
msg2	db 	"Ingrese una palabra de 5 caracteres: "
len2	equ	$-msg1+22d    ;col 29