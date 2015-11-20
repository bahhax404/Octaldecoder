
;This a program I wrote to decode octal number to their ascii equivalent 
; run the program in terminal : ./decode > output.txt < input.txt 
; it's a very basic program that doesn't take performance or memory size into account 

section .data

char1: db "0"
char2: db "0"
char3: db "0"
finalchar: db "0"
finalcharlen equ $-finalchar
bufferlen equ 1
section .bss
outbuffer resb 1
buffer resb 1


section .text



global _start 



_start:
mov esi, 0  ; index 
read:
mov eax, 3
mov ebx, 0 
mov ecx, buffer
mov edx, 1
int 80h
cmp eax, 0 


je Exit 
cmp byte [buffer], 20h

je read

xor eax, eax
mov al, byte [buffer]
xor edx, edx
mov dl, al 
cmp esi, 0
je writechar1
cmp esi, 1
je writechar2
cmp esi, 2
je writechar3


writechar1:

mov byte [char1], dl

inc esi
 
 
jmp read

writechar2:

mov byte [char2],dl

inc esi 
; restore regiters before calling read again

jmp read

writechar3:
mov byte [char3],dl 

xor esi, esi  ; reset the index 
xor eax, eax

mov al, byte [char1]  ; get the first char  and convert it to a number
add al,0
aaa
mov ah, 100
mul ah 
xor ecx, ecx 
mov cx, ax   ;ecx holds the value 
xor eax, eax 

mov al, byte [char2]  ; retreive the value in second number 
add al,0 
aaa 
mov ah, 10
mul ah
;__________________ ax has the value 

mov di, ax ; first value in edi 

xor eax, eax ; clear eax to hold the second value 

mov al,byte [char3]
add al, 0 
aaa

add di , ax ; add the two number to get one value 
add di, cx  ; get the final number by adding ax cx di 

;____ non printable ascii characters works if characters are explicitly invoked in the encoded text _;
newline:
cmp di, 0Ch
je newlinechar

newlinechar:
cmp di, 0Fh
jle nonprintable

jmp othercharacters

nonprintable:

sub di, 2
jmp write
;_____________________ end of non-printable ascii characters _____________________;

;_____________________ other printable  ascii  characters __________________________;
othercharacters:

cmp di, 28h ; 
jge spacetoapos  ; from space to apostrophe
spacetoapos:
cmp di, 2fh
jle space

cmp di, 32h 
jge parenthesis  ; from parenthesis to  backslash "( to /"
parenthesis:
cmp di, 39h
jle brackets

cmp di,3Ch
jge zerotoseven ; from zero to seven 0-7
zerotoseven:
cmp di, 043h
jle zeroseven

cmp di, 46h
jge eightoquest      ; eight to question mark  8 - ?
eightoquest:
cmp di, 4Dh
jle eightoquestion

jmp uppercase  ; jump to uppercase letters 



space:

sub di, 8h
jmp write 

brackets:
sub di, 0Ah
jmp write 

zeroseven:
sub di, 0Ch
jmp write

eightoquestion:
sub di, 0Eh
jmp write

;_________________________ END OF other characters __________________________;

;_____________________ CAPITAL LETTERS  "A to _"  __________________________;
uppercase:
cmp di, 64h ; 101 in decimal 
jge AtoG
AtoG:
cmp di, 6Bh

jle fromAtoG
cmp di, 6Eh 
jge HtoO
HtoO:
cmp di, 75h
jle fromHtoO

cmp di, 78h
jge PtoW
PtoW:
cmp di, 7Fh
jle fromPtoW

cmp di, 82h
jge XtoZ
XtoZ:
cmp di, 84h
jle fromXtoZ

jmp lowercase ; jump to lowercase if no uppercase is found 


fromAtoG:

sub di, 24h
jmp write 

fromHtoO:
sub di, 26h
jmp write 

fromPtoW:
sub di, 28h
jmp write

fromXtoZ:
sub di, 89h
jmp write

;_________________________ END OF CAPITAL LETTERS__________________________;


;_____________________ lowercase letters " a to ~ " __________________________;
lowercase:

cmp di, 8Dh ; 
jge atog
atog:
cmp di, 93h

jle fromatog
cmp di, 96h 
jge htoo
htoo:
cmp di, 9Dh
jle fromhtoo

cmp di,0A0h
jge ptow
ptow:
cmp di, 0A7h
jle fromptow

cmp di, 0AAh
jge xtoz
xtoz:
cmp di, 0B0h
jle fromxtoz



fromatog:

sub di, 2Ch
jmp write 

fromhtoo:
sub di, 2Eh
jmp write 

fromptow:
sub di, 30h
jmp write

fromxtoz:
sub di, 32h
jmp write

;_________________________ END OF lowercase letters__________________________;



write:
mov word [finalchar], di ; put the character in the finalchar to print it 
mov eax, 4
mov ebx, 1
mov ecx, finalchar
mov edx, 1
int 80h


jmp read 

Exit:
mov eax, 1
mov ebx, 0 
int 80h
