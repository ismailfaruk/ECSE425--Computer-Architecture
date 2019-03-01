;given a vector of vectors v1 = [18,23,25,22,24] and one of the relative
;credits v2 = [6,9,6,9,6] write in a vector vectors3 [0,0,0,0,0,0,0,0,0]
;the votes of subjects from 12 credits that must be given to bring the weighted average
;to 26; constraints (a vote of vett3 can not be higher
;5 points from the current weighted average, vett3 must be filled (even if not)
;completely) with a sufficient number of votes to solve the problem
		.data
vett1: 	.word 18,23,25,22,24
vett2:		.word 6,9,6,9,6
vett3:		.word 0,0,0,0,0,0,0,0,0,0
comodo:		.byte 0 	;per identificare la lunghezza di vett3
		.text
		daddi r1,r0,vett1
		daddi r2,r0,vett2
		dsub r3,r2,r1		;r3=sizeof(vett1)
		daddi r1,r0,vett3
		daddi r2,r0,comodo
		dsub r2,r2,r1		;r2=sizeof(vett3)
		daddi r4,r0,0		;r4=s1=0   sommatore per media pesata
		daddi r5,r0,0		;r5=s2=0   sommatore dei voti
		daddi r6,r0,0		;r6=s3=0   sommatore dei crediti
		daddi r1,r0,0		;r1=i=0      contatore per ciclo di scansione vett3
while_scanvett1:
		slt r7,r1,r3
		beqz r7,endwhile_scanvett1
		ld r8,vett1(r1)		;r8=vett1[i]
		ld r9,vett2(r1)		;r9=vett2[i]
		dmult r8,r9
		mflo r10
		dadd r4,r4,r10
		dadd r5,r5,r9
		dadd r6,r6,r9
		daddi r1,r1,8		
		j while_scanvett1
endwhile_scanvett1:
		ddiv r4,r6
		mflo r11			;r11=mediapesata=s1/s3
		daddi r12,r0,0		;r12=i2=0
		daddi r1,r0,0		;r1=i=0
while_scanvett3:
		slt r13,r1,r2		;while(i<vett3.length)
		bnez r13,secondacondizione
		j endwhile_scanvett3
secondacondizione: daddi r14,r0,26
		beq r11,r14,endwhile_scanvett3
		;calcolo x=(mediapesata+1)*(s3+12)-s2   ovvero mediapesata+1=(svoti+votox)/(screditi+12)
		daddi r15,r0,1
		dadd r15,r15,r11		;r15=(mediapesata+1)
		daddi r16,r0,12
		dadd r16,r16,r6		;r16=(s3+12)
		dmult r15,r16		;
		mflo r15			;r15=(mediapesata+1)*(s3+12)
		dsub r16,r15,r5		;r16=x=(mediapesata+1)*(s3+12)-s2  
		daddi r17,r11,5		;r17=mediapesata+5
		slt r18,r17,r16		;if(not(x>mediapesata+5)) goto else
		beqz r18,else
		sd r17,vett3(r12)		;vett3[i2]=mediapesata+5;
		daddi r16,r17,0		;x=(mediapesata+5);
		j comune
else:		sd r16,vett3(r12)
comune:	daddi r19,r0,12
		dmult r19,r16
		mflo r20			;r20=12*x
		dadd r4,r4,r20		;s1+=12*x
		daddi r6,r6,12		;s3+=12;
		daddi r1,r1,8		;i++;
		daddi r12,r12,8		;i2++;
		ddiv r4,r6
		mflo r11
		j while_scanvett3
endwhile_scanvett3: HALT

; public class Compito
; {
	; public static void main(String[] args)
	; {
		; int vett1[]={18,23,25,22,24};
		; int vett2[]={6,9,6,9,6};
		; int vett3[]={0,0,0,0,0,0,0,0,0,0};
		; int s1=0;  //sommatore per media pesata
		; int s2=0;  //sommatore dei voti
		; int s3=0;  //sommatore dei crediti
		; int i=0;
		; int x;
		; while(i<vett1.length)
		; {
			; s1+=vett1[i]*vett2[i];
			; s2+=vett1[i];
			; s3+=vett2[i];
			; i++;
		; }
		
		; int mediapesata=s1/s3; //no inizializzare 
		; int i2=0;   //puntatore di inserimento in vett3
		; i=0;   //indice di scorrimento di vett3
		; System.out.println("prima media pesata"+s1/s3);
		; while(i<vett3.length && mediapesata!=26)
		; {
			; x=(mediapesata+1)*(s3+12)-s2;  //mediapesata+1=(svoti+votox)/(screditi+12)
			; System.out.println(x);
			; if(x>mediapesata+5)
			; {
				; vett3[i2]=mediapesata+5;
				; x=(mediapesata+5);
			; }
			; else
			; {
				; vett3[i2]=x;
			; }
			; s1+=6*x;
			; s3+=6;			
			; i++;
			; i2++;
			; mediapesata=s1/s3;
			; System.out.println("media pesata"+mediapesata);
		; }
		; printvett(vett1);
		; printvett(vett3);
		; printvett(vett2);
		
	; }
	; public static void printvett(int[] vett)
	; {
		; System.out.println(" ");
		; for(int i=0;i<vett.length;i++)
		; {
			; System.out.println(vett[i]);
		; }
	; }
	
; }