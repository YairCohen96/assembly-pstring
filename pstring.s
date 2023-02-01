// yair cohen 313355786
	.section	.rodata	                    #read only data section
invalidIn:	.string	"invalid input!\n"

	########
	.text   	                            #the beginnig of the code
      .globl pstrlen
        .type	pstrlen, @function	        # the label "pstrlen" representing the beginning of a function


pstrlen:

        pushq   %rbp		                #save the old frame pointer  
        movq    %rsp,   %rbp                #save the old frame pointer
        movq    $0  ,   %rax                #before putting return value to %rax

        movzbq  (%rdi), %rax                #put first byte - the length as return value
   
        leave
        ret


    
.globl replaceChar
        .type	replaceChar, @function	    # the label "replaceChar" representing the beginning of a function

replaceChar:

        pushq   %rbp		                #save the old frame pointer  
        movq    %rsp,   %rbp                #save the old frame pointer
    
        #loop through the string and look for oldChar - replace if found:
        movq    $0,     %r9                 #use %r9 as index counter (i) - its caller save so its okay
        call    pstrlen                     #pointer is already in %rdi from caller
        movzbq  %al,    %r10                #hold pstring length in %r10
        movq    %rdi,   %r8                 #use %r8 for pointer to string (without its length - first byte)
        incq    %r8
        
        search:
        cmpq    %r9,    %r10                #if(i==pstring length)
        jz      done1                       #finish search and return
        cmpb    (%r8),   %sil               #if(current char == oldChar) move to replace
        jz      replace
   
        #zf is off - chars don't match
        incq    %r8                         #point to next char in string
        incq    %r9                         #i++
        jmp search                          #move on
    
        replace:
        
        movq    %rdx,    %r11               #replace one byte - old char to new on buffer
        movb    %r11b,   (%r8)              #insert newChar to string
        incq    %r8                         #point to next char in string
        incq    %r9                         #i++
        jmp      search                     #continue loop 
   
            
        done1:

        movq    %rdi,    %rax               #return value - pointer to updated pstring - to %rax (stayed all along in %rdi as from caller)              
        movq	%rbp,    %rsp              	#restore the old stack pointer - release all used memory.
        popq	%rbp		                #restore old frame pointer (the caller function frame)
        ret
    
    
.globl pstrijcpy
    .type	pstrijcpy, @function	        #the label "pstrijcpy" representing the beginning of a function

pstrijcpy:

        #touching /0 is invalid input
        #for j<i and print invalid
        pushq   %rbp        		       #save the old frame pointer  
        movq    %rsp,     %rbp             #save the old frame pointer
        
        movq    %rdi,   %r13               #hold &p1 in callee-save register
        #check for valid i and j:
        cmpb    %cl,       %dl              #check if i smaller than j
        jg      invalidInput
                
        cmpb    $0,       %dl              #check if i smaller than 0
        jl      invalidInput
        
        cmpb    $0,       %cl              #check if j smaller than 0
        jl      invalidInput
        
        call    pstrlen
        cmpb    %dl,      %al              #check if i >= pstrlen1
        jle      invalidInput
        
        cmpb    %cl,      %al              #check if j >= pstrlen1
        jle      invalidInput
        
        movq    %rdi,     %r10             #hold copy of dst
        movq    %rsi,     %rdi             #check pstrlen2 validation
        
        call    pstrlen
        cmpb    %dl,      %al              #check if i > pstrlen2
        jle      invalidInput
        
        cmpb    %cl,      %al              #check if j > pstrlen2
        jle      invalidInput
        
        
        #if valid - copy
        movq    %r10,     %rdi             #send dst back - but %r10 will stay with dst
        movq    $0,       %r9              #int index = 0
        incq    %r10                       #skip the length of string
        incq    %rsi                       #skip the length of string

        search1:
        cmpb    %r9b,      %dl             #check if index > i 
        jle      copy
        incq    %r9                        #index++
        incq    %r10                       #dst++
        incq    %rsi                       #src++
        jmp     search1
        
        copy:
        cmpb    %r9b,      %cl             #if index also > j - finish
        jl      done2
        #else
        movb    (%rsi),    %r11b           #%r11b as buffer
        movb    %r11b,     (%r10)          #replace char in dst
        
        incq    %r9                        #index++
        incq    %r10                       #dst++
        incq    %rsi                       #src++
        jmp     search1      
    
        
        invalidInput:
        movq	$invalidIn, %rdi	        #the string is the only paramter passed to the printf function
	    movq	$0,         %rax
	    call	printf		                #calling to printf AFTER we passed its parameters.
        

        done2:
        
        movq    %r13,      %rax             #return dst pointer
        movq	%rbp,      %rsp   	        #restore the old stack pointer - release all used memory.
        popq	%rbp		                #restore old frame pointer (the caller function frame)
        ret
        
   
    .globl swapCase
    .type	swapCase, @function	            # the label "swapCase" representing the beginning of a function

swapCase:

        pushq   %rbp		                 #save the old frame pointer  
        movq    %rsp,       %rbp             #save the old frame pointer
        #movq    $0,        %r9              #index = 0
        movq    %rdi,       %r10             #copy for iterating over string
        incq    %r10
        
        swapLoop:
        #tests for range of capital or small letters in ascii
        cmpb    $0,         (%r10)           #if we arrived at \0 - finish
        jz      done3
        #else
        cmpb    $65,        (%r10)           #if the current char is bigger than 'A' 
        jl     cont
        #else
        cmpb    $90,        (%r10)
        jle     swapLower
        
        cmpb    $122,       (%r10)
        jg      cont
        
        cmpb    $97,        (%r10)
        jge      swapBigger
        
        cont:
        incq    %r10                        #move to next char
        jmp     swapLoop
            
        
        swapLower:
        addb   $32,         (%r10)
        jmp    cont
         
        swapBigger:
        subb   $32,         (%r10)
        jmp    cont        
                
        done3:
        movq  %rbp,         %rsp            #restore the old stack pointer - release all used memory.
        popq  %rbp		                    #restore old frame pointer (the caller function frame)
        ret
 
    .globl pstrijcmp
    .type	pstrijcmp, @function	        # the label "pstrijcmp" representing the beginning of a function

pstrijcmp:
        
        #touching /0 is invalid input
        #for j<i and print invalid


        pushq  %rbp         		        #save the old frame pointer  
        movq   %rsp,        %rbp            #save the old frame pointer
        
        #check for valid i and j:
        cmpb    %cl,       %dl              #check if i smaller than j
        jg      invalidInput1
        
        cmpb    $0,         %dl             #check if i smaller than 0
        jl      invalidInput1
        
        cmpb    $0,         %cl             #check if j smaller than 0
        jl      invalidInput1
        
        call    pstrlen
        cmpb    %dl,        %al             #check if i >= pstrlen1
        jle      invalidInput1
        
        cmpb    %cl,        %al             #check if j >= pstrlen1
        jle      invalidInput1
        
        movq    %rdi,       %r10            #hold copy of pstr1 for iterating
        movq    %rsi,       %rdi            #check pstrlen2 validation
        
        call    pstrlen
        cmpb    %dl,        %al             #check if i > pstrlen2
        jle      invalidInput1
        
        cmpb    %cl,        %al             #check if j > pstrlen2
        jle      invalidInput1
        
        movq    $0,         %r8             #index = 0
        incq    %r10
        movq    %rsi,       %r9             #for iterating over p2
        incq    %r9
        movq    $0,         %r11
        
        movq    $0,         %rax

        cmpLoop:
        cmpb    %r8b,       %cl             #if index also > j - finish
        jl      done4
        
        cmpb    %r8b,       %dl             #check if index > i
        jg      cont1
        
        movb    (%r9),      %r11b
        cmpb    (%r10),     %r11b
        jz      cont1       #if equal - check the next
        jl      return1
        jg      return_1
        
        cont1:              #move on to next char
        incq    %r8
        incq    %r9
        incq    %r10
        jmp     cmpLoop
        
        return1:
        movq    $1,         %rax
        jmp done4

        return_1:
        movq    $-1,        %rax
        jmp done4

        invalidInput1:
        movq	$invalidIn, %rdi	        #the string is the only paramter passed to the printf function
        movq	$0,         %rax
	    call	printf		                #calling to printf AFTER we passed its parameters.
        movq    $-2,         %rax
        
        
        done4:
        movq	%rbp,       %rsp           	#restore the old stack pointer - release all used memory.
        popq	%rbp		                #restore old frame pointer (the caller function frame)
        ret
 
