org	100h

section .text

	call 	texto  	;iniciamos modo texto
	call 	pagina
	call phrase2
	
inicio:			;intro de los 5 caracteres

	xor 	si,     si 	;lo mimso que: mov si, 0000h


	xor 	di,     di

lupi:	call 	kb
	cmp 	al, "E" ;   "h o l a $"
	je	mostrar
	mov	[300h+si], al ; CS:0300h en adelante
	inc 	si
	jmp 	lupi


mostrar:call 	w_strng

	;call 	kb	; solo detenemos la ejecución
	mov     cl,         "P"
	mov     [200h],     cl
	mov     cl,         "A"
	mov     [201h],     cl
	mov     cl,         "S"
	mov     [202h],     cl
	mov     cl,         "S"
	mov     [203h],     cl
	mov     cl,         "W"
	mov     [204h],     cl	

	mov 	di, 	0d
    	mov	al,	[200h]	
    	mov	cl,	[300h]	
	cmp	cl,	al
	je	yep1
	inc 	di
yep1:	mov	al,	[201h]	
    	mov	cl,	[301h]	
	cmp	cl,	al
	je	yep2
	inc 	di
yep2:	mov	al,	[202h]	
    	mov	cl,	[302h]	
	cmp	cl,	al
	je	yep3
	inc 	di
yep3:	mov	al,	[203h]	
    	mov	cl,	[303h]	
	cmp	cl,	al
	je	yep4
	inc 	di
yep4:	mov	al,	[204h]	
    	mov	cl,	[304h]	
	cmp	cl,	al
	je	comp
	inc 	di
comp:	cmp	di,	0d
	je	cal1
	jmp	cal2
cal1:	call 	cursor		;bienvenido
	call 	phrase1
	jmp 	fin
cal2:	call 	cursor		;error
	call 	phrase2
	jmp 	inicio
fin:
	int 	20h


;---------------------
cursor: mov	ah,     01h
	mov 	ch,     00000000b
	mov 	cl,     00001110b
		;   IRGB
	int 	10h
	ret

w_char1:	mov 	ah, 	09h
	mov 	al, 	cl
	mov 	bh, 	0h
	mov 	bl, 	00001111b
	mov 	cx, 	1h
	int 	10h
	ret

m_cursr1:mov 	ah, 	02h
	mov 	dx, 	di  ; columna
	mov 	dh, 	10d ; fila
	mov 	bh, 	0h
	int 	10h
	ret

phrase1:mov 	di, 	43d
	mov	si, 	0d
lupi1:	mov 	cl, 	[msg1+di-43d]
	call    m_cursr1
	call 	w_char1
	inc	di
	;inc	si
	cmp 	di, len1
	jb	lupi1
	ret
;---------------
;---------------------


w_char2:mov 	ah, 09h
	mov 	al, cl
	mov 	bh, 0h
	mov 	bl, 00001111b
	mov 	cx, 1h
	int 	10h
	ret

m_cursr2:mov 	ah, 02h
	mov 	dx, di  ; columna
	mov 	dh, 2d ; fila
	mov 	bh, 0h
	int 	10h
	ret

phrase2:mov 	di, 0d
	mov	si, 0d
lupi2:	mov 	cl, [msg2+di]
	call    m_cursr2
	call 	w_char2
	inc	di
	;inc	si
	cmp 	di, len2
	jb	lupi2
	ret
;---------------




texto:	mov 	ah, 00h
	mov	al, 03h
	int 	10h
	ret
pagina:	mov 	ah, 05h
	mov	al, 00h
	int 	10h
	ret

kb:	mov	ah, 00h ;subrutina que detiene la ejecución hasta recibir
	int 	16h	;algun carácter en el buffer del teclado
	ret		;este carácter lo guarda en el registro AL

w_strng:mov	ah, 13h
	mov 	al, 01h ; asigna a todos los caracteres el atributo de BL,
			; actualiza la posición del cursor
	mov 	bh, 00h ; número de página 
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
msg1	db 	"BIENVENIDO "
len1	equ	$-msg1+43d    ;col 43
msg2	db 	"Ingrese una clave de 5 caracteres seguido de la tecla E: "
len2	equ	$-msg2    ;col 29

