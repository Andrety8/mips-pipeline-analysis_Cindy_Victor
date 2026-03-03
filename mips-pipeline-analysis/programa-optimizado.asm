.data
vector_x: .word 1, 2, 3, 4, 5, 6, 7, 8
vector_y: .space 32              # 8 enteros (8 * 4 bytes)
const_a:  .word 3
const_b:  .word 5
tamano:   .word 8

.text
.globl main

main:
    # --- Inicialización ---
    la   $s0, vector_x          # Dirección base de X
    la   $s1, vector_y          # Dirección base de Y
    lw   $t0, const_a           # Cargar constante A
    lw   $t1, const_b           # Cargar constante B
    lw   $t2, tamano            # Cargar tamaño del vector (n)
    li   $t3, 0                 # i = 0

loop:
    # --- Condición de salida ---
    beq  $t3, $t2, fin          # Si i == n → terminar

    # --- Cálculo de offset (i * 4 bytes) ---
    sll  $t4, $t3, 2            # t4 = i * 4

    # --- Dirección de X[i] ---
    addu $t5, $s0, $t4          # t5 = &X[i]

    # --- Carga desde memoria ---
    lw   $t6, 0($t5)            # t6 = X[i]

    # --- Relleno del Load-Use (instrucción independiente) ---
    addu $t9, $s1, $t4          # t9 = &Y[i]

    # --- Operación aritmética ---
    mul  $t7, $t6, $t0          # t7 = X[i] * A
    addu $t8, $t7, $t1          # t8 = t7 + B

    # --- Almacenamiento ---
    sw   $t8, 0($t9)            # Y[i] = resultado

    # --- Siguiente iteración ---
    addi $t3, $t3, 1            # i++
    j    loop

fin:
    # --- Finalización ---
    li   $v0, 10
    syscall