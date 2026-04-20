
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#include "rwmake.ch"

//!####################################################################
//! Função: GDPUNIFAT Criado por: GAMADEVBR 08/05/2022
//! Descrição: Gera o Pedido de venda na unidade de faturamento
//!####################################################################
User Function GDPUNIFAT()
	@ 0,0 to 300,300 Dialog oDlg Title "4-Gera Pedido na Unid Faturamento"
	@ 105,10 BmpButton Type 1 Action	Processa( {|| U_DLPUNIFAT() } )
	@ 105,60 BmpButton Type 2 Action Close(oDlg)
	ACTIVATE DIALOG oDlg CENTER
return nil

User Function DLPUNIFAT()
 
   Local aCabec := {}
   Local aItens := {}
   Local aErro := {}
   Local nE
   Local nX

   Private cC5Num
   Private lMsErroAuto := .F.

   cSvFilAnt := cFilAnt
   aPvlDocS := {}
   nPrcVen := 0
   cEmbExp := ""
   cDoc    := ""
   cSerie  := "3  "

   cQtdeNF := ""
   cQtdeNF += "SELECT COUNT(*) AS NOTAS"
   cQtdeNF += " FROM " + RetSqlName("SF1") + " AS F1"
   cQtdeNF += " WHERE F1.D_E_L_E_T_ <> '*' AND"
   cQtdeNF += " F1.F1_XCONSOL = 'S' AND" 
   cQtdeNF += " F1.F1_XGERPED = 'N'"
   cQtdeNF := ChangeQuery(cQtdeNF)
   AliasQtde := CriaTrab(,.F.)
   DbUseArea(.T., "TOPCONN", TCGenQry(,,cQtdeNF), AliasQtde, .F., .T.)
   // SELECT COUNT(*) AS NOTAS FROM SF1010 AS F1 WHERE  F1.D_E_L_E_T_ <> '*' AND F1.F1_XCONSOL = 'S' AND F1.F1_XGERPED = 'N'
   // Alert(cValToChar((AliasQtde)->NOTAS) + " Pedidos para gerar")

   For nX := 1 To (AliasQtde)->NOTAS
      
      cQryF1 := ""
      cQryF1 += "SELECT TOP 1 F1.F1_FILIAL AS 'F1FILIAL', F1.F1_DOC AS 'F1DOC', F1.F1_SERIE AS 'F1SERIE', F1.F1_FORNECE AS 'F1FORNECE', F1.F1_LOJA AS 'F1LOJA', F1.F1_COND AS 'F1COND',"
      cQryF1 += " F1.F1_XF2FILI AS 'F1XF2FILI', F1.F1_XF2DOC AS 'F1XF2DOC', F1.F1_XF2SERI AS 'F1XF2SERI', F1.F1_XF2CLIE AS 'F1XF2CLI', F1.F1_XF2LOJA AS 'F1XF2LOJA',"
      cQryF1 += " F1.F1_XGNFSAI AS 'F1XGNFSAI', F1.F1_XF2PEDC AS 'F1XF2PEDC', F1.F1_XF2CARC AS 'F1XF2CARC', F1.F1_XGERPED AS 'F1XGERPED', F1.F1_XNUMPED AS 'F1XNUMPED',"
      cQryF1 += " F1.F1_XUNDFAT AS 'XUNDFAT', F1.F1_XFILFAT AS 'XFILFAT',"
      cQryF1 += " F1.R_E_C_N_O_ AS 'F1RECNO'"
      cQryF1 += " FROM " + RetSqlName("SF1") + " AS F1"
      cQryF1 += " WHERE F1.D_E_L_E_T_ <> '*' AND"
      cQryF1 += " F1.F1_XCONSOL = 'S' AND"
      cQryF1 += " F1.F1_XGERPED = 'N'"
      cQryF1 := ChangeQuery(cQryF1)
      AliasF1 := CriaTrab(,.F.)
      DbUseArea(.T., "TOPCONN", TCGenQry(,,cQryF1), AliasF1, .F., .T.)
      // SELECT TOP 1 F1.F1_FILIAL AS 'F1FILIAL',F1.F1_DOC AS 'F1DOC',F1.F1_SERIE AS 'F1SERIE',F1.F1_FORNECE AS 'F1FORNECE',F1.F1_LOJA AS 'F1LOJA',F1.F1_COND AS 'F1COND',F1.F1_XF2FILI AS 'F1XF2FILI',F1.F1_XF2DOC AS 'F1XF2DOC',F1.F1_XF2SERI AS 'F1XF2SERI',F1.F1_XF2CLIE AS 'F1XF2CLI',F1.F1_XF2LOJA AS 'F1XF2LOJA',F1.F1_XGNFSAI AS 'F1XGNFSAI',F1.F1_XF2PEDC AS 'F1XF2PEDC',F1.F1_XF2CARC AS 'F1XF2CARC',F1.F1_XGERPED AS 'F1XGERPED',F1.F1_XNUMPED AS 'F1XNUMPED',F1.F1_XUNDFAT AS 'XUNDFAT',F1.F1_XFILFAT AS 'XFILFAT',F1.R_E_C_N_O_ AS 'F1RECNO' FROM SF1010 AS F1 WHERE  F1.D_E_L_E_T_ <> '*' AND F1.F1_XCONSOL = 'S' AND F1.F1_XGERPED = 'N'

      If !(AliasF1)->(Eof())

         aCabec := {}
         aItens := {}

         _cFilial    := (AliasF1)->F1FILIAL
         _cDoc       := (AliasF1)->F1DOC
         _cSerie     := (AliasF1)->F1SERIE
         _cFornece   := (AliasF1)->F1FORNECE
         _cLoja      := (AliasF1)->F1LOJA
         _cUnidFat   := (AliasF1)->XUNDFAT
         _cFilFat    := (AliasF1)->XFILFAT
         _cPedCons   := (AliasF1)->F1XF2PEDC
         _cCarga     := (AliasF1)->F1XF2CARC

         cFilAnt := _cUnidFat //! seta a unidade de faturamento

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
         cQrySZX += " RTRIM(LTRIM(ZX.ZX_LJFCON)) AS ZXLJFCON"
         cQrySZX += " FROM "+RetSqlName("SZX")+" AS ZX"
         cQrySZX += " WHERE ZX.D_E_L_E_T_ <> '*' AND ZX.ZX_UNIFAT = '" + _cUnidFat + "'"
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
         EndIf

         cQryD1 := ""
         cQryD1 += "SELECT D1.D1_FILIAL AS 'D1FILIAL', D1.D1_ITEM AS 'D1ITEM', D1.D1_COD AS 'D1COD', D1.D1_UM AS 'D1UM', D1.D1_QUANT AS 'D1QUANT', D1.D1_VUNIT AS 'D1VUNIT', D1.D1_TOTAL AS 'D1TOTAL',"
         cQryD1 += " D1.D1_FILIAL AS 'FILIAL', D1.D1_LOCAL AS 'D1LOCAL', D1.D1_DOC AS 'D1DOC', D1.D1_SERIE AS 'D1SERIE', D1.D1_FORNECE AS 'D1FORNECE', D1.D1_LOJA AS 'D1LOJA',"
         cQryD1 += " D1.R_E_C_N_O_ AS 'D1RECNO'"
         cQryD1 += " FROM " + RetSqlName("SD1") + " AS D1"
         cQryD1 += " WHERE D1.D_E_L_E_T_ <> '*' AND"
         cQryD1 += " D1.D1_FILIAL = '"+_cFilial+"' AND"
         cQryD1 += " D1.D1_DOC = '"+_cDoc+"' AND"
         cQryD1 += " D1.D1_SERIE = '"+_cSerie+"' AND"
         cQryD1 += " D1.D1_FORNECE = '"+_cFornece+"' AND"
         cQryD1 += " D1.D1_LOJA = '"+_cLoja+"'"
         cQryD1 := ChangeQuery(cQryD1)
         AliasD1 := CriaTrab(,.F.)
         DbUseArea(.T., "TOPCONN", TCGenQry(,,cQryD1), AliasD1, .F., .T.)
         // SELECT D1.D1_FILIAL AS 'D1FILIAL',D1.D1_ITEM AS 'D1ITEM',D1.D1_COD AS 'D1COD',D1.D1_UM AS 'D1UM',D1.D1_QUANT AS 'D1QUANT',D1.D1_VUNIT AS 'D1VUNIT',D1.D1_TOTAL AS 'D1TOTAL',D1.D1_FILIAL AS 'FILIAL',D1.D1_LOCAL AS 'D1LOCAL',D1.D1_DOC AS 'D1DOC',D1.D1_SERIE AS 'D1SERIE',D1.D1_FORNECE AS 'D1FORNECE',D1.D1_LOJA AS 'D1LOJA',D1.R_E_C_N_O_ AS 'D1RECNO' FROM SD1010 AS D1 WHERE  D1.D_E_L_E_T_ <> '*' AND D1.D1_FILIAL = '01010101000' AND D1.D1_DOC = '938000534' AND D1.D1_SERIE = '3  ' AND D1.D1_FORNECE = '02115136' AND D1.D1_LOJA = '0001'

         cC5Num :=  GetSxeNum("SC5", "C5_NUM")
         SC5->(dbSetOrder(1))
         While SC5->(dbSeek(xFilial("SC5")+cC5Num))
            // ConfirmSX8()
            cC5Num :=  GetSxeNum("SC5", "C5_NUM")
         EndDo

         aadd(aCabec,{"C5_NUM",       cC5Num,         Nil})
         aadd(aCabec,{"C5_FILIAL",    (AliasF1)->XUNDFAT,     Nil})
         aadd(aCabec,{"C5_TIPO",      "N",            Nil})
         aadd(aCabec,{"C5_TIPOCLI",   "R",            Nil})
         aadd(aCabec,{"C5_CLIENTE",   cZXCLITRAN,     Nil})
         aadd(aCabec,{"C5_LOJACLI",   cZXLJTRAN,         Nil})
         aadd(aCabec,{"C5_LOJAENT",   cZXLJTRAN,         Nil})
         aadd(aCabec,{"C5_CONDPAG",   "002",         Nil})    // 002  
         aadd(aCabec,{"C5_TABELA",    "003",         Nil})    // 003 
         aadd(aCabec,{"C5_NATUREZ",   "1211003001",           Nil})  // 11111001   
         aadd(aCabec,{"C5_ORIGEM",    "GDCONSOL",    Nil}) 
         aadd(aCabec,{"C5_TPCARGA",    "2",    Nil}) 
         //! campos criados   
         aadd(aCabec,{"C5_XCONSOL",    "S",          Nil})     
         aadd(aCabec,{"C5_XDTCONS",    dDataBase,    Nil})     
         aadd(aCabec,{"C5_XHRCONS",    Time(),       Nil}) 
         aadd(aCabec,{"C5_XUNDFAT",    cZXUNIFAT,    Nil})   // indica a unidade de faturamento
         aadd(aCabec,{"C5_XFILFAT",    cZXFILFAT,     Nil})  // indica a filial de faturamento  
         aadd(aCabec,{"C5_XNFSAI2",    "N",          Nil})  // indica que ainda não gerou NF de saída da unidade de faturamento       
         // aadd(aCabec,{"C5_XCARORI",    (AliasCarga)->C9CARGA,   Nil})     
         // aadd(aCabec,{"C5_XFILORI",    (AliasCarga)->C9FILIAL,   Nil})     
         While !((AliasD1))->(Eof())
            // _cItem = _cItem + 1

            //* ###########################################################
            //* CONSULTA ULTIMA ALICOTA
            //* ###########################################################
            cQryUALI := ""
            cQryUALI += " SELECT TOP 1 D1.D1_COD, B1.B1_GRTRIB AS 'B1GRTRIB', B1.B1_POSIPI AS 'B1POSIPI', D1.D1_DTDIGIT, D1.D1_PICM AS 'D1PICM'"
            cQryUALI += " FROM " + RetSqlName("SD1") + " AS D1"
            cQryUALI += " INNER JOIN  " + RetSqlName("SB1") + " AS B1 ON B1.B1_COD = D1.D1_COD"
            cQryUALI += " WHERE D1.D1_FILIAL = '"+ cZXUNIFAT +"' AND  B1.B1_GRTRIB IN ('000001','000002','000003','000004')"
            cQryUALI += " AND B1.B1_COD ='"+ (AliasD1)->D1COD +"' AND B1.D_E_L_E_T_ <> '*' "
            cQryUALI += " ORDER BY D1.D1_DTDIGIT DESC"
            cQryUALI := ChangeQuery(cQryUALI)
            AliasUALI := CriaTrab(,.F.)
            DbUseArea(.T., "TOPCONN", TCGenQry(,,cQryUALI), AliasUALI, .F., .T.)
            _cB1GRTRIB := Alltrim((AliasUALI)->B1GRTRIB)
            _cB1POSIPI := Alltrim((AliasUALI)->B1POSIPI)
            _cD1PICM := Alltrim((AliasUALI)->D1PICM)

            _cTES := "681"
            If _cB1GRTRIB == "000002" .AND. _cD1PICM == "12"
               _cTES := "682"
            ElseIf _cB1GRTRIB != "000004" .AND. (_cB1POSIPI == "85442000" .OR. _cB1POSIPI == "85444200" )
               _cTES := "683"
            ElseIf _cB1GRTRIB == "000004"
               _cTES := "684"
            ElseIf _cB1GRTRIB == "000001" .AND. _cD1PICM == "12"
               _cTES := "685"
            ElseIf _cB1GRTRIB == "000002" .AND. _cD1PICM == "4"
               _cTES := "686"
            ElseIf _cB1GRTRIB == "000003" .AND. _cD1PICM == "12"
               _cTES := "687"
            ElseIf _cB1GRTRIB == "000001" .AND. _cD1PICM == "4"
               _cTES := "692"
            EndIf

            //* ---------------------------------------------

            aLinha := {}
            aadd(aLinha,{"C6_ITEM",    (AliasD1)->D1ITEM,      Nil})
            aadd(aLinha,{"C6_LOCAL",   (AliasD1)->D1LOCAL,     Nil})
            aadd(aLinha,{"C6_PRODUTO", (AliasD1)->D1COD,       Nil})
            aadd(aLinha,{"C6_QTDVEN",  (AliasD1)->D1QUANT,     Nil})
            aadd(aLinha,{"C6_QTDLIB",  (AliasD1)->D1QUANT,     Nil})
            aadd(aLinha,{"C6_PRCVEN",  (AliasD1)->D1VUNIT,     Nil})
            aadd(aLinha,{"C6_PRUNIT",  (AliasD1)->D1VUNIT,     Nil})
            aadd(aLinha,{"C6_VALOR",   Round(((AliasD1)->D1QUANT * (AliasD1)->D1VUNIT ), 2),     Nil}) // (AliasD1)->D1TOTAL
            aadd(aLinha,{"C6_TES",     _cTES,                  Nil}) // cZXTESCON
            aadd(aLinha,{"C6_OPER",    "08",                   Nil})   
            aadd(aItens,aLinha)

            (AliasD1)->(DBSkip())
         Enddo
         
         // cQryUpd :=""
         // cQryUpd +="UPDATE " + RetSqlName("SC9") + " SET C9_BLEST ='', C9_BLCRED ='', C9_NFISCAL ='', C9_SERIENF ='' WHERE RTRIM(LTRIM(C9_PEDIDO)) = '"+ Alltrim(cC5Num) +"'"
         // nErro := TcSqlExec(cQryUpd)		
         // If nErro != 0
         //    ConOut("Erro na execução da query cQryUpd: "+TcSqlError(), "Atenção")
         //    DisarmTransaction()
         // Else
         //    ConOut("Pedido liberado")
         // Endif

         Begin Transaction
            MSExecAuto({|x,y,z|mata410(x,y,z)},aCabec,aItens,3)

            If !lMsErroAuto
               ConfirmSX8()
               ConOut("Sucesso na Gravacao do pedido!") 
               ConOut("Pedido gerado: " + cC5Num)
               Alert("Pedido gerado: " + cC5Num + ", na unidade de faturamento")

               cQUpdF2 :=""
                cQUpdF2 +="UPDATE " + RetSqlName("SF1") + " SET F1_XGERPED ='S', F1_XNUMPED = '"+cC5Num+"'"
                cQUpdF2 +=" WHERE D_E_L_E_T_ <> '*' AND F1_FILIAL = '"+ _cFilial +"' AND F1_DOC = '"+ _cDoc +"' AND F1_SERIE = '"+ _cSerie +"' AND F1_FORNECE = '"+ _cFornece +"' AND F1_LOJA = '"+_cLoja+"'"
                nErro := TcSqlExec(cQUpdF2)		
                If nErro != 0
                    Alert("Erro na execução da query cQUpdF2: "+TcSqlError(), "Atenção")
                Else
                    Alert("Nota de Entrada Atualizada: " + _cDoc)
                Endif 

               // GERANOTA(cFilAnt, cC5Num, _cCarga, cZXUNIFAT, cZXFILFAT)
            Else
               DisarmTransaction()
               aErro := GetAutoGRLog()
               cErro := ""
               If !Empty(aErro)
                  For nE := 1 To Len(aErro)
                     cErro += aErro[nE] + Chr(13)+Chr(10)
                  Next nE
                  cErro := EncodeUtf8(cErro) 
               EndIf                           
               
               If !Empty(aErro)
                  Conout("================== aErro =====================")
                  Conout(cErro)
                  Conout("================== aErro =====================")
               EndIf
               Alert("Erro na inclusao!")
               Mostraerro()
            EndIf
         End Transaction
      EndIf
      (AliasF1)->(DBCloseArea())
      (AliasD1)->(DBCloseArea())
   Next nX
   (AliasQtde)->(DBCloseArea())
   
   Alert("FIM")
   Close(oDlg)

   // Volto para a filial correta anterior:
   cFilAnt := cSvFilAnt

// RESET ENVIRONMENT 

Return


