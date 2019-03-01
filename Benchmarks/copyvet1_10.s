;The program reads a vector of 10 integer elements and copies it in a second
;vector only if the current element is between 1 and 10 otherwise it sets it to 0
;main()
;{
;	int i;
;	for(i=0;i<len(vet);i++)
;		if(vet[i]>1 && vet[i]<10)
;			vet2[i]=vet[i];
;		else
;			vet[i]=0;
;}

;by Simona Ullo

	.data
vet1:	.word	2,3,1,4,11,6,20,8,34,6
vet2: 	.word 	0,0,0,0,0,0,0,0,0,0,0

	.code
	DADDI R1,R0,vet1	;R1=vet1 indirizzo di vet1
	DADDI R2,R0,vet2	;R2=vet2 indirizzo di vet2
	DSUB R3,R2,R1		;R3=dim(vet1) dimensione di vet1 in byte (80byte)
	DADDI R4,R0,0		;R4=0 inizializza indice vet1
	DADDI R5,R0,0		;R5=0 inizializza indice vet2
loop:	LD R8,vet1(R4)		;R8=Mem[vet1+R4]
	SLTI R9,R8,1		;if(vet1[i]<1) R9=1 ... se l'elemento è maggiore di 1
	BEQZ R9,compare		;... allora confronta se è anche minore di 10
zero:	SD R0,vet1(R4)		;Mem[vet+R4]=0 pone a 0 l'elemento di vet1
control:
	DADDI R4,R4,8		;R4++ incrementa indice vet1
	SLT R9,R4,R3		;if(i<len(vet1)) R9=1 controlla se è stato scandito tutto vet1
	BNEZ R9,loop		;se ci sono ancora elementi cicla nuovamente
	HALT
compare:
	SLTI R9,R8,10		;if(vet1[i]<10) R9=1 ... se l'elemento è minore di 10
	BEQZ R9,zero		;... dev'essere copiato in vet2
	SD R8,vet2(R5)		;Mem[vet2+R5]=R9 copia l'elemento di vet1 in vet2
	DADDI R5,R5,8		;R5++ incrementa indice vet2
	J control			

; f = 250MHz - cache unificata 256MB, blocchi da 8MB - cache separate da 128MB ciascuna, blocchi da 4MB 
; miss penalty (u) = 40 - mp(d) =20 - mp(is) = 30
; aumento prestazioni di un fattore 2 avendo mp=40

;2a) cicli = 183 istr = 110
; 	CPI = cicli/istr = 183/110 = 1,664
;	tCPU = cicli * T = 732ns

;2b) cicli_r = cicli + tdf + tdm * mp = 183 + 159 + 17*40 = 342 + 680 = 1022
;	CPI = cicli_r/istr = 1022/110 = 9,29
;	tCPU = cicli_r * T = 4088ns

;2c) cicli_r = cicli + ddm * mp(d) + idm * mp(i) = 183 + 34*20 + 19*30 = 1433
;	CPI = cicli_R/istr = 13,03
;	tcPU = 5732ns

;3) fm = 680/1022 = 0.66
;   fnm = 342/1022 = 0.34
;	sp_locale = fm / ((1/sp_globale) - fnm) =  0.66 / ((1/2) - 0.34) = 0.66/0.16 = 4,125
;	mp_new = miss_p / sp_locale = 9.7
