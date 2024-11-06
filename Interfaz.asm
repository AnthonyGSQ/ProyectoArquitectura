.data
base_address: .word 0x10010000
.text
.globl main
#variables utilizadas frecuentemente:
#$t0 = x
#$t1 = y
#$t2 direccion del display
#t3 = 512 (tamaño del display 512x512)
#t4 desplazamiento
#t5 color del pixel
#$t6 (x) y $t7 (y) seran los puntos finales de las rectas a dibujar
main:
#direccion de nuestro display
lw $t2, base_address
jal habitacion
jal jugador

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
jal generar_pos_random



add $t6, $t0, 32	#8/4 = 2 de ancho en x para el personaje
add $t7, $t1, 32	#mismo pero para y
sub $t0, $t0, 32	#2 mas de ancho en x
sub $t1, $t1, 32	#mismo pero para y

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

li $t5, 1		#va a ser rojo

lw $ra 0($sp) 	#recuperamos el valor de ra para retornar a main
addi $sp, $sp,4	#liberamos espacio de la pila
jr $ra

salida:
addi $sp, $sp, -4	#hacemos espacio en la pila
sw $ra 0($sp)	#guardamos la direccion del ra para volver a main

li $t5, 4		#va a ser amarilla

lw $ra 0($sp) 	#recuperamos el valor de ra para retornar a main
addi $sp, $sp,4	#liberamos espacio de la pila
jr $ra

dibujar_cuadrado:
mul $t4, $t1,512 	# y*512
add $t4, $t4, $t0	#y*512 + x
add $t4, $t4, $t2	#y*512+x + base_address
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
li $a1, 300	# 412 tope, como genera desde 0, siempre sumaremos 112
		# 300+112=412, el cual es el borde de la habitacion
syscall 		#generamos posicion en x random

li $t0, 112
add $t0, $t0, $a0	#guardamos el x random en $t0
mul $t0, $t0, 4	#multiplicamos por 4 para el display

li $v0, 42
li $a1, 300	# 412 tope, como genera desde 0, siempre sumaremos 112
		# 300+112=412, el cual es el borde de la habitacion
syscall 		#generamos posicion en y random

li $t1, 112
add $t1, $t1, $a0	#guardamos el y random en $t0
mul $t1, $t1, 4	#multiplicamos por 4 para el display

jr $ra