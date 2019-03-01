; Given a vector v1 = {1,2,7,4,5,9,11,3,32,16} a program is realized that
; a) copies the equal elements of v1 into a vector2 reversing the order
; b) creates the vector of double v3, where v3 [i] = v2 [i] / v1 [i]
; c) displays the minimum of v3 and its position
		.data
vett1:	.word 6,4,2,8,5,3,9,1,7,11 ;1,2,7,4,5,9,11,3,32,16
vett2:	.word 0,0,0,0,0,0,0,0,0,0,0
vett2_temp: .word 0,0,0,0,0,0,0,0,0,0,0
vett3:	.word 0,0,0,0,0,0,0,0,0,0,0
		.text
		DADDI R1,R0,vett1		;r1=vett1[]
		daddi r2,r0,vett2		;r2=vett2[]
		dsub r3,r2,r1			;r3=size
		daddi r1,r0,0			;r1=i=0
		daddi r2,r0,0			;r2=i2=0
whileprendipari:	slt r4,r1,r3			        ;while(i<size)
		beqz r4,endwhileprendipari
		LD r5,vett1(r1)			;r5=vett1[i]
		andi r6,r5,1			
ifpari:	bnez r6,endifpari
		SD r5,vett2_temp(r2)
		daddi r2,r2,8
endifpari:	daddi r1,r1,8
		j whileprendipari	
endwhileprendipari:  daddi r1,r0,0	;r1=i=0
		daddi r7,r0,0			;r7=min=0
		daddi r8,r0,0			;r8=minindex=0
		dadd r9,r0,r2			;r9=vett2_size=i2
whilescanvet2: slt r10,r1,r9			;while(i<vett2_size) 
		beqz r10,endwhilescanvet2
		;perform vett2[i]=vett2_temp[i2-1]
		daddi r11,r0,1
		dsub r11,r2,r11			;r11=[i2-1]
		ld r12,vett2_temp(r11)	;r12=vett2_temp[i2-1]
		sd r12,vett2(r1)			;r12=vett2[i]=vett2_temp[i2-1]
		;perform vett3[i]=vett2[i]/vett1[i];
		ld r13,vett1(r1)			;r13=vett1[i]
		ddiv r12,r13
		mflo r12				;r12=vett2[i]/vett1[i];
		sd r12,vett3(r1)		;vett3[i]=vett2[i]/vett1[i];
ifprimo:	bnez r1,ifminimo
		ld r7,vett3(r1)			;r7=min=vett3[i]
		dadd r8,r0,r1			;r8=min_index=i;
ifminimo: 	slt r14,r12,r7			;if(vett2[i]<min)
		beqz r14,incr
		ld r7,vett3(r1)			;min=vett3[i];
		dadd r8,r0,r1			;min_index=i;
incr:		daddi r1,r1,8			;i++
		daddi r15,r0,8
		dsub r2,r2,r15			;i2--
		j whilescanvet2
endwhilescanvet2: HALT			;risultati: r7=min(vett3)   r8=min.index()
		
; public class Compito
; {
	; public static void main(String args[])
	; {
		; int vett1[]={6,4,2,8,5,3,9,1,7,11};
		; int vett2[]={0,0,0,0,0,0,0,0,0,0,0};
		; int vett2_temp[]={0,0,0,0,0,0,0,0,0,0,0};	
		; int vett3[]={0,0,0,0,0,0,0,0,0,0,0};
		
		; int size=10;  //differenza indirizzi di memoria
		; int i=0;
		; int i2=0;
		; while(i<size)
		; {
			; if(vett1[i]%2==0)
			; {
				; vett2_temp[i2]=vett1[i];
				; i2++; //+8
			; }
			; i++;  //+8
		; }
		; printvet(vett2_temp);
		; //inversione vettore vett2_temp e calcolo del minimo
		; i=0;
		; int min=0;
		; int min_index=0;
		; int vett2_size=i2;
		; while(i<vett2_size) 
		; {
			; vett2[i]=vett2_temp[i2-1];
			; vett3[i]=vett2[i]/vett1[i];
			; if(i==0)
			; {
				; min=vett3[i];
				; min_index=i;
			; }
			; if(vett2[i]<min)
			; {
				; min=vett3[i];
				; min_index=i;
			; }
			; i++; //+8
			; i2--; //-8
		; }
		; System.out.println("min "+min+ " minindex "+min_index);
	; }
	
	; static void print(String val)
	; {
		; System.out.println(val);
	; }
	; static void  printvet(int[] val)
	; {
		; String output="";
		; for(int i=0;i<val.length;i++)
		; {
			; output+="  " + val[i]+ "  ";
		; }
		; System.out.println(output);
	; }


; }		
		
		
		


