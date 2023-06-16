# This is a floating point calculator��FPC�� that supports addition, subtraction, multiplication and division of two input floating point numbers and returns the results in binary and hexadecimal formats.
.data 
	msg_welcome: 		.asciiz "\nHello!I am a floating point calculator that can menu addition, subtraction, multiplication and division.\nPlease follow the instructions and input numbers to use me.\n" 
	msg_menu:		.asciiz "\nMenu\n1: +    2: -    3: ��    4: ��   5: Exit\nChoose:"
	msg_exit:		.asciiz "\nThanks for your using. Bye bye!\n"
	msg_first_float:	.asciiz "\nFirst floating-point value:"
	msg_sencond_float:	.asciiz "\nSecond floating-point value:"
	msg_invalid_input:	.asciiz "\nInvalid input!\n"
	msg_print_bin:		.asciiz "\nBinary result:\n"
	msg_print_hex: 		.asciiz "\nHexadecimal result:\n"
	error_over_flow:	.asciiz "\nError: overflow!\n"
	error_under_flow:	.asciiz "\nError: underflow!\n"
	error_div_zero:		.asciiz "\nError: Cannot divde by zero!\n"
	hex_table:  		.asciiz "0123456789ABCDEF"
	hex_digits: 		.asciiz "XXXXXX"
	string_neg:		.asciiz "-"
	string_1dot:		.asciiz "1."
	string_0dot:		.asciiz "0."
	string_totwo:		.asciiz "*2^"
	string_to16:		.asciiz "*16^"
	string_0:		.asciiz "0"
	string_1: 		.asciiz "1"
	string_hex0: 		.asciiz "000000*16^0"

.text
# --    ��ӭ    --
welcome:
    	la      $a0,    msg_welcome      # �����ӭ��
    	li      $v0,    4                # ��ӡ�ַ���
    	syscall                        
    	j       menu                     # ��ת��menu


# --    ���ܲ˵�    --
menu:
    	la      $a0,    msg_menu          # ����˵���ʾ��Ϣ
    	li      $v0,    4                 # ��ӡ�ַ���
    	syscall                        
    	# ��ȡ�û�������
    	li      $v0,    5                 # ��ȡ����
    	syscall                        
   	move    $v1,    $v0               # ������ֵ����$v1
    	j       branch                    # ��ת��branch

branch:
    	beq     $v1,    1,    read_float  # �������ֵΪ1����ת��read_float
    	beq     $v1,    2,    read_float  # �������ֵΪ2����ת��read_float
    	beq     $v1,    3,    read_float  # �������ֵΪ3����ת��read_float
    	beq     $v1,    4,    read_float  # �������ֵΪ4����ת��read_float
    	beq     $v1,    5,    exit        # �������ֵΪ5����ת��exit
    	# ��������������ʾ���������������
    	la      $a0,    msg_invalid_input  # ������������ʾ��Ϣ
    	li      $v0,    4                  # ��ӡ�ַ���
    	syscall                           

    	j       menu                       # ��ת��menu

read_float:
    	# ��ȡ��һ��������
    	la      $a0,    msg_first_float     # �����һ����������ʾ��Ϣ
    	li      $v0,    4                   # ��ӡ�ַ���
    	syscall                           

    	li      $v0,    6                   # ��ȡ������
    	syscall                           

    	mfc1    $t0,    $f0                 # ������������$t0�Ĵ���

    	srl     $s0,    $t0,    31          # �����һ���������ķ�����$s0
    
    	sll     $s1,    $t0,    1		# �����һ����������ָ����$s1
    	srl     $s1,    $s1,    24	  					
    	sll     $s2,    $t0,    9		# �����һ����������β����$s2
    	srl     $s2,    $s2,    9
    	addi    $s2,    $s2,    0x00800000	# β����ǰ��λ1 16������

    	# ��ȡ�ڶ���������
    	la      $a0,    msg_sencond_float   # ����ڶ�����������ʾ��Ϣ
    	li      $v0,    4                   # ��ӡ�ַ���
    	syscall                           

    	li      $v0,    6                   # ��ȡ������
    	syscall                           

    	mfc1    $t0,    $f0                 # ������������$t0�Ĵ���
    	srl     $s3,    $t0,    31          # ����ڶ����������ķ�����$s3
    	sll     $s4,    $t0,    1	    # ����ڶ�����������ָ����$s4
    	srl     $s4,    $s4,    24   
   	sll     $s5,    $t0,    9	     # ����ڶ�����������β����$s5
    	srl     $s5,    $s5,    9
    	addi    $s5,    $s5,    0x00800000  # β����ǰ��λ1 16������

    	beq     $v1,    1,    add            # �������ֵΪ1����ת��add
    	beq     $v1,    2,    sub            # �������ֵΪ2����ת��sub
    	beq     $v1,    3,    multiply       # �������ֵΪ3����ת��multiply
    	beq     $v1,    4,    divide         # �������ֵΪ4����ת��divide

    	la      $a0,    msg_invalid_input   # �������������ʾ��Ϣ
    	li      $v0,    4                   # ��ӡ�ַ���
    	syscall                           

    	j       menu                        # ��ת��menu

	
# --	�ӷ�    --
add:                                		
	sub	$t0,	$s1,	$s4              # ��������ָ���Ĳ�
	bltz	$t0,	adjust_first_operand             # �����ֵΪ������ת�� adjust_first_operand
	bgtz	$t0,	adjust_second_operand            # �����ֵΪ������ת�� adjust_second_operand
	beq	$t0,	$0,	judge_sign       # �����ֵΪ�㣬��ת�� judge_sign

	adjust_first_operand:                            # �Ե�һ�������е���
		addi	$s1,	$s1,	1        # ָ����1
		srl	$s2,	$s2,	1        # β������1λ
		j	add                      # ���� add ���½��м���
	
	adjust_second_operand:                           # �Եڶ��������е���
		addi	$s4,	$s4,	1        # ָ����1
		srl	$s5,	$s5,	1        # β������1λ
		j	add                	 # ���� add ���½��м���

	judge_sign:                              # �����ж�
		xor	$t3,	$s0,	$s3      # ���������Ž�������������������$t3��
		beq	$t3,	0,	same_sign    # �����������ͬ����ת�� same_sign
		beq	$t3,	1,	diff_sign    # ��������Ų�ͬ����ת�� diff_sign

	same_sign:                             # ������ͬ�����
		add	$t3,	$s2,	$s5      # β�����
		move	$t2,	$s1      	 # ��ָ���ƶ���$t2
		move	$t1,	$s0     	 # �������ƶ���$t1
		bge	$t3,	0x01000000,	carry    # ���β���ӷ����λ����ת�� carry
		j	print_result          	 # ����ֱ��������

	diff_sign:                       	 # ���Ų�ͬ�����
		move	$t2,	$s1      	 # ��ָ���ƶ���$t2
		sub	$t3,	$s2,	$s5      # β�����
		bgtz	$t3,	first_operand_bigger        # �����ֵΪ������ת�� first_operand_bigger
		bltz	$t3,	second_operand_bigger       # �����ֵΪ������ת�� second_operand_bigger
		beq	$t3,	$0,	print_zero   # �����ֵΪ�㣬���0

	first_operand_bigger:                               # ��һ����������
		move	$t1,	$s0              # �������ƶ���$t1
		j 	adjust_sub   		 # ��ת�� adjust_sub���е���

	second_operand_bigger:                              # �ڶ�����������
		move	$t1,	$s3      	 # �������ƶ���$t1
		sub	$t3,	$s5,	$s2      # ��β�����
		j 	adjust_sub    		 # ��ת�� adjust_sub���е���

	adjust_sub:                              # ����β������
		blt	$t3,	0x00800000,	adjust_sub1    # ���β��С��0x00800000����ת�� adjust_sub1
		j	print_result   		 # ����ֱ��������

	adjust_sub1:                             # ����β������1
		beq	$t2,	0,	error_underflow    # ���ָ��Ϊ0���׳��������
		addi	$t2,	$t2,	-1    	 # ָ����1
		sll	$t3,	$t3,	1   	 # β������1λ
		blt	$t3,	0x00800000,	adjust_sub1   # ���β��С��0x00800000����������
		j	print_result    		 # ����ֱ��������

	carry:                                   # ��λ����
		beq	$t2,	255,	error_overflow    # ���ָ��Ϊ255���׳��������
		srl	$t3,	$t3,	1    	 # β������1λ
		addi	$t2,	$t2,	1    	 # ָ����1
		j	print_result    		 # ������


# --	����    --
sub:
	xori   	$s3,     $s3,    0x00000001	# �Եڶ������������Ž���ȡ��
	j	add	# Ȼ��ִ�мӷ�


# --	�˷�    --
multiply:                                 
	beq	$s1, 	0, 	mult_first_exp_zero    # �����һ����������ָ��Ϊ0����ת��mult_first_exp_zero
	beq	$s4, 	0, 	mult_second_exp_zero   # ����ڶ�����������ָ��Ϊ0����ת��mult_second_exp_zero
	j	mult_operands_nonzero                       # ���������������ָ������Ϊ0����ת��mult_operands_nonzero
	
	mult_first_exp_zero:                           # ��һ��������ָ��Ϊ0�Ĵ������
   		beq     $s2,   0x800000,	mult_operand_has_zero     # �����һ����������β��Ϊ���ֵ����ת��mult_operand_has_zero
    		beq     $s4,   0,  	mult_second_exp_zero   # ����ڶ�����������ָ��Ϊ0����ת��mult_second_exp_zero
    		j       mult_operands_nonzero               # ������϶������㣬��ת��mult_operands_nonzero

	mult_second_exp_zero:                          # �ڶ���������ָ��Ϊ0�Ĵ������
    		beq     $s5,   0x800000,	mult_operand_has_zero	# ����ڶ�����������β��Ϊ���ֵ����ת��mult_operand_has_zero
    		j       mult_operands_nonzero               # ��������㣬��ת��mult_operands_nonzero

	mult_operand_has_zero:                             # �������д���0�Ĵ������
    		li      $t1,   0                 # ���ý���ķ���Ϊ0
    		li	$t2,   0                 # ���ý����ָ��Ϊ0
   	 	li      $t3,   0                 # ���ý����β��Ϊ0
    		j       multiply_end             # ��ת��multiply_end�����˹���

	mult_operands_nonzero:                              # ��������������Ϊ0�Ĵ������
    		add	$t2,   $s1,   $s4        # ָ���������
    		li      $t4,   127               # ����һ���м����$t4Ϊ����127
    		sub     $t2,   $t2,   $t4        # ָ����ӵĽ����ȥ127���õ��µ�ָ��

    		mult    $s2,   $s5               # β���������
    		mfhi    $t3    			 # ȡ�˷�����ĸ�λ��HI: 16λ0, 2λ��������, 14λС������
    		mflo    $t4    			 # ȡ�˷�����ĵ�λ��LO: 32λС��ʣ�ಿ��                  
    		sll     $t3,   $t3,   9	         # ����λ����9λ
    		srl     $t4,   $t4,   23	 # ����λ����23λ
    		or      $t3,   $t3,   $t4        # ��λ�͵�λ�����߼���������õ��µ�β��

    	# ��һ��
   	srl     $t4,   $t3,   24                 # ��β������24λ��ȡ�õ�25λ
    	beq     $t4,   $0,   after_norm          # �����25λΪ0��������һ������
    	srl     $t3,   $t3,   1                  # ��β������һλ
   	addi    $t2,   $t2,   1                  # ָ����1����ɹ�һ��

	after_norm:
    		slti    $t4,   $t2,   0          # ���ָ��С��0��$t4Ϊ1������Ϊ0
    		beq     $t4,   1,       error_underflow	# ���$t4Ϊ1����ʾָ�����磬��ת��error_underflow�������
    		li      $t4,   255           	 # ����$t4Ϊ����255
    		slt     $t4,   $t4,   $t2        # ���$t4С��$t2��$t4Ϊ1������Ϊ0
    		beq     $t4,   1,       error_overflow    # ���$t4Ϊ1����ʾָ�����磬��ת��error_overflow�������
    		xor     $t1,   $s0,   $s3        # �������������ķ���λ�������������õ�����ķ���λ
    		j       multiply_end             # ��ת��multiply_end�����˹���

	multiply_end:                            # �˷����̽���
    		j       print_result                   # ��ת�����


	
# --	����    --
divide:                                          # �����������
	beq	$s1, 	0, 	div_first_exp_zero     # �����������ָ��Ϊ0����ת��div_first_exp_zero
	j	div_operands_nonzero                        # �����������ָ����Ϊ0����ת��div_operands_nonzero

	div_first_exp_zero:                            # ������ָ��Ϊ0�Ĵ������
    		beq         $s2,     0x800000, div_first_operand_zero     # �����������β��Ϊ���ֵ����ת��div_first_operand_zero
    		j           div_operands_nonzero            # �����������β����Ϊ���ֵ����ת��div_operands_nonzero

	div_first_operand_zero:                            # ������Ϊ0�Ĵ������
    		li          $t1,     0           # ���ý���ķ���Ϊ0
    		li          $t2,     0           # ���ý����ָ��Ϊ0
    		li          $t3,     0           # ���ý����β��Ϊ0
    		j           div_end              # ��ת��div_end�����˹���

	div_operands_nonzero:                               # ��������Ϊ0�Ĵ������
    		bne         $s4,     0,           normal    # ���������ָ����Ϊ0����ת��normal
    		bne         $s5,     0x800000, normal        # ���������β����Ϊ���ֵ����ת��normal
    		j           error_divided_by_zero     # �������Ϊ0����ת��error_divided_by_zero�������

	normal:                                  # �����Ĵ������
    		sub         $t2,     $s1,     $s4       # ָ���������
   		addi        $t2,     $t2,     127       # ������ϳ���127���õ��µ�ָ��
    		xor         $t1,     $s0,     $s3       # �������������ķ���λ�������������õ�����ķ���λ
    		div         $s2,     $s5                # β���������
    		mflo        $t3                         # ȡ��������ĵ�λ����Ϊ�����β������������
    		mfhi        $t4                         # ȡ��������ĸ�λ����Ϊ�µ�β��
   		beq         $t3,     $0,     div_end    # ��������β��Ϊ0����ת��div_end�����˹���
    		li          $t5,     1                  # ����һ���м����$t5Ϊ1

	div_loop1:                                      # ��һ��ѭ����ȷ���������ֵ�λ��
    		srlv        $t6,     $t3,     $t5       # ��β������$t5λ
    		bne         $t6,     $0,     div_loop1  # ������ƺ��β����Ϊ0������ѭ��
    		li          $t6,     1                  # ����һ���м����$t6Ϊ1
    		sub         $t5,     $t5,     $t6       # ��$t5��ȥ1���õ��µ�$t5
    		add         $t2,     $t2,    $t5        # ָ�����ּ���$t5���õ��µ�ָ��
    		slti        $t4,     $t2,     0         # ����µ�ָ��С��0��$t4Ϊ1������Ϊ0
    		beq         $t4,     1,        error_underflow     # ���$t4Ϊ1����ʾָ�����磬��ת��error_underflow�������
    		li          $t4,     255                # ����$t4Ϊ����255
    		slt         $t4,     $t4,     $t2       # ���$t4С��$t2��$t4Ϊ1������Ϊ0
    		beq         $t4,     1,        error_overflow       # ���$t4Ϊ1����ʾָ�����磬��ת��error_overflow�������
    		li          $t7,     23                 # ����һ���м����$t7Ϊ23
    		sub         $t7,     $t7,     $t5       # ��$t7��ȥ$t5���õ��µ�$t7
    		li          $t6,     0                  # ����һ���м����$t6Ϊ0

	div_loop2:                                      # �ڶ���ѭ��������С�����ֵ�λ��
    		sll         $t4,     $t4,     1         # ��β������1λ
    		div         $t4,     $s5                # ���µ�β�����Գ���
    		mflo        $t8                         # ȡ��������ĵ�λ����Ϊ�µ�β��
    		mfhi        $t4                         # ȡ��������ĸ�λ����Ϊ�µ�β��
    		sll         $t3,     $t3,     1         # �������β������1λ
    		add         $t3,     $t3,     $t8       # ���µ�β���ӵ������β���ϣ��õ��µ�β��
    		addi        $t6,     $t6,     1         # ��������$t6��1
    		beq         $t6,     $t7,     div_end   # �������������$t7����ת��div_end�����˹���
    		beq         $t4,     $0,     div_comp_dec	# ����µ�β��Ϊ0����ת��div_comp_dec
    		j           div_loop2                   # ���򣬼���ѭ��

	div_comp_dec:                                   # β��Ϊ0ʱ�Ĵ������
    		sub         $t6,     $t7,     $t6       # ��$t7��ȥ$t6���õ��µ�$t6
    		sllv        $t3,     $t3,     $t6       # �������β������$t6λ���õ��µ�β��

	div_end:                                        # ��������
    		j           print_result                      # ��ת��print_result������


# --	������Ϣ���    --
error_divided_by_zero:
	la          $a0,    error_div_zero       # �����������Ϣ
    	li          $v0,    4                  # ��ӡ�ַ���
   	syscall                               
    	j           exit                       # ��ת���������

error_overflow:
    	la          $a0,    error_over_flow      # ���������Ϣ
    	li          $v0,    4                  # ��ӡ�ַ���
    	syscall                              
    	j           exit                       # ��ת���������

error_underflow:
    	la          $a0,    error_under_flow     # ���������Ϣ
    	li          $v0,    4                  # ��ӡ�ַ���
    	syscall                               
    	j           exit                       # ��ת���������


# --	������    --
print_zero:				       # ���0
    	move        $a0,    $0                  
    	li          $v0,    1                  # ��ӡ����
    	syscall                               
    	li          $v0,    11                 # ����
    	li          $a0,    '\n'
    	syscall                              
    	j           menu                  # ��ת���������

print_result:					       # ���������
    	li          $v0,    4                  # ��ӡ�ַ���
    	la          $a0,    msg_print_bin     # �����������Ϣ
   	syscall                              

    	# �жϽ���Ƿ�Ϊ0
    	beq         $t1,    0,    check_bin_exp_zero   # ����������λΪ0����ת��check_bin_exp_zero
    	j           print_bin_not_zero               # ������ת��print_bin_not_zero

check_bin_exp_zero:
    	beq         $t2,    0,    print_bin_zero   # ������ָ��Ϊ0����ת��print_bin_zero
    	j           print_bin_not_zero               # ������ת��print_bin_not_zero

print_bin_zero:
    	la          $a0,    string_0dot        # "0."
    	syscall                              

    	move        $a1,    $t3                 # �����β������$a1
    	li          $a2,    22                  # ���ô�ӡλ��Ϊ22
    	jal         print_bits                   # ��ӡ���β��

    	la          $a0,    string_totwo        # "*2^"
    	syscall                              

    	move        $a0,    $t2                 # ���ָ������$a0
    	li          $v0,    1                   # ��ӡ����
    	syscall                              

    	jal         print_bin_end                    # ��ת���������������
    	j           menu                 # ��ת���������

print_bin_not_zero:
    	beq         $t1,    0,       skipBinNeg   # ����������λΪ0����������
    	la          $a0,    string_neg          # "-"
	syscall                              

    	skipBinNeg:
    		la          $a0,    string_1dot         # "1."
   		syscall                              

    		move        $a1,    $t3                 # �����β������$a1
    		li          $a2,    22                  # ���ô�ӡλ��Ϊ22
    		jal         print_bits                   # ��ӡ���β��

    		la          $a0,    string_totwo        # "*2^"
    		syscall                              

    		addi        $a0,    $t2,    -127        # ���ָ����ȥ127
    		li          $v0,    1                   # ��ӡ����
    		syscall                              

    		jal         print_bin_end                    # ��ת���������������
    		j           menu                 # ��ת���������

print_bin_end:
    	li          $v0,    4                   # ��ӡ�ַ���
    	la          $a0,    msg_print_hex      # ���ʮ��������Ϣ
    	syscall                              

    	beq         $t1,    0,       check_hex_exp_zero   # ����������λΪ0����ת��check_hex_exp_zero
    	j           print_hex_not_zero                # ������ת��print_hex_not_zero

check_hex_exp_zero:
    	beq         $t2,    0,       print_hex_zero   # ������ָ��Ϊ0����ת��print_hex_zero
    	j           print_hex_not_zero                # ������ת��print_hex_not_zero

print_hex_zero:
    	la          $a0,    string_0dot         # "0."
    	syscall                              

    	la          $a0,    string_hex0         # "000000*16^0"
    	syscall                              

    	j           print_hex_end                  # ��ת��ʮ�������������

print_hex_not_zero:
	lw	    $t1,	28($sp)		#ȡ���������λ
    	beq         $t1,    0,       skipHexoutNeg  # ����������λΪ0����������
    	la          $a0,    string_neg          # "-"
    	syscall                              

    	skipHexoutNeg:
    		addi        $t7,    $t2,    -127        # ���ָ����ȥ127
    		bltz        $t7,    hex_exp_negative    # ������ָ��С��0����ת��hex_exp_negative

    		andi        $t4,    $t7,    0x3         # ȡ���ָ������4������������$t4
    		srl         $t5,    $t7,    2           # ȡ���ָ������4���̣�����$t5
    		j           prepare_hex_output          # ��ת��prepare_hex_output

hex_exp_negative:
    	li          $t4,    0                   # ��ʼ��������$t4
    	move        $t6,    $7                  # ��������$t6��ʼ��Ϊ23

hex_out_loop:
    	andi        $t7,    $t6,    0x3         # ȡ������$t6����4������������$t7
    	beq         $t7,    0,       hex_out_loopEnd 	# �������Ϊ0����ת��hex_out_loopEnd
    	addi        $t6,    $t6,    -1          # ������$t6��1
    	addi        $t4,    $t4,    1           # ������$t4��1
    	j           hex_out_loop                 # ����ѭ��

hex_out_loopEnd:
    	srl         $t5,    $t6,    2           # ȡ������$t6����4���̣�����$t5

prepare_hex_output:
   	 li         $t7,    23                  # �����м����$t7Ϊ23
    	sub         $t6,    $t7,    $t4         # ��$t7��ȥ$t4���õ��µ�$t6
    	srlv        $t6,    $t3,    $t6         # �����β������$t6λ

    	# ���С����ǰ����
    	move        $a0,    $t6                 # ���µ�β������$a0
    	li          $a1,    0                   # ����$a1Ϊ0
    	jal         convert_to_hex              # ��ת��convert_to_hex

    	# "."
   	li          $v0,    11                  # ��ӡ�ַ�
    	la          $a0,    '.'          	# "."
    	syscall                              

    	addi        $t6,    $t4,    9           # ����С������λ��
    	sllv        $t6,    $t3,    $t6         # �����β������$t6λ

    	# ���β��
   	move        $a0,    $t6                 # ���µ�β������$a0
    	li          $a1,    1                   # ����$a1Ϊ1
    	jal         convert_to_hex                     # ��ת��convert_to_hex

    	# "*16^"
    	li          $v0,    4                   # ��ӡ�ַ���
    	la          $a0,    string_to16         # "*16^"
    	syscall                              

    	# ���t5
    	li          $v0,    1                   # ��ӡ����
    	move        $a0,    $t5                 # ���µ�β������$a0
    	syscall                              

print_hex_end:
    	li          $v0,    11                  # ����
    	li          $a0,    '\n'
    	syscall                              

    	j           menu                 	# ��ת���������


print_bits: 					# Ҫ��ʾ�����ݴ���a1���ӵ�a2λ��0��ʼ����ʼ���
    	addi        $sp,    $sp,    -32         # ����ջ�ռ�
    	sw          $t1,    28($sp)             # ����Ĵ���$t1
   	sw          $t6,    24($sp)             # ����Ĵ���$t6
    	sw          $ra,    20($sp)             # ���淵�ص�ַ
    	sw          $fp,    16($sp)             # ����ָ֡��
    	addiu       $fp,    $sp,    28          # �����µ�ָ֡��
    
    	move        $t6,    $a2                 # ��startIndex����$t6
    	li          $v0,    4                   # ��ӡ�ַ���

bit_shift_loop:
    	srlv        $t1,    $a1,    $t6         # ����������$t6λ������$t1
    	andi        $t1,    $t1,    0x1         # ȡ$t1�����λ������$t1
    	beqz        $t1,    print_zero_bit                 # ������λΪ0����ת��print_zero
    	j           print_one_bit                        # ������ת��print_one

print_zero_bit:
    	la          $a0,    string_0            # "0"
    	j           print_bin                   # ��ӡ0

print_one_bit:
    	la          $a0,    string_1            # "1"
    	j           print_bin                   # ��ӡ1

print_bin:
    	syscall                              

    	addi        $t6,    $t6,    -1          # startIndex��1
    	bgez        $t6,    bit_shift_loop      # ���startIndex���ڵ���0����ת��bit_shift_loop

# -- ��������ת��Ϊ16���� --
convert_to_hex: 				# a0ΪҪ���������a1 = 0 ʱ�����3:0���������31:8
    	bne         $a1,    0,      high        # ���a1��Ϊ0����ת��high
    	low: # ���3:0
    	andi        $a0,    $a0,   0xf          # ȡ$a0�ĵ�4λ
    	lb          $a0,    hex_table($a0)      # ����Ӧ��16�����ַ����ص�$a0
    	li          $v0,    11                  # ��ӡ�ַ�
    	j           convert_to_hexEnd           # ��ת��convert_to_hexEnd

high: 						# ���31:8
    	srl         $a0,    $a0,    8           # ��$a0����8λ
    	li          $t9,    5                   # ���ü�����$t9Ϊ5

convert_to_hexLoop:
    	andi        $t7,    $a0,    0xf         # ȡ$a0�ĵ�4λ������$t7
    	lb          $t8,    hex_table($t7)      # ����Ӧ��16�����ַ����ص�$t8
    	sb          $t8,    hex_digits($t9)     # �洢��hex_digits������
    	sub         $t9,    $t9,    1           # ������$t9��1
    	srl         $a0,    $a0,    4           # ��$a0����4λ
    	bgez        $t9,    convert_to_hexLoop  # ���������$t9���ڵ���0������ѭ��

    	la          $a0,    hex_digits          # ����hex_digits�����ַ��$a0

    	li          $v0,    4                   # ��ӡ�ַ���
convert_to_hexEnd:
    	syscall

    	jr          $ra                      	# ������ת��

# --	�˳�����    --
exit:
	la		$a0,	msg_exit	# ����ټ���
	li		$v0,	4	
	syscall 
    	li          $v0,    10                  # �˳�����
    	syscall                              

