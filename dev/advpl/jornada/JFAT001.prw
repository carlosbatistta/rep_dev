#Include "PROTHEUS.CH"
#Include "TOTVS.ch" 
#Include "RWMAKE.ch" 
#Include "TBICONN.ch"
#Include "RPTDEF.ch"
#Include "TOPCONN.CH"
 
//00
//rotinas execução via JOB
//mauro nagata, lurin, 20211226
User Function JFAT001(aParam)

//Ita - 15/08/2023 - Default aParam	:= { "01","01010101000" }
Private _Enter  := chr(13) + Chr(10)
cLogPeds := ""
Default aParam	:= { "01",SM0->M0_CODFIL }

ConOut( "JFAT001 - Início " + Dtoc( Date() ) + " " + Time() )

//RetailSales

_cEmp		:= Alltrim( aParam[1] )
_cFilial	:= Alltrim( aParam[2] )
_lCD := If(Alltrim(_cFilial) == "01010101000",.T.,.F.) //Ita - 17/07/2023
aNatFil := {} //Ita - 18/07/2023 - Array com filiais e suas respectivas naturezas
aAdd(aNatFil, {"01010101000","1211003001"})       //As naturezas: Trasnf. mercadoria CD: 1211003001
aAdd(aNatFil, {"01010101001","1211003002"}) //Trasnf. mercadoria filial Custódia: 1211003002 
aAdd(aNatFil, {"01010101002","1211003003"}) //Trasnf. mercadoria filial Afogados: 1211003003
aAdd(aNatFil, {"01010101003","1211003004"}) //Trasnf. mercadoria filial Sertânia: 1211003004
aAdd(aNatFil, {"01010101004","1211003005"}) //Trasnf. mercadoria filial Salgueiro: 1211003005
aAdd(aNatFil, {"01010101005","1211003006"}) //Trasnf. mercadoria filial Caruaru: 1211003006 

ConOut(_cEmp)
ConOut(_cFilial)

If IsBlind() 
   _Enter  := chr(13) + Chr(10)
   _cMsglog := "["+DTOC(Date())+"-"+Time()+"] JFAT001 - Rodando via job - Empresa: ["+_cEmp+"] Filial: ["+_cFilial+"]"
   
   MemoWrite("C:\TEMP\JFAT001_RUN_JOB_Empresa_"+_cEmp+"_Filial_"+_cFilial+".log",_cMsglog)
   MemoWrite("JFAT001_RUN_JOB_Empresa_"+_cEmp+"_Filial_"+_cFilial+".log",_cMsglog)
   RPCClearEnv()
   RPCSetType(3)
   RPCSetEnv(_cEmp,_cFilial,"","","FAT",,{"SB1"}) 
   _cMsglog := "["+DTOC(Date())+"-"+Time()+"] JFAT001 - Rodando via job - Empresa: ["+_cEmp+"] Filial: ["+_cFilial+"]"
   _cTxtGlog:= _cMsglog + _Enter
   _cEmp		:= Alltrim( aParam[1] )
   _cFilial	:= Alltrim( aParam[2] )
   _lCD := If(Alltrim(_cFilial) == "01010101000",.T.,.F.) //Ita - 17/07/2023
   aNatFil := {} //Ita - 18/07/2023 - Array com filiais e suas respectivas naturezas
   aAdd(aNatFil, {"01010101000","1211003001"})       //As naturezas: Trasnf. mercadoria CD: 1211003001
   aAdd(aNatFil, {"01010101001","1211003002"}) //Trasnf. mercadoria filial Custódia: 1211003002 
   aAdd(aNatFil, {"01010101002","1211003003"}) //Trasnf. mercadoria filial Afogados: 1211003003
   aAdd(aNatFil, {"01010101003","1211003004"}) //Trasnf. mercadoria filial Sertânia: 1211003004
   aAdd(aNatFil, {"01010101004","1211003005"}) //Trasnf. mercadoria filial Salgueiro: 1211003005
   aAdd(aNatFil, {"01010101005","1211003006"}) //Trasnf. mercadoria filial Caruaru: 1211003006 

Else
   _Enter  := chr(13) + Chr(10)
   _cMsglog := "["+DTOC(Date())+"-"+Time()+"] JFAT001 - Rodando via Menu - Empresa: ["+_cEmp+"] Filial: ["+_cFilial+"]"
   _cTxtGlog:= _cMsglog + _Enter
   MemoWrite("C:\TEMP\JFAT001_RUN_MENU_Empresa_"+_cEmp+"_Filial_"+_cFilial+".log",_cMsglog)
   MemoWrite("JFAT001_RUN_MENU_Empresa_"+_cEmp+"_Filial_"+_cFilial+".log",_cMsglog)
EndIf

//PREPARE ENVIRONMENT EMPRESA _cEmp FILIAL _cFilial Modulo "FAT" Tables "SC5", "SC6", "DA1"

JEecuta()	

//RESET ENVIRONMENT 
If IsBlind() 
   RPCClearEnv()
   _cMsglog := "["+DTOC(Date())+"-"+Time()+"] JFAT001 - Finalizado execucao via job  - Empresa: ["+_cEmp+"] Filial: ["+_cFilial+"]"
   _cTxtGlog += _cMsglog + _Enter
   MemoWrite("C:\TEMP\JFAT001_END_JOB_Empresa_"+_cEmp+"_Filial_"+_cFilial+".log",_cMsglog)   
   MemoWrite("JFAT001_END_JOB_Empresa_"+_cEmp+"_Filial_"+_cFilial+".log",_cMsglog)   
Else
   _cMsglog := "["+DTOC(Date())+"-"+Time()+"] JFAT001 - Finalizado execucao via Menu  - Empresa: ["+_cEmp+"] Filial: ["+_cFilial+"]"
   _cTxtGlog += _cMsglog + _Enter
   MemoWrite("C:\TEMP\JFAT001_END_MENU_Empresa_"+_cEmp+"_Filial_"+_cFilial+".log",_cMsglog)   
   MemoWrite("JFAT001_END_MENU_Empresa_"+_cEmp+"_Filial_"+_cFilial+".log",_cMsglog)   
EndIf

ConOut( "JFAT001 - Fim " + Dtoc( Date() ) + " " + Time() )
cTxtLog := "JFAT001 - Fim " + Dtoc( Date() ) + " " + Time() + " - Empresa: ["+_cEmp+"] Filial: ["+_cFilial+"]"
_cTxtGlog += cTxtLog + _Enter
MemoWrite("C:\TEMP\JFAT001_Fim_Empresa_"+_cEmp+"_Filial_"+_cFilial+".log",cTxtLog)
MemoWrite("JFAT001_Fim_Empresa_"+_cEmp+"_Filial_"+_cFilial+".log",cTxtLog)
MemoWrite("C:\TEMP\JFAT001_Pedidos_Empresa_"+_cEmp+"_Filial_"+_cFilial+".log",cLogPeds)
MemoWrite("JFAT001_Pedidos_Empresa_"+_cEmp+"_Filial_"+_cFilial+".log",cLogPeds)
MemoWrite("JFAT001_LOGGERAL_Empresa_"+_cEmp+"_Filial_"+_cFilial+".log",_cTxtGlog)


Return()




Static Function JEecuta()

Local lRet        := .T.
Local cAliasQry 	:=  GetNextAlias() 
//Local nRecnoSC5   
//Local nRecnoSC6
Local nVlrUnit
//Ita - 21/08/2023 - Local cTabPrc     := "003"             //tabela de preço definida
Local cNaturez    := "1211003001"      //código da natureza definido
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
Private cTabPrc     := "003"             //tabela de preço definida
Private _CGC := Alltrim( SM0->M0_CGC )

//pedido normal
//vendedor 1 informado
//tabela de preço não informada
//natureza não informado
//pedido não faturado


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

MemoWrite("C:\TEMP\JEecuta_QUERY_Empresa_"+_cEmp+"_Filial_"+_cFilial+".SQL",cLastQuery)
MemoWrite("JEecuta_QUERY_Empresa_"+_cEmp+"_Filial_"+_cFilial+".SQL",cLastQuery)

_cTxtGlog += "JFAT001 " + Dtoc( Date() ) + " " + Time() + " - Empresa: ["+_cEmp+"] Filial: ["+_cFilial+"] - Query_Pedidos ["+cLastQuery+"]" + _Enter

cpare:=""
If !Eof()

   BEGIN TRANSACTION

      Do While !Eof()

         //número do pedido de vendas
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
         _cTxtGlog += "JFAT001 " + Dtoc( Date() ) + " " + Time() + " - Empresa: ["+_cEmp+"] Filial: ["+_cFilial+"] - Pedido ["+cNumPV+"]" + _Enter

         ////substituído bloco acima pelo abaixo [Mauro Nagata, www.lurin.com.br, 20220502]
         aCabec         := {}
         aItens         := {}
         aLinha         := {}
         lMsErroAuto    := .F.
         _cOperPV := If(_lCD,"08","09") //Ita - 17/07/2023
         //12345678901
         //01010101005
         nPsNat := aScan(aNatFil, {|x,y| x[1] == Substr(Alltrim( _cFilial ),1,11) }) //Ita - 18/07/2023
         If nPsNat > 0
            cNaturez := aNatFil[nPsNat,2] //Obtém a natureza correspondente a filial
         EndIf

         aAdd( aCabec, { "C5_NUM"     , cNumPV     , Nil } )
         //Ita - 30/08/2023 - aAdd( aCabec, { "C5_CLIENTE"  , cCliPV    , Nil } )
         //Ita - 30/08/2023 - aAdd( aCabec, { "C5_LOJACLI"  , cLojPV    , Nil } )
         aAdd( aCabec, { "C5_TABELA"  , cTabPrc    , Nil } )
         aAdd( aCabec, { "C5_NATUREZ" , cNaturez   , Nil } )

         //Ita - 30/08/2023 - aAdd( aCabec, { "C5_CLIENT" , cCliEnt     , Nil } ) //Cliente Entrega
         //Ita - 30/08/2023 - aAdd( aCabec, { "C5_LOJAENT" , cLojEnt    , Nil } ) //Loja Entrega
         //aAdd( aCabec, { "C5_REAJUST" , cTipReaj   , Nil } ) //Tipo Reajuste
         aAdd( aCabec, { "C5_CONDPAG" , cCndPg     , Nil } ) //Condição Pagamento  [desde que seja diferente do Tipo 9, conforme faq em anexo]
         aAdd( aCabec, { "C5_VEND1"   , cVnd1      , Nil } ) //Vendedor - (Todos os pedidos devem ter a mesma quantidade de vendedores, registrados os mesmos códigos, e nos mesmos campos)
         //aAdd( aCabec, { "C5_VEND1"   , cVnd1      , Nil } ) //Vendedor 1 - (Todos os pedidos devem ter a mesma quantidade de vendedores, registrados os mesmos códigos, e nos mesmos campos)
         //aAdd( aCabec, { "C5_VEND2"   , cVnd2      , Nil } ) //Vendedor 2 - (Todos os pedidos devem ter a mesma quantidade de vendedores, registrados os mesmos códigos, e nos mesmos campos)
         //aAdd( aCabec, { "C5_VEND3"   , cVnd3      , Nil } ) //Vendedor 3 - (Todos os pedidos devem ter a mesma quantidade de vendedores, registrados os mesmos códigos, e nos mesmos campos)
         //aAdd( aCabec, { "C5_VEND4"   , cVnd4      , Nil } ) //Vendedor 4 - (Todos os pedidos devem ter a mesma quantidade de vendedores, registrados os mesmos códigos, e nos mesmos campos)
         //aAdd( aCabec, { "C5_VEND5"   , cVnd5      , Nil } ) //Vendedor 5 - (Todos os pedidos devem ter a mesma quantidade de vendedores, registrados os mesmos códigos, e nos mesmos campos)
         //Ita - 15/09/2023 - aAdd( aCabec, { "C5_TPFRETE" , cTpFret    , Nil } ) //Tipo de Frete
         aAdd( aCabec, { "C5_TPFRETE" , 'R'    , Nil } ) //Tipo de Frete - R-Por conta do remetente
         
         //aAdd( aCabec, { "C5_TRANSP"  , cTransp    , Nil } ) //Transportadora
         //aAdd( aCabec, { "C5_INCISS"  , cIncISS    , Nil } ) //ISS Incluso
         //aAdd( aCabec, { "C5_RECISS"  , cRecISS    , Nil } ) //Recolhe ISS
         //aAdd( aCabec, { "C5_FORNISS" , cForISS    , Nil } ) //Fornecedor ISS
         //aAdd( aCabec, { "C5_INDPRES" , cIndPres   , Nil } ) //Presença Com 
         //aAdd( aCabec, { "C5_ESPECI1" , "SPED"    , Nil } ) //Ita - 30/08/2023 - Alterar de  NFCE para SPED
         //aAdd( aCabec, { "C5_VEICULO" , _cVeicul  , Nil } ) //Ita - 15/09/2023
         /*
- Tipo Pedido (C5_TIPO)
- Cliente (C5_CLIENTE)
- Loja do Cliente (C5_LOJACLI)
- Tipo Cliente (C5_TIPOCLI)
- Cliente Entrega (C5_CLIENT)
- Loja Entrega (C5_LOJAENT)
- Tipo Reajuste (C5_REAJUST)
- Condição Pagamento (C5_CONDPAG) [desde que seja diferente do Tipo 9, conforme faq em anexo]
- Vendedores (C5_VEND'x') (Todos os pedidos devem ter a mesma quantidade de vendedores, registrados os mesmos códigos, e nos mesmos campos)
- Tipo Frete (C5_TPFRETE)
- Transportadora (C5_TRANSP)
- ISS Incluso (C5_INCISS)
- Recolhe ISS (C5_RECISS)
- Fornecedor ISS (C5_FORNISS)
- Presença Com (C5_INDPRES)
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
            _cTxtGlog += "JFAT001 " + Dtoc( Date() ) + " " + Time() + " - Empresa: ["+_cEmp+"] Filial: ["+_cFilial+"] - Pedido ["+cNumPV+"]  Item: "+SC6->C6_ITEM+" Produto...: " + SC6->C6_PRODUTO + "Quantiade: ["+CVALTOCHAR( SC6->C6_QTDVEN )+"] Valor Unitario: ["+CVALTOCHAR( nvlrUnit )+"] Operacao: ["+_cOperPV+"]" + _Enter

            DbSelectArea( "SC6" )
            DbSkip()

         EndDo

         nOpc := 4 

         ConOut("antes-exec")
         
         MSExecAuto( { |a, b, c, d| MATA410( a, b, c, d ) }, aCabec, aItens, nOpc, .F. )
         
         ConOut("depois-exec")
         
         If !lMsErroAuto
         
            /////////////////////
            /// Ita - 20/07/2023
            //ConOut( "Chamndo Função fUpdOrcs - para alterar ocçamentos..." )
            //Ita - 26/09/2023 - fUpdOrcs()
            //ConOut("Retornou das alterações dos orçamentos")
            ///////////////////////////////////////////////////////////////////

            /////////////////////
            /// Ita - 26/09/2023
            ///       Faz desvinculo com orçamento
            ///////////////////////////////////////
            DbSelectArea("SC5")
            RecLock("SC5",.F.)
               SC5->C5_ORCRES := ""
            MsunLock()

            ConOut( "Alterado com sucesso! " + cNumPV )
            cLogPeds += "Alterado com sucesso! " + cNumPV + _Enter

            _cTxtGlog += "JFAT001 " + Dtoc( Date() ) + " " + Time() + " - Empresa: ["+_cEmp+"] Filial: ["+_cFilial+"] - Pedido ["+cNumPV+"]  Alterado com Sucesso!" + _Enter

         
         Else
         
            ConOut( "Erro na alteração" )
            cLogPeds += "Erro na alteração! " + cNumPV + _Enter
            //Ita - 06/10/2023 - MostraErro()
            /* Ita - 06/10/2023
            aErroAuto := GetAutoGRLog()            

            For nCount := 1 To Len(aErroAuto)
               cLogErro += StrTran( StrTran( aErroAuto[nCount], "<", "" ), "-", "" ) + " "
               ConOut( cLogErro )
            Next nCount
            */
            cLogTxt  := ""            

            //Pegando log do ExecAuto
            aLogAuto := GetAutoGRLog()
            
            //Percorrendo o Log e incrementando o texto (para usar o CRLF você deve usar a include "Protheus.ch")
            For nCount := 1 To Len(aLogAuto)
               cLogTxt += aLogAuto[nCount] + _Enter //CRLF
            Next nCount

            //Ita - 06/10/2023 - _cTxtGlog += "JFAT001 " + Dtoc( Date() ) + " " + Time() + " - Empresa: ["+_cEmp+"] Filial: ["+_cFilial+"] - Pedido ["+cNumPV+"]  Erro na Alteracao - Detalhe: ["+cLogErro+"]" + _Enter
            _cTxtGlog += "JFAT001 " + Dtoc( Date() ) + " " + Time() + " - Empresa: ["+_cEmp+"] Filial: ["+_cFilial+"] - Pedido ["+cNumPV+"]  Erro na Alteracao - C5_NUM["+cNumPV+"] C5_TABELA["+cTabPrc+"] C5_NATUREZ["+cNaturez+"] C5_CONDPAG["+cCndPg+"] C5_VEND1["+cVnd1+"] C5_TPFRETE[R] C5_ESPECI1[SPED] C6_ITEM:["+SC6->C6_ITEM+"] C6_PRODUTO["+SC6->C6_PRODUTO+"] C6_QTDVEN["+CVALTOCHAR( SC6->C6_QTDVEN )+"] C6_QTDLIB["+CVALTOCHAR( SC6->C6_QTDVEN )+"] C6_PRCVEN["+CVALTOCHAR( nvlrUnit )+"] C6_PRUNIT["+CVALTOCHAR( nvlrUnit )+"] C6_OPER["+_cOperPV+"] - Detalhe: ["+cLogTxt+"]" + _Enter

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

   _cTxtGlog += "JFAT001 " + Dtoc( Date() ) + " " + Time() + " - Empresa: ["+_cEmp+"] Filial: ["+_cFilial+"] - Finalizada a rotina do JOB " + _Enter

Else
   ConOut( "JFAT001 - Não existe registro para esta query" )
   ConOut( "JFAT001 - Query " + cLastQuery)
   _Enter  := chr(13) + Chr(10)
   cTxtlog := "JFAT001 - Não existe registro para esta query" + _Enter
   cTxtlog += "JFAT001 - Query " + cLastQuery
   MemoWrite("C:\TEMP\JFAT001_Emp_"+_cEmp+"_Filial_"+_cFilial+".LOG",cTxtlog)
   MemoWrite("JFAT001_Emp_"+_cEmp+"_Filial_"+_cFilial+".LOG",cTxtlog)
   _cTxtGlog += "JFAT001 " + Dtoc( Date() ) + " " + Time() + " - Empresa: ["+_cEmp+"] Filial: ["+_cFilial+"] " + cTxtlog + _Enter

Endif

Return lRet



//Excluído bloco abaixo [Mauro Nagata, wwww.lurin.com.br, 20220502]
//busca o preço do produto na tabela de preço
Static Function BuscaPrc( cTabela, cCodProd )        
Local aLastQuery  := {} 
Local cLastQuery  := ""
Local cAlias 	   := GetNextAlias() 
//Ita - 17/07/2023 Local nVlrUnit    := 999999999      //caso não localize o valor do produto na tabela de preço
Local nVlrUnit    := 1      //Ita - 17/07/2023 - caso não localize o valor do produto na tabela de preço

BEGINSQL ALIAS cAlias
   %noParser%        
   SELECT	DA1.DA1_PRCVEN 
   FROM 	   %Table:DA1%  DA1
   WHERE 	DA1.%NotDel%
            AND DA1.DA1_FILIAL = %xFilial:DA1%
            AND DA1.DA1_CODTAB = %Exp:cTabela%
            AND DA1.DA1_CODPRO = %Exp:cCodProd%   
            
ENDSQL

//se encontrar o produto na tabela de preço 
If !Eof()
   aLastQuery    := GetLastQuery()
   cLastQuery    := aLastQuery[2] 

   ConOut( "JFAT001 - Query executada: " + cLastQuery )
   MemoWrite("C:\TEMP\BuscaPrc_QUERY_Empresa_"+_cEmp+"_Filial_"+_cFilial+".SQL",cLastQuery)
   MemoWrite("BuscaPrc_QUERY_Empresa_"+_cEmp+"_Filial_"+_cFilial+".SQL",cLastQuery)

   nVlrUnit := (cAlias)->DA1_PRCVEN

   _cTxtGlog += "JFAT001 " + Dtoc( Date() ) + " " + Time() + " - Empresa: ["+_cEmp+"] Filial: ["+_cFilial+"] BuscaPrc - Query executada: [" + cLastQuery + "] Valor Encontrado: ["+CVALTOCHAR( nVlrUnit )+"]" + _Enter   

Else
   _cTxtGlog += "JFAT001 " + Dtoc( Date() ) + " " + Time() + " - Empresa: ["+_cEmp+"] Filial: ["+_cFilial+"] BuscaPrc - Query executada: [" + cLastQuery + "] Valor Encontrado: [ NAO ENCONTROU PRECO!]" + _Enter   
EndIf

(cAlias)->( DbCloseArea() )

Return( nVlrUnit )

//fim bloco  [Mauro Nagata, wwww.lurin.com.br, 20220502]

//////////////////////
/// Ita - 17/07/2023
///       Função fGetUNFE
///       Obttém valor da última NF de Entrada.
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

   MemoWrite("C:\TEMP\fGetUNFE_QUERY_Empresa_"+_cEmp+"_Filial_"+_cFilial+".SQL",cQryUNFE)
   MemoWrite("fGetUNFE_QUERY_Empresa_"+_cEmp+"_Filial_"+_cFilial+".SQL",cQryUNFE)

   TCQuery cQryUNFE NEW ALIAS "XUNFESD1"

   TCSetField("XUNFESD1","D1_VUNIT","N",TamSX3("D1_VUNIT")[1],TamSX3("D1_VUNIT")[2])
   DbSelectArea("XUNFESD1")
   _nRtUVlr := If(XUNFESD1->D1_VUNIT > 0, XUNFESD1->D1_VUNIT, 0)
   DbCloseArea()

   _cTxtGlog += "JFAT001 " + Dtoc( Date() ) + " " + Time() + " - Empresa: ["+_cEmp+"] Filial: ["+_cFilial+"] Busca Ultima NF de Entrada - Query executada: [" + cQryUNFE + "] Valor Encontrado: [ "+CVALTOCHAR( _nRtUVlr )+" ]" + _Enter   

Return(_nRtUVlr)

/////////////////////////////
/// Ita - 20/07/2023
///       Função fUpdOrcs
///       Atualiza Orçamentos
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
         //Ita - 26/09/2023 - nVlrTab := BuscaPrc( cTabPrc, SL2->L2_PRODUTO )
         If _lCD
            nVlrTab := BuscaPrc( cTabPrc, SL2->L2_PRODUTO )
         Else
            nVlrTab := fGetUNFE(SL2->L2_PRODUTO)
            If nVlrTab == 0
               nVlrTab := BuscaPrc( cTabPrc, SL2->L2_PRODUTO )
            EndIf            
         EndIf         

         nVlrDesc := SL2->L2_VALDESC

         RecLock( "SL2", .F. )
         SL2->L2_VRUNIT    := nVlrTab
         SL2->L2_VLRITEM   := ( nVlrTab - nVlrDesc ) * SL2->L2_QUANT
         SL2->( MsUnLock() )

         nTotCDesc += SL2->L2_VLRITEM
         ntotSDesc += (SL2->L2_VRUNIT * SL2->L2_QUANT)

         //ConOut( "Gravação Item Orçamento SL2 - Orçamento: " + cNumOrc + " Pedido de venda: " + SC5->C5_NUM + " Produto: " + SC6->C6_PRODUTO + " Preço: "+ Str( SC6->C6_PRCVEN, 14, 2 ) )

         DbSelectArea( "SL2" )
         DbSkip()

      EndDo

      DbSelectArea( "SL1" )      //orçamento
      DbSetOrder(1)
      If DbSeek( xFilial( "SL1" ) + cNumOrc )
         
         ConOut( "Achou SL1 - Orçamento: " + xFilial( "SL1" )+"|"+cNumOrc )

         RecLock( "SL1", .F. )
         SL1->L1_VLRTOT    := nTotCDesc
         SL1->L1_VALMERC   := nTotSDesc
         SL1->( MsUnLock() )

         ConOut( "Gravação Orçamento SL1 - Orçamento: " + cNumOrc )


         //ConOut( "Gravação Orçamento SL1 - Orçamento: " + cNumOrc + " Pedido de venda: " + SC5->C5_NUM + " Produto: " + SC6->C6_PRODUTO + " Total C/Desc: "+ Str(  nTotCDesc, 14, 2 ) + " Total S/Desc: "+ Str(  nTotSDesc, 14, 2 ) )

      EndIf

      DbSelectArea( "SL4" )   //condição negociada
      DbSetOrder(1)
      If DbSeek( xFilial( "SL4" ) + cNumOrc )

         ConOut( "Achou SL4 - Orçamento: " + xFilial( "SL4" ) +"|"+ cNumOrc )

         RecLock( "SL4", .F. )
         SL4->L4_VALOR     := nTotCDesc
         SL4->( MsUnLock() )

         ConOut( "Gravação Orçamento SL4 - Orçamento: " + cNumOrc )

         //ConOut( "Gravação Orçamento SL4 - Orçamento: " + cNumOrc + " Pedido de venda: " + SC5->C5_NUM + " Produto: " + SC6->C6_PRODUTO + " Total C/Desc: "+ Str(  nTotCDesc, 14, 2 ) )
      EndIf

   EndIf
Return
