;Search for the minimum of a vector, using the passage of parameters
; through stack.
;C implementation
;
; int v[] = {9,5,8,33,4,2,5,3,7,6};
; const int LEN = 10;
; int min = v[0];
; for(int i = 1; i < LEN; i++)
; 	if( minimo(min,v[i]) == v[i])
;		min = v[i];
;
;
; int minimo(int a, int b){
; 	return (a < b? a: b);
;
; by Salvo Scellato

		.data
vet:		.word 9,5,8,33,4,2,5,3,7,6
len:		.word 0

		.text

		DADDI R1, R0, vet
		DADDI R2, R0, len
		DSUB R7, R2, R1		;lunghezza del vettore in R7
		DADDI R30, R0, 1024	;stack pointer in R3
		DADDI R1, R0, 0		;i = R1
		LD R10, vet(R1)		;R10 = min = vet[0]
for:		DADDI R1, R1, 8		;i++
		BEQ R1, R7, endfor	;se i == LEN, fine del for
		DADDI R30, R30, -8	;decremento SP
		SD R10, (R30)		;PUSH MIN
		LD R5, vet(R1)		;R5 = vet[i]
		DADDI R30, R30, -8	;decremento SP
		SD R5, (R30)		;PUSH vet[i]
		JAL minimo		;chiamata a minimo()
		LD R6, (R30)		;POP in R6
		DADDI R30, R30, 8	;incremento SP
		BNE R5, R6, continue 	;non c'è un nuovo minimo
		DADD R10, R5, R0	;min = vet[i]
continue:	J for			;si ricomincia
endfor:		HALT			;FINE

minimo:		LD R21, (R30)		;POP 
		DADDI R30, R30, 8	;incremento SP
		LD R22, (R30)		;POP
		DADDI R30, R30, 8	;incremento SP
		SLT R25, R21, R22	;confronto
		DADDI R30, R30, -8	;decremento SP(da fare solo una volta)
		BEQZ R25, b			;il minore è b
		SD R21, (R30)		;ritorno a
		JR R31			;ritorno il controllo
b:		SD R22, (R30)		;ritorno b
		JR R31			;ritorno il controllo

		
		
