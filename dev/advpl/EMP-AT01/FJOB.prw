 #INCLUDE "totvs.ch"
#INCLUDE "topconn.ch"
#INCLUDE "fileio.ch"
#INCLUDE "tbiConn.ch"
#INCLUDE "aarray.ch"
#INCLUDE "json.ch"


// JOSE TEIXEIRA | BOSSWARE

#DEFINE __CELDIG 10
#DEFINE __EOF "*"
#DEFINE __FILE_ERROR -1
#DEFINE __TRUE__  .T.
#DEFINE __FALSE__  .F.
#DEFINE __CONNECT 'TOPCONN'
#DEFINE __JOB_DEFAULT_NAME " [ JOB SCHEDULE  ] "
#DEFINE __LOG "*"
#DEFINE __END_SERVICE__ EXIT
#DEFINE __USERFUNCTION "U_"
#DEFINE __EXTENSION__  '*.TXT'
#DEFINE __TAB ","
#DEFINE __ASPAS '"'
#DEFINE  __ENTER__ CHR( 13 ) + CHR( 10 )
#DEFINE __USADO      "€€€€€€€€€€€€€€"   // USADO
#DEFINE __NUSADO     "€€€€€€€€€€€€€€€"  // Não Usado
#DEFINE __RESERV     "€€"               // NO USADO / NO BROWSE
#DEFINE __RESERVE_W  "þÀ"               // USADO / NO BROWSE
#DEFINE __OBRIGA     "€"                // OBRIGATORIO
#DEFINE __ENTER  CHR(13) + CHR(10)
#IFNDEF CRLF
	#DEFINE CRLF Chr(13)+Chr(10)
#ENDIF


/*
####################################################################################################
## 												  												  ##																						
## BY      : JOSE TEIXEIRA                                                                        ##
##------------------------------------------------------------------------------------------------##
## BOSSWARE TECHNOLOGY  | DATA | 01/10/2017                                                       ##
##                                                                                                ##
##                                                                                                ##
##  I   N   T   E   G   R   A   Ç   Ã  O             P R O T H E U S     X    P E G A S U S       ##
##                                                                                                ##
##                                                                                                ##
##                                                                                                ##
##------------------------------------------------------------------------------------------------##
## CLIENTE : CASAS BANDEIRANTES                                                                   ##
##------------------------------------------------------------------------------------------------##
####################################################################################################
*/


class TJOB

	data __this
	data lNew as logical
	data lInProcess
	data JOBNAME as String



	method start()
	method stop()
	method thisObject(obj)
	method New(cJobName) constructor
	method getParam()

endclass



method New(cJobName) class TJOB
	::lNew:= .T.
	::lInProcess := .F.
	IF;
			!Empty(ALLTRIM(cJobName ))
		::JOBNAME := cJobName
	Else
		::JOBNAME := __JOB_DEFAULT_NAME
	EndIF


return nil

/*     
####################################################################################################
## 																								  ##																						
## BY      : JOSE TEIXEIRA                                                                        ##
##------------------------------------------------------------------------------------------------##
## BOSSWARE TECHNOLOGY                                                                            ##
##------------------------------------------------------------------------------------------------##
## CLIENTE : CASAS BANDEIRANTES                                                                   ##
##------------------------------------------------------------------------------------------------##
####################################################################################################
*/


method start() class TJOB

	local cEnv 	 := GetEnvServer()
	local lStart := __TRUE__
	local __LOG_PATH  :=  GetSrvProfString("Startpath","") + 'pegasus\job\'
	local cEmp := ""
	local cFil := ""
	local cEmpresa := ""
	local __APPUSER
	local aAlias := {'SA1'}
	local __BLOCK_PROCESS := {}
	local aRet := {}
	local __cNAlias
	local cMsg := ""
	local cObs := ""
	local nI := 0
	local nY := 1
	local nTime
	local cServerIni := GetAdv97()
	local cSecao := "TSERVICE"
	local cDelay := "TDELAY"
	local cEmail := "TEMAIL"
	local cLog   := "TLOG"
	local cMain  := "MAIN"
	local cNameJOB := "JOBNAME"
	local __INITJOBFIN := "INITJOB"
	local __BLOCK := {||}
	local __BLOCK_PROCESS
	local aData
	local __INIT
	local __TIME
	local cTime
	local lProcess := .F.
	local xDataP
	local xDataE

	local __DATA
	local lOpen
	local __IDHd
	local __nInterval
	local lRet
	local cSql := ""
	private aRecnoSM0 := GETEMP()


	__createKey(  __LOG_PATH )

	cNameJOB := GetPvProfString(cSecao, cNameJOB, "@@", cServerIni)

	::JOBNAME := IIF( cNameJOB == "@@",;
		::JOBNAME, cNameJOB )


	__cInterNet := Nil



	While ;
			!KillApp()
		::lInProcess := __TRUE__


		__TIME := StrZero(Val(Left(Time(),2)),2)

		IF ( ;
				KillApp() ;
				.OR. File( __LOG_PATH+"TJOB.JOB") )

			ConOut( " " )
			ConOut( " " )
			ConOut( "************************* " + ::JOBNAME + " ************************* ")
			ConOut(::JOBNAME + " FOI SOLICITADO ENCERRAMENTO DO JOB. O MESMO SERA FINALIZADO. AGUARDE..." )
			ConOut( "************************* " + ::JOBNAME + " ************************* ")
			ConOut( " " )
			ConOut( " " )

			Sleep(8000)


			ConOut( "************************* " + ::JOBNAME + " ************************* ")
			ConOut(::JOBNAME + " FINALIZADO COM SUCESSO !" )
			ConOut( "************************* " + ::JOBNAME + " ************************* ")


			__END_SERVICE__  // Kill !


		EndIF



		ConOut( ::JOBNAME + " A G U A R D E ...INICIANDO JOB ! "  )

		Sleep(2000)



		ConOut( " " )
		ConOut( " " )
		ConOut( "************************* " + ::JOBNAME + " ************************* " )
		ConOut( ::JOBNAME + " : MONTANDO AMBIENTE PARA A EMPRESA : " + cEmpresa          )
		ConOut( "************************* " + ::JOBNAME + " ************************* " )
		ConOut( " " )
		ConOut( " " )



		lRet := PVSales()

		ConOut( " " )
		ConOut( " " )
		ConOut( "************************* " + ::JOBNAME + " ************************* ")
		ConOut(::JOBNAME + " : AGUARDANDO NOVA CHAMADA..." + Time()   )
		ConOut( "************************* " + ::JOBNAME + " ************************* ")
		ConOut( " " )
		ConOut( " " )


		__nInterval := ( 1 * 60 ) * 1000

		// __nInterval :=  ( 60 * 60 * 12 ) * 1000


		Sleep( __nInterval )


		ConOut( " " )
		ConOut( " " )
		ConOut( "************************* " + ::JOBNAME + " ************************* ")
		ConOut(::JOBNAME + " : CARREGANDO..." + Time() )
		ConOut( "************************* " + ::JOBNAME + " ************************* ")
		ConOut( " " )
		ConOut( " " )

		Sleep(2000)





		Sleep(3000)



	End

Return

/*     
####################################################################################################
## 																								  ##																						
## BY      : JOSE TEIXEIRA                                                                        ##
##------------------------------------------------------------------------------------------------##
## BOSSWARE TECHNOLOGY                        				                                      ##
##------------------------------------------------------------------------------------------------##
## CLIENTE : CASAS BANDEIRANTES                                                                   ##
##------------------------------------------------------------------------------------------------##
####################################################################################################
*/


method getParam() class TJOB
	local aParam := {}

	local cServerIni := GetAdv97()
	local cSecao := "TSERVICE"
	local cDelay := "TDELAY"
	local cEmail := "TEMAIL"
	local cLog   := "TLOG"
	local cMain  := "MAIN"



	cDelay := GetPvProfString(cSecao, cDelay, "@@", cServerIni)
	cEmail := GetPvProfString(cSecao, cEmail, "@@", cServerIni)
	cLog := GetPvProfString(cSecao, cLog, "@@", cServerIni)

	AADD( aParam, cDelay )
	AADD( aParam, cEmail )
	AADD( aParam, cLog )

return aParam


/*     

####################################################################################################
## 																								  ##																						
## BY      : JOSE TEIXEIRA                                                                        ##
##------------------------------------------------------------------------------------------------##
## BOSSWARE TECHNOLOGY                                                                ##
##------------------------------------------------------------------------------------------------##
## CLIENTE : CASAS BANDEIRANTES                                                                             ##
##------------------------------------------------------------------------------------------------##
####################################################################################################
*/



Static Function __createKey(  __LOG_PATH )
	local cServerIni := GetAdv97()
	WritePProString('TSERVICE', 'TDELAY', '5', cServerIni ) // MINUTOS OU HORA..DEPENDENDO DA CHAMADA...
	WritePProString('TSERVICE', 'TEMAIL', 'teixeira.totvs@gmail.com', cServerIni ) // ENVIAR E-MAIL COM PROCESSO EXECUTADO OU ERRO
	WritePProString('TSERVICE', 'TLOG', '\tlogs', cServerIni ) // CONTROLE DE ERROS
	WritePProString('TSERVICE', 'MAIN', 'WFLWFIN', cServerIni ) // PROGRAMA QUE FAZ A IMPORTAÇÃO...
	WritePProString('TSERVICE', 'PREPAREIN', '21', cServerIni ) // LISTA DE EMPRESAS QUE IREMOS USAR...
	WritePProString('TSERVICE', 'SXS', '0', cServerIni ) // LISTA DE EMPRESAS QUE IREMOS USAR...



	MAKEDIR(  __LOG_PATH )
	MAKEDIR(  __LOG_PATH+'\tlogs' )

Return NIL


/*     

####################################################################################################
## 																								  ##																						
## BY      : JOSE TEIXEIRA                                                                        ##
##------------------------------------------------------------------------------------------------##
## BOSSWARE TECHNOLOGY                                                                            ##
##------------------------------------------------------------------------------------------------##
## CLIENTE : CASAS BANDEIRANTES                                                                   ##
##------------------------------------------------------------------------------------------------##
####################################################################################################
*/


 


/*     
####################################################################################################
## 																								  ##
## BY      : JOSE TEIXEIRA                                                                        ##
##------------------------------------------------------------------------------------------------##
## BOSSWARE TECHNOLOGY                                                                		      ##
##------------------------------------------------------------------------------------------------##
## CLIENTE : CASAS BANDEIRANTES                                                                   ##
##------------------------------------------------------------------------------------------------##
####################################################################################################
*/


Static Function __CALLTIME( nInterval, lHora )

	local nHora := StrZero(  (HoraToInt(Time())+Val(nInterval)), 2 )

	dbSelectArea("SX6")
	DBSetOrder(1)


	RecLock("SX6", !dbSeek(cFilAnt+"ES_JOBMIN") )
	SX6->X6_FIL		:= cFilant
	SX6->X6_VAR		:= "ES_JOBMIN"
	SX6->X6_TIPO	:= "C"
	SX6->X6_DESCRIC	:= ""
	SX6->X6_DSCSPA	:= ""
	SX6->X6_DSCENG	:= ""
	SX6->X6_DESC1	:= ""
	SX6->X6_DSCSPA1	:= ""
	SX6->X6_DSCENG1	:= ""
	SX6->X6_DESC2	:= ""
	SX6->X6_DSCSPA2	:= ""
	SX6->X6_DSCENG2	:= ""
	SX6->X6_CONTEUD	:= IIF( lHora, nHora, nInterval ) // INTERVALO SERÁ EM HORA..OU EM MINUTOS
	MsUnLock()

Return




Static Function getEmp()
	local lOpen
	local aRecnoSM0 := {}
	IF ( lOpen := MyOpenSm0(.T.) )

		dbSelectArea( 'SM0' )
		dbGoTop()

		While !SM0->( EOF() )

			IF SM0->M0_CODIGO == "02"   // TRANSPORADORA..
				IF aScan( aRecnoSM0, { |x| x[2] == SM0->M0_CODIGO } ) == 0
					aAdd( aRecnoSM0, { Recno(), SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_NOME, SM0->M0_FILIAL } )
				EndIF
			EndIF

			SM0->( dbSkip() )
		End

		SM0->( dbCloseArea() )
	EndIF

Return aRecnoSM0
	


Static Function MyOpenSM0(lShared)

	Local lOpen := .F.
	Local nLoop := 0

	For nLoop := 1 To 20
		dbUseArea( .T., , 'SIGAMAT.EMP', 'SM0', lShared, .F. )

		If !Empty( Select( 'SM0' ) )
			lOpen := .T.
			dbSetIndex( 'SIGAMAT.IND' )
			Exit
		EndIf

		Sleep( 500 )

	Next nLoop

	If !lOpen
		MsgStop( 'Não foi possível a abertura da tabela ' + ;
			IIf( lShared, 'de empresas (SM0).', 'de empresas (SM0) de forma exclusiva.' ), 'ATENÇÃO' )
	EndIf

Return lOpen

	
Static Function PVSales()

	local cSQL := ""
	local __cNameAlias :=  GETNEXTALIAS()
	local lRet := .F.
	local aaPedido
	local aaBusiness
	local aFiles := {}
	local aSizes := {}
	local nTotal
	local vProduto := ""
	local __FILIAL
	local v_TpPessoa
	local v_TpClient
	local v_TpCatCli
	local v_Cliente
	local v_TpMat
	local v_PedPeg := ""
	local v_RamoAtv := ""
	local v_TpFrete := ""
	local v_UFCli := ""
	local v_Vidrac := ""
	local aCab := {}
	local lRet
	local aRet := {}
	local nX := 0

	ADir("\system\pegasus\json\*.json", aFiles, aSizes)

	nTotal := Len( aFiles )

	ConOut( "TOTAL....: " + cValToChar( nTotal ) )

	For nX := 1 To Len( aFiles )

		aaPedido := ReadJsonFile("\system\pegasus\json\"+aFiles[nX])

		aaBusiness := FromJson( ToJson(aaPedido) )


		v_CodCli   := aaPedido[#'Pedido'][1][#'C5_CLIENTE']
		v_LojCli   := aaPedido[#'Pedido'][1][#'C5_LOJACLI']
		v_ConPag   := aaPedido[#'Pedido'][1][#'C5_CONDPAG']
		v_MenFat   := aaPedido[#'Pedido'][1][#'C5_MENFAT']
		v_TpPessoa := aaPedido[#'Pedido'][1][#'A1_PESSOA']
		v_TpClient := aaPedido[#'Pedido'][1][#'A1_TIPO']
		v_TpCatCli := aaPedido[#'Pedido'][1][#'A1_CATEGUE']
		v_Cliente  := aaPedido[#'Pedido'][1][#'A1_NREDUZ']
		v_PedPeg   := aaPedido[#'Pedido'][1][#'C5_XPEDPEG']
		v_RamoAtv  := aaPedido[#'Pedido'][1][#'A1_TPESSOA']
		v_TpFrete  := aaPedido[#'Pedido'][1][#'C5_TPFRETE']
		v_UFCli    := aaPedido[#'Pedido'][1][#'A1_EST']
		v_Vidrac   := "" //aaPedido[#'Pedido'][1][#'A1_XVIDRAC']

		ConOut( " CLIENTE/LOJA... " + v_CodCli+"/"+v_LojCli + " [ PEDIDO ] -> " +  v_PedPeg)




		lRet := PVPutSales( @aaPedido, v_CodCli, v_LojCli, v_ConPag, v_MenFat, v_TpPessoa, v_TpClient, v_TpCatCli, v_Cliente, v_PedPeg, v_RamoAtv,  v_TpFrete, v_UFCli, v_Vidrac)



	Next



Return .T.

Static Function PVPutSales( aaPedido, v_CodCli, v_LojCli, v_ConPag, v_MenFat, v_TpPessoa, v_TpClient, v_TpCatCli, v_Cliente, v_PedPeg, v_RamoAtv, v_TpFrete, v_UFCli, v_Vidrac )

	local aItens := {}
	local lRet := .F.
	local v_TpMat := ""
	local __nCount := 0
	local aTPMat := {}
	local __FILIAL := ""
	local __TIPOMAT := ""
	local __cNameAlias
	local __n := 0
	For __n := 1 To Len( aaPEDIDO:ADATA[2][2] )

		v_TpMat:= aaPedido[#'Itens'][__n][#'C6_TIPOMATERIAL']

		IF ( AllTrim(v_TpMat) ==  "1" ) // DIST. OU VAREJO

			IF (  AllTrim(v_TpPessoa) == "J" )
				__FILIAL := "03"
			Else
				__FILIAL := "08"
			EndIF

			IF( AllTrim(v_TpClient) == "S" .OR. AllTrim(v_TpClient) == "F" )
				__FILIAL := "08"
			EndIF

			/*
 
             01807,03209,07507,08901,15302 , 13703 
			- BAYEUX
			- CABEDELO
			- JOAO PESSOA
			- MAMANGUAPE
			- SAPÉ
			- SANTA RITA
			*/


 


			ConOut(" MATERIAL 1...: " + v_TpMat + " : FILIAL : " + __FILIAL )

			aAdd( aItens, { __FILIAL, aaPedido[#'Itens'][__n][#'C6_PRODUTO'] ,;
				aaPedido[#'Itens'][__n][#'C6_QTDVEN']  ,;
				aaPedido[#'Itens'][__n][#'C6_QTDLIB']  ,;
				aaPedido[#'Itens'][__n][#'C6_PECA']    ,;
				aaPedido[#'Itens'][__n][#'C6_PRCVEN']  ,;
				aaPedido[#'Itens'][__n][#'C6_TES']} )

			__TIPOMAT := AllTrim(v_TpMat)
		EndIF
	Next

	IF ( !Empty( __FILIAL ) )

		lRet := PVPutOrder( __FILIAL, v_CodCli, v_LojCli, v_ConPag, v_MenFat, v_TpPessoa,;
			v_TpClient, v_TpCatCli, v_Cliente, aItens, v_PedPeg, @aaPedido, v_RamoAtv, v_TpFrete, v_UFCli, __TIPOMAT, v_Vidrac )
	EndIF

	aItens := {}
	__FILIAL := ""

	For __n := 1 To Len( aaPEDIDO:ADATA[2][2] )

		v_TpMat:= aaPedido[#'Itens'][__n][#'C6_TIPOMATERIAL']

		IF ( AllTrim(v_TpMat) $  "2/5" ) // DIST. OU VAREJO

			IF (  AllTrim(v_TpPessoa) == "J" )
				__FILIAL := "05"
			Else
				__FILIAL := "08"
			EndIF

			IF( AllTrim(v_TpClient) == "S" .OR. AllTrim(v_TpClient) == "F"  )
				__FILIAL := "08"
			EndIF

			// Quando : A1_XVIDRAC = '2' e A1_EST = 'PE' - gravar na filial 03 !
			IF( AllTrim(v_Vidrac) == "2" .AND. AllTrim(v_UFCli) == "PE"  )
				IF ( AllTrim(v_TpMat) $  "2/5" )
					__FILIAL := "03"
				EndIF
			EndIF

	 

			aAdd( aItens, { __FILIAL, aaPedido[#'Itens'][__n][#'C6_PRODUTO'] ,;
				aaPedido[#'Itens'][__n][#'C6_QTDVEN']  ,;
				aaPedido[#'Itens'][__n][#'C6_QTDLIB']  ,;
				aaPedido[#'Itens'][__n][#'C6_PECA']    ,;
				aaPedido[#'Itens'][__n][#'C6_PRCVEN']  ,;
				aaPedido[#'Itens'][__n][#'C6_TES']} )

			__TIPOMAT :=  AllTrim(v_TpMat)

			ConOut(" MATERIAL 2/5...: " + v_TpMat + " : FILIAL : " + __FILIAL )
		EndIF
	Next

	IF ( !Empty( __FILIAL ) )

		lRet := PVPutOrder( __FILIAL, v_CodCli, v_LojCli, v_ConPag, v_MenFat, v_TpPessoa,;
			v_TpClient, v_TpCatCli, v_Cliente, aItens, v_PedPeg, @aaPedido, v_RamoAtv, v_TpFrete,  v_UFCli, __TIPOMAT, v_Vidrac  )
	EndIF
	aItens := {}
	__FILIAL := ""


	For __n := 1 To Len( aaPEDIDO:ADATA[2][2] )

		v_TpMat:= aaPedido[#'Itens'][__n][#'C6_TIPOMATERIAL']

		IF ( AllTrim(v_TpMat) == "4" ) // MATRIZ

			__FILIAL := "01"

			aAdd( aItens, { __FILIAL, aaPedido[#'Itens'][__n][#'C6_PRODUTO'] ,;
				aaPedido[#'Itens'][__n][#'C6_QTDVEN']  ,;
				aaPedido[#'Itens'][__n][#'C6_QTDLIB']  ,;
				aaPedido[#'Itens'][__n][#'C6_PECA']    ,;
				aaPedido[#'Itens'][__n][#'C6_PRCVEN']  ,;
				aaPedido[#'Itens'][__n][#'C6_TES']} )

			__TIPOMAT :=  AllTrim(v_TpMat)

			ConOut(" MATERIAL 4...: " + v_TpMat + " : FILIAL : " + __FILIAL )

		EndIF
	Next

	IF ( !Empty( __FILIAL ) )

		lRet := PVPutOrder( __FILIAL, v_CodCli, v_LojCli, v_ConPag, v_MenFat, v_TpPessoa,;
			v_TpClient, v_TpCatCli, v_Cliente, aItens, v_PedPeg, @aaPedido, v_RamoAtv, v_TpFrete, v_UFCli, __TIPOMAT, v_Vidrac )
	EndIF



Return .T.


Static Function PVPutOrder( __FILIAL, v_CodCli, v_LojCli, v_ConPag, v_MenFat, v_TpPessoa,;
		v_TpClient, v_TpCatCli, v_Cliente, aItens, v_PedPeg, aaPedido, v_RamoAtv, v_TpFrete, v_UFCli, __TIPOMAT, v_Vidrac )

	local aLog := {}
	local aCab := {}
	local aItePv := {}
	local aItensPV := {}
	local v_largura := 0
	local v_altura := 0
	local __TIPOP := "01"
	local v_Ped := ""
	local v_Tes := ""
	local v_TotST := 0
	local nValCom1 := 0
	local nValCom2 := 0
	local nValCom3 := 0
	local nValCom4 := 0
	local nValCom5 := 0.00
	local v_Vend1 := ""
	local v_Vend2 := ""
	local v_Vend3 := ""
	local v_Vend4 := ""
	local v_Vend5 := ""
	local v_qtdven := 0
	local aErro := {}
	local nErro := ""
	local cErro := ""
	local lRet := .F.
	local lPSales := .F.
	local v_TpMat := ""
	local __nCount := 0
	local aTPMat := {}
	local v_LocPad := "01"
	local lPgtoCom := .F.

	local nStatus := 0
	local cItem := "00"
	local cEstLoc := ""
	local cEst := ""
	local vTipoCli := ""
	local cCf := ""
	local cCfop := ""
	local v_OriProd := ""
	local v_SitTrib := ""
	local v_ClaFis := ""
	local __cNameAlias
	local cSQL := ""
	local v_prcven
	local v_totven
	local oError := ErrorBlock({|e|;
		ConOut("Mensagem de Erro: " +chr(10)+ e:Description)})

	local cSQL := ""
	local v_Vidrac := ""
	local __k := 0
	local __n := 0
	local __aFPag := {}
	local cSql := ""
	local lEstPB := .F.
	local lEstPI := .F.

	local aProd := {}
	private lMsErroAuto := .F.
	private lAutoErrNoFile := .T.

	Begin Sequence

		IF( Empty( aItens ) )
			Return .T.
		EndIF

		For __k := 1 To Len( aaPEDIDO:ADATA[2][2] )

			v_TpMat := AllTrim( aaPedido[#'Itens'][__k][#'C6_TIPOMATERIAL']   )

			IF ( aScan( aTPMat, { |x| x[1] == v_TpMat } ) == 0 )
				IF( v_TpMat $ "2/5" .AND.  __nCount == 0 )
					__nCount += 1
				Else
					aAdd( aTPMat, { v_TpMat } )
				EndIF
			EndIF

			ConOut(" MATERIAL....: " +  v_TpMat )

		Next





		ConOut( " " )
		ConOut( "************************ [ CONECTANDO...] ************************* ")
		ConOut(" FILIAL..: " + __FILIAL  )

       
		__cNameAlias := GETNEXTALIAS()

	  
		/*
 
             01807,03209,07507,08901,15302,13703 
			- BAYEUX
			- CABEDELO
			- JOAO PESSOA
			- MAMANGUAPE
			- SAPÉ
			- SANTA RITA
		*/

		RPCSetType(3)
		RpcSetEnv("01", __FILIAL )

		cSQL := " SELECT A1_COD_MUN, A1_EST FROM SA1010 WHERE D_E_L_E_T_ <> '*' AND TRIM(A1_COD) = '"+v_CodCli+"' AND A1_LOJA ='"+v_LojCli+"'   "
		dbUseArea(.T.,__CONNECT,TcGenQry(,,cSQL),__cNameAlias,.T.,.T.)
		
		lEstPB := .F.
		lEstPI := .F.

 		IF !(__cNameAlias)->(Eof())
 
 			// IF( AllTrim( (__cNameAlias)->A1_COD_MUN ) $ "01807/08901/15302/13703/" )

			//	__FILIAL := __FILIAL 
			//Else

				IF 	AllTrim( (__cNameAlias)->A1_EST ) == "PB"
					__FILIAL := "09"
					lEstPB := .T. 
					RpcClearEnv()           
					RPCSetType(3)
					RpcSetEnv("01", __FILIAL )    
				Else
					__FILIAL := __FILIAL 	
				EndIF

/*
				IF 	AllTrim( (__cNameAlias)->A1_EST ) == "PI"
					__FILIAL := "10"
					lEstPI := .T. 
					RpcClearEnv()           
					RPCSetType(3)
					RpcSetEnv("01", __FILIAL )    
				Else
					__FILIAL := __FILIAL 	
				EndIF

*/


			//EndIF
		EndIF



 		//IF( AllTrim( (__cNameAlias)->A1_COD_MUN ) $ "01807/08901/15302/13703/" ) .AND. ( AllTrim(__TIPOMAT) $  "1/2/5" )
				//	__FILIAL := "09"
				//	lEstPB := .T. 
				//	RpcClearEnv()           
				//	RPCSetType(3)
				//	RpcSetEnv("01", __FILIAL ) 
		//EndIF 

		(__cNameAlias)->(dbCloseArea())


		
 






		cSql := " BEGIN " + CRLF
		cSql += "  "  + CRLF
		cSql += " FOR K IN (SELECT C5_EMISSAO, C5_NUM, C5_XPEDPEG FROM SC5010 WHERE C5_EMISSAO = '" + DTOS(dDataBase) + "' AND C5_XPEDPEG  != ' '   "  + CRLF
		cSql += " ) LOOP "  + CRLF
		cSql += " "  + CRLF
		cSql += " UPDATE TBL_PTHTRANSACAO SET CD_VCHSTATUS = 'P' , CD_VCHPEDIDOPROTHEUS = K.C5_NUM WHERE CD_VCHPEDIDOPEGASUS = K.C5_XPEDPEG ; "  + CRLF
		cSql += " "  + CRLF
		cSql += "COMMIT; "  + CRLF
		cSql += " "  + CRLF
		cSql += "END LOOP; "  + CRLF
		cSql += " END;"  + CRLF

		TCSqlExec( cSql )

		__cNameAlias := GETNEXTALIAS()


		cSQL := " SELECT A1_MSBLQL, A1_LC, A1_COD, A1_LOJA, A1_NREDUZ, A1_TIPO,  A1_PESSOA, A1_CATEGUE, A1_TPESSOA,  A1_EST, A1_RISCO,A1_XVIDRAC FROM SA1010 WHERE D_E_L_E_T_ <> '*' AND TRIM(A1_COD) = '"+v_CodCli+"' AND A1_LOJA ='"+v_LojCli+"' "
		dbUseArea(.T.,__CONNECT,TcGenQry(,,cSQL),__cNameAlias,.T.,.T.)

		IF !(__cNameAlias)->(Eof())
			v_Vidrac := (__cNameAlias)->A1_XVIDRAC
		EndIF

		IF( (__cNameAlias)->A1_MSBLQL == "1" )
			MemoWrite("system\pegasus\json\erros\CLI_BLOQ_"+AllTrim(v_CodCli)+".log", "CLIENTE BLOQUEADO! " + " CLIENTE/LOJA... " + v_CodCli+"/"+v_LojCli)
			(__cNameAlias)->(DBCloseArea())
			Return
		EndiF

		(__cNameAlias)->(DBCloseArea())


  
		IF( AllTrim(v_Vidrac) == "2" .AND. AllTrim(v_UFCli) == "PE"  )
			IF ( AllTrim(__TIPOMAT) $  "2/5" )

				ConOut("-- DISTRIBUIDORA -- CLIENTE DO TIPO VIDRACEIRO ! " )

				__FILIAL := "03"

				RpcClearEnv()
				RPCSetType(3)
				RpcSetEnv("01", __FILIAL )

			EndIF
		EndIF
	 
		MemoWrite("\system\", "SA1.pth")


		//lPSales := GetPVSales( v_PedPeg, Len( aTPMat ) - __nCount ) // Gravou todos os pedidos emc cada filial ?

		//IF ( lPSales )
		//	Return
		//EndIF

		nValCom1 := aaPedido[#'Pedido'][1][#'C5_COMIS1']
		nValCom2 :=	aaPedido[#'Pedido'][1][#'C5_COMIS2']
		nValCom3 :=	aaPedido[#'Pedido'][1][#'C5_COMIS3']
		nValCom4 :=	aaPedido[#'Pedido'][1][#'C5_COMIS4']
		nValCom5 :=	aaPedido[#'Pedido'][1][#'C5_COMIS5']

		v_Vend1  :=	aaPedido[#'Pedido'][1][#'C5_VEND1']
		v_Vend2  :=	aaPedido[#'Pedido'][1][#'C5_VEND2']
		v_Vend3  :=	aaPedido[#'Pedido'][1][#'C5_VEND3']
		v_Vend4  :=	aaPedido[#'Pedido'][1][#'C5_VEND4']
		v_Vend5  :=	aaPedido[#'Pedido'][1][#'C5_VEND5']
		v_PedCDV := aaPedido[#'Pedido'][1][#'C5_XJOBCDV']

		v_Ped := getPedido( __FILIAL )


		__cNameAlias := GETNEXTALIAS()



		cSQL := " SELECT A1_MSBLQL, A1_LC, A1_COD, A1_LOJA, A1_NREDUZ, A1_TIPO,  A1_PESSOA, A1_CATEGUE, A1_TPESSOA,  A1_EST, A1_RISCO,A1_XVIDRAC FROM SA1010 WHERE D_E_L_E_T_ <> '*' AND TRIM(A1_COD) = '"+v_CodCli+"' AND A1_LOJA ='"+v_LojCli+"' "
		dbUseArea(.T.,__CONNECT,TcGenQry(,,cSQL),__cNameAlias,.T.,.T.)

		IF !(__cNameAlias)->(Eof())
			cEst := (__cNameAlias)->A1_EST
			vTipoCli := (__cNameAlias)->A1_TIPO

		EndIF

		(__cNameAlias)->(DBCloseArea())

		MemoWrite("\system\", "SA1.pth")

		IF( AllTrim(v_ConPag) $ ":")
			__aFPag := StrTokArr( v_ConPag, ":" )
			aAdd( __aFPag , v_ConPag )
			aAdd( __aFPag , "1005" )
		Else
			aAdd( __aFPag , v_ConPag )
			aAdd( __aFPag , "10001" )
		EndIF

		aAdd( aCab , { "C5_NUM"		, v_Ped		 , NIL } )
		aAdd( aCab , { "C5_EMISSAO"	, dDataBase	 , NIL } )
		aAdd( aCab , { "C5_TIPO"	, "N"		 , NIL } )
		aAdd( aCab , { "C5_CLIENTE"	, v_CodCli   , NIL } )
		aAdd( aCab , { "C5_LOJACLI"	, v_LojCli   , NIL } )
		aAdd( aCab , { "C5_CLIENT"	, v_CodCli	 , NIL } )
		aAdd( aCab , { "C5_LOJAENT"	, v_LojCli	 , NIL } )
		aAdd( aCab , { "C5_TIPOCLI"	, v_TpClient , NIL } )
		aAdd( aCab , { "C5_CONDPAG"	, __aFPag[1]   , NIL } )
		aAdd( aCab , { "C5_NATUREZ"	, __aFPag[2]   , NIL } )
//	aAdd( aCab , { "C5_MENFAT"  , v_MenFat   , NIL } )
		aAdd( aCab , { "C5_MENNOTA"  , v_MenFat   , NIL } )
		aAdd( aCab , { "C5_XPEDPEG" , v_PedPeg   , NIL } )
		aAdd( aCab , { "C5_TPFRETE" , v_TpFrete  , NIL } )
		aAdd( aCab , { "C5_INDPRES" , "0"   , NIL } )		
		aAdd( aCab , { "C5_XJOBCDV" , "N"        , NIL } )

		IF( AllTrim( __TIPOMAT ) == "2" .OR. AllTrim( __TIPOMAT ) == "5" )
			aAdd( aCab , { "C5_XTPMAT" , "25" , NIL } )
		Else
			aAdd( aCab , { "C5_XTPMAT" , __TIPOMAT , NIL } )
		EndIF

		v_TotST := __SUBTRIB( v_CodCli, v_LojCli, v_TpClient, __TIPOP , __FILIAL, aItens )


		nValCom1 := IIF(  nValCom1 !=0 , Round( (( nValCom1 / v_TotST ) * 100), 2) , 0 )
		nValCom2 := IIF(  nValCom2 !=0 , Round( (( nValCom2 / v_TotST ) * 100), 2) , 0 )
		nValCom3 := IIF(  nValCom3 !=0 , Round( (( nValCom3 / v_TotST ) * 100), 2) , 0 )
		nValCom4 := IIF(  nValCom4 !=0 , Round( (( nValCom4 / v_TotST ) * 100), 2) , 0 )
		nValCom5 := IIF(  nValCom5 !=0 , Round( (( nValCom5 / v_TotST ) * 100), 2) , 0 )

		ConOut( nValCom1 )
		ConOut( nValCom2 )
		ConOut( nValCom3 )
		ConOut( nValCom4 )
		ConOut( nValCom5 )

		lPgtoCom := __COMISSAO( v_PedPeg, NIL  )

		IF !lPgtoCom


        /*
			IF( nValCom1 != 0 .OR. nValCom2 != 0 )
			ConOut( "PAGAMENTO COMISSAO PARA PEDIDO / PEGASUS ...: " + v_PedPeg )
			
	        cSQL := "UPDATE SC5010 SET  C5_COMIS1 = " + cValToChar(nValCom1) +", C5_COMIS2 = " + cValToChar(nValCom2) +" WHERE TRIM(C5_XPEDPEG) = '" + AlLTrim(v_PedPeg) + "' AND TRIM(C5_FILIAL) = '"+__FILIAL+"'  AND D_E_L_E_T_ <> '*'"
			nStatus := TCSqlExec( cSQL )
			 
			ConOut( cSQL )  
				IF (nStatus < 0)
			    ConOut("TCSQLError() " + TCSQLError())
				EndIF

			EndIF

		RpcClearEnv()
		ConOut( " " )		
		ConOut( " " )		
	
		
		Return .T.
		
		*/

			IF( !Empty( v_Vend1 ) )
				aAdd( aCab , { "C5_VEND1"	, v_Vend1  , NIL } )
			EndIF

			IF( !Empty( v_Vend2 ) )
				aAdd( aCab , { "C5_VEND2"	, v_Vend2  , NIL } )
			EndIF

			IF( !Empty( v_Vend3 ) )
				aAdd( aCab , { "C5_VEND3"	, v_Vend3   , NIL } )
			EndIF

			IF( !Empty( v_Vend4 ) )
				aAdd( aCab , { "C5_VEND4"	, v_Vend4  , NIL } )
			EndIF

			IF( !Empty( v_Vend5 ) )
				aAdd( aCab , { "C5_VEND5"	, v_Vend5   , NIL } )
			EndIF

			IF( nValCom1 != 0 )
				aAdd( aCab , { "C5_COMIS1"	,	nValCom1 , NIL } )
			EndIF

			IF( nValCom2 != 0 )
				aAdd( aCab , { "C5_COMIS2"	,	nValCom2 , NIL } )
			EndIF

			IF( nValCom3 != 0 )
				aAdd( aCab , { "C5_COMIS3"	,	nValCom3 , NIL } )
			EndIF

			IF( nValCom4 != 0 )
				aAdd( aCab , { "C5_COMIS4"	,	nValCom4 , NIL } )
			EndIF

			IF( nValCom5 != 0 )
				aAdd( aCab , { "C5_COMIS5"	,	nValCom5 , NIL } )
			EndIF
		EndIF





		// CATEGORIA = INDUSTRIA , ESTADO DE PE = E FOR CNPJ = ""
		IF (  AllTrim( v_TpPessoa ) != "F" .AND. ;
				Upper(AllTrim( v_RamoAtv )) == "IN" .AND. ;
				AllTrim( __FILIAL ) == "05" ) //.AND. AllTrim(v_UFCli) != "PE"    )

			__TIPOP := "12"

		EndIF

		IF( AllTrim( __FILIAL ) == "08" )
			__TIPOP := "01"
		EndIF



		For __n := 1 To Len( aItens )

			v_Tes := __TES( __TIPOP ,"S", aItens[__n][2], v_CodCli, v_LojCli, __FILIAL )

			v_largura := Posicione("SB5",1,xFilial("SB5")+aItens[__n][2],"B5_LARG")
			v_altura  := Posicione("SB5",1,xFilial("SB5")+aItens[__n][2],"B5_COMPR")

			__cNameAlias := GETNEXTALIAS()





			IF( AlLTrim( __FILIAL ) == "08" )
				IF( AllTrim(v_TpMat) == "2" .OR. AllTrim(v_TpMat) == "5"  .OR. AllTrim(v_TpMat) == "4"  )
					v_LocPad := "03"
				Else
					v_LocPad := "18"
				EndIF
			EndIF


			cSQL := " SELECT B1_LOCPAD, B1_TIPO, B1_ORIGEM FROM SB1010 WHERE D_E_L_E_T_ <> '*' AND TRIM(B1_COD) = '"+ALLTRIM(aItens[__n][2])+"'"
			dbUseArea(.T.,__CONNECT,TcGenQry(,,cSQL),__cNameAlias,.T.,.T.)

			IF !(__cNameAlias)->(Eof())
				IF ( AllTrim((__cNameAlias)->B1_TIPO) == "PA" )
					v_LocPad := "03"
				EndIF
				v_OriProd := AllTrim( (__cNameAlias)->B1_ORIGEM )
			EndIF

			(__cNameAlias)->(DBCloseArea())

            
			IF( AlLTrim( __FILIAL ) == "01" )
				v_LocPad := "12"
				v_Tes := "540"
			EndIF

     
      
			IF( AlLTrim( __FILIAL ) == "08" )
				IF( AllTrim(v_TpMat) == "4"  )
					v_Tes := "540"
				EndIF
			EndIF

			// Quando : A1_XVIDRAC = '3' e A1_EST = 'PE' - gravar na filial 03 e usar a TES 558 !
			IF( AllTrim(v_Vidrac) == "2" .AND. AllTrim(v_UFCli) == "PE"  )
				IF ( AllTrim(__TIPOMAT) $  "2/5" )

					v_LocPad := "03"  // Armazém
					__TIPOP := "01" // operação
					v_Tes := "558"  // TES

				EndIF
			EndIF

			 

			
			//IF( AllTrim(v_Vidrac) == "2" .AND. lEstPB )
			//	IF ( AllTrim(__TIPOMAT) $  "2/5" )
			
			//EndIF	

			//IF( AllTrim(__TIPOMAT) ==  "1" .AND. lEstPB )
				 
				//	v_LocPad := "01"  // Armazém
				//	__TIPOP := "01" // operação
				//	v_Tes := "502"  // TES
				 
			//EndIF	




			cItem := Soma1(cItem,TamSX3("C6_ITEM")[1])

			aAdd(aItePv,{"C6_FILIAL"  	,xFilial("SC6")	,Nil})
			aAdd(aItePv,{"C6_ITEM"   	,cItem ,Nil})
			aAdd(aItePv,{"C6_PRODUTO"	,aItens[__n][2]	,Nil})

			IF ( v_largura !=0 .AND. v_altura != 0 )
				aAdd(aItePv,{"C6_LARGURA" 	,v_largura	,Nil})
				aAdd(aItePv,{"C6_ALTURA"  	,v_altura	,Nil})
			EndIF

			IF( aItens[__n][5] != 0 )
				aAdd(aItePv,{"C6_PECA"  ,aItens[__n][5]	,Nil})
			EndIF


			// aItens[__n][2]

			// Posicione("SB1",1,xFilial("SB1")+_SC5->C6_PRODUTO,"SB1->B1_IPI")
			aProd := getProduto( aItens[__n][2] )


			IF( AT( ",", cValToChar( aItens[__n][3] ) ) !=0  )
				v_qtdven := VAL( StrTran( Transform( aItens[__n][3], PesqPict("SC6","C6_QTDVEN")) , ",",".") )
			Else
				v_qtdven :=   aItens[__n][3]
			EndIF

			aAdd(aItePv,{"C6_QTDVEN"  	, v_qtdven , Nil})
			aAdd(aItePv,{"C6_QTDLIB"  	, v_qtdven , Nil})

			IF !lEstPB .AND. AllTrim( aProd[1][2] ) != "507" .AND. !lEstPI
				IF Empty( aItens[__n][7] )
					aAdd(aItePv,{"C6_OPER"  	, __TIPOP  , Nil})
				EndIF
			EndIF 


			//Transform( aItens[__n][3], PesqPict("SC6","C6_QTDVEN"))

//			aAdd(aItePv,{"C6_PRCVEN"  	, Round(aItens[__n][6],2)	,Nil})
			//v_prcven := VAL( Replace(Transform( NoRound( aItens[__n][6]), "@E 9,999,999.99") ,",",".") )
			v_prcven := NoRound( aItens[__n][6] )
			v_totven :=  A410Arred(v_prcven*v_qtdven,"C6_VALOR")
			//IF( Len( SubStr(ALLTRIM(v_prcven), AT( ".",ALLTRIM(v_prcven)), 10 ))   > 3 )
			aAdd(aItePv,{"C6_PRCVEN"  	, v_prcven	,Nil})


			//Else
			//	aAdd(aItePv,{"C6_PRCVEN"  	, aItens[__n][6] 	,Nil})
			//EndIF


 
			aAdd(aItePv,{"C6_ENTREG"    , dDataBase ,Nil})

			/*
			IF( !Empty(AllTrim( aItens[__n][6])) )
				IF( AllTrim( aItens[__n][6] ) != AllTrim(v_Tes)   )
					aAdd(aItePv,{"C6_TES"   , AllTrim( aItens[__n][6] )  , Nil})
				Else
					aAdd(aItePv,{"C6_TES"   , v_Tes   ,Nil})			
				EndIF
			EndIF
			*/	
			//IF( AlLTrim( __FILIAL ) == "09" )		
			//     v_LocPad := "01"
			//EndIF

			
			IF( !Empty(AllTrim( aItens[__n][7])) ) // Foi digitado a TES...
				v_Tes := aItens[__n][7] // TES pelo PEGASUS
			EndIF 

			IF lEstPB .OR. lEstPI
 

					IF ( ;
							AllTrim(__TIPOMAT) $  "1/2/5" ;
					 		.AND. ;
							( AllTrim(aProd[1][1] ) != '0030' .OR. AllTrim(aProd[1][1]) != '030' ) .AND. AllTrim( aProd[1][2] ) != "507";
						) 
						v_LocPad := "03"  // Armazém
						__TIPOP := "01" // operação
						v_Tes := "558"  // TES	

						 		ConOut(" FILIAL PARAIBA => 558 COM MATERIAL : " + __TIPOMAT  )		
					EndIF 
					


					IF ( ;
							AllTrim(__TIPOMAT) $  "1/2/5" ;
					 		.AND. ;
							( AllTrim(aProd[1][1] ) == '0030' .OR. AllTrim(aProd[1][1]) == '030' ) .AND. AllTrim( aProd[1][2] ) != "507" ;
						) 
						v_LocPad := "01"  // Armazém
						__TIPOP := "01" // operação
						v_Tes := "502"  // TES	

						 		ConOut(" FILIAL PARAIBA => 558 COM MATERIAL : " + __TIPOMAT  )		
					EndIF 				

				
			EndIF


			
			IF( AllTrim( aProd[1][2] ) == "507" .AND. AllTrim(cEst) == "PE" )
				v_Tes := "708"
				v_LocPad := "01"  
			EndIF 

			IF( AllTrim(aProd[1][2] ) == "507" .AND. AllTrim(cEst) != "PE"  )
				v_Tes := "709"
				v_LocPad := "01"  
			EndIF 
	
	        IF( AllTrim(aProd[1][2] ) == "507" .AND. AllTrim(cEst) == "PB"  )
				v_Tes := "502"
				v_LocPad := "01"  
			EndIF  

			IF ( AllTrim(__TIPOMAT) ==  "2" ) 

				IF(  AllTrim( vTipoCli ) == "S"  .AND. AllTrim( cEst ) == "PE"    )

						v_Tes := "558"

				EndIF 

			EndIF 

			IF (  AllTrim(__TIPOMAT) $  "1/5" )
				IF(  AllTrim( vTipoCli ) == "S"  .AND. AllTrim( cEst ) == "PE"    )
					IF( AllTrim(  aProd[1][1] ) ==   "030"  .OR.  AllTrim(  aProd[1][1] ) ==   "0030"   )
						v_Tes := "562"
					End IF
				EndIF 
			EndIF 

 
			aAdd(aItePv,{"C6_TES"   , v_Tes   ,Nil})



			IF ( lEstPB .AND. AllTrim(__TIPOMAT) == "1" )
				v_LocPad := "01"
			EndIF 

			IF ( lEstPI .AND. AllTrim(__TIPOMAT) == "1" )
				v_LocPad := "01"
			EndIF 


			aAdd(aItePv,{"C6_LOCAL" , v_LocPad  ,Nil})


			cEstLoc := GetMV("MV_ESTADO")

			/*

			IF ( lEstPB ;
				.AND. ;
				AllTrim(__TIPOMAT) $  "1/2/5" )
				v_LocPad := "03"  // Armazém
				__TIPOP := "01" // operação
				v_Tes := "558"  // TES		
			EndIF
		

			IF ( lEstPB  .AND. AllTrim(__TIPOMAT) ==  "1" )
				v_LocPad := "01"  // Armazém
				__TIPOP := "01" // operação
				v_Tes := "502"  // TES		
			EndIF
 
			*/

			cCf := Posicione("SF4",1,xFilial("SF4")+v_Tes,"F4_CF")
			v_SitTrib := AllTrim(Posicione("SF4",1,xFilial("SF4")+v_Tes,"F4_SITTRIB") )

			IF lEstPB .OR. lEstPI
			    v_Tes := "9"+ RIGHT( ALLTRIM( v_Tes) , 3 )
				cCfop :=  '5'+SubStr(cCf,2,3) 
			Else
				cCfop := IIF( "PE" <> cEst,'6'+SubStr(cCf,2,3),'5'+SubStr(cCf,2,3) )
			EndIF
			v_ClaFis := v_OriProd+v_SitTrib

			aAdd(aItePv,{"C6_CF" , cCfop  ,Nil})
			aAdd(aItePv,{"C6_CLASFIS" , v_ClaFis  ,Nil})

//			aAdd(aItePv,{"C6_VALOR" , v_totven  ,Nil}) 		   

			aAdd(aItensPV,aItePv)
			aItePv := {}
			
		Next

		aPSales := getPSales( v_PedPeg, __FILIAL , __TIPOMAT )

		IF ( Empty(aPSales) )

			IF( ALLTRIM(__FILIAL) == "08" )
				__FILIAL := "08"
			EndIF
			ConOut( " " )
			ConOut( "AGUARDE, GRAVANDO PEDIDO..." )

			MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCab, aItensPV, 3)

			IF !lMsErroAuto

				ConOut( " " )
				ConOut( " PEDIDO : "  + v_Ped + " - PROCESSADO COM SUCESSO !" )
				ConOut( "******************************************************************** ")

				IF lEstPB .OR. lEstPI
				  
					nStatus := TCSqlExec(" UPDATE SC6010 SET C6_TES = '5' || SUBSTR( C6_TES , 2 )  WHERE TRIM(C6_NUM)='"+AllTrim(v_Ped)+"'" )

					IF (nStatus < 0)
						conout("TCSQLError() " + TCSQLError())
					EndIF
					
				EndIF 


				__TOLOG( "", v_PedPeg, __FILIAL, v_Ped, aLog, .F. )

			Else

				ConOut( " " )
				ConOut( " -- ERRO AO PROCESSAR PEDIDO -- [ " + v_Ped + " ] " )
				ConOut( " ANALISAR LOG !!! \system\pegasus\log\log_"+__FILIAL+"_"+v_PedPeg+".log")
				ConOut( "******************************************************************** ")

				aErros 	:= GetAutoGRLog()
				nErros	:= Len( aErros )

				For nErro := 1 To Len( aErros )

					IF !Empty( aErros[ nErro ] )
						//ConOut( "ERRO -> [ " + cValToChar(nErro) + " ] " +  aErros[ nErro ] )
						//cErro := aErros[ nErro ] + CRLF
						aAdd( aLog, aErros[ nErro ] )
					EndIF

				Next nErro

				__TOLOG( cErro, v_PedPeg, __FILIAL, v_Ped, aLog, .F. )

			EndIF
		Else
			__TOLOG( "", v_PedPeg, __FILIAL, v_Ped, aLog, .T. )
		EndIF

		RpcClearEnv()
		ConOut( " " )
		ConOut( " " )

		RECOVER
		ConOut( ProcName() + " " + Str(ProcLine()) + " " + oError:Description )


	End Sequence

	ErrorBlock(oError)

Return .T.


Static Function __TOLOG( cErro, v_PedPeg, __FILIAL, v_Ped, aLog, lExist )

	local __logFile := "LOG_"+__FILIAL+"_"+v_PedPeg+".log"
	local __pathLog := GetSrvProfString( 'RootPath', '' )+"\system\pegasus\json\erros\"+__logFile
	local __pathJson := GetSrvProfString( 'RootPath', '' )+"\system\pegasus\json\"+v_PedPeg+".json"
	local __JSONDEST := GetSrvProfString( 'RootPath', '' )+"\system\pegasus\proc\"+v_PedPeg+".json"
	local lRet
	local cSql := ""
	local nStatus := 0


	IF( lExist )
		IF( File( __pathJson ) )
			__CopyFile( __pathJson, __JSONDEST )
			FERASE(__pathJson)
		EndIF
		Return Nil
	EndIF


	IF( !Empty( aLog ) )
		lRet := getInfo( aLog, v_PedPeg, __pathLog )
	EndIF

	IF( !Empty( aLog ) )

		TCSqlExec( " DELETE FROM TBL_PTHTRANSACAO WHERE TRIM(CD_VCHPEDIDOPEGASUS) = '"+AllTrim(v_PedPeg)+"' AND TRIM(CD_VCHSTATUS) = 'E' "  )

		cSql := " INSERT INTO TBL_PTHTRANSACAO ( CD_VCHPEDIDOPEGASUS , CD_VCHPEDIDOPROTHEUS, CD_VCHSTATUS, CD_VCHDATAHORAREC, CD_VCHDATAHORAPRO, CD_VCHLOGFILE ) VALUES('"+v_PedPeg+"','NNNNNN', 'E','"+DTOC( Date() ) + " - " + Time() +"','NNNNNN','" + __logFile + "' ) "

		nStatus := TCSqlExec( cSql )

		IF ( nStatus < 0 )
			ConOut( " " )
			ConOut( "************************ [ ERRO !] ************************* ")
			ConOut(" FILIAL..: " + __FILIAL  )
			ConOut(" SQL.....: " + TCSQLError()  )
			ConOut( "************************************************************ ")
			ConOut( " " )

		EndIF

	EndIF


	IF( Empty( aLog ) ) // Processou MsExecAuto sem erros !

		__LIBPED ( v_Ped )

		IF( File( __pathJson ) )
			__CopyFile( __pathJson, __JSONDEST )
		EndIF

		cSql := " INSERT INTO TBL_PTHTRANSACAO ( CD_VCHPEDIDOPEGASUS , CD_VCHPEDIDOPROTHEUS, CD_VCHSTATUS, CD_VCHDATAHORAREC, CD_VCHDATAHORAPRO, CD_VCHLOGFILE ) VALUES('"+v_PedPeg+"','" + AllTrim(v_Ped) + "', 'P','"+DTOC( Date() ) + " - " + Time() +"','"+DTOC( Date() ) + " - " + Time() +"','NNNNNN' ) "

		nStatus := TCSqlExec( cSql )

		IF ( nStatus < 0 )
			ConOut( " " )
			ConOut( "************************ [ ERRO !] ************************* ")
			ConOut(" FILIAL..: " + __FILIAL  )
			ConOut(" SQL.....: " + TCSQLError()  )
			ConOut( "************************************************************ ")
			ConOut( " " )

		EndIF


	EndIF



Return Nil

Static Function GetPVSales( v_PedPeg, __nCount )

	local lRet := .F.
	local cSQL := ""
	local  __cNameAlias := GETNEXTALIAS()
	local __tmp := v_PedPeg+".json"
	local __pedido := GetSrvProfString( 'RootPath', '' )+"\system\pegasus\json\"+__tmp


	cSQL := " SELECT COUNT(*) AS vTotal  FROM " + RETSQLNAME("SC5") + " WHERE TRIM(C5_XPEDPEG) = '"+v_PedPeg+"' AND D_E_L_E_T_ <> '*' "
	dbUseArea(.T.,__CONNECT,TcGenQry(,,cSQL),__cNameAlias,.T.,.T.)


	IF( vTotal == __nCount )

		//IF FERASE(__pedido) == -1
		// 	ConOut('--ERROR FILE!--')
		//EndIF

		lRet := .T.

	EndIF

	(__cNameAlias)->(DBCloseArea())


Return lRet


Static Function getProduto( vProduto )

	local aRet := {}
	local cSQL := ""
	local aOldArea := GetArea()
	local  __cNameAlias := GETNEXTALIAS()
 

	 
	cSQL := " SELECT * FROM SB1010 WHERE TRIM(B1_COD) = '" + AlLTrim(vProduto)  + "'"
 

	MemoWrite("\system\getProduto.pth" , cSQL )

	dbUseArea(.T.,__CONNECT,TcGenQry(,,cSQL),__cNameAlias,.T.,.T.)


	IF !(__cNameAlias)->(Eof())
		aAdd( aRet, { (__cNameAlias)->B1_GRTRIB, (__cNameAlias)->B1_SUBGRP } )
	EndIF

	(__cNameAlias)->(DBCloseArea())


	RestArea(aOldArea)

Return aRet


Static Function getPSales( vPPegasus, vFilial, __TIPOMAT )

	local aRet := {}
	local cQuery := ""
	local aOldArea := GetArea()
	local  __cNameAlias := GETNEXTALIAS()
	local v_SqlAnd := ""

	IF( AllTrim( __TIPOMAT ) == "2" .OR. AllTrim( __TIPOMAT ) == "5" )
		v_SqlAnd := " AND TRIM(C5_XTPMAT) = '25' "
	Else
		v_SqlAnd := " AND TRIM(C5_XTPMAT) = '" + AllTrim( __TIPOMAT ) +"'"
	EndIF

	cQuery := " SELECT * FROM SC5010 WHERE TRIM(C5_XPEDPEG) = '" + AlLTrim(vPPegasus) + "' AND TRIM(C5_FILIAL) = '" + AllTrim(vFilial) + "' AND D_E_L_E_T_ <> '*' "
	cQuery += v_SqlAnd


	MemoWrite("\system\getPSales.pth" , cQuery )

	dbUseArea(.T.,__CONNECT,TcGenQry(,,cQuery),__cNameAlias,.T.,.T.)


	IF !(__cNameAlias)->(Eof())
		aAdd( aRet, { (__cNameAlias)->C5_NUM, vPPegasus } )
	EndIF

	(__cNameAlias)->(DBCloseArea())


	RestArea(aOldArea)

Return aRet


Static Function __COMISSAO( vPPegasus, vFilial )

	local lRet := .F.
	local cQuery := ""
//	 Local aOldArea := GetArea()
	local  __cNameAlias := GETNEXTALIAS()

	cQuery := " SELECT C5_COMIS1, C5_COMIS2 FROM SC5010 WHERE TRIM(C5_XPEDPEG) = '" + AlLTrim(vPPegasus) + "' AND TRIM(C5_FILIAL) != '00' AND D_E_L_E_T_ <> '*' "

	MemoWrite("\system\getComissao.pth" , cQuery )

	dbUseArea(.T.,__CONNECT,TcGenQry(,,cQuery),__cNameAlias,.T.,.T.)


	IF !(__cNameAlias)->(Eof())
		IF (  (__cNameAlias)->C5_COMIS1 != 0 .OR. (__cNameAlias)->C5_COMIS2 != 0 )
			lRet := .T.
		EndIF
	EndIF

	(__cNameAlias)->(DBCloseArea())


	//	RestArea(aOldArea)

Return lRet





Static Function __TES( cTPOPER,cEntSai, cCodProd, cCliente, cLoja, vFilial )


	local cQuery := ""
	Local cTPOPER
	Local cPRODNAC
	Local cPRODST
	Local cCONTRIB
	Local cTPCLIEN
	Local cDENTROE
	Local cTES
	Local cDESCTES
	local cOriProd := ""
	local  __cNameAlias


 

	
	DBSelectArea("SB1")
	DBSetOrder(1)
	DbSeek(xFilial()+cCodProd)

	ConOut( "PRODUTO : " + cCodProd + " / " + SB1->B1_DESC )

	cOriProd := SB1->B1_ORIGEM

	IF SB1->B1_ORIGEM=="1"
		cPRODNAC := "S"
	Else
		cPRODNAC := "N"
	Endif

	IF !Empty(SB1->B1_PICMRET)
		cPRODST := "S"
	Else
		cPRODST := "N"
	EndIF

	__cNameAlias := GETNEXTALIAS()

	cQuery := "SELECT * FROM " + RETSQLNAME("SA1") +" WHERE TRIM(A1_COD) = '" +AllTrim(cCliente) +"' AND TRIM(A1_LOJA) = '" + AllTrim(cLoja)+ "' AND D_E_L_E_T_ <> '*' "
	dbUseArea(.T.,__CONNECT,TcGenQry(,,cQuery),__cNameAlias,.T.,.T.)


	ConOut( " PESQUISANDO CLIENTE..." + cCliente+"/"+cLoja )

	ConOut( "CLIENTE : " + (__cNameAlias)->A1_NREDUZ +" / " + (__cNameAlias)->A1_NOME )

	IF Empty((__cNameAlias)->A1_INSCR) .Or. "ISENT" $ (__cNameAlias)->A1_INSCR
		cContrib := "N"
	Else
		cContrib := "S"
	EndIF

	cTPCLIEN := (__cNameAlias)->A1_TIPO

	IF (__cNameAlias)->A1_EST $ GETMV("MV_ESTADO")
		cDENTROE := "S"
	Else
		cDENTROE := "N"
	EndIF


	cQuery := "SELECT Z5_TES, Z5_DESCTES "
	cQuery += "FROM " + RetSqlName("SZ5")+" "
	cQuery += "WHERE D_E_L_E_T_ <> '*' "
	cQuery += "AND Z5_FILIAL = '"+vFilial+"' "
	cQuery += "AND Z5_MSBLQL <> '1' "
	cQuery += "AND Z5_TPOPER = '" + cTPOPER + "' "


	If !Empty(cPRODNAC) .And. AllTrim(cOriProd) != '5'
		cQuery += "AND (Z5_PRODNAC = '" + cPRODNAC + "' "
		cQuery += "OR Z5_PRODNAC = 'A') "
	Else
		IF (__cNameAlias)->A1_EST $ GETMV("MV_ESTADO") .AND.  AllTrim(cOriProd) == "5"
			cQuery += " AND ( TRIM(Z5_ORIPROD) = '" + AllTrim(cOriProd) + "' ) "
		EndIF

	Endif

	If !Empty(cPRODST)
		cQuery += "AND (Z5_PRODST = '" + cPRODST + "' "
		cQuery += "OR Z5_PRODST = 'A') "
	Endif
	If !Empty(cCONTRIB)
		cQuery += "AND (Z5_CONTRIB = '" + cCONTRIB + "' "
		cQuery += "OR Z5_CONTRIB = 'A') "
	Endif
	If !Empty(cTPCLIEN)
		cQuery += "AND (Z5_TPCLIEN = '" + cTPCLIEN + "' "
		cQuery += "OR Z5_TPCLIEN = 'A') "
	Endif
	If !Empty(cDENTROE)
		cQuery += "AND (Z5_DENTROE = '" + cDENTROE + "' "
		cQuery += "OR Z5_DENTROE = 'A') "
	Endif

	MemoWrite("\system\tes.pth" , cQuery )

	(__cNameAlias)->(DBCloseArea())

	__cNameAlias := GETNEXTALIAS()

	dbUseArea(.T.,__CONNECT,TcGenQry(,,cQuery),__cNameAlias,.T.,.T.)

	cTES := (__cNameAlias)->Z5_TES
	(__cNameAlias)->(DBCloseArea())

Return(cTES)



Static Function getInfo( aLog, v_PedPeg, __pathLog  )
	local n
	local nHandle



	nHandle  :=  FCreate(__pathLog)
	ConOut( " getInfo -> nHandle : " + cValToChar( nHandle ) )
	FWrite(nHandle, DtoC(MsDate()) + " - " + Time() + CRLF )

	For n := 1 To Len( aLog )
		FWrite(nHandle, aLog[n] + CRLF )
	Next

	FClose( nHandle )

Return .T.






Static Function __SUBTRIB( v_CodCli, v_LojCli, v_TpClient, __TIPOP , __FILIAL, aItens  )

	local v_Itens := 0
	local _nAliqIcm  := 0.00
	local _nValIcm   := 0.00
	local _nBaseIcm  := 0.00
	local _nValIpi   := 0.00
	local _nBaseIpi  := 0.00
	local _nValMerc  := 0.00
	local _nValSol   := 0.00
	local nTotSol    := 0.00
	local nTotIPI    := 0.00
	local __n := 0
 


	For __n := 1 To Len( aItens )

        //  502
		v_Tes := __TES ( __TIPOP ,"S", aItens[__n][2], v_CodCli, v_LojCli, __FILIAL )

		// Somando os itens :
		v_Itens +=  ROUND( ( aItens[__n][3] * aItens[__n][6] ),2)

		// Calcula impostos...
		MaFisIni(  v_CodCli,v_LojCli,"C","N",v_TpClient,MaFisRelImp("MTR700",{"SC5","SC6"}),,,"SB1","MTR700")
		MaFisAdd( aItens[__n][2],;
			v_Tes,;
			aItens[__n][3] ,;
			aItens[__n][6] ,;
			0,;//SC6->C6_VALDESC,;
			"",;
			"",;
			0,;
			0,;
			0,;
			0,;
			0,;
			( aItens[__n][3] * aItens[__n][6] ),;
			0,;
			0,;
			0)


		_nAliqIcm  := MaFisRet(1,"IT_ALIQICM")
		_nValIcm   := MaFisRet(1,"IT_VALICM" )
		_nBaseIcm  := MaFisRet(1,"IT_BASEICM")
		_nValIpi   := MaFisRet(1,"IT_VALIPI" )
		_nBaseIpi  := MaFisRet(1,"IT_BASEICM")
		_nValMerc  := MaFisRet(1,"IT_VALMERC")
		_nValSol   := MaFisRet(1,"IT_VALSOL" )

		nTotSol += _nValSol

		IF !Empty(_nValSol)
			_nValSol := Round(_nValSol/aItens[__n][3],2)
		EndIF

		Conout( "Subs. Trib do Produto :" + aItens[__n][2]  + " R$ :" + cValToChar(_nValSol) )


		// Calcula IPI
		nTotIPI += _nValIpi

		Conout( " I.P.I do Produto :" + aItens[__n][2] + " R$ :" + cValToChar(_nValIpi) )

		MaFisEnd()
	Next

	// Valor total do pedido com calculo dos impostos !
	IF ( nTotSol != 0 ) // Se tem ST...
		v_TotST := nTotSol + nTotIPI
	Else
		v_TotST := nTotIPI
	EndIF

	Conout( " Total ( R$ ) de Itens : " + cValToChar(v_Itens) )
	Conout( " Total ( R$ ) de Impostos : " + cValToChar(v_TotST) )

	v_TotST :=  v_TotST + v_Itens



Return v_TotST


Static Function getPedido( vFilial )

	Local cPedVen := ""
	Local aArea := GetArea()
	Local cAliasSC5 := "TSC5"
	Local __X_NUM := 0
	Local __L_MV := "" 

	local __nx := 0
	local lFound := .T.
	local cQuery := ""
	local aQuery
	local nT := 100
	local nI := 1

  /*
 GETMV("ES_LNUMPED")
	IF AllTrim(vFilial == "03" )
		__L_MV := "Y"
	ElseIF  AllTrim(vFilial == "05" )
		__L_MV := "P"
 	ElseIF  AllTrim(vFilial == "09" )
		__L_MV := "R"
 	ElseIF  AllTrim(vFilial == "01" )
		__L_MV := "M"
 	ElseIF  AllTrim(vFilial == "08" )
		__L_MV := "N"
	EndIF 
	
 

	 

	 For nI := 1 To nT 

		cPedVen := StrZero( Randomize( 1234, 12345 ) , 5 )
		cPedVen := AlLTrim(__L_MV)+ALLTRIM( cPedVen  )

		DbSelectArea('SC5')
		SC5->(DbSetOrder(1)) //C5_FILIAL + C5_NUM
		SC5->(DbGoTop())
 		IF ( SC5->(!dbSeek( vFilial + cPedVen )) )

			SC5->(DBCLOSEAREA())
			RestArea(aArea)

			Return(cPedVen)
		EndIF 
	 Next nI 


  */
 
	IF ( AllTrim(vFilial) == "03" ) 
		
		__L_MV := "L"

   		cQuery := " SELECT NVL( LPAD((TO_NUMBER(TO_CHAR(  MAX(regexp_replace( C5_NUM, '[^[:digit:]]', null )) ))+1),'5','0'), '00001')  AS NPEDVEN   FROM SC5010  WHERE   LENGTH(TRIM(C5_NUM)) = 6 "
		cQuery += " AND LPAD(C5_NUM,1) = '"+__L_MV+"'  AND   D_E_L_E_T_  <> '*' AND LENGTH(TRIM(C5_NUM)) = 6"
		cQuery += " AND C5_FILIAL = '" + vFilial + "' "

	   
	  
	ElseIF ( AllTrim(vFilial) == "05" ) 
		
		__L_MV := "A"

	 
   		cQuery := " SELECT NVL( LPAD((TO_NUMBER(TO_CHAR(  MAX(regexp_replace( C5_NUM, '[^[:digit:]]', null )) ))+1),'5','0'), '00001')  AS NPEDVEN   FROM SC5010  WHERE   LENGTH(TRIM(C5_NUM)) = 6 "
		cQuery += " AND LPAD(C5_NUM,1) = '"+__L_MV+"'  AND   D_E_L_E_T_  <> '*' AND LENGTH(TRIM(C5_NUM)) = 6"
		cQuery += " AND C5_FILIAL = '" + vFilial + "' "
	 
 

		 

 	ElseIF ( AllTrim(vFilial) == "09" ) 
	
		__L_MV := "E"
	    cQuery := " SELECT NVL( LPAD((TO_NUMBER(TO_CHAR(  MAX(regexp_replace( C5_NUM, '[^[:digit:]]', null )) ))+1),'5','0'), '00001')  AS NPEDVEN   FROM SC5010  WHERE   LENGTH(TRIM(C5_NUM)) = 6 "
		cQuery += " AND LPAD(C5_NUM,1) = '"+__L_MV+"'  AND   D_E_L_E_T_  <> '*' AND LENGTH(TRIM(C5_NUM)) = 6"
		cQuery += " AND C5_FILIAL = '" + vFilial + "' "
			 
 	ElseIF ( AllTrim(vFilial) == "10" ) 
	
		__L_MV := "A"
	    cQuery := " SELECT NVL( LPAD((TO_NUMBER(TO_CHAR(  MAX(regexp_replace( C5_NUM, '[^[:digit:]]', null )) ))+1),'5','0'), '00001')  AS NPEDVEN   FROM SC5010  WHERE   LENGTH(TRIM(C5_NUM)) = 6 "
		cQuery += " AND LPAD(C5_NUM,1) = '"+__L_MV+"'  AND   D_E_L_E_T_  <> '*' AND LENGTH(TRIM(C5_NUM)) = 6"
		cQuery += " AND C5_FILIAL = '" + vFilial + "' "

	 ElseIF ( AllTrim(vFilial) == "01" ) 
		
		__L_MV := "F"
 
	 
   		cQuery := " SELECT NVL( LPAD((TO_NUMBER(TO_CHAR(  MAX(regexp_replace( C5_NUM, '[^[:digit:]]', null )) ))+1),'5','0'), '00001')  AS NPEDVEN   FROM SC5010  WHERE   LENGTH(TRIM(C5_NUM)) = 6 "
		cQuery += " AND LPAD(C5_NUM,1) = '"+__L_MV+"'  AND   D_E_L_E_T_  <> '*' AND LENGTH(TRIM(C5_NUM)) = 6"
		cQuery += " AND C5_FILIAL = '" + vFilial + "' "

	 ElseIF ( AllTrim(vFilial) == "08" ) 
		
		__L_MV := "Z"
	    
 
	 
   		cQuery := " SELECT NVL( LPAD((TO_NUMBER(TO_CHAR(  MAX(regexp_replace( C5_NUM, '[^[:digit:]]', null )) ))+1),'5','0'), '00001')  AS NPEDVEN   FROM SC5010  WHERE   LENGTH(TRIM(C5_NUM)) = 6 "
		cQuery += " AND LPAD(C5_NUM,1) = '"+__L_MV+"'  AND   D_E_L_E_T_  <> '*' AND LENGTH(TRIM(C5_NUM)) = 6"
		cQuery += " AND C5_FILIAL = '" + vFilial + "' "


	EndIF 
 
		MemoWrite("\system\GETNUMPED_"+__L_MV, cQuery )

		cQuery := ChangeQuery( cQuery )
		dbUseArea( .t., "TOPCONN", TcGenQry( ,,cQuery ), cAliasSC5, .f., .t. )

		cPedVen:= __L_MV+(cAliasSC5)->NPEDVEN

		DbCloseArea("TSC5")
		RestArea(aArea)
	 

Return(cPedVen)    
	
User Function FJOB

	private oJob := TJOB():New()

	oJob:Start()

Return


User Function PTH001

	private bBrowse := { || __refresh() }
	private aIndex := {}
	private cFiltro := "!Empty(C5_XPEDPEG) .AND. C5_FILIAL $ '01/03/05/08' .AND. DTOS(C5_EMISSAO) >= '20181001' "
	private bFiltraBrw := { || FilBrowse( "SC5" , @aIndex , @cFiltro ) }
	private aCampos := {}


	aadd(aCampos,{"Pedido","C5_NUM"              ,'C',06,0,'@!'})
	aadd(aCampos,{"Ped.Pegasus","C5_XPEDPEG"     ,'C',20,0,'@!'})
	aadd(aCampos,{"Nome","C5_XCLINOMadmin"     ,'C',60,0,'@!'})

	private cCadastro := "TOTVS Pegasus Interface"

	private aCores := { {" Empty( C5_LIBEROK ) ","BR_VERDE"},; // Pedido de Vendas em Aberto
	{" !Empty( C5_NOTA ) ","BR_VERMELHO"},;  // Pedido de Vendas Faturado
	{" AllTrim(C5_LIBEROK) == 'S' ","BR_AMARELO"}} // Pedido de Vendas Liberado

	private aRotina := { {"Pesquisar","AxPesqui"  ,0,1} ,;
		{"Visualizar","AxVisual" ,0,2} ,;
		{"Legenda","U_legpth()" ,0,3} }


	private cString := "SC5"

	dbSelectArea("SC5")
	dbSetOrder(1)


	dbSelectArea(cString)
	Eval( bFiltraBrw )
	mBrowse( 6, 1, 22, 75, cString,aCampos,,,,,aCores )


//	    mBrowse( 6 ,1, 22, 75, cString,,,,,,aCores,,,1000, bBrowse)
EndFilBrw( "SC5" , @aIndex )

Return ( NIL )


Static Function __LIBPED(cPedido)
	Local aArea     := GetArea()
	Local aAreaC5   := SC5->(GetArea())
	Local aAreaC6   := SC6->(GetArea())
	Local aAreaC9   := SC9->(GetArea())
	Local cPedido   := SC5->C5_NUM
	Local aAreaAux  := {}
	Local cBlqCred  := "  "
	Local cBlqEst   := "  "
	Local aLocal    := {}
	Default cPedido := ""

	DbSelectArea('SC5')
	SC5->(DbSetOrder(1)) //C5_FILIAL + C5_NUM
	SC5->(DbGoTop())

	DbSelectArea('SC6')
	SC6->(DbSetOrder(1)) //C6_FILIAL + C6_NUM + C6_ITEM
	SC6->(DbGoTop())

	DbSelectArea('SC9')
	SC9->(DbSetOrder(1)) //C9_FILIAL + C9_PEDIDO + C9_ITEM
	SC9->(DbGoTop())

	//Se conseguir posicionar no pedido
	If SC5->(DbSeek(FWxFilial('SC5') + cPedido))

		//Se conseguir posicionar nos itens do pedido
		If SC6->(DbSeek(FWxFilial('SC6') + cPedido))
			aAreaAux := SC6->(GetArea())

			//Percorre todos os itens
			While ! SC6->(EoF()) .And. SC6->C6_FILIAL = FWxFilial('SC6') .And. SC6->C6_NUM == cPedido
				//Posiciona na liberação do item do pedido e estorna a liberação
				SC9->(DbSeek(FWxFilial('SC9')+SC6->C6_NUM+SC6->C6_ITEM))
				While  (!SC9->(Eof())) .AND. SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM) == FWxFilial('SC9')+SC6->(C6_NUM+C6_ITEM)
					SC9->(a460Estorna(.T.))
					SC9->(DbSkip())
				EndDo

				SC6->(DbSkip())
			EndDo

			RecLock("SC5", .F.)
			C5_LIBEROK := ""
			SC5->(MsUnLock())

			//Percorre todos os itens
			RestArea(aAreaAux)
			While ! SC6->(EoF()) .And. SC6->C6_FILIAL = FWxFilial('SC6') .And. SC6->C6_NUM == cPedido
				StaticCall(FATXFUN, MaGravaSC9, SC6->C6_QTDVEN, cBlqCred, cBlqEst, aLocal)
				 
				ConOut( "LIBERANDO...... " +   SC6->C6_NUM + " / " + SC6->C6_PRODUTO )
				SC6->(DbSkip())
			EndDo
		EndIf
	EndIf

	RestArea(aAreaC9)
	RestArea(aAreaC6)
	RestArea(aAreaC5)
	RestArea(aArea)
Return



USER FUNCTION UPTABLES
	local nFils := 1
	local nI := 0
	For nI := 1 To nFils

		RpcSetType( 3 )
		RpcSetEnv( "01", StrZero(nI,2) )
		X31UPDTABLE("SC5")
		CHKFILE("SC5")
		//  CriaSB2("00007042","01")
		//	CriaSB2("00000354","01")
		//	CriaSB2("00000355","01")
		Sleep(3000)
		ConOut( "FIL -> " + StrZero(nI,2) + ' cFilAnt -> ' + cFilAnt )
		RpcClearEnv()

	Next
RETURN


Static Function getCliente( cCodigo )

	local cSQL := ""
	local __idx := 0
	local  __cNameAlias := GETNEXTALIAS()
	local aRet := {}

	cSQL += "  SELECT CASE " + __ENTER
	cSQL += "        WHEN A1_MSBLQL = '1' THEN 'S' " + __ENTER
	cSQL += "                             ELSE 'N' " + __ENTER
	cSQL += "        END AS MSBLQL," + __ENTER
	cSQL += "        CASE " + __ENTER
	cSQL += "        WHEN A1_SALDUP > = 0 THEN A1_LC - (A1_SALDUP + A1_SALPED)  " + __ENTER
	cSQL += "                             ELSE -1 *(Abs(A1_LC - (A1_SALDUP + A1_SALPED))) " + __ENTER
	cSQL += "        END AS LC, A1_COD, A1_LOJA, A1_NREDUZ, A1_TIPO , A1_PESSOA, A1_CATEGUE, A1_TPESSOA, A1_EST, A1_RISCO,A1_XVIDRAC  " + __ENTER
	cSQL += "  FROM SA1010  " + __ENTER
	cSQL += "   WHERE TRIM(A1_COD) = '" + cCodigo + "' AND D_E_L_E_T_ <> '*' " + __ENTER

	dbUseArea(.T.,__CONNECT,TcGenQry(,,cSQL),__cNameAlias,.T.,.T.)

	IF !(__cNameAlias)->(Eof())       // A1_MSBLQL, A1_LC, A1_COD, A1_LOJA, A1_NREDUZ, A1_TIPO,  A1_PESSOA, A1_CATEGUE, A1_TPESSOA,  A1_EST, A1_RISCO,A1_XVIDRAC
		AADD( aRet, {   (__cNameAlias)->MSBLQL, (__cNameAlias)->LC,;
			(__cNameAlias)->A1_COD, (__cNameAlias)->A1_LOJA,;
			(__cNameAlias)->A1_NREDUZ,  (__cNameAlias)->A1_TIPO, (__cNameAlias)->A1_PESSOA, (__cNameAlias)->A1_CATEGUE,;
			(__cNameAlias)->A1_TPESSOA, (__cNameAlias)->A1_EST,  (__cNameAlias)->A1_RISCO, (__cNameAlias)->A1_XVIDRAC  } )
	Else
		AADD( aRet, {  '*', 0, '','',''  })
	EndIF

	(__cNameAlias)->(DBCloseArea())

	MemoWrite("\system\", "getCliente.pth")

Return aRet

User Function TTimp()
local aRet := getImposto( "05" , "021936", "01", "R", "00000100", "576",  1, 10,10 )
Return 
Static Function getImposto( __FILIAL,  cCliente,cLoja,cTipo,cProduto,cTes,nQtd,nPrc,nValor )


Local aImp := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}


	RPCSetType(3)
	RpcSetEnv("01", __FILIAL )

	// -------------------------------------------------------------------
	// Realiza os calculos necessários
	// -------------------------------------------------------------------
	MaFisIni(cCliente,; // 1-Codigo Cliente/Fornecedor
	cLoja,; // 2-Loja do Cliente/Fornecedor
	"C",; // 3-C:Cliente , F:Fornecedor
	"N",; // 4-Tipo da NF
	cTipo,; // 5-Tipo do Cliente/Fornecedor
	MaFisRelImp("MT100",{"SF2","SD2"}),;		// 6-Relacao de Impostos que suportados no arquivo
	,;						   					// 7-Tipo de complemento
	,;											// 8-Permite Incluir Impostos no Rodape .T./.F.
	"SB1",;					    				// 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
	"MATA461")									// 10-Nome da rotina que esta utilizando a funcao



// -------------------------------------------------------------------
	// Monta o retorno para a MaFisRet
	// -------------------------------------------------------------------
	MaFisAdd(cProduto, cTes, nQtd, nPrc, 0, "", "",, 0, 0, 0, 0, nValor, 0)
	
	//Monta um array com os valores necessários
	
	aImp[1] := cProduto
	aImp[2] := cTes
	aImp[3] := MaFisRet(1,"IT_VALSOL") //Valor de ST
	aImp[4] := MaFisRet(1,"IT_VALICM") //Valor de ICMS
	aImp[5] := MaFisRet(1,"IT_VALIPI") //Valor de IPI
	aImp[6] := MaFisRet(1,"IT_ALIQCOF") //Aliquota de calculo do COFINS
	aImp[7] := MaFisRet(1,"IT_ALIQPIS") //Aliquota de calculo do PIS
	aImp[8] := MaFisRet(1,"IT_ALIQPS2") //Aliquota de calculo do PIS 2
	aImp[9] := MaFisRet(1,"IT_ALIQCF2") //Aliquota de calculo do COFINS 2
	aImp[10]:= MaFisRet(1,"IT_DESCZF") //Valor de Desconto da Zona Franca de Manaus
	aImp[11]:= MaFisRet(1,"IT_VALPIS") //Valor do PIS
	aImp[12]:= MaFisRet(1,"IT_VALCOF") //Valor do COFINS
	aImp[13]:= MaFisRet(1,"IT_BASEICM") //Valor da Base de ICMS
	aImp[14]:= MaFisRet(1,"IT_BASESOL") //Base do ICMS Solidario
	aImp[15]:= MaFisRet(1,"IT_ALIQSOL") //Aliquota do ICMS Solidario
	aImp[16]:= MaFisRet(1,"IT_MARGEM") //Margem de lucro para calculo da Base do ICMS Sol.
	aImp[17]:= MaFisRet(1,"IT_ALIQICM") //Aliquota de ICMS
	aImp[18]:= MaFisRet(1,"IT_ALIQIPI") //Aliquota de IPI	
	//Não sei bem o uso dessas funções
	MaFisSave()
	MaFisEnd()
	
Return aImp 
