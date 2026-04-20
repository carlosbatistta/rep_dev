#INCLUDE "RWMAKE.CH"

/*/{Protheus.doc} M310CABEC
Ponto de entrada da rotina MATA310 - Transferência entre Filiais. Executada após a montagem do array aCabec antes das chamadas das rotinas automáticas que 
irão gerar o cabeçalho do pedido de vendas, do documento de entrada ou da fatura de entrada (localizado). É utilizado para permitir que o usuário manipule 
o array aCabec que contém os itens do cabeçalho do pedido de vendas, documento de entrada ou fatura de entrada. É passado um parâmetro para identificar a 
rotina a ser executada após o ponto de entrada.
@author Carlos Batista
@since 28/11/2025
@version 1.0
/*/
User Function M310CABEC()
local cProg	:= ParamIXB[1]
local aCabec	:= ParamIXB[2]
local nPos  	:= 0
local aPerg 	:= {}
local aRet  	:= {}

if cProg == "MATA410"

   nPos:= ascan(aCabec,{|x| x[1] == 'C5_FORMAPG' })
   
   if nPos > 0
     	aCabec[nPos,02] := "NGF"
   else
		aadd(aCabec,{"C5_FORMAPG","NGF",NIL}) 
	endif

	aadd(aPerg,{1,"Código do transportador",space(TamSx3("A4_COD")[01]),"","","SA4","",0,.T.})
	
	while !( ParamBox(aPerg,"Parâmetro obrigatório (M310CABEC())",aRet) )
		MsgStop("É obrigatório informar o código do transportador!", "Informe o transportador") 
	enddo
	
   nPos:= ascan(aCabec,{|x| x[1] == 'C5_TRANSP' })
   
   if nPos > 0
     	aCabec[nPos,02] := aRet[1]
   else
		aadd(aCabec,{"C5_TRANSP",aRet[1],NIL}) 
	endif

endif

return aCabec
