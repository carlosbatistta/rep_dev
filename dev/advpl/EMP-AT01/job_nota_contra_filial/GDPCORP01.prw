
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#include "rwmake.ch"

//!####################################################################
//! Função: GDCONSOL Criado por: GAMADEVBR 20/04/2022
//! Descrição: Consolidação dos Pedidos
//!####################################################################

User Function GDCONSOL()
	@ 0,0 to 300,300 Dialog oDlg Title "1-Consolidacao dos Pedidos"
	@ 105,10 BmpButton Type 1 Action	Processa( {|| DLCONSOL() } )
	@ 105,60 BmpButton Type 2 Action Close(oDlg)
	ACTIVATE DIALOG oDlg CENTER
return nil

Static Function DLCONSOL()
 
   Local aCabec := {}
   Local aItens := {}
   Local aErro := {}
   Local nE
   // Local nP
   Local cSvFilAnt := cFilAnt
   Local cC5Num
   Local cZXEMPVEND:= ""
   Local cZXFILFAT := ""
   Local cZXUNIFAT := ""
   Local cZXTESCON := ""
   Local cZXTESTRAN:= ""
   Local cZXCLICON := ""
   Local cZXLJCON  := ""
   Local cZXCLITRAN:= ""
   Local cZXLJTRAN := ""
   Local cZXFORCON := ""
   Local cZXLJFCON := ""
   // Local nTotal := 0

   Private lMsErroAuto := .F.  

   //! C5_XCORP   = S (S=Sim; N=Não) - indica que o pedido é corporativo
   //! C5_XCORINC = S (S=Sim; N=Não) - indica que pedido já passou pelo processo de consolidação
   //! C5_XCONSOL = S (S=Sim; N=Não) - indica que esse é um novo pedido gerado no processo de consolidação
   //! C5_XPROBLE = S (S=Sim; N=Não) - indica que o pedido tem algum problema, no caso, não está liberado, o usuário pode corrigir e marcar com Sim, caso o problema continue a rotina vai marcar ele novamente com S
   // PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01' MODULO "FAT" TABLES "SC5","SC6","SA1","SA2","SB1","SB2","SF4"
   // SELECIONA CARGA COM PEDIDOS LIBERADOS
   cQtdCarga := ""
   cQtdCarga += "SELECT DAK.DAK_FILIAL AS 'DAKFILIAL', DAK.DAK_COD AS 'DAKCOD', DAK.DAK_SEQCAR AS 'DAKSEQCAR', C5.C5_XEMPVEN  AS 'C5XEMPVEN'"
   cQtdCarga += " FROM " + RetSqlName("DAK") + " AS DAK"
   cQtdCarga += " INNER JOIN " + RetSqlName("DAI") + " AS DAI ON DAI.DAI_COD = DAK.DAK_COD"
   cQtdCarga += " INNER JOIN " + RetSqlName("SC9") + " AS C9 ON C9.C9_PEDIDO = DAI.DAI_PEDIDO"
   cQtdCarga += " INNER JOIN " + RetSqlName("SC5") + " AS C5 ON C5.C5_NUM = DAI.DAI_PEDIDO"
   cQtdCarga += " WHERE"
   cQtdCarga += " DAK.D_E_L_E_T_ <> '*' AND DAI.DAI_SEQCAR = DAK_SEQCAR"
   // cQtdCarga += " AND DAK_XCONSO =''" //! descomentar para não deixar gerar mais
   cQtdCarga += " AND"
   cQtdCarga += " C9.C9_FILIAL =  DAK.DAK_FILIAL AND C9.C9_CLIENTE = DAI.DAI_CLIENT  AND C9.C9_LOJA = DAI.DAI_LOJA"
   cQtdCarga += " AND"
   cQtdCarga += " C5.C5_FILIAL =  DAK.DAK_FILIAL AND C5.C5_CLIENTE = DAI.DAI_CLIENT  AND C5.C5_LOJACLI = DAI.DAI_LOJA"
   cQtdCarga += " AND"
   cQtdCarga += " C5.C5_XCORP = 'S' AND C5.C5_XCORINC = ''"
   cQtdCarga += " GROUP BY DAK.DAK_FILIAL, DAK.DAK_COD, DAK.DAK_SEQCAR, C5.C5_XEMPVEN"
   cQtdCarga += " ORDER BY DAK.DAK_COD" 
   cQtdCarga := ChangeQuery(cQtdCarga)
   AliasCarga := CriaTrab(,.F.)
   DbUseArea(.T., "TOPCONN", TCGenQry(,,cQtdCarga), AliasCarga, .F., .T.)
   // SELECT DAK.DAK_FILIAL AS 'DAKFILIAL',DAK.DAK_COD AS 'DAKCOD',DAK.DAK_SEQCAR AS 'DAKSEQCAR',C5.C5_XEMPVEN AS 'C5XEMPVEN' FROM DAK010 AS DAK INNER JOIN DAI010 AS DAI ON DAI.DAI_COD = DAK.DAK_COD INNER JOIN SC9010 AS C9 ON C9.C9_PEDIDO = DAI.DAI_PEDIDO INNER JOIN SC5010 AS C5 ON C5.C5_NUM = DAI.DAI_PEDIDO INNER JOIN SC6010 AS C6 ON C6.C6_NUM = C5.C5_NUM WHERE  DAK.D_E_L_E_T_ <> '*' AND DAI.DAI_SEQCAR = DAK_SEQCAR AND C9.C9_FILIAL = DAK.DAK_FILIAL AND C9.C9_CLIENTE = DAI.DAI_CLIENT AND C9.C9_LOJA = DAI.DAI_LOJA AND C5.C5_FILIAL = DAK.DAK_FILIAL AND C5.C5_CLIENTE = DAI.DAI_CLIENT AND C5.C5_LOJACLI = DAI.DAI_LOJA AND C5.C5_XCORP = 'S' AND C5.C5_XCORINC = ' ' AND C6.C6_FILIAL = DAK.DAK_FILIAL AND C6.C6_CLI = DAI.DAI_CLIENT AND C6.C6_LOJA = DAI.DAI_LOJA GROUP BY DAK.DAK_FILIAL, DAK.DAK_COD, DAK.DAK_SEQCAR, C5.C5_XEMPVEN  ORDER BY  DAK.DAK_COD

   While !(AliasCarga)->(Eof())
      cQryC5 := ""
      cQryC5 += "SELECT DISTINCT"
      cQryC5 += " DAK.DAK_FILIAL AS 'DAKFILIAL',"
      cQryC5 += " DAK.DAK_COD AS 'DAKCOD',"
      cQryC5 += " DAK.DAK_SEQCAR AS 'DAKSEQCAR',"
      cQryC5 += " DAI.DAI_PEDIDO AS 'DAIPEDIDO',"
      cQryC5 += " DAI.DAI_CLIENT AS 'DAICLIENT',"
      cQryC5 += " DAI.DAI_LOJA AS 'DAILOJA',"
      cQryC5 += " C5.C5_XEMPVEN AS 'C5XEMPVEN'"
      cQryC5 += " FROM " + RetSqlName("DAK") + " AS DAK"
      cQryC5 += " INNER JOIN " + RetSqlName("DAI") + " AS DAI ON DAI.DAI_COD = DAK.DAK_COD AND DAI.D_E_L_E_T_ <> '*'"
      cQryC5 += " INNER JOIN " + RetSqlName("SC5") + " AS C5 ON C5.C5_NUM = DAI.DAI_PEDIDO AND C5.D_E_L_E_T_ <> '*'"
      cQryC5 += " WHERE"
      cQryC5 += " DAK.D_E_L_E_T_ <> '*'"
      cQryC5 += " AND DAK.DAK_FILIAL = '"+(AliasCarga)->DAKFILIAL+"'"
      cQryC5 += " AND DAK.DAK_COD = '"+(AliasCarga)->DAKCOD+"'"
      cQryC5 += " AND DAI.DAI_SEQCAR = '"+(AliasCarga)->DAKSEQCAR+"'"
      cQryC5 += " AND C5.C5_XEMPVEN ='"+(AliasCarga)->C5XEMPVEN+"'"
      cQryC5 += " AND C5.C5_FILIAL   =  DAK.DAK_FILIAL"
      cQryC5 += " AND C5.C5_CLIENTE  = DAI.DAI_CLIENT"
      cQryC5 += " AND C5.C5_LOJACLI  = DAI.DAI_LOJA"
      cQryC5 += " AND C5.C5_XCORP    = 'S'"
      cQryC5 += " AND C5.C5_XCORINC  = ''"
      cQryC5 += " ORDER BY DAK.DAK_COD, DAI.DAI_PEDIDO"
      cQryC5 := ChangeQuery(cQryC5)
      AliasC5 := CriaTrab(,.F.)
      DbUseArea(.T., "TOPCONN", TCGenQry(,,cQryC5), AliasC5, .F., .T.)
      // SELECT DISTINCT DAK.DAK_FILIAL AS 'DAKFILIAL',DAK.DAK_COD AS 'DAKCOD',DAK.DAK_SEQCAR AS 'DAKSEQCAR',DAI.DAI_PEDIDO AS 'DAIPEDIDO',C9.C9_LOCAL AS 'C9LOCAL',C9.C9_ITEM AS 'C9ITEM',C9.C9_PRODUTO AS 'C9PRODUTO',C9.C9_QTDLIB AS 'C9QTDLIB',C9.C9_PRCVEN AS 'C9PRCVEN',C5.C5_XEMPVEN AS 'C5XEMPVEN' FROM DAK010 AS DAK INNER JOIN DAI010 AS DAI ON DAI.DAI_COD = DAK.DAK_COD AND DAI.D_E_L_E_T_ <> '*' INNER JOIN SC9010 AS C9 ON C9.C9_PEDIDO = DAI.DAI_PEDIDO AND C9.D_E_L_E_T_ <> '*' INNER JOIN SC5010 AS C5 ON C5.C5_NUM = DAI.DAI_PEDIDO AND C5.D_E_L_E_T_ <> '*' INNER JOIN SC6010 AS C6 ON C6.C6_NUM = C5.C5_NUM AND C6.D_E_L_E_T_ <> '*' WHERE  DAK.D_E_L_E_T_ <> '*' AND DAK.DAK_FILIAL = '01010101001' AND DAK.DAK_COD = '000003' AND DAI.DAI_SEQCAR = '01' AND C5.C5_XEMPVEN ='01020101000' AND C9.C9_FILIAL = DAK.DAK_FILIAL AND C9.C9_CLIENTE = DAI.DAI_CLIENT AND C9.C9_LOJA = DAI.DAI_LOJA AND C5.C5_FILIAL = DAK.DAK_FILIAL AND C5.C5_CLIENTE = DAI.DAI_CLIENT AND C5.C5_LOJACLI = DAI.DAI_LOJA AND C5.C5_XCORP = 'S' AND C5.C5_XCORINC = ' ' AND C6.C6_FILIAL = DAK.DAK_FILIAL AND C6.C6_CLI = DAI.DAI_CLIENT AND C6.C6_LOJA = DAI.DAI_LOJA  ORDER BY  DAK.DAK_COD, DAI.DAI_PEDIDO, C9.C9_ITEM

      If !(AliasC5)->(Eof())

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
         cQrySZX += " RTRIM(LTRIM(ZX.ZX_LJFCON)) AS ZXLJFCON,"
         cQrySZX += " ZX.ZX_PERCPRC AS ZXPERCPRC"
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
            nZXPERCPRC   := (AliasSZX)->ZXPERCPRC
         Else
            Alert("Empresa não cadastrada nos parametros SZX: " + (AliasC5)->C5XEMPVEN)
            Loop // volta  para For nP := 1 To (AliasCarga)->PEDIDOS
         EndIf

         _cFilial    := (AliasC5)->DAKFILIAL
         _cCarga     := (AliasC5)->DAKCOD
         _cSeqCar    := (AliasC5)->DAKSEQCAR
         _cPedido    := (AliasC5)->DAIPEDIDO
         cFilAnt     := cZXEMPVEND //! seta a empresa vendedora

         cC5Num :=  GetSx8Num("SC5")
         SC5->(dbSetOrder(1))
         While SC5->(dbSeek(xFilial("SC5")+cC5Num))
            cC5Num :=  GetSxeNum("SC5", "C5_NUM")
         EndDo

         aCabec := {}
         aItens := {}
         aadd(aCabec,{"C5_NUM",       cC5Num,        Nil})
         aadd(aCabec,{"C5_FILIAL",    cZXEMPVEND,    Nil})
         aadd(aCabec,{"C5_TIPO",      "N",           Nil})
         aadd(aCabec,{"C5_TIPOCLI",   "R",           Nil})
         aadd(aCabec,{"C5_CLIENTE",   Padr(cZXCLICON,TamSX3("C5_CLIENTE")[1]),     Nil})
         aadd(aCabec,{"C5_LOJACLI",   Padr(cZXLJCON,TamSX3("C5_LOJACLI")[1]),      Nil})
         aadd(aCabec,{"C5_LOJAENT",   Padr(cZXLJCON,TamSX3("C5_LOJAENT")[1]),      Nil})
         aadd(aCabec,{"C5_CONDPAG",   "009",         Nil})    // 002  
         aadd(aCabec,{"C5_TABELA",    "003",         Nil})    // 003 
         aadd(aCabec,{"C5_NATUREZ",   "11122001",           Nil})    // 11111001   1211003001
         aadd(aCabec,{"C5_ORIGEM",    "GDCONSOL",    Nil})     
         //! campos criados
         aadd(aCabec,{"C5_XCONSOL",    "S",          Nil})     
         aadd(aCabec,{"C5_XDTCONS",    dDataBase,    Nil})     
         aadd(aCabec,{"C5_XHRCONS",    Time(),       Nil})     
         aadd(aCabec,{"C5_XCARORI",    (AliasC5)->DAKCOD,   Nil})     
         aadd(aCabec,{"C5_XFILORI",    (AliasC5)->DAKFILIAL,   Nil}) 
         aadd(aCabec,{"C5_XEMPVEN",    cZXEMPVEND,   Nil}) //! grava XEMPVEND para saber para qual empresa deve gerar a nota de saida do pedido consolidado
         aadd(aCabec,{"C5_XUNDFAT",    cZXUNIFAT,    Nil})
         aadd(aCabec,{"C5_XFILFAT",    cZXFILFAT,    Nil})   
         aadd(aCabec,{"C5_XNFSAI1",    "N",          Nil})  // indica que ainda não gerou NF de saída da empresa vendedora



         //!############################################
         //!SELECINA OS ITENS DO PEDIDO
         //!############################################
         cQryItens := ""
         cQryItens += "SELECT"
         cQryItens += " C9.C9_PRODUTO as 'C9PRODUTO',"
         cQryItens += " SUM(C9.C9_QTDLIB) AS 'QTDE'"
         cQryItens += " FROM " + RetSqlName("SC9") + " AS C9"
         cQryItens += " INNER JOIN SC5010 AS C5 ON C5.C5_NUM = C9_PEDIDO AND C5.D_E_L_E_T_ <> '*'"
         cQryItens += " WHERE"
         cQryItens += " C9.D_E_L_E_T_ <> '*'"
         cQryItens += " AND C9.C9_BLEST = ''"
         cQryItens += " AND C9.C9_BLOQUEI = ''"
         cQryItens += " AND C9.C9_FILIAL = '"+(AliasCarga)->DAKFILIAL+"'"
         cQryItens += " AND C9.C9_CARGA = '"+(AliasCarga)->DAKCOD+"'"
         cQryItens += " AND C9.C9_SEQCAR = '"+(AliasCarga)->DAKSEQCAR+"'"
         cQryItens += " AND C5.C5_XEMPVEN ='"+(AliasCarga)->C5XEMPVEN+"'"
         cQryItens += " AND C5.C5_XCORP    = 'S'"
         cQryItens += " AND C5.C5_XCORINC  = ''"
         cQryItens += " GROUP BY C9_PRODUTO"
         cQryItens := ChangeQuery(cQryItens)
         AliasItens := CriaTrab(,.F.)
         DbUseArea(.T., "TOPCONN", TCGenQry(,,cQryItens), AliasItens, .F., .T.)



         _cItem := 0  
         While !((AliasItens))->(Eof())

            //* ###########################################################
            //* CONSULTA O MENOR PREÇO
            //* ###########################################################
            cQryPreco := ""
            cQryPreco += " SELECT DISTINCT TOP 1 DAK.DAK_FILIAL AS 'DAKFILIAL', DAK.DAK_COD AS 'DAKCOD', DAK.DAK_SEQCAR AS 'DAKSEQCAR',"
            cQryPreco += " DAI.DAI_PEDIDO AS 'DAIPEDIDO', DAI.DAI_CLIENT AS 'DAICLIENT', DAI.DAI_LOJA AS 'DAILOJA',"
            cQryPreco += " C9.C9_LOCAL AS 'C9LOCAL', C9.C9_ITEM AS 'C9ITEM', C9.C9_PRODUTO AS 'C9PRODUTO', C9.C9_QTDLIB AS 'C9QTDLIB', C9.C9_PRCVEN AS 'C9PRCVEN',"
            cQryPreco += " C5.C5_XEMPVEN AS 'C5XEMPVEN',"
            cQryPreco += " MIN(C9.C9_PRCVEN) OVER (PARTITION BY C9_PRODUTO) AS MENOR_PRECO"
            cQryPreco += " FROM " + RetSqlName("DAK") + " AS DAK"
            cQryPreco += " INNER JOIN " + RetSqlName("DAI") + " AS DAI ON DAI.DAI_COD = DAK.DAK_COD AND DAI.D_E_L_E_T_ <> '*'"
            cQryPreco += " INNER JOIN " + RetSqlName("SC9") + " AS C9 ON C9.C9_PEDIDO = DAI.DAI_PEDIDO AND C9.D_E_L_E_T_ <> '*'"
            cQryPreco += " INNER JOIN " + RetSqlName("SC5") + " AS C5 ON C5.C5_NUM = DAI.DAI_PEDIDO AND C5.D_E_L_E_T_ <> '*'"
            cQryPreco += " INNER JOIN " + RetSqlName("SC6") + " AS C6 ON C6.C6_NUM = C5.C5_NUM AND C6.D_E_L_E_T_ <> '*'"
            cQryPreco += " WHERE  DAK.D_E_L_E_T_ <> '*' "
            cQryPreco += " AND C9.C9_PRODUTO ='"+ (AliasItens)->C9PRODUTO +"'"
            cQryPreco += " AND DAK.DAK_FILIAL = '"+(AliasC5)->DAKFILIAL+"'"
            cQryPreco += " AND DAK.DAK_COD = '"+(AliasC5)->DAKCOD+"'"
            cQryPreco += " AND DAI.DAI_SEQCAR = '"+(AliasC5)->DAKSEQCAR+"'"
            cQryPreco += " AND C5.C5_XEMPVEN ='"+(AliasC5)->C5XEMPVEN+"'"
            cQryPreco += " AND C9.C9_FILIAL = DAK.DAK_FILIAL"
            cQryPreco += " AND C9.C9_CLIENTE = DAI.DAI_CLIENT"
            cQryPreco += " AND C9.C9_LOJA = DAI.DAI_LOJA"
            cQryPreco += " AND C5.C5_FILIAL = DAK.DAK_FILIAL"
            cQryPreco += " AND C5.C5_CLIENTE = DAI.DAI_CLIENT"
            cQryPreco += " AND C5.C5_LOJACLI = DAI.DAI_LOJA"
            cQryPreco += " AND C5.C5_XCORP = 'S' AND C5.C5_XCORINC = ' '" 
            cQryPreco += " AND C6.C6_FILIAL = DAK.DAK_FILIAL"
            cQryPreco += " AND C6.C6_CLI = DAI.DAI_CLIENT"
            cQryPreco += " AND C6.C6_LOJA = DAI.DAI_LOJA"
            cQryPreco += " ORDER BY  DAK.DAK_COD, DAI.DAI_PEDIDO, C9.C9_ITEM"
            cQryPreco := ChangeQuery(cQryPreco)
            AliasPreco := CriaTrab(,.F.)
            DbUseArea(.T., "TOPCONN", TCGenQry(,,cQryPreco), AliasPreco, .F., .T.)
            _nPreco := (AliasPreco)->MENOR_PRECO - ((AliasPreco)->MENOR_PRECO * nZXPERCPRC / 100)
            //* ###########################################################

            //* ###########################################################
            //* CONSULTA TES AUTOMÁTICAS
            //* ###########################################################
            cQryTES := ""
            cQryTES += " SELECT B1.B1_GRTRIB AS 'B1GRTRIB', B1.B1_GRPTI AS 'B1GRPTI', B1.B1_ORIGEM AS 'B1ORIGEM'"
            cQryTES += " FROM " + RetSqlName("SB1") + " AS B1"
            cQryTES += " WHERE B1.B1_COD ='"+(AliasItens)->C9PRODUTO+"' AND B1.D_E_L_E_T_ <> '*' "
            cQryTES := ChangeQuery(cQryTES)
            AliasTES := CriaTrab(,.F.)
            DbUseArea(.T., "TOPCONN", TCGenQry(,,cQryTES), AliasTES, .F., .T.)
            _cB1GRTRIB := Alltrim((AliasTES)->B1GRTRIB)
            _cB1GRPTI := Alltrim((AliasTES)->B1GRPTI)
            _cB1ORIGEM := Alltrim((AliasTES)->B1ORIGEM)

            // dbSelectArea("SB1")
            // dbSetOrder(1)
            // dbSeek(xFilial("SB1") + (AliasItens)->C9PRODUTO)
            // _cB1GRTRIB := Alltrim(SB1->B1_GRTRIB)
            // _cB1GRPTI := Alltrim(SB1->B1_GRPTI)
            // _cB1ORIGEM := Alltrim(SB1->B1_ORIGEM)
            
            _cTES := "513"
            If !empty(_cB1GRPTI)
               If _cB1GRPTI == "0005"
                  _cTES := "518"
               EndIf
            ElseIf _cB1GRTRIB == "000004" .AND. Val(_cB1ORIGEM) > 3
               _cTES := "510"
            ElseIf _cB1GRTRIB == "000004" .AND. _cB1ORIGEM $ "1/2/3"
               _cTES := "520"
            EndIf

            //* ###########################################################
            
            _cItem = _cItem + 1
            aLinha := {}
            aadd(aLinha,{"C6_ITEM",    STRZERO(_cItem, 2),                 Nil})
            aadd(aLinha,{"C6_LOCAL",   "01", Nil}) // Padr((AliasC5)->C9LOCAL, TamSX3("C6_LOCAL")[1])
            aadd(aLinha,{"C6_PRODUTO", AllTrim((AliasItens)->C9PRODUTO),   Nil})
            aadd(aLinha,{"C6_QTDVEN",  (AliasItens)->QTDE,                 Nil})
            aadd(aLinha,{"C6_QTDLIB",  (AliasItens)->QTDE,                 Nil})
            aadd(aLinha,{"C6_PRCVEN",  _nPreco,                            Nil})
            // aadd(aLinha,{"C6_PRCVEN",  (AliasC5)->C9PRCVEN,     Nil})
            aadd(aLinha,{"C6_PRUNIT",  _nPreco,                            Nil})
            aadd(aLinha,{"C6_VALOR",   Round( ( (AliasItens)->QTDE * _nPreco ), 2),   Nil})
            aadd(aLinha,{"C6_TES",  _cTES,                              Nil})
            aadd(aLinha,{"C6_OPER", "01",                               Nil})   
            aadd(aItens,aLinha)
            (AliasItens)->(DBSkip())
         Enddo
         (AliasItens)->(DBCloseArea())
         (AliasC5)->(DBCloseArea())
   
         // ! ######################################################################
         // ! Liberando pedido aqui para testar novamente, na producao remover isso  
         // ! ######################################################################  
         cQryUpd :=""
         cQryUpd +="UPDATE " + RetSqlName("SC9") + " SET C9_BLEST ='', C9_BLCRED ='', C9_NFISCAL ='', C9_SERIENF ='' WHERE D_E_L_E_T_ <> '*' AND C9_FILIAL = '"+ Alltrim(_cFilial) +"' AND C9_PEDIDO = '"+ Alltrim(_cPedido) +"'"
         nErro := TcSqlExec(cQryUpd)		
         If nErro != 0
            ConOut("Erro na execução da query cQryUpd: "+TcSqlError(), "Atenção")
         Else
            ConOut("Pedido liberado")
         Endif

         Begin Transaction
            
            MSExecAuto({|x,y,z|mata410(x,y,z)},aCabec,aItens,3)

            If !lMsErroAuto
               ConfirmSX8()
               Alert("Sucesso na Consolidacao! Pedido :" + cC5Num + ", gerado com sucesso!!!")

               cQryUpdDAK :=""
               cQryUpdDAK +="UPDATE " + RetSqlName("DAK") + " SET DAK_XCONSO ='S', DAK_XPEDCO ='" + cC5Num + "' , DAK_XEMPVE ='" + cZXEMPVEND + "'"
               cQryUpdDAK +=" WHERE D_E_L_E_T_ <> '*' AND DAK_FILIAL = '"+ Alltrim(_cFilial) +"' AND DAK_COD = '"+ _cCarga +"' AND DAK_SEQCAR = '"+ _cSeqCar +"'"
               nErro := TcSqlExec(cQryUpdDAK)		
               If nErro != 0
                  Alert("Erro na execução da query cQryUpdDAK: "+TcSqlError(), "Atenção")
               Else
                  Alert("Carga Atualizada: " +  _cCarga + " Seq: " + _cSeqCar)
               Endif

               // cQryUPDC9 :=""
               // cQryUPDC9 +="UPDATE " + RetSqlName("SC9") + " SET C9_XPEDCON ='" + cC5Num + "', C9_XFILCON ='" + cFilAnt + "' WHERE C9_FILIAL = '"+ Alltrim(_cFilial) +"' AND C9_PEDIDO = '"+ Alltrim(_cPedido) +"'"
               // nErro := TcSqlExec(cQryUPDC9)		
               // If nErro != 0
               //    ConOut("Erro na execução da query cQryUPDC9: "+TcSqlError(), "Atenção")
               // Else
               //    ConOut("Carga Atualizada com a Filial")
               // Endif

               // cQryUPDC5 :=""
               // cQryUPDC5 +="UPDATE " + RetSqlName("SC5") + " SET C5_XCORINC ='S'"
               // cQryUPDC5 +=" WHERE R_E_C_N_O_ = " + CValToChar(_nC5Recno) //! atualiza esse pedido pra informar que ele foi incluido no processo de consolidação
               // nErro := TcSqlExec(cQryUPDC5)		
               // If nErro != 0
               //    ConOut("Erro na execução da query cQryUPDC5: "+TcSqlError(), "Atenção")
               // Else
               //    ConOut("Carga Atualizada com a Filial")
               // Endif
            Else
               aErro := GetAutoGRLog()
               cErro := ""
               If !Empty(aErro)
                  For nE := 1 To Len(aErro)
                     cErro += aErro[nE] + Chr(13)+Chr(10)
                  Next nE
                  cErro := EncodeUtf8(cErro) 
               EndIf                           
               
               Mostraerro()
            EndIf
         End Transaction

      EndIf
   (AliasCarga)->(DBSkip())
   
   cFilAnt := cSvFilAnt

   Enddo
   (AliasCarga)->(DBCloseArea())

   Alert("FIM")
   Close(oDlg)

   

Return
