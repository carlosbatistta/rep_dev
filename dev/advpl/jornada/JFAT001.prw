#Include "PROTHEUS.CH"
#Include "TOTVS.ch" 
#Include "RWMAKE.ch" 
#Include "TBICONN.ch"
#Include "RPTDEF.ch"
#Include "TOPCONN.CH"
 
//00
//rotinas execuo via JOB
//mauro nagata, lurin, 20211226
User Function JFAT001(aParam)

//Ita - 15/08/2023 - Default aParam	:= { "01","01010101000" }
Private _Enter  := chr(13) + Chr(10)
cLogPeds := ""
Default aParam	:= { "01",SM0->M0_CODFIL }

ConOut( "JFAT001 - Incio " + Dtoc( Date() ) + " " + Time() )

//RetailSales

_cEmp		:= Alltrim( aParam[1] )
_cFilial	:= Alltrim( aParam[2] )
_lCD := If(Alltrim(_cFilial) == "01010101000",.T.,.F.) //Ita - 17/07/2023
aNatFil := {} //Ita - 18/07/2023 - Array com filiais e suas respectivas naturezas
aAdd(aNatFil, {"01010101000","1211003001"})       //As naturezas: Trasnf. mercadoria CD: 1211003001
aAdd(aNatFil, {"01010101001","1211003002"}) //Trasnf. mercadoria filial Custdia: 1211003002 
aAdd(aNatFil, {"01010101002","1211003003"}) //Trasnf. mercadoria filial Afogados: 1211003003
aAdd(aNatFil, {"01010101003","1211003004"}) //Trasnf. mercadoria filial Sertnia: 1211003004
aAdd(aNatFil, {"01010101004","1211003005"}) //Trasnf. mercadoria filial Salgueiro: 1211003005
aAdd(aNatFil, {"01010101005","1211003006"}) //Trasnf. mercadoria filial Caruaru: 1211003006 

ConOut(_cEmp)
ConOut(_cFilial)

If IsBlind() 
   _cMsglog := "["+DTOC(Date())+"-"+Time()+"] JFAT001 - Rodando via job - Empresa: ["+_cEmp+"] Filial: ["+_cFilial+"]"
   MemoWrite("C:\TEMP\JFAT001_RUN_JOB_Empresa_"+_cEmp+"_Filial_"+_cFilial+"_.log",_cMsglog)
   MemoWrite("JFAT001_RUN_JOB_Empresa_"+_cEmp+"_Filial_"+_cFilial+"_.log",_cMsglog)
   RPCClearEnv()
   RPCSetType(3)
   RPCSetEnv(_cEmp,_cFilial,"","","FAT",,{"SB1"}) 

   _cEmp		:= Alltrim( aParam[1] )
   _cFilial	:= Alltrim( aParam[2] )
   _lCD := If(Alltrim(_cFilial) == "01010101000",.T.,.F.) //Ita - 17/07/2023
   aNatFil := {} //Ita - 18/07/2023 - Array com filiais e suas respectivas naturezas
   aAdd(aNatFil, {"01010101000","1211003001"})       //As naturezas: Trasnf. mercadoria CD: 1211003001
   aAdd(aNatFil, {"01010101001","1211003002"}) //Trasnf. mercadoria filial Custdia: 1211003002 
   aAdd(aNatFil, {"01010101002","1211003003"}) //Trasnf. mercadoria filial Afogados: 1211003003
   aAdd(aNatFil, {"01010101003","1211003004"}) //Trasnf. mercadoria filial Sertnia: 1211003004
   aAdd(aNatFil, {"01010101004","1211003005"}) //Trasnf. mercadoria filial Salgueiro: 1211003005
   aAdd(aNatFil, {"01010101005","1211003006"}) //Trasnf. mercadoria filial Caruaru: 1211003006 

Else
   _cMsglog := "["+DTOC(Date())+"-"+Time()+"] JFAT001 - Rodando via Menu - Empresa: ["+_cEmp+"] Filial: ["+_cFilial+"]"
   MemoWrite("C:\TEMP\JFAT001_RUN_MENU_Empresa_"+_cEmp+"_Filial_"+_cFilial+"_.log",_cMsglog)
   MemoWrite("JFAT001_RUN_MENU_Empresa_"+_cEmp+"_Filial_"+_cFilial+"_.log",_cMsglog)
EndIf

//PREPARE ENVIRONMENT EMPRESA _cEmp FILIAL _cFilial Modulo "FAT" Tables "SC5", "SC6", "DA1"

JEecuta()	

//RESET ENVIRONMENT 
If IsBlind() 
   RPCClearEnv()
   _cMsglog := "["+DTOC(Date())+"-"+Time()+"] JFAT001 - Finalizado execucao via job  - Empresa: ["+_cEmp+"] Filial: ["+_cFilial+"]"
   MemoWrite("C:\TEMP\JFAT001_END_JOB_Empresa_"+_cEmp+"_Filial_"+_cFilial+"_.log",_cMsglog)   
   MemoWrite("JFAT001_END_JOB_Empresa_"+_cEmp+"_Filial_"+_cFilial+"_.log",_cMsglog)   
Else
   _cMsglog := "["+DTOC(Date())+"-"+Time()+"] JFAT001 - Finalizado execucao via Menu  - Empresa: ["+_cEmp+"] Filial: ["+_cFilial+"]"
   MemoWrite("C:\TEMP\JFAT001_END_MENU_Empresa_"+_cEmp+"_Filial_"+_cFilial+"_.log",_cMsglog)   
   MemoWrite("JFAT001_END_MENU_Empresa_"+_cEmp+"_Filial_"+_cFilial+"_.log",_cMsglog)   
EndIf

ConOut( "JFAT001 - Fim " + Dtoc( Date() ) + " " + Time() )
cTxtLog := "JFAT001 - Fim " + Dtoc( Date() ) + " " + Time() + " - Empresa: ["+_cEmp+"] Filial: ["+_cFilial+"]"
MemoWrite("C:\TEMP\JFAT001_Fim_Empresa_"+_cEmp+"_Filial_"+_cFilial+"_.log",cTxtLog)
MemoWrite("JFAT001_Fim_Empresa_"+_cEmp+"_Filial_"+_cFilial+"_.log",cTxtLog)
MemoWrite("C:\TEMP\JFAT001_Pedidos_Empresa_"+_cEmp+"_Filial_"+_cFilial+"_.log",cLogPeds)
MemoWrite("JFAT001_Pedidos_Empresa_"+_cEmp+"_Filial_"+_cFilial+"_.log",cLogPeds)


Return()




Static Function JEecuta()

Local lRet        := .T.
Local cAliasQry 	:=  GetNextAlias() 
//Local nRecnoSC5   
//Local nRecnoSC6
Local nVlrUnit
//Ita - 21/08/2023 - Local cTabPrc     := "003"             //tabela de preo definida
Local cNaturez    := "1211003001"      //cdigo da natureza definido
Local aLastQuery   
Local cLogErro    := ""
Local nOpc        := 0
Local nCount      := 0
Local aCabec      := {}
Local aItens      := {}
Local aLinha      := {}
Local aErroAuto   := {}  
Local cNumPV
Local cNumOrc
Local nTotCDesc
Local ntotSDesc
Local nVlrTab
Local nVlrDesc
Local nVlrUnit
Private cTabPrc     := "003"             //tabela de preo definida
Private _CGC := Alltrim( SM0->M0_CGC )

//pedido normal
//vendedor 1 informado
//tabela de preo no informada
//natureza no informado
//pedido no faturado


BeginSql Alias cAliasQry    
   %noParser%

   SELECT   SC5.C5_NUM, C5_VEICULO
         
   FROM     %Table:SC5% SC5

   WHERE
         SC5.%NotDel% 		                       
         AND SC5.C5_FILIAL    = %xFilial:SC5%	 
         AND SC5.C5_TIPO      = 'N'
         AND SC5.C5_VEND1     <> ''
         AND SC5.C5_TABELA    = ''
         AND SC5.C5_NATUREZ   = ''
         AND SC5.C5_LIBEROK <> ''
         AND SC5.C5_NOTA = ''
   ORDER BY SC5.C5_NUM
     
EndSql

aLastQuery    := GetLastQuery()
cLastQuery    := aLastQuery[2]

ConOut(cLastQuery)

MemoWrite("C:\TEMP\JEecuta.SQL",cLastQuery)
MemoWrite("JEecuta.SQL",cLastQuery)
cpare:=""
If !Eof()

   BEGIN TRANSACTION

      Do While !Eof()

         //nmero do pedido de vendas
         cNumPV := (cAliasQry)->C5_NUM
         _cVeicul := (cAliasQry)->C5_VEICULO //Ita - 15/09/2023
         If Empty(_cVeicul)
            _cVeicul := ""
         EndIf

         cCliPV := "02115136" //(cAliasQry)->C5_CLIENTE //Ita - 17/07/2023
         //cLojPV := "0"+Right(Alltrim( _cFilial ),3) //(cAliasQry)->C5_LOJACLI //"         "
         _cArea := GetArea()
         cLojPV := Posicione("SA1",3,FWxFilial("SA1")+_CGC,"A1_LOJA")
         RestArea(_cArea)

         cCliEnt  := cCliPV
         cLojEnt  := cLojPV
         //cTipReaj := (cAliasQry)->C5_REAJUST
         cCndPg   := "002" //(cAliasQry)->C5_CONDPAG
         cVnd1    := "186"
         cTpFret  := "S" //S - SEM FRETE

         cCGCCli := Posicione("SA1",1,FWxFilial("SA1")+cCliPV+cLojPV,"A1_CGC")

         

         //posiciona o pedido de vendas
         DbSelectArea( "SC5" ) 
         DbSetOrder(1)
         DBSeek(xFilial("SC5")+cNumPV)

         ConOut(cNumPV)

         ////substitudo bloco acima pelo abaixo [Mauro Nagata, www.lurin.com.br, 20220502]
         aCabec         := {}
         aItens         := {}
         aLinha         := {}
         lMsErroAuto    := .F.
         _cOperPV := If(_lCD,"08","09") //Ita - 17/07/2023
         //12345678901
         //01010101005
         nPsNat := aScan(aNatFil, {|x,y| x[1] == Substr(Alltrim( _cFilial ),1,11) }) //Ita - 18/07/2023
         If nPsNat > 0
            cNaturez := aNatFil[nPsNat,2] //Obtm a natureza correspondente a filial
         EndIf

         aAdd( aCabec, { "C5_NUM"     , cNumPV     , Nil } )
         //Ita - 30/08/2023 - aAdd( aCabec, { "C5_CLIENTE"  , cCliPV    , Nil } )
         //Ita - 30/08/2023 - aAdd( aCabec, { "C5_LOJACLI"  , cLojPV    , Nil } )
         aAdd( aCabec, { "C5_TABELA"  , cTabPrc    , Nil } )
         aAdd( aCabec, { "C5_NATUREZ" , cNaturez   , Nil } )

         //Ita - 30/08/2023 - aAdd( aCabec, { "C5_CLIENT" , cCliEnt     , Nil } ) //Cliente Entrega
         //Ita - 30/08/2023 - aAdd( aCabec, { "C5_LOJAENT" , cLojEnt    , Nil } ) //Loja Entrega
         //aAdd( aCabec, { "C5_REAJUST" , cTipReaj   , Nil } ) //Tipo Reajuste
         aAdd( aCabec, { "C5_CONDPAG" , cCndPg     , Nil } ) //Condio Pagamento  [desde que seja diferente do Tipo 9, conforme faq em anexo]
         aAdd( aCabec, { "C5_VEND1"   , cVnd1      , Nil } ) //Vendedor - (Todos os pedidos devem ter a mesma quantidade de vendedores, registrados os mesmos cdigos, e nos mesmos campos)
         aAdd( aCabec, { "C5_VEND1"   , cVnd1      , Nil } ) //Vendedor 1 - (Todos os pedidos devem ter a mesma quantidade de vendedores, registrados os mesmos cdigos, e nos mesmos campos)
         //aAdd( aCabec, { "C5_VEND2"   , cVnd2      , Nil } ) //Vendedor 2 - (Todos os pedidos devem ter a mesma quantidade de vendedores, registrados os mesmos cdigos, e nos mesmos campos)
         //aAdd( aCabec, { "C5_VEND3"   , cVnd3      , Nil } ) //Vendedor 3 - (Todos os pedidos devem ter a mesma quantidade de vendedores, registrados os mesmos cdigos, e nos mesmos campos)
         //aAdd( aCabec, { "C5_VEND4"   , cVnd4      , Nil } ) //Vendedor 4 - (Todos os pedidos devem ter a mesma quantidade de vendedores, registrados os mesmos cdigos, e nos mesmos campos)
         //aAdd( aCabec, { "C5_VEND5"   , cVnd5      , Nil } ) //Vendedor 5 - (Todos os pedidos devem ter a mesma quantidade de vendedores, registrados os mesmos cdigos, e nos mesmos campos)
         //Ita - 15/09/2023 - aAdd( aCabec, { "C5_TPFRETE" , cTpFret    , Nil } ) //Tipo de Frete
         aAdd( aCabec, { "C5_TPFRETE" , 'R'    , Nil } ) //Tipo de Frete - R-Por conta do remetente
         
         //aAdd( aCabec, { "C5_TRANSP"  , cTransp    , Nil } ) //Transportadora
         //aAdd( aCabec, { "C5_INCISS"  , cIncISS    , Nil } ) //ISS Incluso
         //aAdd( aCabec, { "C5_RECISS"  , cRecISS    , Nil } ) //Recolhe ISS
         //aAdd( aCabec, { "C5_FORNISS" , cForISS    , Nil } ) //Fornecedor ISS
         //aAdd( aCabec, { "C5_INDPRES" , cIndPres   , Nil } ) //Presena Com 
         aAdd( aCabec, { "C5_ESPECI1" , "SPED"    , Nil } ) //Ita - 30/08/2023 - Alterar de  NFCE para SPED
         aAdd( aCabec, { "C5_VEICULO" , _cVeicul  , Nil } ) //Ita - 15/09/2023
         /*
- Tipo Pedido (C5_TIPO)
- Cliente (C5_CLIENTE)
- Loja do Cliente (C5_LOJACLI)
- Tipo Cliente (C5_TIPOCLI)
- Cliente Entrega (C5_CLIENT)
- Loja Entrega (C5_LOJAENT)
- Tipo Reajuste (C5_REAJUST)
- Condio Pagamento (C5_CONDPAG) [desde que seja diferente do Tipo 9, conforme faq em anexo]
- Vendedores (C5_VEND'x') (Todos os pedidos devem ter a mesma quantidade de vendedores, registrados os mesmos cdigos, e nos mesmos campos)
- Tipo Frete (C5_TPFRETE)
- Transportadora (C5_TRANSP)
- ISS Incluso (C5_INCISS)
- Recolhe ISS (C5_RECISS)
- Fornecedor ISS (C5_FORNISS)
- Presena Com (C5_INDPRES)
         */

         DbSelectArea( "SC6" )
         DbSeek( xFilial( "SC6" ) + cNumPV )
         Do While !Eof() .And. SC6->C6_FILIAL == xFilial( "SC6" ) .And. SC6->C6_NUM == cNumPV

            ConOut("While-SC6")

            //Ita - 17/07/2023 - nVlrUnit := 0
            /*** Ita - Comentado para atender Regra informada por Carlos - 22/09/2023
            nVlrUnit := fGetUNFE(SC6->C6_PRODUTO) //Ita - 17/07/2023
            If nVlrUnit == 0
               nVlrUnit := BuscaPrc( cTabPrc, SC6->C6_PRODUTO )
            EndIf
            *******************************************************/
            If _lCD
               nVlrUnit := BuscaPrc( cTabPrc, SC6->C6_PRODUTO )
            Else
               nVlrUnit := fGetUNFE(SC6->C6_PRODUTO) //Ita - 17/07/2023
               If nVlrUnit == 0
                  nVlrUnit := BuscaPrc( cTabPrc, SC6->C6_PRODUTO )
               EndIf            
            EndIf

            aLinha := {}

            aAdd( aLinha,{ "C6_ITEM"      , SC6->C6_ITEM    , Nil } )
            aAdd( aLinha,{ "C6_PRODUTO"   , SC6->C6_PRODUTO , Nil } )
            aAdd( aLinha,{ "C6_QTDVEN"    , SC6->C6_QTDVEN  , Nil } )
            aAdd( aLinha,{ "C6_QTDLIB"    , SC6->C6_QTDVEN  , Nil } ) //Ita - 05/09/2023
            aAdd( aLinha,{ "C6_PRCVEN"    , nvlrUnit        , Nil } )
            aAdd( aLinha,{ "C6_PRUNIT"    , nvlrUnit        , Nil } )
            aAdd( aLinha,{ "C6_OPER"      , _cOperPV        , Nil } ) //Ita - 17/07/2023 - aAdd( aLinha,{ "C6_OPER"      , "08"            , Nil } )

            aAdd( aItens, aLinha )
         
            ConOut( "Montagem Item PV - Pedido de venda: " + SC5->C5_NUM + " Produto: " + SC6->C6_PRODUTO  )

            DbSelectArea( "SC6" )
            DbSkip()

         EndDo

         nOpc := 4 

         ConOut("antes-exec")
         
         MSExecAuto( { |a, b, c, d| MATA410( a, b, c, d ) }, aCabec, aItens, nOpc, .F. )
         
         ConOut("depois-exec")
         
         If !lMsErroAuto
         
            ConOut( "Alterado com sucesso! " + cNumPV )
            cLogPeds += "Alterado com sucesso! " + cNumPV + _Enter
            

            /////////////////////
            /// Ita - 20/07/2023
            ConOut( "Chamndo Funo fUpdOrcs - para alterar ocamentos..." )
            fUpdOrcs()
            ConOut("Retornou das alteraes dos oramentos")
            ///////////////////////////////////////////////////////////////////
         
         Else
         
            ConOut( "Erro na alterao" )
            cLogPeds += "Erro na alterao! " + cNumPV + _Enter
            MostraErro()
            aErroAuto := GetAutoGRLog()            

            For nCount := 1 To Len(aErroAuto)
               cLogErro += StrTran( StrTran( aErroAuto[nCount], "<", "" ), "-", "" ) + " "
               ConOut( cLogErro )
            Next nCount

            DbSelectArea( cAliasQry )
            DbSkip()
            Loop

         EndIf         
         
         //fim bloco [Mauro Nagata, www.lurin.com.br, 20220502]
         
         DbSelectArea( cAliasQry )
         DbSkip()

      EndDo 

   END TRANSACTION

   (cAliasQry)->( DbCloseArea() )

   ConOut( "JFAT001 - Query " + cLastQuery)
   ConOut( "JFAT001 - Finalizada a rotina do JOB" )

Else
   ConOut( "JFAT001 - No existe registro para esta query" )
   ConOut( "JFAT001 - Query " + cLastQuery)
   _Enter  := chr(13) + Chr(10)
   cTxtlog := "JFAT001 - No existe registro para esta query" + _Enter
   cTxtlog += "JFAT001 - Query " + cLastQuery
   MemoWrite("C:\TEMP\JFAT001.LOG",cTxtlog)
   MemoWrite("JFAT001.LOG",cTxtlog)

Endif

Return lRet



//Excludo bloco abaixo [Mauro Nagata, wwww.lurin.com.br, 20220502]
//busca o preo do produto na tabela de preo
Static Function BuscaPrc( cTabela, cCodProd )        
Local aLastQuery  := {} 
Local cLastQuery  := ""
Local cAlias 	   := GetNextAlias() 
//Ita - 17/07/2023 Local nVlrUnit    := 999999999      //caso no localize o valor do produto na tabela de preo
Local nVlrUnit    := 1      //Ita - 17/07/2023 - caso no localize o valor do produto na tabela de preo

BEGINSQL ALIAS cAlias
   %noParser%        
   SELECT	DA1.DA1_PRCVEN 
   FROM 	   %Table:DA1%  DA1
   WHERE 	DA1.%NotDel%
            AND DA1.DA1_FILIAL = %xFilial:DA1%
            AND DA1.DA1_CODTAB = %Exp:cTabela%
            AND DA1.DA1_CODPRO = %Exp:cCodProd%   
            
ENDSQL

//se encontrar o produto na tabela de preo 
If !Eof()
   aLastQuery    := GetLastQuery()
   cLastQuery    := aLastQuery[2] 

   ConOut( "JFAT001 - Query executada: " + cLastQuery )
   MemoWrite("C:\TEMP\BuscaPrc.SQL",cLastQuery)
   MemoWrite("BuscaPrc.SQL",cLastQuery)

   nVlrUnit := (cAlias)->DA1_PRCVEN
EndIf

(cAlias)->( DbCloseArea() )

Return( nVlrUnit )

//fim bloco  [Mauro Nagata, wwww.lurin.com.br, 20220502]

//////////////////////
/// Ita - 17/07/2023
///       Funo fGetUNFE
///       Obttm valor da ltima NF de Entrada.
///////////////////////////////////////////////

Static Function fGetUNFE(xProd)//,xFornece,xLojFor)
   
   Local _Enter  := chr(13) + Chr(10)
   Local cQryUNFE := ""

   cQryUNFE := " SELECT SD1.D1_FILIAL,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_FORNECE, " + _Enter
   cQryUNFE += "        SD1.D1_LOJA,SD1.D1_EMISSAO,SD1.D1_ITEM,SD1.D1_COD,SD1.D1_VUNIT " + _Enter
   cQryUNFE += "   FROM "+RetSQLName("SD1")+" SD1 " + _Enter
   cQryUNFE += "  WHERE SD1.D1_FILIAL = '"+FWxFilial("SD1")+"'" + _Enter
   cQryUNFE += "    AND SD1.D1_TIPO = 'N'" + _Enter
   cQryUNFE += "    AND SD1.D1_COD = '"+xProd+"'" + _Enter
   //cQryUNFE += "    AND SD1.D1_FORNECE = '"+xFornece+"'" + _Enter
   //cQryUNFE += "    AND SD1.D1_LOJA = '"+xLojFor+"'" + _Enter
   cQryUNFE += "    AND SD1.D_E_L_E_T_ <> '*'" + _Enter
   cQryUNFE += "  ORDER BY SD1.D1_EMISSAO DESC" + _Enter

   MemoWrite("C:\TEMP\fGetUNFE.SQL",cQryUNFE)
   MemoWrite("fGetUNFE.SQL",cQryUNFE)

   TCQuery cQryUNFE NEW ALIAS "XUNFESD1"

   TCSetField("XUNFESD1","D1_VUNIT","N",TamSX3("D1_VUNIT")[1],TamSX3("D1_VUNIT")[2])
   DbSelectArea("XUNFESD1")
   _nRtUVlr := If(XUNFESD1->D1_VUNIT > 0, XUNFESD1->D1_VUNIT, 0)
   DbCloseArea()

Return(_nRtUVlr)

/////////////////////////////
/// Ita - 20/07/2023
///       Funo fUpdOrcs
///       Atualiza Oramentos
//////////////////////////////////////
Static Function fUpdOrcs
      
   nTotCDesc   := 0
   nTotSDesc   := 0
   cNumOrc     := SC5->C5_ORCRES

   ConOut("ORCRES -> " + cNumOrc)
         
   DbSelectArea( "SL2" ) 
   DbSetOrder(1)
   If DbSeek( xFilial( "SL2" ) + cNumOrc )

      ConOut("achou-sl2->"+cNumOrc)

      Do While !Eof() .And. SL2->L2_FILIAL = xFilial( "SL2" ) .And. SL2->L2_NUM == cNumOrc

         ConOut("while-sl2")

         nVlrTab := 0
         nVlrTab := BuscaPrc( cTabPrc, SL2->L2_PRODUTO )

         nVlrDesc := SL2->L2_VALDESC

         RecLock( "SL2", .F. )
         SL2->L2_VRUNIT    := nVlrTab
         SL2->L2_VLRITEM   := ( nVlrTab - nVlrDesc ) * SL2->L2_QUANT
         SL2->( MsUnLock() )

         nTotCDesc += SL2->L2_VLRITEM
         ntotSDesc += (SL2->L2_VRUNIT * SL2->L2_QUANT)

         //ConOut( "Gravao Item Oramento SL2 - Oramento: " + cNumOrc + " Pedido de venda: " + SC5->C5_NUM + " Produto: " + SC6->C6_PRODUTO + " Preo: "+ Str( SC6->C6_PRCVEN, 14, 2 ) )

         DbSelectArea( "SL2" )
         DbSkip()

      EndDo

      DbSelectArea( "SL1" )      //oramento
      DbSetOrder(1)
      If DbSeek( xFilial( "SL1" ) + cNumOrc )
         
         ConOut( "Achou SL1 - Oramento: " + xFilial( "SL1" )+"|"+cNumOrc )

         RecLock( "SL1", .F. )
         SL1->L1_VLRTOT    := nTotCDesc
         SL1->L1_VALMERC   := nTotSDesc
         SL1->( MsUnLock() )

         ConOut( "Gravao Oramento SL1 - Oramento: " + cNumOrc )


         //ConOut( "Gravao Oramento SL1 - Oramento: " + cNumOrc + " Pedido de venda: " + SC5->C5_NUM + " Produto: " + SC6->C6_PRODUTO + " Total C/Desc: "+ Str(  nTotCDesc, 14, 2 ) + " Total S/Desc: "+ Str(  nTotSDesc, 14, 2 ) )

      EndIf

      DbSelectArea( "SL4" )   //condio negociada
      DbSetOrder(1)
      If DbSeek( xFilial( "SL4" ) + cNumOrc )

         ConOut( "Achou SL4 - Oramento: " + xFilial( "SL4" ) +"|"+ cNumOrc )

         RecLock( "SL4", .F. )
         SL4->L4_VALOR     := nTotCDesc
         SL4->( MsUnLock() )

         ConOut( "Gravao Oramento SL4 - Oramento: " + cNumOrc )

         //ConOut( "Gravao Oramento SL4 - Oramento: " + cNumOrc + " Pedido de venda: " + SC5->C5_NUM + " Produto: " + SC6->C6_PRODUTO + " Total C/Desc: "+ Str(  nTotCDesc, 14, 2 ) )
      EndIf

   EndIf
Return
