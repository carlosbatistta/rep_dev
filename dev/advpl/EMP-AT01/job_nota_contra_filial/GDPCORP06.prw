
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#include "rwmake.ch"

//!####################################################################
//! Função: GDENTUNIFAT Criado por: GAMADEVBR 03/05/2022
//! Descrição: Gravação da Nota de Entrada na  Filail de Faturamento
//! Rotina automática: MATA103 - DOCUMENTO TIPO NORMAL
//!####################################################################
// DOCUMENTO TIPO NORMAL VINCULADO AO PEDIDO DE COMPRAS
User Function DLGNFENT6()
	@ 0,0 to 300,300 Dialog oDlg Title "6-Gera NF Entrada na Filial de Faturamento"
	@ 105,10 BmpButton Type 1 Action	Processa( {|| GDENTUNIFAT() } )
	@ 105,60 BmpButton Type 2 Action Close(oDlg)
	ACTIVATE DIALOG oDlg CENTER
return nil

Static Function GDENTUNIFAT()
    Local aCab := {}
    Local aItem := {}
    Local aItens := {}
    // Local aAutoImp := {}
    Local aItensRat := {}
    Local aCodRet := {}
    Local aParamAux := {}
    Local nOpc := 3  // 3-Inclusão / 4-Classificação / 5-Exclusão
    Local _cTES_Entrada := ""
    // Local cNum := ""
    // Local nI := 0
    Local nX := 0
    // Local nReg := 1
    Private lMsErroAuto := .F.
    Private lMsHelpAuto := .T.

    cSvFilAnt := cFilAnt

    cQtdeNF := ""
    cQtdeNF += "SELECT COUNT(*) AS NOTAS"
    cQtdeNF += " FROM " + RetSqlName("SF2") + " AS F2"
    cQtdeNF += " WHERE F2.D_E_L_E_T_ <> '*' AND"
    // cQtdeNF += " F2.F2_CHVNFE <> '' AND " //! descomentar para verificar se já foi autorizada
    cQtdeNF += " F2.F2_XCONSOL = 'S' AND"  //! verifica se é uma nota do processo de venda corporativa
    cQtdeNF += " F2.F2_XNFENT2 = 'N'" //! verifica se ainda não foi geada a nota de entrada
    // cQtdeNF += " GROUP BY F2.F2_DOC" //! verifica se ainda não foi geada a nota de entrada
    cQtdeNF := ChangeQuery(cQtdeNF)
    AliasQtde := CriaTrab(,.F.)
    DbUseArea(.T., "TOPCONN", TCGenQry(,,cQtdeNF), AliasQtde, .F., .T.)
    // SELECT COUNT(*) AS NOTAS, F2.F2_DOC FROM SF2010 AS F2 WHERE  F2.D_E_L_E_T_ <> '*' AND F2.F2_XCONSOL = 'S' AND F2.F2_XNFENT2 = 'N' GROUP BY F2.F2_DOC

    // Alert(cValToChar((AliasQtde)->NOTAS) + " Notas para entrar")

    For nX := 1 To (AliasQtde)->NOTAS

        cQryF2 := ""
        cQryF2 += "SELECT TOP 1 F2.F2_FILIAL AS 'FILIAL', F2.F2_EMISSAO AS 'F2EMISSAO', F2.F2_DOC AS 'F2DOC', F2.F2_SERIE AS 'F2SERIE', F2.F2_CLIENTE AS 'F2CLIENTE', F2.F2_LOJA AS 'F2LOJA',"
        cQryF2 += " F2.F2_COND AS 'F2COND', F2.F2_VALBRUT AS 'F2VALBRUT', F2.F2_XCARCON AS 'F2XCARCON', F2.F2_XPEDCON AS 'F2XPEDCON',"
        cQryF2 += " F2.F2_XUNDFAT AS 'F2XUNDFAT', F2.F2_XFILFAT AS 'F2XFILFAT', F2.R_E_C_N_O_ AS 'RECNO'"
        cQryF2 += " FROM " + RetSqlName("SF2") + " AS F2"
        cQryF2 += " WHERE F2.D_E_L_E_T_ <> '*' AND"
        // cQryF2 += " F2.F2_CHVNFE <> '' AND " //! descomentar para verificar se já foi autorizada
        cQryF2 += " F2.F2_XCONSOL = 'S' AND"  //! verifica se é uma nota do processo de venda corporativa
        cQryF2 += " F2.F2_XNFENT2 = 'N'" //! verifica se ainda não foi geada a nota de entrada
        cQryF2 := ChangeQuery(cQryF2)
        AliasF2 := CriaTrab(,.F.)
        DbUseArea(.T., "TOPCONN", TCGenQry(,,cQryF2), AliasF2, .F., .T.)
        // SELECT TOP 1 F2.F2_FILIAL AS 'FILIAL',F2.F2_DOC AS 'F2DOC',F2.F2_SERIE AS 'F2SERIE',F2.F2_CLIENTE AS 'F2CLIENTE',F2.F2_LOJA AS 'F2LOJA',F2.F2_COND AS 'F2COND',F2.F2_VALBRUT AS 'F2VALBRUT',F2.F2_XCARCON AS 'F2XCARCON',F2.F2_XPEDCON AS 'F2XPEDCON',F2.F2_XUNDFAT AS 'F2XUNDFAT',F2.F2_XFILFAT AS 'F2XFILFAT',F2.R_E_C_N_O_ AS 'RECNO' FROM SF2010 AS F2 WHERE  F2.D_E_L_E_T_ <> '*' AND F2.F2_XCONSOL = 'S' AND F2.F2_XNFENT2 = 'N'

        // PREPARE ENVIRONMENT EMPRESA "T1" FILIAL "D MG 01 " MODULO "FAT" TABLES "SF2","SD2","SA1","SA2","SB1","SB2","SF4","SED","SE1"

        If !(AliasF2)->(Eof())
            aCab := {}
            aItem := {}
            aItens := {}

            _cFilial    := (AliasF2)->FILIAL
            _cDoc       := (AliasF2)->F2DOC
            _cSerie     := (AliasF2)->F2SERIE
            _cCliente   := (AliasF2)->F2CLIENTE
            _cLoja      := (AliasF2)->F2LOJA
            _cUnidFat   := (AliasF2)->F2XUNDFAT
            _cFilFat    := (AliasF2)->F2XFILFAT
            _cPedCons   := (AliasF2)->F2XPEDCON
            _cCarga     := (AliasF2)->F2XCARCON

            cFilAnt := _cFilFat //! seta a filial de faturamento

             cQrySZX := ""
            cQrySZX += "SELECT"
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
            cQrySZX += " RTRIM(LTRIM(ZX.ZX_LJFCON)) AS ZXLJFCON,"
            cQrySZX += " RTRIM(LTRIM(ZX.ZX_FORTRAN)) AS ZXFORTRAN,"
            cQrySZX += " RTRIM(LTRIM(ZX.ZX_LJFTRAN)) AS ZXLJFTRAN,"
            cQrySZX += " RTRIM(LTRIM(ZX.ZX_CCTRAN)) AS ZXCCTRAN"
            cQrySZX += " FROM "+RetSqlName("SZX")+" AS ZX"
            cQrySZX += " WHERE ZX.D_E_L_E_T_ <> '*' AND ZX.ZX_FILFAT = '" + _cFilFat + "'"
            cQrySZX := ChangeQuery(cQrySZX)
            AliasSZX := CriaTrab(,.F.)
            DbUseArea(.T., "TOPCONN", TCGenQry(,,cQrySZX), AliasSZX, .F., .T.)

            If !(AliasSZX)->(Eof())
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
                cZXFORTRAN  := AllTrim((AliasSZX)->ZXFORTRAN)
                cZXLJFTRAN  := AllTrim((AliasSZX)->ZXLJFTRAN)
                cZXCCTRAN   := AllTrim((AliasSZX)->ZXCCTRAN)
            EndIf

            // cNum := GetSxeNum("SF1","F1_DOC")
            // SF1->(dbSetOrder(1))
            // While SF1->(dbSeek(xFilial("SF1")+cNum))
            //     ConfirmSX8()
            //     cNum := GetSxeNum("SF1","F1_DOC")
            // EndDo

            cQryD2 := ""
            cQryD2 += "SELECT D2.D2_ITEM AS 'D2ITEM', D2.D2_COD AS 'D2COD', D2.D2_UM AS 'D2UM', D2.D2_QUANT AS 'D2QUANT', D2.D2_PRCVEN AS 'D2PRCVEN', D2.D2_TOTAL AS 'D2TOTAL',"
            cQryD2 += " D2.D2_FILIAL AS 'FILIAL', D2.D2_DOC AS 'D2DOC', D2.D2_SERIE AS 'D2SERIE', D2.D2_CLIENTE AS 'D2CLIENTE', D2.D2_LOJA AS 'D2LOJA', D2.D2_TES AS 'D2TES',"
            cQryD2 += " D2.R_E_C_N_O_ AS 'D2RECNO'"
            cQryD2 += " FROM " + RetSqlName("SD2") + " AS D2"
            cQryD2 += " WHERE D2.D_E_L_E_T_ <> '*' AND"
            cQryD2 += " D2.D2_FILIAL = '"+(AliasF2)->FILIAL+"' AND"
            cQryD2 += " D2.D2_DOC = '"+(AliasF2)->F2DOC+"' AND"
            cQryD2 += " D2.D2_SERIE = '"+(AliasF2)->F2SERIE+"' AND"
            cQryD2 += " D2.D2_CLIENTE = '"+(AliasF2)->F2CLIENTE+"' AND"
            cQryD2 += " D2.D2_LOJA = '"+(AliasF2)->F2LOJA+"'"
            cQryD2 := ChangeQuery(cQryD2)
            AliasD2 := CriaTrab(,.F.)
            DbUseArea(.T., "TOPCONN", TCGenQry(,,cQryD2), AliasD2, .F., .T.)
            // SELECT D2.D2_ITEM AS 'D2ITEM',D2.D2_COD AS 'D2COD',D2.D2_UM AS 'D2UM',D2.D2_QUANT AS 'D2QUANT',D2.D2_PRCVEN AS 'D2PRCVEN',D2.D2_TOTAL AS 'D2TOTAL',D2.D2_FILIAL AS 'FILIAL',D2.D2_DOC AS 'D2DOC',D2.D2_SERIE AS 'D2SERIE',D2.D2_CLIENTE AS 'D2CLIENTE',D2.D2_LOJA AS 'D2LOJA',D2.R_E_C_N_O_ AS 'D2RECNO' FROM SD2010 AS D2 WHERE  D2.D_E_L_E_T_ <> '*' AND D2.D2_FILIAL = '01010101000' AND D2.D2_DOC = '000000004' AND D2.D2_SERIE = '3  ' AND D2.D2_CLIENTE = '02115136' AND D2.D2_LOJA = '0002'


            //Cabeçalho
            aadd(aCab,{"F1_TIPO"        , "N",          Nil})
            aadd(aCab,{"F1_FORMUL"      , "N",          Nil})
            aadd(aCab,{"F1_DOC"         , _cDoc,         Nil}) // cNum
            aadd(aCab,{"F1_SERIE"       , (AliasF2)->F2SERIE, Nil})
            aadd(aCab,{"F1_EMISSAO"     , SToD((AliasF2)->F2EMISSAO),    Nil})
            aadd(aCab,{"F1_DTDIGIT"     , DDATABASE,    Nil})
            aadd(aCab,{"F1_FORNECE"     , cZXFORTRAN, Nil})
            aadd(aCab,{"F1_LOJA"        , Padr(cZXLJFTRAN, TamSX3("F1_LOJA")[1]), Nil})
            aadd(aCab,{"F1_ESPECIE"     , "NF",         Nil})
            aadd(aCab,{"F1_COND"        , (AliasF2)->F2COND, Nil})
            aadd(aCab,{"F1_DESPESA"     , 0,            Nil})
            aadd(aCab,{"F1_DESCONT"     , 0,            Nil})
            aadd(aCab,{"F1_SEGURO"      , 0,            Nil})
            aadd(aCab,{"F1_FRETE"       , 0,            Nil})
            aadd(aCab,{"F1_MOEDA"       , 1,            Nil})
            aadd(aCab,{"F1_TXMOEDA"     , 1,            Nil})
            aadd(aCab,{"F1_STATUS"      , "A",          Nil})
            //! campos criados    
            aadd(aCab,{"F1_XCONSOL",    "S",            Nil})  // indica que faz parte do processo que gerou o pedido consolidado
            // aadd(aCab,{"F1_XGNFSAI",    "N",            Nil})  // vai ser preenchido com S quando gerar a nota de saída para a filial de faturamento     
            aadd(aCab,{"F1_XF2FILI",    _cFilial,       Nil})  // dados de origem da entrada   
            aadd(aCab,{"F1_XF2DOC",     _cDoc,          Nil})  // dados de origem da entrada    
            aadd(aCab,{"F1_XF2SERI",    _cSerie,        Nil})  // dados de origem da entrada    
            aadd(aCab,{"F1_XF2CLIE",    _cCliente,      Nil})  // dados de origem da entrada    
            aadd(aCab,{"F1_XF2LOJA",    _cLoja,         Nil})  // dados de origem da entrada    
            aadd(aCab,{"F1_XUNDFAT",    _cUnidFat,      Nil})  // indica a unidade de faturamento   
            aadd(aCab,{"F1_XFILFAT",    _cFilFat,       Nil})  // indica a filial de faturamento  
            aadd(aCab,{"F1_XF2PEDC",    _cPedCons,      Nil})  // dados de origem da entrada   
            aadd(aCab,{"F1_XF2CARC",    _cCarga,        Nil})  // dados de origem da entrada
            //! campos que seram modificados aogerar o pedido e a nota de saída para a filial de faturamento 
            // aadd(aCab,{"F1_XGERPED",    "N",            Nil})  // vai ficar S após gerar o pedido de venda para a filial de faturamento 
            // aadd(aCab,{"F1_XNUMPED",    "",             Nil})  // vai ser preenchido quando gerar o pedido de venda para a filial de faturamento 

            While !((AliasD2))->(Eof())

                //* ###########################################################
                //* CONSULTA GRUPO TRIBUTÁRIO
                //* ###########################################################
                cQryGRUPO := ""
                cQryGRUPO += " SELECT B1.B1_GRTRIB AS 'B1GRTRIB', B1.B1_GRPTI AS 'B1GRPTI', B1.B1_ORIGEM AS 'B1ORIGEM'"
                cQryGRUPO += " FROM " + RetSqlName("SB1") + " AS B1"
                cQryGRUPO += " WHERE B1.B1_COD ='"+ (AliasD2)->D2COD +"' AND B1.D_E_L_E_T_ <> '*' "
                cQryGRUPO := ChangeQuery(cQryGRUPO)
                AliasGRP := CriaTrab(,.F.)
                DbUseArea(.T., "TOPCONN", TCGenQry(,,cQryGRUPO), AliasGRP, .F., .T.)
                _cB1GRTRIB := Alltrim((AliasGRP)->B1GRTRIB)
                // _cB1GRPTI := Alltrim((AliasGRP)->B1GRPTI)
                // _cB1ORIGEM := Alltrim((AliasGRP)->B1ORIGEM)

                DO CASE
                    CASE _cB1GRTRIB $ "000001/000002"
                        _cTES_Entrada := "245"
                    CASE _cB1GRTRIB == "000004"
                        _cTES_Entrada := "246"
                    CASE _cB1GRTRIB == "000003"
                        _cTES_Entrada := "248"
                    OTHERWISE
                        _cTES_Entrada := "241"
                ENDCASE
                //* ---------------------------------------------

                // MaTesInt(1,"70",cA100For,cLoja,If(cTipo$"DB","C","F"),(AliasD2)->D2COD,"D1_TES")

                aItem := {}
                aadd(aItem,{"D1_ITEM"   ,(AliasD2)->D2ITEM,                             NIL})
                aadd(aItem,{"D1_COD"    ,PadR((AliasD2)->D2COD,TamSx3("D1_COD")[1]),    NIL})
                aadd(aItem,{"D1_UM"     ,(AliasD2)->D2UM,                               NIL})
                aadd(aItem,{"D1_LOCAL"  ,"01",                                          NIL})
                aadd(aItem,{"D1_OPER"   ,"70",                                          NIL})
                aadd(aItem,{"D1_QUANT"  ,(AliasD2)->D2QUANT,                            NIL})
                aadd(aItem,{"D1_VUNIT"  ,(AliasD2)->D2PRCVEN,                           NIL})
                aadd(aItem,{"D1_TOTAL"  , Round(((AliasD2)->D2QUANT * (AliasD2)->D2PRCVEN), 2), NIL})
                // aadd(aItem,{"D1_TOTAL"  ,(AliasD2)->D2TOTAL,                            NIL})
                aadd(aItem,{"D1_TES"    ,_cTES_Entrada,                                 NIL})
                aadd(aItem,{"D1_CC"     ,cZXCCTRAN,                                     NIL})
                aadd(aItens,aItem)

                // aadd(aItens[Len(aItens)], {'D1_PEDIDO ', _cPedido ,}) // Número do Pedido de Compras
                // aadd(aItens[Len(aItens)], {'D1_ITEMPC ', _cItem ,}) // Item do Pedido de Compras

                // if(nOpc == 4)//Se for classificação deve informar a variável LINPOS
                //     aAdd(aItem, {"LINPOS" , "D1_ITEM",  StrZero(nX,4)}) //ou SD1->D1_ITEM  se estiver posicionado.
                // endIf
                (AliasD2)->(DBSkip())
            Enddo

            SetFunName("MATA103")
            MSExecAuto({|x,y,z,k,a,b| MATA103(x,y,z,,,,k,a,,,b)},aCab,aItens,nOpc,aParamAux,aItensRat,aCodRet)

            If !lMsErroAuto
                Alert("Nota Fiscal de Entrada: " + _cDoc + ", gerada na Filial de Faturamento")
                cQUpdF2 :=""
                cQUpdF2 +="UPDATE " + RetSqlName("SF2") + " SET F2_XNFENT2 ='S'"
                cQUpdF2 +=" WHERE D_E_L_E_T_ <> '*' AND F2_FILIAL = '"+ _cFilial +"' AND F2_DOC = '"+ _cDoc +"' AND F2_SERIE = '"+ _cSerie +"' AND F2_CLIENTE = '"+ _cCliente +"' AND F2_LOJA = '"+_cLoja+"'"
                nErro := TcSqlExec(cQUpdF2)		
                If nErro != 0
                    Alert("Erro na execução da query cQUpdF2: "+TcSqlError(), "Atenção")
                Else
                    Alert("Nota de saida Atualizada: " + _cDoc)
                Endif
            Else
                MostraErro()
                Alert("Erro na inclusao!")
            EndIf
        EndIf
    Next nX
    (AliasQtde)->(DBCloseArea())

    Alert("FIM")
    Close(oDlg)

    // RESET ENVIRONMENT
    cFilAnt := cSvFilAnt

Return
