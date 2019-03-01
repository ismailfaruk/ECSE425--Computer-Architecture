; The program reads a vector of 10 positive integers and an integer
; positive, the vector flows and if the current element is equal or less
; of 20 then elevates it to the square, otherwise it subtracts the given number.
;main() 
;{
;	int i;
;	for(i=0; i<10; i++)
;		if(vet[i]<20 || pari(vet[i])))
;			vet[i]=vet[i]*vet[i];
;		else
;			vet[i]=vet[i]-num;
;}

;by Simona Ullo

	.data
vet:	.word 	23,3,4,25,2,40,8,9,12,24
num:	.word 	1
venti:	.word	20

	.code
	DADDI R1,R0,vet 	;R1=vet - indirizzo della variabile vet
	DADDI R2,R0,num		;R2=num - indirizzo della variabile num
	DSUB R3,R2,R1		;R3=num-vet - dimensione di vet
	DADDI R4,R0,0		;R4=0 - indice di vet
	LD R5,venti(R0)		;R5=Mem[venti] - 20 (valore del confronto)
	LD R6,num(R0)		;R6=Mem[num] - valore da sottrarre

loop:	LD R7,vet(R4)		;R7=Mem[vet+R4] - carica un elemento del vettore	
	SLTI R8,R7,20		;if(R7<20) R8=1 ...
	BNEZ R8,quad  		;... allora eleva al quadrato l'elemento del vettore
	ANDI R8,R7,1		;verifica se l'elemento del vettore è pari ...
	BEQZ R8,quad		;... in tal caso lo eleva al quadrato
	DSUB R7,R7,R6		;R7=R7-R6 sottrae num all'elemento del vettore
	DADD R29,R7,R0		;mette il valore in R29 per scriverlo in memoria
	J scrivi;		;salta per scrivere l'elemento modificato in memoria

quad:	DADD R30,R0,R7		;I parametro funzione - valore da elevare al quadrato
	JAL quadrato		;chiamata della funzione quadrato

scrivi:	SD R29,vet(R4)		;Mem[vet+R4]=R7 memorizza il valore modificato
	DADDI R4,R4,8		;R4++
	SLT R8,R4,R3		;if(R4<R3) R8=1 
	BNEZ R8,loop		;se ci sono ancora elementi nel vettore ripete il ciclo
	HALT
		
; FUNZIONE QUADRATO
; int quadrato (int num)
; {
;	int i;
;	for(i=0;i<num;i++)
;		num+=num;
;	return num;
; }
; R31 ritorno funzione, R30 = num ; R29 = valore di ritorno
quadrato: 
	DADDI R28,R0,0		;R28=0 - indice ciclo
	DADD R29,R0,R0		;R29=R30
ciclo:
	SLT R27,R28,R30		;if(R28<R29) R27=1
	BEQZ R27,ret		;ritorna al chiamante
	DADD R29,R29,R30	;R29+=R29 - somma R29 a sè stesso
	DADDI R28,R28,1		;R28++ - incrementa indice ciclo
	J ciclo			;cicla nuovamente
ret:	JR R31			;return

; f = 250MHz - cache unificata 256MB, blocchi da 8MB - cache separate da 128MB ciascuna, blocchi da 4MB 
; miss penalty (u) = 40 - mp(d) =20 - mp(is) = 30
; aumento prestazioni di un fattore 1,5 avendo mp=40

;2a) num_istruzioni = 657 , num_cicli = 950
;	CPI = cicli/istruzioni = 950/657 = 1,446
;	tCPU = cicli * T = cicli * (1/f) = 3,8microsec

;2b) cicli_r = cicli + total_demand_fetches + total_demand_misses * miss penalty = 
;	= 950 + 824 + 15*40 = 1774 + 600 = 2374
;	CPI = 2374/657 = 3,613
;	tCPU = 9,5microsec

;2c) cicli_r = cicli + ddm * misspenalty + idm * misspenalty =
;	= 950 + 24*20 + 30*30 = 950 + 480 + 900 = 2330
;	CPI = 2330/657 = 3,55
;	tCPU = 9,32microsec

;3) fm = 600 / 2374 = 0,25
;   fnm = 1774 / 2374 = 0,75
;   Per la legge di Amdhal
;	speedup_g = 1 / (fnm + fm/speedup_l)	
;	speedup_l = fm / ((1/speedup_g) - fnm) = 0,25 / ((1/1,5) - 0,75) = 
