// yair cohen 313355786
	.section	.rodata	                    #read only data section
scanNum:    .string "%hhu"	                #scanf number format
invalid:	.string	"invalid option!\n"
format3:    .string "%d%*c"	                #number format
format5:    .string " %c"                   #char scan format
format37:   .string "compare result: %d\n"
format36:   .string "length: %d, string: %s\n"
format33:   .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
format31:   .string "first pstring length: %d, second pstring length: %d\n"

#jump table - switch case:
.align 8
.L10:
    .quad .L2   #default case
    .quad .L3   #case 31
    .quad .L4   #case 32
    .quad .L5   #case 33
    .quad .L6   #case 34
    .quad .L7   #case 35
    .quad .L8   #case 36
    .quad .L9   #case 37

	########
	.text   	                    #the beginnig of the code
        
        .globl	run_func
	.type  run_func, @function

# the run_func function:
run_func:
    pushq   %rbp		        #save the old frame pointer  
    movq    %rsp,    %rbp       #for correct debugging
    sub     $32,     %rsp       #allocate space for 2 ints (chars this time actually) and two pointers to p1 p2 on stack frame

    #store the pointers on stack:
    movq    %rsi,   -32(%rbp)   #store p1
    movq    %rdx,   -24(%rbp)   #store p2
        
    #set up the jump table access:
    subq    $30,    %rdi        #holding now chosen index-30 in %rdi
    cmpq    $7,     %rdi        #compare 7:xi
    ja      .L2                 #goto - default
    jmp     *.L10(,%rdi,8)      #goto jt[xi]
    
    .L9:                        #case 37
          
    # get two numbers from scanf:
    movq    $0,     %rax        #before calling scanf
    movq    $format3, %rdi      #first parameter to scanf
    leaq    -16(%rbp), %rsi     #putting i adress -  on the stack frame
    call    scanf               #get i from user -> %rsi
    
    
    leaq    -12(%rbp), %rsi     #put j "under" i on stack
    movq    $0,     %rax        #before calling scanf
    movq    $format3, %rdi      #first parameter to scanf
    call    scanf               #get j from user -> %rsi
    
    movq    -32(%rbp),  %rdi    #p1 to first parameter
    movq    -24(%rbp),  %rsi    #p2 to second parameter
    movq    -16(%rbp),  %rdx    #put i as third parameter
    movq    -12(%rbp),  %rcx    #put j as fourth parameter
    
    call    pstrijcmp           #call the function
    #after return from function:
    #return value in %rax
    
    movq    $format37, %rdi    #first parameter to printf
    movq    %rax,      %rsi    #second parameter
    call    printf
    jmp     done               #finish program
    
    
    
    .L8:                       #case 36
       
     movq    -32(%rbp), %rdi   #&p1 as only parameter
     call    swapCase
        
    #after return from function:
    #print p1:
    movq    $0,         %rsi   #clear %rsi
    movq   -32(%rbp),   %r10
    movb    (%r10),     %sil   #hold length of pstring
    movq    -32(%rbp),  %rdx   #hold the string    
    incq    %rdx

    movq    $format36,   %rdi  #first parameter to printf
    call    printf
    
    movq    -24(%rbp),   %rdi  #&p2 as only parameter
    call swapCase
        
    #print p2:
    movq    $0,         %rsi
    movq    -24(%rbp),  %r10 #put second length to buffer
    movb    (%r10),     %sil #second length as parameter on %rsi
    movq    -24(%rbp),  %rdx
    incq    %rdx
    movq    $format36,  %rdi #first parameter to printf
    call    printf

    jmp     done             #finish program
    
    
    
    
    .L7:                     #case 35
     #get two numbers from scanf:
     movq    $0,        %rax #before calling scanf
     movq    $scanNum,  %rdi #first parameter to scanf
     leaq    -16(%rbp), %rsi #putting i adress -  on the stack frame
     call    scanf           #get i from user to %rsi
    
    
     leaq    -15(%rbp), %rsi #put j "under" i on stack
     movq    $0,        %rax #before calling scanf
     movq    $scanNum,  %rdi #first parameter to scanf
     call    scanf           #get j from user -> %rsi
        
     movq    -32(%rbp), %rdi #&p1 to first parameter as dst
     movq    -24(%rbp), %rsi #&p2 to second parameter as src
     movq    -16(%rbp), %rdx #put i as third parameter
     movq    -15(%rbp), %rcx #put j as fourth parameter
    
     call    pstrijcpy       #call the function
       
    #after return from function - same proccess for print as #case 36:
    movq    $0,         %rsi
    movq   -32(%rbp),   %r10
    movb    (%r10),     %sil
    movq    -32(%rbp),  %rdx
    incq    %rdx

    movq    $format36,  %rdi    #first parameter to printf
    call    printf
    
    #print p2:
    movq    $0,         %rsi
    movq    -24(%rbp),  %r10    #put second length to buffer
    movb    (%r10),     %sil    #second length as parameter on %rsi
    movq    -24(%rbp),  %rdx
    incq    %rdx
    movq    $format36,  %rdi    #first parameter to printf
    call    printf

    jmp     done                #finish program
    
        
    .L6:                        #case 34
        jmp .L2                 #default invalid input
    
    .L5:                        #case 33
    #get two chars from scanf
    movq    $0,         %rax    #before calling scanf
    movq    $format5,   %rdi    #first parameter to scanf
    leaq     -16(%rbp), %rsi    #putting oldChar adress -  on the stack frame
    call    scanf               #get oldChar from user -> %rsi
    
    
    leaq    -15(%rbp),  %rsi    #put newChar "under" oldChar on stack
    movq    $0,         %rax    #before calling scanf
    movq    $format5,   %rdi    #first parameter to scanf
    call    scanf               #get newChar from user -> %rsi
        
    #set parametres for replaceChar func - p1:
    movq    -32(%rbp),  %rdi    #first param - &p1
    movq    -16(%rbp),  %rsi    #second param - oldChar
    movq    -15(%rbp),  %rdx    #third param - newChar
    call    replaceChar
    #return val in %rax
    movq    %rax,       %rcx    #put updated p1 in its place on stack frame
    incq    %rcx
        
    #set parametres for replaceChar func - p2:
    movq    -24(%rbp),  %rdi    #first param - &p2
    movq    -16(%rbp),  %rsi    #second param - oldChar
    movq    -15(%rbp),  %rdx    #third param - newChar
    call    replaceChar
    #return val in %rax
    movq  %rax,         %r8     #put updated p2 in its place on stack frame
    incq    %r8
        
    #set param for print:
    movq    $format33,  %rdi    #first parameter - format to printf
    movq    -16(%rbp),  %rsi    #second param - oldChar
    movq    -15(%rbp),  %rdx    #third param - newChar
    movq    $0,         %rax
    call    printf
    
    jmp     done            #finish program        
    
    .L4:                    #case 32
        jmp .L5             #just like case 33
    
    .L3:                    #case 31
       
    #set param for pstrlen:
    movq    -32(%rbp),  %rdi        #first param - &p1
    call    pstrlen
        
    #return value in %rax:
    movq    %rax,   -   16(%rbp)    #store p1Length on stack frame
        
    #set param for pstrlen:
    movq    -24(%rbp),  %rdi        #first param - &p2
    call    pstrlen
        
    #return value in %rax:
    movq    %rax,       -8(%rbp)    #store p2Length on stack frame
        
    #set params for printf
    movq    $format31,   %rdi       #first parameter - format to printf
    movq    $0, %rsi
    movq    -16(%rbp),   %rsi       #second param - p1Length
    movq    $0, %rdx
    movq    -8(%rbp),    %rdx       #third param - p2Length
    movq    $0,          %rax
    call    printf
        
    jmp     done
        
    
    .L2:                            #default case
    movq	$invalid,    %rdi	    #the string is the only paramter passed to the printf function
	movq	$0,          %rax
	call	printf		            #calling to printf AFTER we passed its parameters.

     

    done:

    leave
    ret
