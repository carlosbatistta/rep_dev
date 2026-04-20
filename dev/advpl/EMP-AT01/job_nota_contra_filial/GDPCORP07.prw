
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#include "rwmake.ch"

//!####################################################################
//! Função: GDNFFIFAT Criado por: GAMADEVBR 20/04/2022
//! Descrição: Gravação da Nota de Saida com base nos pedidos ORIGINAIS
//!####################################################################
User Function GDNFFIFAT()
	@ 0,0 to 300,300 Dialog oDlg Title "7-Gera Notas dos clientes FILFAL"
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
Local cSerie    := "3"
Local cDoc 	   	:= ""
Local cTipoNF   := "N"

// Local nP
Local cSvFilAnt := cFilAnt

PRIVATE lMsErroAuto := .F.

    cQtdePED := ""
    cQtdePED += "SELECT DISTINCT DAK.DAK_FILIAL AS 'DAKFILIAL', DAK.DAK_COD AS 'DAKCOD', DAK.DAK_SEQCAR AS 'DAKSEQCAR', DAK.R_E_C_N_O_ AS 'DAKRECNO',"
    cQtdePED += " C5.C5_FILIAL AS 'C5FILIAL', C5.C5_NUM AS 'C5NUM', C5.C5_CLIENTE AS 'C5CLIENTE', C5.C5_LOJACLI AS 'C5LOJACLI', C5.C5_CONDPAG AS 'CONDPAG', C5.C5_TABELA AS 'C5TABELA',"
    cQtdePED += " C5.C5_XCORP AS 'C5XCORP', C5.C5_XEMPVEN AS 'C5XEMPVEN', C5.C5_NOTA AS 'C5NOTA', C5.R_E_C_N_O_ AS 'C5RECNO'"
    cQtdePED += " FROM DAK010 AS DAK"
    cQtdePED += " INNER JOIN DAI010 AS DAI ON DAI.DAI_COD = DAK.DAK_COD AND DAI.D_E_L_E_T_ <> '*'"
    cQtdePED += " INNER JOIN SC9010 AS C9 ON C9.C9_PEDIDO = DAI.DAI_PEDIDO AND C9.D_E_L_E_T_ <> '*'"
    cQtdePED += " INNER JOIN SC5010 AS C5 ON C5.C5_NUM = DAI.DAI_PEDIDO AND C5.D_E_L_E_T_ <> '*'"
    cQtdePED += " INNER JOIN SC6010 AS C6 ON C6.C6_NUM = C5.C5_NUM AND C6.D_E_L_E_T_ <> '*'"
    cQtdePED += " WHERE"
    cQtdePED += " DAK.D_E_L_E_T_ <> '*' AND  DAK_XCONSO = 'S'"
    // cQtdePED += " AND DAK.DAK_XNFCLI = ''" //! descomentar para não deixar gerar notas para os clientes novamente 
    cQtdePED += " AND DAI.DAI_SEQCAR = DAK_SEQCAR"
    cQtdePED += " AND C9.C9_FILIAL =  DAK.DAK_FILIAL AND C9.C9_CLIENTE = DAI.DAI_CLIENT  AND C9.C9_LOJA = DAI.DAI_LOJA"
    cQtdePED += " AND C5.C5_FILIAL =  DAK.DAK_FILIAL AND C5.C5_CLIENTE = DAI.DAI_CLIENT  AND C5.C5_LOJACLI = DAI.DAI_LOJA"
    cQtdePED += " AND C5.C5_XCORP = 'S'" 
    // cQtdePED += " AND C5_XNFCLIE =''" //! descomentar para não deixar gerar notas para os clientes novamente 
    cQtdePED += " AND"
    cQtdePED += " C6.C6_FILIAL =  DAK.DAK_FILIAL AND C6.C6_CLI = DAI.DAI_CLIENT  AND C6.C6_LOJA = DAI.DAI_LOJA"
    cQtdePED := ChangeQuery(cQtdePED)
    AliasQtde := CriaTrab(,.F.)
    DbUseArea(.T., "TOPCONN", TCGenQry(,,cQtdePED), AliasQtde, .F., .T.)

    While !(AliasQtde)->(Eof())
        _cCargaFil  := (AliasQtde)->DAKFILIAL
        _cCargaCod  := (AliasQtde)->DAKCOD
        _cCargaSeq  := (AliasQtde)->DAKSEQCAR
        _cCargaRec  := (AliasQtde)->DAKRECNO
        _cC5Top     := (AliasQtde)->C5RECNO

        cQryC5 := ""
        cQryC5 += "SELECT C5.C5_FILIAL AS 'C5FILIAL', C5.C5_NUM AS 'C5NUM', C5.C5_CLIENTE AS 'C5CLIENTE', C5.C5_TIPOCLI AS 'C5TIPOCLI', C5.C5_LOJACLI AS 'C5LOJACLI',"
        cQryC5 += " C5.C5_LOJAENT AS 'C5LOJAENT', C5.C5_CONDPAG AS 'C5CONDPAG', C5.C5_TABELA AS 'C5TABELA', C5.C5_NATUREZ AS 'C5NATUREZ',"
        cQryC5 += " C5.C5_XUNDFAT AS 'C5XUNDFAT', C5.C5_XFILFAT AS 'C5XFILFAT', C5.C5_XCORP AS 'C5XCORP', C5.C5_XEMPVEN AS C5XEMPVEN,"
        cQryC5 += " C5.R_E_C_N_O_ AS 'C5RECNO'"
        cQryC5 += " FROM " + RetSqlName("SC5") + " AS C5"
        cQryC5 += " WHERE C5.D_E_L_E_T_ <> '*' AND"
        cQryC5 += " C5.R_E_C_N_O_ = " + cValToChar(_cC5Top)
        // cQryC5 += " C5.C5_FILIAL = '" + (AliasQtde)->C5FILIAL + "' AND C5.C5_NUM ='" + (AliasQtde)->C5NUM + "' AND C5.C5_CLIENTE = '" + (AliasQtde)->C5CLIENTE + "' AND C5.C5_LOJACLI = '" + (AliasQtde)->C5LOJACLI + "'"
        cQryC5 := ChangeQuery(cQryC5)
        AliasC5 := CriaTrab(,.F.)
        DbUseArea(.T., "TOPCONN", TCGenQry(,,cQryC5), AliasC5, .F., .T.)

        If !(AliasC5)->(Eof())
        
            aCabs 	:=	{}	
            aItens	:=	{}


            //* ###########################################################
            //* cQrySZX BUSCA OS PARAMETROS NA SZX
            //* ###########################################################
            cQrySZX := ""
            cQrySZX += "SELECT"
            // cQrySZX += " SUBSTRING(RTRIM(LTRIM(ZX.ZX_EMPVEND)),3, 6) AS ZXEMPVEND,"
            cQrySZX += " ZX.ZX_EMPVEND AS ZXEMPVEND,"
            cQrySZX += " RTRIM(LTRIM(ZX.ZX_FILFAT)) AS ZXFILFAT,"
            cQrySZX += " RTRIM(LTRIM(ZX.ZX_UNIFAT)) AS ZXUNIFAT,"
            cQrySZX += " RTRIM(LTRIM(ZX.ZX_TESCON)) AS ZXTESCON,"
            cQrySZX += " RTRIM(LTRIM(ZX.ZX_TESTRAN)) AS ZXTESTRAN,"
            cQrySZX += " RTRIM(LTRIM(ZX.ZX_CLICON)) AS ZXCLICON,"
            cQrySZX += " RTRIM(LTRIM(ZX.ZX_LJCON)) AS ZXLJCON,"
            cQrySZX += " RTRIM(LTRIM(ZX.ZX_CLITRAN)) AS ZXCLITRAN,"
            cQrySZX += " RTRIM(LTRIM(ZX.ZX_LJTRAN)) AS ZXLJTRAN,"
            cQrySZX += " RTRIM(LTRIM(ZX.ZX_FORCON)) AS ZXFORCON,"
            cQrySZX += " RTRIM(LTRIM(ZX.ZX_LJFCON)) AS ZXLJFCON"
            cQrySZX += " FROM "+RetSqlName("SZX")+" AS ZX"
            cQrySZX += " WHERE ZX.D_E_L_E_T_ <> '*' AND ZX.ZX_EMPVEND  = '"+(AliasC5)->C5XEMPVEN+"'"
            cQrySZX := ChangeQuery(cQrySZX)
            AliasSZX := CriaTrab(,.F.)
            DbUseArea(.T., "TOPCONN", TCGenQry(,,cQrySZX), AliasSZX, .F., .T.) 
            // SELECT ZX.ZX_EMPVEND AS ZXEMPVEND,RTRIM(LTRIM(ZX.ZX_FILFAT)) AS ZXFILFAT,RTRIM(LTRIM(ZX.ZX_UNIFAT)) AS ZXUNIFAT,RTRIM(LTRIM(ZX.ZX_TESCON)) AS ZXTESCON,RTRIM(LTRIM(ZX.ZX_TESTRAN)) AS ZXTESTRAN,RTRIM(LTRIM(ZX.ZX_CLICON)) AS ZXCLICON,RTRIM(LTRIM(ZX.ZX_LJCON)) AS ZXLJCON,RTRIM(LTRIM(ZX.ZX_CLITRAN)) AS ZXCLITRAN,RTRIM(LTRIM(ZX.ZX_LJTRAN)) AS ZXLJTRAN,RTRIM(LTRIM(ZX.ZX_FORCON)) AS ZXFORCON,RTRIM(LTRIM(ZX.ZX_LJFCON)) AS ZXLJFCON FROM SZX010 AS ZX WHERE  ZX.D_E_L_E_T_ <> '*' AND ZX.ZX_EMPVEND = '01020101000'

            If !((AliasSZX))->(Eof())
                cZXEMPVEND  := AllTrim((AliasSZX)->ZXEMPVEND)
                cZXFILFAT   := AllTrim((AliasSZX)->ZXFILFAT)
                cZXUNIFAT   := AllTrim((AliasSZX)->ZXUNIFAT)
                cZXTESCON   := AllTrim((AliasSZX)->ZXTESCON)
                cZXTESTRAN  := AllTrim((AliasSZX)->ZXTESTRAN)
                cZXCLICON   := AllTrim((AliasSZX)->ZXCLICON)
                cZXLJCON    := AllTrim((AliasSZX)->ZXLJCON)
                cZXCLITRAN  := AllTrim((AliasSZX)->ZXCLITRAN)
                cZXLJTRAN   := AllTrim((AliasSZX)->ZXLJTRAN)
                cZXFORCON   := AllTrim((AliasSZX)->ZXFORCON)
                cZXLJFCON   := AllTrim((AliasSZX)->ZXLJFCON)

                _cUnidFat   := cZXUNIFAT
                _cFilFat    := cZXFILFAT
                cFilAnt     := _cFilFat //! seta a FILIAL de faturamento
            Else
                Alert("Empresa não cadastrada nos parametros SZX: " + (AliasCarga)->C5XEMPVEN)
                return // volta  para For nP := 1 To (AliasQtde)->PEDIDOS
            EndIf

            _cFilial    := (AliasC5)->C5FILIAL
            _cPedido    := (AliasC5)->C5NUM
            _cCliente   := (AliasC5)->C5CLIENTE
            _cLojaCli   := (AliasC5)->C5LOJACLI
            _cTipoCli   := (AliasC5)->C5TIPOCLI
            _cLojaEnt   := (AliasC5)->C5LOJAENT
            _nC5Recno   := (AliasC5)->C5RECNO

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

            // Montagem do cabeçalho do Documento Fiscal
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
            
            // nF2XNFENT2 	:= Ascan(aStruSF2,{|x| AllTrim(x[1]) == "F2_XNFENT2"}) // Já Gerou NF Entrada na Filial de Faturamento?
            // nF2XCONSOL 	:= Ascan(aStruSF2,{|x| AllTrim(x[1]) == "F2_XCONSOL"})
            // nF2XPEDCON 	:= Ascan(aStruSF2,{|x| AllTrim(x[1]) == "F2_XPEDCON"})
            // nF2XUNDFAT 	:= Ascan(aStruSF2,{|x| AllTrim(x[1]) == "F2_XUNDFAT"})
            // nF2XFILFAT 	:= Ascan(aStruSF2,{|x| AllTrim(x[1]) == "F2_XFILFAT"})

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

            // aCabs[nF2XNFENT2] 	:= 'N' // Já Gerou NF Entrada na Filial de Faturamento?
            // aCabs[nF2XCONSOL] 	:= 'S'
            // aCabs[nF2XPEDCON] 	:= _cPedido
            // aCabs[nF2XUNDFAT] 	:= _cUnidFat
            // aCabs[nF2XFILFAT] 	:= _cFilFat

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
                (Aliasc6)->(DBSkip())
                nItemNF++
            Enddo
            (AliasC6)->(DBCloseArea())

            cNF := MaNfs2Nfs(/*cSerOri*/        "",;        // Serie do Documento de Origem
                            /*cNumORI*/         "",;        // Numero do Documento de Origem
                            /*cClieFor*/        "",;        // Cliente/Fornecedor do documento do origem
                            /*cLoja*/           "",;        // Loja do Documento de origem
                            /*cSerieNFS*/       cSerie,;    // Serie do Documento a ser gerado
                            /*lMostraCtb*/      NIL,;       // Mostra Lct.Contabil (OPC)
                            /*lAglutCtb*/       NIL,;       // Aglutina Lct.Contabil (OPC)
                            /*lCtbOnLine*/      NIL,;       // Contabiliza On-Line (OPC)
                            /*lCtbCusto*/       NIL,;       // Contabiliza Custo On-Line (OPC)
                            /*lReajusta*/       NIL,;       // Reajuste de preco na nota fiscal (OPC)
                            /*nCalAcrs*/        NIL,;       // Tipo de Acrescimo Financeiro (OPC)
                            /*nArredPrcLis*/    NIL,;       // Tipo de Arredondamento (OPC)
                            /*lAtuSA7*/         NIL,;       // Atualiza Amarracao Cliente x Produto (OPC)
                            /*lECF*/            NIL,;       // Cupom Fiscal (OPC)
                            /*bFilSD2*/         NIL,;       // CodeBlock de Selecao do SD2 (OPC)
                            /*bSD2*/            NIL,;       // CodeBlock a ser executado para o SD2 (OPC)
                            /*bSF2*/            NIL,;       // CodeBlock a ser executado para o SF2 (OPC)
                            /*bTTS*/            NIL,;       // CodeBlock a ser executado no final da transacao (OPC)
                            /*aDocOri*/         aDocOri,;   // Array com os Recnos do SF2 (OPC)
                            /*aItemOri*/        aItens,;    // Array com os itens do SD2 (OPC)
                            /*aSF2*/            aCabs,;     // Array com os dados do SF2 (OPC)
                            /*lNoFiscal*/       .F.,;       // Calculo Fiscal - Desabilita o calculo fiscal pois as informacoes ja foram passadas nos campos do SD2 e SF2 (OPC)
                            /*bFiscalSF2*/      bFiscalSF2,;// CodeBlock para tratamento do fiscal - SF2 (OPC)
                            /*bFiscalSD2*/      bFiscalSD2,;// CodeBlock para tratamento do fiscal - SD2 (OPC)
                            /*bFatSE1*/         NIL,;       // CodeBlock para tratamento do fiscal - SE1 (OPC)
                            /*cNumNFS*/         cDoc)       // Numero do documento fiscal (OPC)

            If !Empty(cNF)

               cQUpdC5 :=""
               cQUpdC5 +="UPDATE " + RetSqlName("SC5") + " SET C5_NOTA ='" + cNF + "', C5_SERIE = '" + cSerie + Space(2) + "', C5_XNFCLIE ='S'"
               cQUpdC5 +=" WHERE D_E_L_E_T_ <> '*' AND R_E_C_N_O_ = "+ cValToChar(_cC5Top)
               nErro := TcSqlExec(cQUpdC5)		
               If nErro != 0
                  Alert("Erro na execução da query cQUpdC5: "+TcSqlError(), "Atenção")
               Else
                  Alert("Pedido Atualizado: " + _cPedido)
               Endif

               // TODO atualizar DAK e DAI
               /*
                CAMPOS DA CARGA PARA SEREM ATUALIZADOS QUANDO FATURAR:

                DAK 
                DAK_FEZ=1
                DAK_OK = CODIGO XXX

                DAI  
                DAI_NFISCA = NUMERO DA NOTA DO PEDIDO (DAI_PEDIDO)
                DAI_SERIE = SÉRIE DA NOTA DO PEDIDO (DAI_PEDIDO)
                DAI_SDOC = SÉRIE DA NOTA DO PEDIDO (DAI_PEDIDO)
               */

                // _cCargaFil  := (AliasQtde)->DAKFILIAL
                // _cCargaCod  := (AliasQtde)->DAKCOD
                // _cCargaSeq  := (AliasQtde)->DAKSEQCAR
                // _cCargaRec  := (AliasQtde)->DAKSEQCAR

                cQUpdDAK :=""
                cQUpdDAK +="UPDATE " + RetSqlName("DAK") + " SET DAK_FEZNF ='1', DAK_OK = 'XXX'"
                cQUpdDAK +=" WHERE R_E_C_N_O_ = "+ cValToChar(_cCargaRec)
                nErro := TcSqlExec(cQUpdDAK)		
                If nErro != 0
                    Alert("Erro na execução da query cQUpdDAK: "+TcSqlError(), "Atenção")
                Else
                    // Alert("Sucesso")
                Endif

                cQUpdDAI :=""
                cQUpdDAI +="UPDATE " + RetSqlName("DAI") + " SET DAI_NFISCA ='"+ cNF +"', DAI_SERIE = '"+ cSerie +"', DAI_SDOC = '"+ cSerie +"'"
                cQUpdDAI +=" WHERE DAI_FILIAL = '"+ _cCargaFil +"' AND DAI_COD = '"+ _cCargaCod +"' AND DAI_SEQCAR = '"+ _cCargaSeq +"'"
                nErro := TcSqlExec(cQUpdDAI)		
                If nErro != 0
                    Alert("Erro na execução da query cQUpdDAI: "+TcSqlError(), "Atenção")
                Else
                    // Alert("Sucesso")
                Endif
                
                Alert("Nota Fiscal de Saída: " + cNF + ",  na Filail de Faturamento")
                EndIf
  
        EndIf
        (AliasC5)->(DBCloseArea()) 
    (AliasQtde)->(DBSkip())
    Enddo
    (AliasQtde)->(DBCloseArea())

    Alert("FIM")
    Close(oDlg)

    cFilAnt := cSvFilAnt
    // RESET ENVIRONMENT
 
Return
