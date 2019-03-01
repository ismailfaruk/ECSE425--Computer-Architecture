;Given a vector of integers 1 [] = {4,6,8,9,10,12,16,3,24,15} to copy in a vector vett2 [] the numbers
;divisible by 4 and in a vector v3 [] those divisible by 8
;and then calculate the minima by writing them in r29 and r30,
		.data
vett1:	.word 4,6,8,9,10,12,13,3,5,15
vett2:	.word 0,0,0,0,0,0,0,0,0,0
vett3:	.word 0,0,0,0,0,0,0,0,0,0
		.text
		daddi r1,r0,vett1
		daddi r2,r0,vett2
		dsub r3,r2,r1			;r3=sizeof(vett1)
		daddi r1,r0,0			;r1=i=0  indice di scorrimento di vett1
		daddi r2,r0,0			;r2=i2=0 indice di inserimento in vett2
		daddi r4,r0,0			;r4=i3=0 indice di inserimento in vett3
while_scanvett1:
		ld r20,vett1(r1)			;r20=k=vett1[i]
		slt r5,r1,r3
		beqz r5,endwhile_scanvett1	;if(!(i<size)) goto endwhile_scanvett1
		ld r6,vett1(r1)			;r6=vett1[i]
		andi r7,r6,3
		bnez r7,testdivper8		;if(k%4!=0) goto testdivper8
		bnez r2,noprimodivper4		;if(i2!=0) goto noprimodivper4	
		dadd r29,r0,r20			;r29=min1=k=vett1[i]
		j comune1			
noprimodivper4: dadd r28,r0,r20
		daddi r27,r20,0
		dadd r28,r0,r29
		jal minimo
		dadd r29,r0,r26			;r29=minimo()
comune1:	sd r20,vett2(r2)			;vett2[i2]=k;
		daddi r2,r2,8
testdivper8:  andi r7,r20,7
		bnez r7,incr
		bnez r4,noprimodivper8
		dadd  r30,r0,r20
		j comune2
noprimodivper8: dadd r28,r30,r0		;r28=min2
		dadd r27,r20,r0
		jal minimo
		daddi r30,r26,0			;r30=minimo()
comune2:	sd r20,vett2(r4)	
		daddi r4,r4,8
incr:		daddi r1,r1,8		
		j while_scanvett1
endwhile_scanvett1: HALT
		
;******************  FUNZIONE MINIMO **********************
;    r26=minimo(int min=r28,int val=r27)   
minimo:	slt r21,r27,r28
		beqz r21,tienivecchio
		dadd r26,r27,r0
		jr r31
tienivecchio: dadd r26,r28,r0		
		jr r31
		
; public class Compito
; {
	; public static void main(String[] args)
	; {
		; int vett1[]={4,6,8,9,10,12,16,3,24,15};
		; int vett2[]={0,0,0,0,0,0,0,0,0,0};
		; int vett3[]={0,0,0,0,0,0,0,0,0,0};
		; int size=vett1.length;
		; int i=0;  //indice di scorrimento di vett1
		; int i2=0; //indice di inserimento in vett2
		; int i3=0; // indice di inserimento in vett3
		; int k;
		; int min1=0,min2=0;
		; while(i<size)
		; {
			; k=vett1[i];
			; if(k%4==0)
			; {
				; if(i2==0)
					; min1=k;
				; else  //noprimodivper4
					; min1=minimo(min1,k);
				; vett2[i2]=k;
				; i2++;
			; }
			; if(k%8==0)
			; {
				; if(i3==0)
					; min2=k;
				; else  //noprimodivper8
					; min2=minimo(min2,k);
				; vett2[i3]=k;
				; i3++;
			; }
			; i++;
		; }
		; System.out.println(min1);
		; System.out.println(min2);
	; }
	
	; public static  int minimo(int min,int val)
	; {
		; if(val<min)
			; return val;
		; else
			; return min;
	; }
; }		