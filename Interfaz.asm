.data
	# Mensajes a modo de prueba.
	message_w: .asciiz "\nEl jugador se mueve en Y = +1 (W)\n"
	message_a: .asciiz "\nEl jugador se mueve en X = -1 (A)\n"
	message_s: .asciiz "\nEl jugador se mueve en Y = -1 (S)\n"
	message_d: .asciiz "\nEl jugador se mueve en X = +1 (D)\n"
	alignment_error_message: .asciiz "/nError Alineacion/"
  
	base_address: .word 0x10010000
	regiones_disponibles: .word 1,2,3,4,5,6,7,8,9
	bordes_regiones:
	# Para evitar generar entidades encima unas de otras se spawneara una por region de manera aleatoria
	# esto para evitar incrementar la complejidad del codigo al revisar las posiciones ocupadas.
	# la habitacion es de 300x300 de manera que cada region sera de 100x100, debido al tamaño de las entidades
	# 64x64, las coordenadas de spawneo de cada region se les restara/sumara 32 para evitar entidades fuera de
	# la habitacion
	# 36x36 de espacio para generar el centro de la entidad
           #.word x_min,x_max,y_min,y_max
	.word 144, 180, 144, 180	#region 1
	.word 244, 280, 144, 180	#region 2
	.word 344, 380, 144, 180	#region 3
	
	.word 144, 180, 244, 280	#region 4
	.word 244, 280, 244, 280	#region 5 centro
	.word 344, 380, 244, 280	#region 6
	
	.word 144, 180, 344, 380	#region 7
	.word 244, 280, 344, 380	#region 8
	.word 344, 380, 344, 380	#region 9
	
	# Coordenadas player
	jugador_x: .word 0 # X
	jugador_y: .word 0 # Y
.text
	.globl main
	#variables utilizadas frecuentemente:
	#$t0 = x
	#$t1 = y
	#$t2 direccion del display
	#t3 = 512 (tamaño del display 512x512)
	#t4 desplazamiento
	#t5 color del pixel
	#$t6 (x) y $t7 (y) seran las coordenadas finales de lo que se dibuje
	main:
	#direccion de nuestro display
	lw $t2, base_address
	la $s0, regiones_disponibles
	la $s1, bordes_regiones
	jal habitacion
	jal jugador
	jal enemigos
	jal enemigos
	jal enemigos
	jal salida
	
	jal gameplay

	li $v0, 10	#cerrar programa
	syscall

	habitacion:
		#va a ser azul
		addi $sp, $sp, -4	#hacemos espacio en la pila
		sw $ra 0($sp)	#guardamos la direccion del ra para volver a main
		li $t5, 255		#azul
		#primera recta horizontal
		li $t0, 448
		li $t1, 448
		li $t6, 1648	
		jal dibujar_recta_horizontal
		#segunda recta horizontal
		li $t0, 448
		li $t1, 1648
		jal dibujar_recta_horizontal
		#primera recta vertical
		li $t0, 448
		li $t1, 448
		jal dibujar_recta_vertical
		#segunda recta vertical
		li $t0, 1648
		li $t1, 448
		jal dibujar_recta_vertical
		
		lw $ra 0($sp) 	#recuperamos el valor de ra para retornar a main
		addi $sp, $sp,4	#liberamos espacio de la pila
		jr $ra


	jugador:
		addi $sp, $sp, -4	#hacemos espacio en la pila
		sw $ra 0($sp)	#guardamos la direccion del ra para volver a main
		li $t5, 0x00FF00		#va a ser verde
		jal get_random_region
		
		
		
		add $t6, $t0, 32	#32/4 = 8 de ancho en x para el personaje
		add $t7, $t1, 32	#mismo pero para y
		sub $t0, $t0, 32	#8 mas de ancho en x
		sub $t1, $t1, 32	#mismo pero para y
		
		sw $t6, jugador_x
		sw $t7, jugador_y

		jal dibujar_cuadrado
		lw $ra 0($sp) 	#recuperamos el valor de ra para retornar a main
		addi $sp, $sp, 4	#liberamos espacio de la pila

		#TODO: quiza para el movimiento del jugador/enemigo sea buena idea
		#simplemente en un bucle hasta n donde n sea el ancho/altura del jugador/enemigo
		#dibujar la nueva posicion con rectas y la antigua posicion pintarla
		#de color negro

		jr $ra
	enemigos:
		addi $sp, $sp, -4	#hacemos espacio en la pila
		sw $ra 0($sp)	#guardamos la direccion del ra para volver a main
		
		li $t5, 0xFF0000		#va a ser rojo
		
		jal get_random_region
		
		
		
		add $t6, $t0, 32	#32/4 = 8 de ancho en x para el personaje
		add $t7, $t1, 32	#mismo pero para y
		sub $t0, $t0, 32	#8 mas de ancho en x
		sub $t1, $t1, 32	#mismo pero para y
		
		jal dibujar_cuadrado
		
		
		lw $ra 0($sp) 	#recuperamos el valor de ra para retornar a main
		addi $sp, $sp,4	#liberamos espacio de la pila
		jr $ra
		
	salida:
		addi $sp, $sp, -4	#hacemos espacio en la pila
		sw $ra 0($sp)	#guardamos la direccion del ra para volver a main
		
		li $t5, 0xFFFF00		#va a ser amarilla
		jal get_random_region
		
		
		
		add $t6, $t0, 32	#32/4 = 8 de ancho en x para el personaje
		add $t7, $t1, 32	#mismo pero para y
		sub $t0, $t0, 32	#8 mas de ancho en x
		sub $t1, $t1, 32	#mismo pero para y
		
		jal dibujar_cuadrado
		lw $ra 0($sp) 	#recup
		
		lw $ra 0($sp) 	#recuperamos el valor de ra para retornar a main
		addi $sp, $sp,4	#liberamos espacio de la pila
		jr $ra
		
	dibujar_cuadrado:
		# Asegurar que las coordenadas x e y estén alineadas correctamente
		andi $t0, $t0, 0xFFFFFFFC
		andi $t1, $t1, 0xFFFFFFFC
		
		mul $t4, $t1,512 	# y*512
		add $t4, $t4, $t0	#y*512 + x
		add $t4, $t4, $t2	#y*512+x + base_address
		
		# Verificacion alineacion de memoria.
		and $t3, $t4, 3
		bnez $t3, alignment_error
		
		sw $t5, 0($t4)
		add $t0, $t0, 4
		bne $t0, $t6 dibujar_cuadrado #recorrer en x
		add $t1, $t1, 4
		sub $t0, $t0, 64		#volver a la posicion izq en x original
		bne $t1, $t7 dibujar_cuadrado #recorrer en y
		
		jr $ra
			
		
	dibujar_recta_horizontal:
		mul $t4, $t1,512 	# y*512
		add $t4, $t4, $t0	#y*512 + x
		add $t4, $t4, $t2	#y*512+x + base_address
		sw $t5, 0($t4)
		add $t0,$t0,4
		bne $t0,$t6, dibujar_recta_horizontal
		jr $ra
		
	dibujar_recta_vertical:
		mul $t4, $t1,512
		add $t4, $t4, $t0
		add $t4, $t4, $t2
		sw $t5,0($t4)
		add $t1,$t1,4
		bne $t1, $t6, dibujar_recta_vertical
		jr $ra
		
	#esta funcion guarda un 'x' y 'y' random dentro de la habitacion e, $t0 y $t1
	generar_pos_random:
		li $v0, 42
		li $a1, 36 
		syscall 		#generamos posicion en x random
		
		add $t0, $t0, $a0	#sumamos el random con el x_min de la region seleccionada
		mul $t0, $t0, 4	#multiplicamos por 4 para el display
		li $v0, 42
		li $a1, 36
		syscall 		#generamos posicion en y random
		
		add $t1, $t1, $a0	#sumamos el random con el y_min de la region seleccionada
		mul $t1, $t1, 4	#multiplicamos por 4 para el display
		
		jr $ra
		
	get_random_region:
		li $v0, 42
		li $a1, 8
		syscall		#random para seleccionar la region
		li $t0, 4		#lo usaremos para irnos a x posicion del arreglo de regiones_disponibles
		mul $t0, $t0, $a0
		add $s0,$s0,$t0	#movemos $s0 a la region escojida aleatoriamente
		lw $t0, 0($s0)
		beq $t0, $zero, get_random_region #si es una region usada, buscamos otra
		sw $zero, 0($s0)	#cargamos 0 en las regiones ya usadas
		addi $sp, $sp, -4	#hacemos espacio en la pila
		sw $ra 0($sp)	#guardamos la direccion del ra para volver a main
		la $s0, regiones_disponibles	#restauramos $s0 para futuras iteraciones
		la $s1, bordes_regiones 	#restauramos $s1 para futuras iteraciones
		
		
		mul $t8, $a0, 16	#0x16 region 1, 1x16 region 2, 2x16 region 3...
		add $s1, $s1, $t8	#min_x de region n
		lw $t0, 0($s1)	#cargamos el x_min a $t0
		
		addi $s1,$s1, 8	#min_y de region n
		lw $t1, 0($s1)	#cargamos el y_min a $t1
		
		jal generar_pos_random

		lw $ra 0($sp) 	#recuperamos el valor de ra para retornar a main
		addi $sp, $sp, 4	#liberamos espacio de la pila
		
		jr $ra
		
	###########################
	# Mauricio Artavia Monge #
	##########################
	gameplay:
		li $v0, 12    # Solicita la entrada del usuario en formato integer
		syscall
		
		move $a0, $v0           
		move $t0, $v0    # Guardamos el código ASCII de la tecla en $t0
		
		lw $t6, jugador_x
		lw $t7, jugador_y
		
		# Comprobamos si hemos presionado 'W'
		li $t1, 87    # Código ASCII para 'w'
		beq $t0, $t1, move_up
		li $t1, 119    # Código ASCII para 'W'
		beq $t0, $t1, move_up
		
		# Comprobamos si hemos presionado 'A'
		li $t1, 97    # Código ASCII para 'a'
		beq $t0, $t1, move_left
		li $t1, 65    # Código ASCII para 'A'
		beq $t0, $t1, move_left
		
		# Comprobamos si hemos presionado 'S'
		li $t1, 115    # Código ASCII para 's'
		beq $t0, $t1, move_down
		li $t1, 83    # Código ASCII para 'S'
		beq $t0, $t1, move_down
		
		# Comprobamos si hemos presionado 'D'
		li $t1, 100    # Código ASCII para 'd'
		beq $t0, $t1, move_right
		li $t1, 68    # Código ASCII para 'D'
		beq $t0, $t1, move_right
		
		# Si no es ninguna tecla válida, no hace nada y terminamos la lectura.
		j gameplay      # Reiniciamos el programa esperando una tecla válida.
		
		# Movemos el jugador hacia arriba
	move_up:
		addi $t7, $t7, -4
		sw $t7, jugador_y
		j redraw_player
		
	# Movemos el jugador hacia abajo
	move_down:
		addi $t7, $t7, 4
		sw $t7, jugador_y
		j redraw_player
		
	# Movemos el jugador hacia la izquierda
	move_left:
		addi $t6, $t6, -4
		sw $t6, jugador_x
		j redraw_player
		
	# Movemos el jugador hacia la derecha
	move_right:
		addi $t6, $t6, 4
		sw $t6, jugador_x
		j redraw_player
		
	# Redibujamos el jugador en la nueva posición
	redraw_player:
		li $t5, 0x000000    # Borramos la posición anterior
		mul $t4, $t7, 512   # y*512
		add $t4, $t4, $t6   # y*512 + x
		add $t4, $t4, $t2   # y*512+x + base_address
		
		#Verificacion Alineacion
		and $t3, $t4, 3
		bnez $t3, alignment_error
			
		sw $t5, 0($t4)
		li $t5, 0x00FF00    # Color verde para el jugador
		
		mul $t4, $t7, 512 # y*512 
		add $t4, $t4, $t6 # y*512 + x 
		add $t4, $t4, $t2 # y*512 + base_address 
		sw $t5, 0($t4)
		
		# jal dibujar_cuadrado
		j gameplay      # Esperamos una nueva entrada del usuario
			
	alignment_error:
		li $v0, 4
		la $a0, alignment_error_message
		syscall
		jr $ra



