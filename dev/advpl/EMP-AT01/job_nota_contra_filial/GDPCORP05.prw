
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#include "rwmake.ch"

//!####################################################################
//! Função: GERANOTA Criado por: GAMADEVBR 20/04/2022
//! Descrição: Gravação da Nota de Saida com base no pedido gerado com na nota de entrada
//!####################################################################
User Function GDNFUNFAT()
	@ 0,0 to 300,300 Dialog oDlg Title "5-Gera NF de Saída na Unidade de Faturamento"
	@ 105,10 BmpButton Type 1 Action	Processa( {|| GERANOTA() } )
	@ 105,60 BmpButton Type 2 Action Close(oDlg)
	ACTIVATE DIALOG oDlg CENTER
return nil

Static Function GERANOTA()
Local aCabs 	:=	{}	
Local aItens	:=	{}	
Local aStruSF2 	:= 	{}	
Local aStruSD2 	:= 	{}	
Local nX		:=	1	
Local aDocOri	:=	{}
Local nItemNF   := 1
Local bFiscalSF2:= {|| .T.}
Local bFiscalSD2:= {|| .T.}
Local cNF       := ""	
Local cDoc 	   	:= ""
Local cSerie    := "3  "
Local cTipoNF   := "N"
Local dData := DATE()
Local cData := DTOS(dData)

// Local nP
Local cSvFilAnt := cFilAnt

PRIVATE lMsErroAuto := .F.

    cQtdePED := ""
    cQtdePED += "SELECT COUNT(*) AS PEDIDOS, C5. C5_NUM, C5.R_E_C_N_O_ AS RECNO"
    cQtdePED += " FROM " + RetSqlName("SC5") + " AS C5"
    cQtdePED += " WHERE C5.D_E_L_E_T_ <> '*' AND"
    cQtdePED += " C5.C5_XCONSOL = 'S' AND" 
    cQtdePED += " C5.C5_XNFSAI2 = 'N'"
    cQtdePED += " GROUP BY C5. C5_NUM, C5.R_E_C_N_O_"
    cQtdePED := ChangeQuery(cQtdePED)
    AliasQtde := CriaTrab(,.F.)
    DbUseArea(.T., "TOPCONN", TCGenQry(,,cQtdePED), AliasQtde, .F., .T.)
    // SELECT COUNT(*) AS PEDIDOS, C5.C5_NUM FROM SC5010 AS C5 WHERE  C5.D_E_L_E_T_ <> '*' AND C5.C5_XCONSOL = 'S' AND C5.C5_XNFSAI2 = 'N' GROUP BY C5.C5_NUM
    // Alert(cValToChar((AliasQtde)->NOTAS) + " Notas de saidas para gerar")

    // For nP := 1 To (AliasQtde)->PEDIDOS
    While !((AliasQtde))->(Eof())
        cQryC5 := ""
        cQryC5 += "SELECT C5.C5_FILIAL AS 'C5FILIAL', C5.C5_NUM AS 'C5NUM', C5.C5_CLIENTE AS 'C5CLIENTE', C5.C5_TIPOCLI AS 'C5TIPOCLI', C5.C5_LOJACLI AS 'C5LOJACLI',"
        cQryC5 += " C5.C5_LOJAENT AS 'C5LOJAENT', C5.C5_CONDPAG AS 'C5CONDPAG', C5.C5_TABELA AS 'C5TABELA', C5.C5_NATUREZ AS 'C5NATUREZ',"
        cQryC5 += " C5.C5_XUNDFAT AS 'C5XUNDFAT', C5.C5_XFILFAT AS 'C5XFILFAT',"
        cQryC5 += " C5.R_E_C_N_O_ AS 'C5RECNO'"
        cQryC5 += " FROM " + RetSqlName("SC5") + " AS C5"
        cQryC5 += " WHERE C5.D_E_L_E_T_ <> '*' AND"
        cQryC5 += " C5.C5_XCONSOL = 'S' AND"
        cQryC5 += " C5.C5_XNFSAI2 = 'N' AND"
        cQryC5 += " C5.C5_NOTA = '' AND"
        cQryC5 += " C5.C5_SERIE = '' AND"
        cQryC5 += " C5.R_E_C_N_O_ = " + cValtoChar((AliasQtde)->RECNO)
        cQryC5 := ChangeQuery(cQryC5) 
        AliasC5 := CriaTrab(,.F.)
        DbUseArea(.T., "TOPCONN", TCGenQry(,,cQryC5), AliasC5, .F., .T.)
        // SELECT C5.C5_FILIAL AS 'C5FILIAL',C5.C5_NUM AS 'C5NUM',C5.C5_CLIENTE AS 'C5CLIENTE',C5.C5_TIPOCLI AS 'C5TIPOCLI',C5.C5_LOJACLI AS 'C5LOJACLI',C5.C5_LOJAENT AS 'C5LOJAENT',C5.C5_CONDPAG AS 'C5CONDPAG',C5.C5_TABELA AS 'C5TABELA',C5.C5_NATUREZ AS 'C5NATUREZ',C5.C5_XUNDFAT AS 'C5XUNDFAT',C5.C5_XFILFAT AS 'C5XFILFAT',C5.R_E_C_N_O_ AS 'C5RECNO' FROM SC5010 AS C5 WHERE  C5.D_E_L_E_T_ <> '*' AND C5.C5_XCONSOL = 'S' AND C5.C5_XNFSAI2 = 'N' AND C5.C5_NOTA = ' ' AND C5.C5_SERIE = ' '

        If !(AliasC5)->(Eof())
        

            _cFilial    := (AliasC5)->C5FILIAL
            _cPedido    := (AliasC5)->C5NUM
            _cCliente   := (AliasC5)->C5CLIENTE
            _cLojaCli   := (AliasC5)->C5LOJACLI
            _cTipoCli   := (AliasC5)->C5TIPOCLI
            _cLojaEnt   := (AliasC5)->C5LOJAENT
            _cUnidFat   := (AliasC5)->C5XUNDFAT
            _cFilFat    := (AliasC5)->C5XFILFAT
            _nC5Recno   := (AliasC5)->C5RECNO
            cFilAnt     := _cUnidFat //! seta a unidade de faturamento

            cQryC6 := ""
            cQryC6 += "SELECT DISTINCT"
            cQryC6 += " C6.C6_FILIAL AS 'C6FILIAL', C6_NUM AS 'C6NUM', C6.C6_ITEM AS 'C6ITEM', C6.C6_PRODUTO AS 'C6PRODUTO', C6.C6_LOCAL AS 'C6LOCAL', C6.C6_TES AS 'C6TES', C6.R_E_C_N_O_ AS 'C6RECNO',"
            cQryC6 += " C6.C6_ITEM AS 'C6ITEM', C6.C6_QTDVEN AS 'C6QTDVEN', C6.C6_PRCVEN AS 'C6PRCVEN', C6.C6_VALOR AS 'C6VALOR', C9.C9_BLEST AS 'C9BLEST', C9.C9_BLOQUEI AS 'C9BLOQUEI'"
            cQryC6 += " FROM " + RetSqlName("SC6") + " AS C6"
            cQryC6 += " INNER JOIN " + RetSqlName("SC9") + " AS C9 ON C9.C9_PRODUTO = C6.C6_PRODUTO AND C9.C9_FILIAL = C6.C6_FILIAL AND C9.C9_PEDIDO = C6.C6_NUM AND C9.C9_ITEM = C6.C6_ITEM"
            cQryC6 += " WHERE C6.D_E_L_E_T_ <> '*' AND C6.C6_FILIAL = '"+ _cFilial +"'AND C6.C6_NUM = '" + _cPedido + "' AND C6.C6_CLI = '" + _cCliente + "' AND C6.C6_LOJA = '" + _cLojaCli + "'"
            cQryC6 += " AND C9.C9_BLEST = '' AND C9.C9_BLOQUEI = '' AND C9.D_E_L_E_T_ <> '*'"
            cQryC6 := ChangeQuery(cQryC6)
            Aliasc6 := CriaTrab(,.F.)
            DbUseArea(.T., "TOPCONN", TCGenQry(,,cQryC6), Aliasc6, .F., .T.)
            // IF ((Aliasc6))->(Eof())

            // ENDIF

            //Montagem do cabeçalho do Documento Fiscal
            aStruSF2 	:= 	SF2->(dbStruct())	
            nF2FILIAL 	:= Ascan(aStruSF2,{|x| AllTrim(x[1]) == "F2_FILIAL"})	
            nF2TIPO 	:= Ascan(aStruSF2,{|x| AllTrim(x[1]) == "F2_TIPO"})	
            nF2DOC 		:= Ascan(aStruSF2,{|x| AllTrim(x[1]) == "F2_DOC"})	
            nF2SERIE 	:= Ascan(aStruSF2,{|x| AllTrim(x[1]) == "F2_SERIE"})	
            nF2EMISSAO 	:= Ascan(aStruSF2,{|x| AllTrim(x[1]) == "F2_EMISSAO"})	
            nF2CLIENTE 	:= Ascan(aStruSF2,{|x| AllTrim(x[1]) == "F2_CLIENTE"})
            nF2LOJA 	:= Ascan(aStruSF2,{|x| AllTrim(x[1]) == "F2_LOJA"})
            nF2CLIENT   := Ascan(aStruSF2,{|x| AllTrim(x[1]) == "F2_CLIENT"})
            nF2LOJENT 	:= Ascan(aStruSF2,{|x| AllTrim(x[1]) == "F2_LOJENT"})
            nF2TIPOCLI  := Ascan(aStruSF2,{|x| AllTrim(x[1]) == "F2_TIPOCLI"})
            nF2COND 	:= Ascan(aStruSF2,{|x| AllTrim(x[1]) == "F2_COND"})	
            nF2DTDIGIT 	:= Ascan(aStruSF2,{|x| AllTrim(x[1]) == "F2_DTDIGIT"})	
            nF2EST 		:= Ascan(aStruSF2,{|x| AllTrim(x[1]) == "F2_EST"})
            nF2UFORIG   := Ascan(aStruSF2,{|x| AllTrim(x[1]) == "F2_UFORIG"})
            nF2UFDEST   := Ascan(aStruSF2,{|x| AllTrim(x[1]) == "F2_UFDEST"})	
            
            nF2XNFENT2 	:= Ascan(aStruSF2,{|x| AllTrim(x[1]) == "F2_XNFENT2"}) // Já Gerou NF Entrada na Filial de Faturamento?
            nF2XCONSOL 	:= Ascan(aStruSF2,{|x| AllTrim(x[1]) == "F2_XCONSOL"})
            nF2XPEDCON 	:= Ascan(aStruSF2,{|x| AllTrim(x[1]) == "F2_XPEDCON"})
            nF2XUNDFAT 	:= Ascan(aStruSF2,{|x| AllTrim(x[1]) == "F2_XUNDFAT"})
            nF2XFILFAT 	:= Ascan(aStruSF2,{|x| AllTrim(x[1]) == "F2_XFILFAT"})

            For nX := 1 To Len(aStruSF2)
                If aStruSF2[nX][2] $ "C/M"
                    Aadd(aCabs,"")
                ElseIf aStruSF2[nX][2] == "N"
                    Aadd(aCabs,0)
                ElseIf aStruSF2[nX][2] == "D"
                    Aadd(aCabs,CtoD("  /  /  "))
                ElseIf aStruSF2[nX][2] == "L"
                    Aadd(aCabs,.F.)
                EndIf
            Next nX

            dbSelectArea("SA1")
            dbSetOrder(1)
            dbSeek(xFilial("SA1") + (AliasC5)->C5CLIENTE + (AliasC5)->C5LOJACLI)

            aCabs[nF2FILIAL]	:= xFilial("SF2")
            aCabs[nF2TIPO]		:= cTipoNF
            aCabs[nF2DOC]		:= cDoc
            aCabs[nF2SERIE]		:= cSerie
            aCabs[nF2EMISSAO]	:= dDataBase
            aCabs[nF2CLIENTE]	:= (AliasC5)->C5CLIENTE
            aCabs[nF2LOJA]		:= (AliasC5)->C5LOJACLI
            aCabs[nF2CLIENT]	:= (AliasC5)->C5CLIENTE
            aCabs[nF2LOJENT]	:= (AliasC5)->C5LOJAENT
            aCabs[nF2TIPOCLI]   := (AliasC5)->C5TIPOCLI
            aCabs[nF2COND]		:= (AliasC5)->C5CONDPAG
            aCabs[nF2DTDIGIT]	:= dDataBase
            aCabs[nF2EST]		:= SA1->A1_EST
            aCabs[nF2UFORIG]	:= SA1->A1_EST
            aCabs[nF2UFDEST]	:= SA1->A1_EST

            aCabs[nF2XNFENT2] 	:= 'N' // Já Gerou NF Entrada na Filial de Faturamento?
            aCabs[nF2XCONSOL] 	:= 'S'
            aCabs[nF2XPEDCON] 	:= _cPedido
            aCabs[nF2XUNDFAT] 	:= _cUnidFat
            aCabs[nF2XFILFAT] 	:= _cFilFat

             //Montagem dos itens do Documento Fiscal
            aStruSD2 	:= 	SD2->(dbStruct())           
            nD2FILIAL 	:= Ascan(aStruSD2,{|x| AllTrim(x[1]) == "D2_FILIAL"})
            nD2DOC 		:= Ascan(aStruSD2,{|x| AllTrim(x[1]) == "D2_DOC"})
            nD2SERIE 	:= Ascan(aStruSD2,{|x| AllTrim(x[1]) == "D2_SERIE"})
            nD2CLIENTE 	:= Ascan(aStruSD2,{|x| AllTrim(x[1]) == "D2_CLIENTE"})
            nD2LOJA 	:= Ascan(aStruSD2,{|x| AllTrim(x[1]) == "D2_LOJA"})
            nD2EMISSAO 	:= Ascan(aStruSD2,{|x| AllTrim(x[1]) == "D2_EMISSAO"})
            nD2TIPO 	:= Ascan(aStruSD2,{|x| AllTrim(x[1]) == "D2_TIPO"})
            nD2ITEM 	:= Ascan(aStruSD2,{|x| AllTrim(x[1]) == "D2_ITEM"})
            nD2CF 		:= Ascan(aStruSD2,{|x| AllTrim(x[1]) == "D2_CF"})
            nD2COD 		:= Ascan(aStruSD2,{|x| AllTrim(x[1]) == "D2_COD"})
            nD2UM 		:= Ascan(aStruSD2,{|x| AllTrim(x[1]) == "D2_UM"})
            nD2QUANT 	:= Ascan(aStruSD2,{|x| AllTrim(x[1]) == "D2_QUANT"})
            nD2PRCVEN 	:= Ascan(aStruSD2,{|x| AllTrim(x[1]) == "D2_PRCVEN"})
            nD2PRUNIT 	:= Ascan(aStruSD2,{|x| AllTrim(x[1]) == "D2_PRUNIT"})
            nD2TOTAL 	:= Ascan(aStruSD2,{|x| AllTrim(x[1]) == "D2_TOTAL"})
            nD2LOCAL 	:= Ascan(aStruSD2,{|x| AllTrim(x[1]) == "D2_LOCAL"})
            nD2TES	 	:= Ascan(aStruSD2,{|x| AllTrim(x[1]) == "D2_TES"})
            nD2CONTA	:= Ascan(aStruSD2,{|x| AllTrim(x[1]) == "D2_CONTA"})

            aItens	:=	{}
            nItemNF := 1
            While !((Aliasc6))->(Eof())
                aAdd(aItens, {})
                // nPos := Len(aItens)

                For nX := 1 To Len(aStruSD2)
                    If	aStruSD2[nX][2]$"C/M"
                        aAdd(aItens[nItemNF],"")
                    ElseIf aStruSD2[nX][2]=="D"
                        aAdd(aItens[nItemNF],CToD(""))
                    ElseIf aStruSD2[nX][2]=="N"
                        aAdd(aItens[nItemNF],0)
                    ElseIf aStruSD2[nX][2]=="L"
                        aAdd(aItens[nItemNF],.T.)
                    EndIf
                Next nX

                For nX := 1 to Len(aItens)
                    AADD(aDocOri,0)
                Next

                dbSelectArea("SF4")
                dbSetOrder(1)
                dbSeek(xFilial("SF4") + (Aliasc6)->C6TES)

           
                dbSelectArea("SB1")
                dbSetOrder(1)
                dbSeek(xFilial("SB1") + (Aliasc6)->C6PRODUTO)

                aItens[nItemNF,nD2FILIAL]	:=	xFilial("SD2")
                aItens[nItemNF,nD2DOC]		:=	cDoc
                aItens[nItemNF,nD2SERIE]	:=	cSerie
                aItens[nItemNF,nD2CLIENTE]	:=	_cCliente
                aItens[nItemNF,nD2LOJA]		:=	_cLojaCli
                aItens[nItemNF,nD2EMISSAO]	:=	dDataBase
                aItens[nItemNF,nD2TIPO]		:=	cTipoNF
                aItens[nItemNF,nD2ITEM]		:=	(Aliasc6)->C6ITEM
                aItens[nItemNF,nD2CF]		:=	SF4->F4_CF
                aItens[nItemNF,nD2COD]		:=	SB1->B1_COD
                aItens[nItemNF,nD2UM]		:=	SB1->B1_UM
                aItens[nItemNF,nD2QUANT]	:=	(Aliasc6)->C6QTDVEN
                aItens[nItemNF,nD2PRCVEN]	:=	(Aliasc6)->C6PRCVEN
                aItens[nItemNF,nD2TOTAL]	:=	(Aliasc6)->C6VALOR
                aItens[nItemNF,nD2PRUNIT]   :=  (Aliasc6)->C6PRCVEN
                aItens[nItemNF,nD2LOCAL]	:=	SB1->B1_LOCPAD
                aItens[nItemNF,nD2TES]		:=	SF4->F4_CODIGO
                aItens[nItemNF,nD2CONTA]	:=	"1011501010001"
                (Aliasc6)->(DBSkip())
                nItemNF++
            Enddo
            (AliasC6)->(DBCloseArea())
            If !Empty(aItens)
                cNF := MaNfs2Nfs(/*cSerOri*/        "",;        //Serie do Documento de Origem
                                /*cNumORI*/         "",;        //Numero do Documento de Origem
                                /*cClieFor*/        "",;        //Cliente/Fornecedor do documento do origem
                                /*cLoja*/           "",;        //Loja do Documento de origem
                                /*cSerieNFS*/       cSerie,;    //Serie do Documento a ser gerado
                                /*lMostraCtb*/      NIL,;       //Mostra Lct.Contabil (OPC)
                                /*lAglutCtb*/       NIL,;       //Aglutina Lct.Contabil (OPC)
                                /*lCtbOnLine*/      NIL,;       //Contabiliza On-Line (OPC)
                                /*lCtbCusto*/       NIL,;       //Contabiliza Custo On-Line (OPC)
                                /*lReajusta*/       NIL,;       //Reajuste de preco na nota fiscal (OPC)
                                /*nCalAcrs*/        NIL,;       //Tipo de Acrescimo Financeiro (OPC)
                                /*nArredPrcLis*/    NIL,;       //Tipo de Arredondamento (OPC)
                                /*lAtuSA7*/         NIL,;       //Atualiza Amarracao Cliente x Produto (OPC)
                                /*lECF*/            NIL,;       //Cupom Fiscal (OPC)
                                /*bFilSD2*/         NIL,;       //CodeBlock de Selecao do SD2 (OPC)
                                /*bSD2*/            NIL,;       //CodeBlock a ser executado para o SD2 (OPC)
                                /*bSF2*/            NIL,;       //CodeBlock a ser executado para o SF2 (OPC)
                                /*bTTS*/            NIL,;       //CodeBlock a ser executado no final da transacao (OPC)
                                /*aDocOri*/         aDocOri,;   //Array com os Recnos do SF2 (OPC)
                                /*aItemOri*/        aItens,;    //Array com os itens do SD2 (OPC)
                                /*aSF2*/            aCabs,;     //Array com os dados do SF2 (OPC)
                                /*lNoFiscal*/       .F.,;       //Calculo Fiscal - Desabilita o calculo fiscal pois as informacoes ja foram passadas nos campos do SD2 e SF2 (OPC)
                                /*bFiscalSF2*/      bFiscalSF2,;//CodeBlock para tratamento do fiscal - SF2 (OPC)
                                /*bFiscalSD2*/      bFiscalSD2,;//CodeBlock para tratamento do fiscal - SD2 (OPC)
                                /*bFatSE1*/         NIL,;       //CodeBlock para tratamento do fiscal - SE1 (OPC)
                                /*cNumNFS*/         cDoc)       //Numero do documento fiscal (OPC)
            Endif

            If !Empty(cNF)
               cQUpdC5 :=""
               cQUpdC5 +="UPDATE " + RetSqlName("SC5") + " SET C5_NOTA ='"+cNF+"', C5_SERIE = '"+cSerie+"', C5_XNFSAI2 = 'S'"
               cQUpdC5 +=" WHERE D_E_L_E_T_ <> '*' AND R_E_C_N_O_ = "+ cValToChar(_nC5Recno)
               nErro := TcSqlExec(cQUpdC5)		
               If nErro != 0
                  Alert("Erro na execução da query cQUpdC5: "+TcSqlError(), "Atenção")
               Else
                  Alert("Pedido Atualizado: " + _cPedido)
               Endif

               cQUpdC6 :=""
               cQUpdC6 +="UPDATE " + RetSqlName("SC6") + " SET C6_NOTA ='"+cNF+"', C6_SERIE = '"+cSerie+"', C6_DATFAT = '"+ cData +"'"
               cQUpdC6 +=" WHERE D_E_L_E_T_ <> '*' AND C6_FILIAL = '"+ _cFilial +"' AND C6_NUM = '"+ _cPedido +"' AND C6_CLI='"+ _cCliente +"' AND C6_LOJA = '"+ _cLojaCli +"' AND C6_OP = ''"
               nErro := TcSqlExec(cQUpdC6)		
               If nErro != 0
                  Alert("Erro na execução da query cQUpdC6: "+TcSqlError(), "Atenção")
               Else
                  Alert("Pedido Atualizado: " + _cPedido)
               Endif
               
               Alert("Nota Fiscal de Saída: " + cNF + ",  na Unidade de Faturamento")
            EndIf
  
        EndIf

    (AliasC5)->(DBCloseArea())
    (AliasQtde)->(DBSkip())
    Enddo     
    // Next nP
    (AliasQtde)->(DBCloseArea())

    Alert("FIM")
    Close(oDlg)

    cFilAnt := cSvFilAnt
    // RESET ENVIRONMENT
 
Return
