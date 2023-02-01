// yair cohen 313355786
	.section	.rodata	            #read only data section

format3:    .string "%d%*c"	        #number format - print/scan
format4:    .string "%[^\n]%*c"     #string format - print/scan

	########
	.text   	                    #the beginnig of the code
.globl	run_main    	            #the label "main.c" is used to state the initial point of this program
	.type	run_main, @function	    # the label "main.c" representing the beginning of a function
# the run_main function:
run_main:
    movq %rsp, %rbp #for correct debugging
    
    pushq   %rbp		            #save the old frame pointer  
    movq    %rsp,       %rbp        #save the old frame pointer
    
    #getPStrings:
    sub     $528,       %rsp        #allocating space on stack frame for 3 integers, two strings and index (mult of 16 convention)  
    
    movq    $0,         %r12        #clear %r12

    movq    $0,         %rax        #before calling scanf
    movq    $format3,   %rdi        #second parameter to scanf
    leaq    -528(%rbp), %rsi        #putting n1 adress -  on the stack frame
    movq    $0,         %r14        #clear %r12
    movq    %rsi,       %r14        #as a buffer for making sure we get a one byte size number
    call    scanf                   #get n1 from user -> %rsi
    movb    (%r14),     %r12b           
    
    movb    %r12b,      -524(%rbp)  #put the one byte number in right location for pstring1
    
   
    leaq    -523(%rbp), %rsi        #put the input string "under" n1 on stack - 255 bytes max ('\0' added in format %s)
    movq    $0, %rax                #before calling scanf
    movq    $format4,   %rdi        #second parameter to scanf
    call    scanf                   #get first string from user to %rsi
    
    
    #same proccess for pstring2:
    movq    $0, %r12            #clear again for pstring2
    movq    $0, %rax            #before calling scanf
    movq    $format3,   %rdi    #second parameter to scanf
    leaq    -268(%rbp), %rsi    #putting n1 adress -  on the stack frame
    movq    $0,         %r14
    movq    %rsi,       %r14
    call    scanf               #get n2 from user to %rsi
    movb    (%r14),     %r12b
    
    movb    %r12b,      -264(%rbp)
    
    
    leaq    -263(%rbp), %rsi    #put the input string "under" n2 on stack - 256 bytes max including '\0' added in format %s
    movq    $0, %rax            #before calling scanf
    movq    $format4,   %rdi    #second parameter to scanf
    call    scanf               #get first string from user -> %rsi
    
    #finally get also index for switch case from user
    movq    $0, %rax            #before calling scanf
    movq    $format3,   %rdi    #second parameter to scanf
    leaq     -8(%rbp),  %rsi    #putting menu index adress -  on the stack frame
    call    scanf               #get index from user -> %rsi
    
    
    #send 3 parameters to run_func:
    
   
    movq    -8(%rbp),   %rdi    #index - first parameter
    leaq    -524(%rbp), %rsi    #get p1 from stack frame to %rsi for print
    leaq    -264(%rbp), %rdx    #get p2 from stack frame to %rsi for print
    call    run_func
    
    
   
    #finish after return from run_func
    leave
    ret
