; Program that reads a vector of 10 integers and copies it inverted into another
;vector only if the current element is odd or less than 50, otherwise
;puts it in the square of the current element.

;main()
;{
;	int i,j=len(vet1)-1;
;	for(i=0;i<len(vet1);i++,j--)
;		if(vet1[i]<50 || dispari(vet1[i]))
;			vet2[j]=vet[i];
;		else
;			vet2[j]=quadrato(vet1[i]);
;}

;by Simona Ullo

	.data
vet1:	.word	2,33,60,5,75,63
vet2:	.word 	0,0,0,0,0,0

	.code
	DADDI R1,R0,0		;R1=0 indice di vet1
	DADDI R2,R0,vet1	;R2=vet1 indirizzo di vet1
	DADDI R3,R0,vet2	;R3=vet2 indirizzo di vet2
	DSUB R4,R3,R2		;R4=vet2-vet1 dimensione di vet1 in byte
	DADD R5,R4,R0		;R5=R4 indice di vet2 
	DADDI R5,R5,-8		;R5=dim(vet2)-1 - ultima posizione di vet2 a partire dalla quale si copiano i valori
loop:	LD R7,vet1(R1)		;R7=Mem[vet1+R1] carica in R7 l'elemento attuale del vettore
	SLTI R8,R7,50		;if(vet1[i]<50) R8=1 else R8=0
	BNEZ R8,copy		;... se il valore è minore di 50 bisogna copiarlo in vet2
	ANDI R8,R7,1		;Se R8=1 allora il numero è dispari, altrimenti è pari
	BNEZ R8,copy		;... se il valore è dispari bisogna copiarlo in vet2
	DADD R30,R7,R0		;R30=vet1[i] elemento attuale da elevare al quadrato - parametro funzione
	JAL quadrato		;chiama la funzione quadrato 
	DADD R7,R29,R0		;R7=R29 valore di ritorno della funzione quadrato

copy:	SD R7,vet2(R5)		;copia in vet2 il valore attuale di vet1
	DADDI R5,R5,-8		;R5-- (j--)

	DADDI R1,R1,8		;R1++
	SLT R9,R1,R4		;if(i<len(vet1[i]) R9=1 else R9=0
	BNEZ R9,loop		;cicla nuovamente se ci sono ancora elementi in vet1
	HALT

;****Funzione quadrato****
;for(i=0;i<val;i++)
;	val+=val

quadrato:
	DADD R29,R30,R0		;R29=valore da elevare al quadrato
	DADDI R28,R0,0		;R28=0 (i=0) indice ad incremento
ciclo:	SLT R27,R28,R30		;if(i<val) R27=1 else R27=0
	BEQZ R27,end
	DADD R29,R29,R30	;val+=val
	DADDI R28,R28,1		;R28++
	J ciclo	
end:	JR R31
	


