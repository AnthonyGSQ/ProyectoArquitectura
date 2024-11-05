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
main:
#direccion de nuestro display
lw $t2, base_address
jal habitacion

habitacion:
#va a ser azul
#$t6 y $t7 seran los puntos finales de las rectas de la habitacion
li $t5, 255		#azul
#primera recta
li $t0, 448
li $t1, 448
li $t6, 1648	
jal dibujar_recta
#TODO: guardar en pila el jr $ra para evitar bugs
jr $ra
	dibujar_recta:
	#punto inicial
	mul $t4, $t1,512 	# y*512
	add $t4, $t4, $t0	#y*512 + x
	add $t4, $t4, $t2	#y*512+x + base_address
	sw $t5, 0($t4)
	add $t0,$t0,4
	bne $t0,$t6, dibujar_recta
	jr $ra

jugador:
#va a ser verde
li $t5, 2
enemigos:
#va a ser rojo
li $t5, 1
salida:
#va a ser amarilla
li $t5, 4