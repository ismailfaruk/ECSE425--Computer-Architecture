; Given the vector of double vett1 = {2, 5, 7, 8, 10, 13, 16}
; x = 5
; create an assembly program that:
; (a) displays the elements of vett1> x
; (b) Create a vector v2 containing the elements of v1 in reverse order
; (c) Displays the position of the minimum of vectors2 (starting from position 0)

;for(i=0;i<7;i++){
;  if(vet[i]>x) stampa vet1(vetmaggiore)
;}
;for(j=0;j<size1;++){
;	vet2[i]=vet1[size-1]
;	if(j==0) pos=0
;	else if(min>vet[j]) min=vet[j]
;			pos=j


		.data
vet1:		.word 2,5,7,8,2,10,16
vet2:		.word 0,0,0,0,0,0,0
vetmagg:	.word 0,0,0,0,0,0,0


		.text
		daddi r1,r0,vet1
		daddi r2,r0,vet2
		dsub r3,r2,r1		;size vet1
		daddi r4,r0,0		;r4=i=0 index vet1
		daddi r5,r0,0		;r5=j=0 index vetmagg 
		daddi r1,r0,0		;r1=k=index vet2
		daddi r6,r3,-8		;r6=size-1
		daddi r7,r0,0		;r7=min
		daddi r31,r0,0		;r30=posmin
		
while:	slt r8,r4,r3			;r8=if(i<size)
		beqz r8,endwhile
		ld r9,vet1(r4)		
		daddi r10,r0,5		;r10=x=5
		slt r11,r10,r9		;r11=if(x<vet[i])
		beqz r11,else
		sd r9,vetmagg(r5)
		daddi r5,r5,8		;r5=j++
else:		daddi r4,r4,8		;r4=i++
		j while
		
endwhile:	nop

while2:	slt r12,r1,r4		;r12=if(r1=k<r4=size1)
		beqz r12,endwhile2
		ld r13,vet1(r6)
		sd r13,vet2(r1)		
		j minimo
	
endwhile2:	halt


minimo:	bnez r1,elsemin			;if(r1==0)
		dadd r27,r0,r13			;r27=min=vet[0]
		daddi r31,r0,0			;r31=pos=0
		j endminimo
elsemin:	slt r14,r13,r27			;r14=if(r13<r27)
		beqz r14,endminimo
		dadd  r27,r0,r13			;r27=min=vet2[i]
		daddi r31,r31,1			;r31=pos=k
		j endminimo
endminimo: daddi r1,r1,8			;r1=k++
		beqz r6,endwhile2
		daddi r6,r6,-8		        ;size--
		j while2