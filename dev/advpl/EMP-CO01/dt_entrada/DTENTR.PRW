#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
TOMSA08 - 
*/
/*
+----------+-----------+----------+-------------------------+------+------------+
|Programa  | TOMSA08  | Autor | Luciano junior   		      |Data  |26/09/2024|
+----------+-----------+----------+-------------------------+------+------------+
| USO      | Especifico 													   	|
+-------------------------------------------------------------------------------+
|                  Documentacao Eletronica Totvs - Protheus Doc   			   	|
+-------------------------------------------------------------------------------+
|{Protheus.doc}	Registro das datas de prev.entrega e data de entrega das notas  |
| filtrando por data de emissao da nota                                        	|
| @author	Luciano 			                                               	|
| @since	26/09/2024	                                                       	|
| @return                                                                      	|
+----------+--------------------------------------------------------------------+
|           		ALTERACOES FEITAS DESDE A CRIACAO          					|
+----------+-----------+--------------------------------------------------------+
|Autor     | Data      | Descricao                                             	|
+----------+-----------+--------------------------------------------------------+
| Carlos   | linhas:   | Inclusão do campo XDTENTR o qual será gravado a data   |
| Batista  | 137, 165, | real de entrega.                                       |
|          | 204 e 363 |                                                        |
+----------+-----------+--------------------------------------------------------+
*/
User Function TOMSA10()

private oGeraTxt

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Registrar datas de entrega")
@ 02,10 TO 080,190
@ 10,018 Say " Rotina para informar ou alterar as datas de entrega das "
@ 18,018 Say "notas fiscais das cargas parametrizadas ou confirmar / "
@ 24,018 Say "alterar datas de previsão de entrega "
@ 32,018 Say "                                     "

@ 65,095 BMPBUTTON TYPE 05 ACTION Parametros()
@ 65,125 BMPBUTTON TYPE 17 ACTION Selecionar()
@ 65,155 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)

Activate Dialog oGeraTxt Centered

return 

Static Function Parametros()
local cPerg 	:= "TOMSA10"
local aRegs 	:= {}
local aHelpPor:={} , aHelpEng:={} , aHelpSpa:={}

xPutSx1(cPerg,"01","Emissao de: "  ,"cPerSpa","cPerEng","MV_CH7","D",TamSX3("F2_EMISSAO")[1],0,0,"G",""," ","","","MV_PAR01")
xPutSx1(cPerg,"02","Emissao Ate: " ,"cPerSpa","cPerEng","MV_CH7","D",TamSX3("F2_EMISSAO")[1],0,0,"G",""," ","","","MV_PAR02")

If !Pergunte(cPerg,.T.)
	Return
EndIf

Return

Static Function Selecionar()
if empty(mv_par01) .and. empty(mv_par02) 
	MsgStop("Favor informar os parâmetros de busca !","Parametrização não informada !")
else	
	Processa( {|lEnd| TOMSA08P(@lEnd) }, "Aguarde...", "Filtrando notas fiscais...",.T.)
endif

return .t.

Static Function TOMSA08P(lEnd)
local oColumn
local aCampos	:= {}
local aColumns	:= {}
local cArqTrb
local cIndice1 := ""
local nX, aColunas
local aTam
local lMarcar  := .F.
local aSeek   	:= {}
local nTotReg	:= nAtual := 0
local cQuery
private oBrowse
private aRotina:= Menudef()

aadd(aCampos,{"TR_OK"  	,"C",002,0})
aTam:= TamSX3("F2_FILIAL")
aadd(aCampos,{"TR_FILIAL","C",aTam[1],aTam[2]})
aTam:= TamSX3("F2_SERIE")
aadd(aCampos,{"TR_SERIE","C",aTam[1],aTam[2]})
aTam:= TamSX3("F2_DOC")
aadd(aCampos,{"TR_DOC"	,"C",aTam[1],aTam[2]})
aTam:= TamSX3("A1_NOME")
aadd(aCampos,{"TR_NOME"	,"C",aTam[1],aTam[2]})
aadd(aCampos,{"TR_EMISSAO"	,"D",010,0})
aadd(aCampos,{"TR_DTTRANS"	,"D",010,0})
aadd(aCampos,{"TR_XSUGENT "	,"D",010,0})
aadd(aCampos,{"TR_DTENTR"	,"D",010,0})

if (select("TRB") <> 0)
	dbselectArea("TRB")
	TRB->(dbCloseArea ())
endif

cArqTrb 	:= CriaTrab(aCampos,.T.)

cIndice1 := alltrim(CriaTrab(,.F.))
cIndice1 := left(cIndice1,5) + right(cIndice1,2) + "A"

if file(cIndice1+OrdBagExt())
	FErase(cIndice1+OrdBagExt())
endif

dbUseArea(.T.,,cArqTrb,"TRB",Nil,.F.)

IndRegua("TRB", cIndice1, "TR_DOC + TR_SERIE",,, "Indice 1")

dbClearIndex()

dbSetIndex(cIndice1+OrdBagExt())

// cQuery := "SELECT F2_FILIAL, F2_SERIE, F2_DOC,F2_CLIENTE,F2_EMISSAO,F2_DTTRANS,F2_XSUGENT,F2_DTENTR,A1_NOME "
// cQuery += CHR(13) + "FROM "+ RetSqlName("SF2") +" AS SF2 "
// cQuery += CHR(13) + "INNER JOIN " + RetSqlName("SA1") +" AS SA1 ON A1_FILIAL = ' ' AND A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA AND SA1.D_E_L_E_T_ <> '*' "  
// cQuery += CHR(13) + " WHERE "
// cQuery += CHR(13) + "SF2.D_E_L_E_T_ <> '*' "
// cQuery += CHR(13) + "AND SF2.F2_EMISSAO BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"' "
// cQuery += CHR(13) + "ORDER BY F2_DOC, F2_SERIE"

// Montagem da query com JOIN em SD2 e filtros adicionais
cQuery  := "SELECT DISTINCT SF2.F2_FILIAL,"
cQuery +=        " SF2.F2_SERIE,"
cQuery +=        " SF2.F2_DOC,"
cQuery +=        " SF2.F2_CLIENTE,"
cQuery +=        " SF2.F2_EMISSAO,"
cQuery +=        " SF2.F2_DTTRANS,"
cQuery +=        " SF2.F2_XSUGENT," // inclusão do novo campo na consulta sql
cQuery +=        " SF2.F2_DTENTR,"
cQuery +=		 " SF2.F2_XDTENTR,"
cQuery +=        " A1.A1_NOME"
cQuery +=  CHR(13) + "FROM " + RetSqlName("SF2") + " AS SF2"
cQuery +=  CHR(13) + "INNER JOIN " + RetSqlName("SA1") + " AS A1"
cQuery +=        " ON A1.A1_FILIAL = ' '"
cQuery +=        " AND A1.A1_COD    = SF2.F2_CLIENTE"
cQuery +=        " AND A1.A1_LOJA   = SF2.F2_LOJA"
cQuery +=        " AND A1.D_E_L_E_T_ <> '*'"
cQuery +=  CHR(13) + "INNER JOIN " + RetSqlName("SD2") + " AS SD2"
cQuery +=        " ON SD2.D2_FILIAL = SF2.F2_FILIAL"
cQuery +=        " AND SD2.D2_SERIE = SF2.F2_SERIE"
cQuery +=        " AND SD2.D2_DOC   = SF2.F2_DOC"
cQuery +=        " AND SD2.D_E_L_E_T_ <> '*'"
cQuery +=  CHR(13) + "WHERE SF2.D_E_L_E_T_        <> '*'"
cQuery +=  CHR(13) + "  AND SF2.F2_EMISSAO BETWEEN '" + Dtos(mv_par01) + "'"
cQuery +=        " AND '"         + Dtos(mv_par02) + "'"
cQuery +=  CHR(13) + "  AND SF2.F2_TIPO = 'N' "
cQuery +=  CHR(13) + "  AND SF2.F2_CLIENTE != '32780025'"
cQuery +=  CHR(13) + "  AND SD2.D2_COD != '228'"
cQuery +=  CHR(13) + "ORDER BY SF2.F2_DOC, SF2.F2_SERIE"


MEMOWRITE( "c:\query\TOMSA08.txt",cQuery)
TcQuery cQuery new alias "TMP01"
TcSetField("TMP01","F2_EMISSAO","D",10,00)
TcSetField("TMP01","F2_DTTRANS","D",10,00)
TcSetField("TMP01","F2_XSUGENT","D",10,00)
TcSetField("TMP01","F2_XDTENTR","D",10,00) // inclusão do novo campo nos logs
TcSetField("TMP01","F2_DTENTR","D",10,00)

if TMP01->(eof())
	if empty(strtran(mv_par01,",","")) .and. !empty(mv_par02)
		MsgStop("Não há notas fiscais pendentes de confirmação da data de entrega informada via EDI para o operador logístico informado na parametrização !","Sem notas fiscais!")
	elseif !empty(strtran(mv_par01,",","")) .and. !empty(mv_par02)
		MsgStop("Não há notas fiscais das cargas informadas ou pendentes de confirmação da data de entrega informada via EDI para o operador logístico informado na parametrização !","Sem notas fiscais!")
	elseif !empty(strtran(mv_par01,",","")) .and. empty(mv_par02)
		MsgStop("Não há notas fiscais das cargas informadas na parametrização !","Sem notas fiscais!")
	endif

	dbselectarea("TMP01")
	dbCloseArea("TMP01")
	return
endif

DbEval( {|| nTotReg++ })
ProcRegua(nTotReg)

TMP01->(dbgotop())
while TMP01->(!Eof())
		nAtual += 1

		IncProc("Aguarde... " +  str((nAtual/nTotReg) * 100,3) +' %')
		if lEnd
		   alert("CANCELADO PELO OPERADOR")
			Exit
		endif

	if RecLock("TRB", .T.)

		TRB->TR_OK      := "  "
		TRB->TR_FILIAL  := TMP01->F2_FILIAL
		TRB->TR_SERIE   := TMP01->F2_SERIE
		TRB->TR_DOC     := TMP01->F2_DOC
		TRB->TR_NOME    := TMP01->A1_NOME
		TRB->TR_EMISSAO := TMP01->F2_EMISSAO
		TRB->TR_DTTRANS := TMP01->F2_DTTRANS
		TRB->TR_XSUGENT := TMP01->F2_XSUGENT
		TRB->TR_DTENTR := TMP01->F2_XDTENTR
		/*
		if !Empty(TMP01->F2_DTENTR) .and. TMP01->F2_DTENTR > STOD("20260101") .and. Empty(TMP01->F2_XDTENTR)
			TRB->TR_DTENTR := TMP01->F2_DTENTR
		endif

		if !Empty(TMP01->F2_XDTENTR)
			TRB->TR_DTENTR := TMP01->F2_XDTENTR
		endif
		*/
		
		MsUnLock()
	endif

TMP01->(DbSkip())

enddo
dbselectarea("TMP01")
dbCloseArea("TMP01")

TRB->(DbGoTop())

if TRB->(!eof())
	
	aadd(aSeek,{"Número da nota fiscal"	,{{"","C",050,0,"Número da nota fiscal","@!"}} } )
 	
	oBrowse:= FWMarkBrowse():New()
	oBrowse:SetDescription("* * * CONFIRME O RECEBIMENTO DO CANHOTO (MARCANDO O REGISTRO) E CORRIJA, QUANDO NECESSÁRIO, AS DATAS DE ENTREGA * * *")
	oBrowse:SetAlias("TRB")
	oBrowse:SetFieldMark("TR_OK")
	oBrowse:oBrowse:SetDBFFilter(.F.)
	oBrowse:oBrowse:SetUseFilter(.F.)
	oBrowse:SetWalkThru(.F.)
	oBrowse:SetAmbiente(.F.)
	oBrowse:SetTemporary(.T.)
	oBrowse:oBrowse:SetSeek(.T.,aSeek)
	oBrowse:DisableDetails()
	oBrowse:SetAfterMark( { || TOMSA08EDIT()  } )

	aColunas:={	{"FL" 				,"TR_FILIAL" 	,"C",2,0,""},;
					{"Série"				,"TR_SERIE" 	,"C",TamSx3("F2_SERIE")[1],0,""},;
					{"Número Doc."		,"TR_DOC" 		,"C",TamSx3("F2_DOC")[1],0,""},;
					{"Cliente"			,"TR_NOME" 		,"C",TamSx3("A1_NOME")[1],0,""},;
					{"Emissão" 			,"TR_EMISSAO" 	,"D",10,0,""},;
					{"Saída Transp."	,"TR_DTTRANS" 	,"D",10,0,""},;
					{"Prev.Entrega"		,"TR_XSUGENT " 	,"D",10,0,""},;
					{"DT. Entrega"		,"TR_DTENTR" 	,"D",10,0,"",.T.}}

	oBrowse:SetFields(aColunas)
		
	oBrowse:AddButton("Confirmar datas de entrega das notas fiscais marcadas", { || MsgRun('Gravando confirmação...','Processando',{|| TOMSA08R() }) },,,, .F., 2 )
	
	oBrowse:bAllMark := { || oBrowse:Refresh(.T.)  }
	
	oBrowse:Activate()
	
	oBrowse:oBrowse:Setfocus()
else
	if empty(strtran(mv_par01,",","")) .and. !empty(mv_par02)
		MsgStop("Não há notas fiscais pendentes de confirmação da data de entrega informada via EDI para o operador logístico informado na parametrização !","Sem notas fiscais!")
	elseif !empty(strtran(mv_par01,",","")) .and. !empty(mv_par02)
		MsgStop("Não há notas fiscais das cargas informadas ou pendentes de confirmação da data de entrega informada via EDI para o operador logístico informado na parametrização !","Sem notas fiscais!")
	elseif !empty(strtran(mv_par01,",","")) .and. empty(mv_par02)
		MsgStop("Não há notas fiscais das cargas informadas na parametrização !","Sem notas fiscais!")
	endif
	return
endif

if !Empty(cArqTrb)
	TRB->(DbCloseArea())
	Ferase(cArqTrb+GetDBExtension())
	FErase(cIndice1+OrdBagExt())
	cArqTrb := ""
endif

return(.T.)

// Retirando opções padrão de menu (incluir,alterar...)
Static Function MenuDef()
local aRot := {}
local lOk := .T.
return(aClone(aRot))

// Edita a data de entrega  
Static Function TOMSA08EDIT()
local aParamBox := {}
local aRet := {}
local aMvPar := {}
local nMv

// salvando grupo de perguntas que possa existir na rotina 
for nMv := 1 To 40
	aadd( aMvPar, &( "MV_PAR" + strzero( nMv, 2, 0 ) ) )
next

aadd(aParamBox,{9,"Nota fiscal - Série: "+ TRB->TR_DOC +" - "+ TRB->TR_SERIE,100,50,.T.})
aadd(aParamBox,{1,"Saída Transp." , TRB->TR_DTTRANS	,"" ,".T.",,".T.",50,.F.})
aadd(aParamBox,{1,"Prev de Entrega", TRB->TR_XSUGENT,"" ,".T.",,".T.",50,.F.})
aadd(aParamBox,{1,"Data da entrega", TRB->TR_DTENTR	,"" ,".T.",,".T.",50,.F.})

if !( ParamBox(aParamBox,"Data de entrega",aRet,nil,nil,.T.,50,600,nil,nil,.F.) )
	return NIL
endif

RecLock("TRB",.F.)
replace TR_DTTRANS with aRet[2]
replace TR_XSUGENT with aRet[3]
replace TR_DTENTR with aRet[4]
MsUnLock()

// recuperando grupo de perguntas que possa existir na rotina 
for nMv := 1 to len( aMvPar )
    &( "MV_PAR" + strzero( nMv, 2, 0 ) ) := aMvPar[ nMv ]
next

return

// Gravar a confirmação dos registros marcados  
Static Function TOMSA08R()
local nCont := 0

if !(MsgYesNo("Confirma datas de entrega das notas fiscais marcadas ?","Confirma dados ?"))
	MsgStop("Cancelada confirmação!","Processo abortado!")
	return 
endif 

TRB->( DbSetOrder(1) )
TRB->( DbGoTop() )

while !TRB->(eof())

		if empty(TRB->TR_OK) //Se diferente de vazio, é porque foi marcado
			TRB->(dbskip())
			loop
		endif
		
		if lEnd
			MsgStop("CANCELADO PELO OPERADOR","Rotina cancelada!")
			Exit
		endif

		BEGIN TRANSACTION

			lOk := .T.

			dbselectarea("SF2")
			dbsetorder(1)
			if SF2->(dbseek(TRB->TR_FILIAL + TRB->TR_DOC + TRB->TR_SERIE))

				if !empty(TRB->TR_DTENTR) .and. TRB->TR_DTENTR < SF2->F2_EMISSAO
					
					MsgStop("NÃO PERMITIDA A GRAVAÇÃO DA DATA DE ENTREGA DA NOTA FISCAL "+ alltrim(SF2->F2_DOC) +". MOTIVO: DATA DE ENTREGA < DATA DE EMISSAO DA NOTA FISCAL!","Data de entrega inválida!")
					lOk := .F.					
				
				//elseif TRB->TR_DTENTR != SF2->F2_DTENTR
				Else

					RecLock("SF2",.F.)
					if !empty(TRB->TR_DTTRANS) 
						replace F2_DTTRANS  with TRB->TR_DTTRANS
					endif
					if !empty(TRB->TR_XSUGENT) 
						replace F2_XSUGENT  with TRB->TR_XSUGENT
					endif
					if !empty(TRB->TR_DTENTR) 
						replace F2_XDTENTR   with TRB->TR_DTENTR //alterado F2_DTENTR para F2_XDTENTR
					endif

					MsUnLock()
					nCont++
				endif
			else
				MsgStop("NOTA FISCAL "+ TRB->TR_FILIAL +' '+ TRB->TR_DOC +' '+ TRB->TR_SERIE +" NAO LOCALIZADA ! VERIFIQUE O QUE DIGITOU.","NOTA FISCAL NAO LOCALIZADA!")
				lOk := .F.			
			endif
		
		END TRANSACTION
				
		TRB->(dbskip())			
enddo

if nCont == 0
	MsgAlert("Não foi confirmado nenhum recebimento e data de entrega.","Atenção")
else
	MsgBox("Registros atualizados : "+ str(nCont,5) )
endif

TRB->(dbgotop())
oBrowse:Refresh(.T.)

return



//###########################################
//Criar perguntas na SX1 
// Funcao substituta do PutSx1 (que foi descontinuada no P12)
//###########################################
Static Function xPutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,; 
     cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,; 
     cF3, cGrpSxg,cPyme,; 
     cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,; 
     cDef02,cDefSpa2,cDefEng2,; 
     cDef03,cDefSpa3,cDefEng3,; 
     cDef04,cDefSpa4,cDefEng4,; 
     cDef05,cDefSpa5,cDefEng5,; 
     aHelpPor,aHelpEng,aHelpSpa,cHelp) 

LOCAL aArea := GetArea() 
Local cKey 
Local lPort := .f. 
Local lSpa := .f. 
Local lIngl := .f. 

cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "." 

cPyme    := Iif( cPyme           == Nil, " ", cPyme          ) 
cF3      := Iif( cF3           == NIl, " ", cF3          ) 
cGrpSxg := Iif( cGrpSxg     == Nil, " ", cGrpSxg     ) 
cCnt01   := Iif( cCnt01          == Nil, "" , cCnt01      ) 
cHelp      := Iif( cHelp          == Nil, "" , cHelp          ) 

dbSelectArea( "SX1" ) 
dbSetOrder( 1 ) 

// Ajusta o tamanho do grupo. Ajuste emergencial para validaÃ§Ã£o dos fontes. 
// RFC - 15/03/2007 
cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " ) 

If !( DbSeek( cGrupo + cOrdem )) 

    cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt) 
     cPerSpa     := If(! "?" $ cPerSpa .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa) 
     cPerEng     := If(! "?" $ cPerEng .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng) 

     Reclock( "SX1" , .T. ) 

     Replace X1_GRUPO   With cGrupo 
     Replace X1_ORDEM   With cOrdem 
     Replace X1_PERGUNT With cPergunt 
     Replace X1_PERSPA With cPerSpa 
     Replace X1_PERENG With cPerEng 
     Replace X1_VARIAVL With cVar 
     Replace X1_TIPO    With cTipo 
     Replace X1_TAMANHO With nTamanho 
     Replace X1_DECIMAL With nDecimal 
     Replace X1_PRESEL With nPresel 
     Replace X1_GSC     With cGSC 
     Replace X1_VALID   With cValid 

     Replace X1_VAR01   With cVar01 

     Replace X1_F3      With cF3 
     Replace X1_GRPSXG With cGrpSxg 

     If Fieldpos("X1_PYME") > 0 
          If cPyme != Nil 
               Replace X1_PYME With cPyme 
          Endif 
     Endif 

     Replace X1_CNT01   With cCnt01 
     If cGSC == "C"               // Mult Escolha 
          Replace X1_DEF01   With cDef01 
          Replace X1_DEFSPA1 With cDefSpa1 
          Replace X1_DEFENG1 With cDefEng1 

          Replace X1_DEF02   With cDef02 
          Replace X1_DEFSPA2 With cDefSpa2 
          Replace X1_DEFENG2 With cDefEng2 

          Replace X1_DEF03   With cDef03 
          Replace X1_DEFSPA3 With cDefSpa3 
          Replace X1_DEFENG3 With cDefEng3 

          Replace X1_DEF04   With cDef04 
          Replace X1_DEFSPA4 With cDefSpa4 
          Replace X1_DEFENG4 With cDefEng4 

          Replace X1_DEF05   With cDef05 
          Replace X1_DEFSPA5 With cDefSpa5 
          Replace X1_DEFENG5 With cDefEng5 
     Endif 

     Replace X1_HELP With cHelp 

     PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa) 

     MsUnlock() 
Else 

   lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT) 
   lSpa := ! "?" $ X1_PERSPA .And. ! Empty(SX1->X1_PERSPA) 
   lIngl := ! "?" $ X1_PERENG .And. ! Empty(SX1->X1_PERENG) 

   If lPort .Or. lSpa .Or. lIngl 
          RecLock("SX1",.F.) 
          If lPort 
        SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?" 
          EndIf 
          If lSpa 
               SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?" 
          EndIf 
          If lIngl 
               SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?" 
          EndIf 
          SX1->(MsUnLock()) 
     EndIf 
Endif 

RestArea( aArea ) 

Return
