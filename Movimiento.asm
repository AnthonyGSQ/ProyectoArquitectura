.data
  # Mensajes a modo de prueba.
  message_w: .asciiz "\nEl jugador se mueve en Y = +1 (W)\n"
  message_a: .asciiz "\nEl jugador se mueve en X = -1 (A)\n"
  message_s: .asciiz "\nEl jugador se mueve en Y = -1 (S)\n"
  message_d: .asciiz "\nEl jugador se mueve en X = +1 (D)\n"

.text
  main:
    li $v0, 12    # Solicita la entrada del usuario en formato integer
    syscall
    
    move $a0, $v0           
        move $t0, $v0    # Guardamos el c�digo ASCII de la tecla en $t0
    
    # Comprobamos si hemos presionado 'W'
    li $t1, 87    # C�digo ASCII para 'w'
    beq $t0, $t1, print_w
    
    li $t1, 119    # C�digo ASCII para 'W'
    beq $t0, $t1, print_w
    
    # Comprobamos si hemos presionado 'A'
    li $t1, 97    # C�digo ASCII para 'a'
    beq $t0, $t1, print_a
    
    li $t1, 65    # C�digo ASCII para 'A'
    beq $t0, $t1, print_a
    
    # Comprobamos si hemos presionado 'S'
    li $t1, 115    # C�digo ASCII para 's'
    beq $t0, $t1, print_s
    
    li $t1, 83    # C�digo ASCII para 'S'
    beq $t0, $t1, print_s
    
    # Comprobamos si hemos presionado 'D'
    li $t1, 100    # C�digo ASCII para 'd'
    beq $t0, $t1, print_d
    
    li $t1, 68    # C�digo ASCII para 'D'
    beq $t0, $t1, print_d
    
    # Si no es ninguna tecla v�lida, no hace nada y terminamos la lectura.
    j main      # Reiniciamos el programa esperando una tecla v�lida.
    
    
    
  # Rutas para impresi�n de cada tecla (A modo de prueba)
  print_w:
    li $v0, 4
    la $a0, message_w
    syscall
  
    j main
  
  print_a:
    li $v0, 4
    la $a0, message_a
    syscall
  
    j main
  
  print_s:
    li $v0, 4
    la $a0, message_s
    syscall
  
    j main
  
  print_d:
    li $v0, 4
    la $a0, message_d
    syscall
  
    j main