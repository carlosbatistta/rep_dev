#include "Protheus.Ch"
#INCLUDE "topconn.ch"

#DEFINE __CONNECT 'TOPCONN'  
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FTRANSFIL³ Autor ³ DIOGENES MARINHO      ³ Data ³ 23/05/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ROTINA INCLUI DE FORMA AUTOMATICA AS NOTAS FISCAIS DE ENTRA ³±±
±±³          ³DA ENTRE FILIAIS                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CASAS BANDEIRANTES                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function fTransFil

Local aCabec := {}
Local aItens := {}
Local __cSQL   
		
PRIVATE lMsErroAuto := .F.

If pergunte("TRSFIL")
	
	If mv_par06 == cFilAnt
		
		dbSelectArea("SM0")
		dbSeek(cEmpAnt+mv_par01)
		cCNPJCli := SM0->M0_CGC
		
		cQuery := " SELECT * FROM  " + RetSqlName("SF2")
		cQuery += " WHERE F2_FILIAL = '"+mv_par01+"' AND "
		cQuery += " F2_DOC = '"+mv_par02+"' AND "
		cQuery += " F2_SERIE = '"+mv_par03+"' AND "
		cQuery += " D_E_L_E_T_ = ' ' "
		
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMP1', .F., .T.)
		
		dbSelectArea("TMP1")
		dbGoTop()
		
		
		//	cCNPJCli := SM0->M0_CGC //Posicione("SA1",1,xFilial("SA1")+TMP1->F2_CLIENTE+TMP1->F2_LOJA,"A1_CGC")
		
		cCodFor := Posicione("SA2",3,xFilial("SA2")+cCNPJCli,"A2_COD+A2_LOJA")
		aadd(aCabec,{"F1_FILIAL"   ,cFilAnt })		
		aadd(aCabec,{"F1_FILORI"   ,mv_par01 })				
		aadd(aCabec,{"F1_TIPO"   ,"N"})
		aadd(aCabec,{"F1_FORMUL" ,"N"})
		aadd(aCabec,{"F1_DOC"    ,mv_par02})
		aadd(aCabec,{"F1_SERIE"  ,mv_par03})
		aadd(aCabec,{"F1_EMISSAO",STOD(TMP1->F2_EMISSAO)})
		aadd(aCabec,{"F1_FORNECE",SubStr(cCodFor,1,6)})
		aadd(aCabec,{"F1_LOJA"   ,SubStr(cCodFor,7,2)})
		aadd(aCabec,{"F1_ESPECIE","SPED"})
		aadd(aCabec,{"F1_DTDIGIT",mv_par05})
	    aadd(aCabec,{"F1_CHVNFE",mv_par08})
		
		dbSelectArea("TMP1")
		dbCloseArea()
		
		cQuery := " SELECT * FROM  " + RetSqlName("SD2")
		cQuery += " WHERE D2_FILIAL = '"+mv_par01+"' AND "
		cQuery += " D2_DOC = '"+mv_par02+"' AND "
		cQuery += " D2_SERIE = '"+mv_par03+"' AND "
		cQuery += " D_E_L_E_T_ = ' ' "
		
		
		__cSQL := GETNEXTALIAS() 
		dbUseArea(.T.,__CONNECT,TcGenQry(,,cQuery),__cSQL,.T.,.T.)
				    
	IF (__cSQL)->(Eof())
	   MsgAlert("Nota : " + MV_PAR02 + " não encontrada","CBAND")
	   		(__cSQL)->(dbCloseArea())
	EndIF		
	While !(__cSQL)->(Eof())
	
		  // IF ALLTRIM((__cSQL)->D2_DOC) == ALLTRIM(MV_PAR02) .AND. ALLTRIM((__cSQL)->D2_SERIE) == ALLTRIM(MV_PAR03)
				aLinha := {}
				aadd(aLinha,{"D1_FILIAL"   ,cFilAnt })						
				aadd(aLinha,{"D1_COD"  ,(__cSQL)->D2_COD,Nil})
				aadd(aLinha,{"D1_QUANT",(__cSQL)->D2_QUANT,Nil})
				aadd(aLinha,{"D1_VUNIT",(__cSQL)->D2_PRCVEN,Nil})
				aadd(aLinha,{"D1_TOTAL",(__cSQL)->D2_TOTAL,Nil})
				aadd(aLinha,{"D1_TES"  ,mv_par04,Nil})   
				aadd(aLinha,{"D1_LOCAL",mv_par07,Nil})
				aadd(aItens,aLinha)
		  //	EndIF
	 (__cSQL)->(DBSkip())	
	Loop
	EndDo
		
 
		(__cSQL)->(dbCloseArea())
		
		MSExecAuto({|x,y| mata103(x,y)},aCabec,aItens)
		
		If !lMsErroAuto
			Alert("Nota Fiscal foi incluida com sucesso")
		Else
			Alert("Erro na inclusao!")
			MostraErro()
		EndIf
		
	Else
		
		Alert("A filial logado ( "+cFilAnt+" ) não pode ser diferente da filial destino ( "+mv_par06+" ) informado no parametro.")
		
	EndIf
	
EndIf

Return()
