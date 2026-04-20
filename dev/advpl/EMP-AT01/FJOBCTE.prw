#INCLUDE "totvs.ch"
#INCLUDE "topconn.ch"
#INCLUDE "fileio.ch"
#INCLUDE "tbiConn.ch"


// JOSE TEIXEIRA | BOSSWARE

#DEFINE __CELDIG 10
#DEFINE __EOF "*"
#DEFINE __FILE_ERROR -1
#DEFINE __TRUE__  .T.
#DEFINE __FALSE__  .F.
#DEFINE __CONNECT 'TOPCONN'
#DEFINE __JOB_DEFAULT_NAME " [ JOB PROCESSOR  ] "
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
#IFNDEF CRLF
	#DEFINE CRLF Chr(13)+Chr(10)
#ENDIF




/*
####################################################################################################
## 												  												  ##																						
## BY      : JOSE TEIXEIRA                                                                        ##
##------------------------------------------------------------------------------------------------##
## BOSSWARE TECHNOLOGY  | DATA | 12/11/2016                                                       ##
##                                                                                                ##
##                                                                                                ##
##           J    O     B          C  T  E                                                        ##
##                                                                                                ##
##                                                                                                ##
##                                                                                                ##
##------------------------------------------------------------------------------------------------##
## CLIENTE : CASAS BANDEIRANTES                                                                   ##
##------------------------------------------------------------------------------------------------##
####################################################################################################
*/


class TJOBCTE

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



method New(cJobName) class TJOBCTE
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


method start() class TJOBCTE

	local cEnv 	 := GetEnvServer()
	local lStart := __TRUE__
	local cPathLog  :=  GetSrvProfString("Startpath","") + 'TService\'
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
	local __INITJOBFIN := "INITJOBFIN"
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
	private aRecnoSM0 := GETEMP()
	private xFil := ""
	private aMATA103 := {}
	__createKey( cPathLog )  // Cria parametros para o APPSERVER !!!

	cNameJOB := GetPvProfString(cSecao, cNameJOB, "@@", cServerIni)

	::JOBNAME := IIF( cNameJOB == "@@",;
		::JOBNAME, cNameJOB )


	__cInterNet := Nil



	While ;
			!KillApp()
		::lInProcess := __TRUE__


		__TIME := StrZero(Val(Left(Time(),2)),2)

		IF ( ;
				KillApp() .Or.File(cPathLog+"TJOBCTE.JOB") ) // caso seja criado esse arquivo, imediatamente o JOB será encerreado.

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


			__END_SERVICE__  // Kill Process JOB



		EndIF


		For nI := 1 To Len( aRecnoSM0 )


			PTInternal(1, ::JOBNAME + " A G U A R D E ...INICIANDO JOB CTE"  )

			Sleep(2000)

			cEmp := aRecnoSM0[nI][2] //SM0->M0_CODIGO
			cFil := aRecnoSM0[nI][3] //SM0->M0_CODFIL

			cEmpresa := aRecnoSM0[nI][2] + " - " + AllTrim(aRecnoSM0[nI][4]) +" / "+ AllTrim(aRecnoSM0[nI][5]) //SM0->( M0_CODIGO + " - " + AllTrim( M0_NOME ) + " / " + AllTrim( M0_FILIAL ) )

			ConOut( " " )
			ConOut( " " )
			ConOut( "************************* " + ::JOBNAME + " ************************* ")
			ConOut(::JOBNAME + " : MONTANDO AMBIENTE PARA A EMPRESA : " + cEmpresa )
			ConOut( "************************* " + ::JOBNAME + " ************************* ")
			ConOut( " " )
			ConOut( " " )


//				RpcSetType( 3 )
			RpcSetEnv( aRecnoSM0[nI][2], aRecnoSM0[nI][3] )

			nTime := SuperGetMV("ES_HORAWFL", , 10 )
			cEmp := aRecnoSM0[nI][2] //SM0->M0_CODIGO
			cColigada := "0"+cEmp
			cEmpresa := aRecnoSM0[nI][2] + " - " + AllTrim(aRecnoSM0[nI][4]) +" / "+ AllTrim(aRecnoSM0[nI][5])
			cDelay := "1"


			ConOut( " " )
			ConOut( " " )
			ConOut( "************************* " + ::JOBNAME + " ************************* " )
			ConOut( ::JOBNAME + " : MONTANDO AMBIENTE PARA A EMPRESA : " + cEmpresa          )
			ConOut( "************************* " + ::JOBNAME + " ************************* " )
			ConOut( " " )
			ConOut( " " )

                 /*
 				
				__IDHd := LS_GetID()
				
				__APPUSER := GetPvProfString(cSecao, cMain, "@@", cServerIni)
				

				cDelay := GetPvProfString(cSecao, "TDELAY", "@@", cServerIni)
				cEmail := GetPvProfString(cSecao, cEmail, "@@", cServerIni)
				cLog := GetPvProfString(cSecao, cLog, "@@", cServerIni)	 
				
				__INITJOBFIN := GetPvProfString(cSecao, __INITJOBFIN, "@@", cServerIni)	

			    __APPUSER := __USERFUNCTION+GetPvProfString(cSecao, cMain, "@@", cServerIni)
			    	
				__APPUSER :="{|x,y| " + ALLTRIM(__APPUSER )+ " (x,y)} "  
    			__BLOCK := &( ALLTRIM(__APPUSER) )
    			
    			
			IF cEmp == "01" .AND. cFil == "01"
				   	__BLOCK_PROCESS := Eval( __BLOCK, cEmp, cFil )

                
				IF __BLOCK_PROCESS[1][1] == __EOF
			 		     nY += 1
				EndIF
				
			EndIF
					   
				 ConOut( " "  )
		   	     ConOut( " " )                                                                                  
			     ConOut( "************************* " + ::JOBNAME + " ************************* ")
				 ConOut(::JOBNAME + " : AGUARDANDO NF...." )                                
			     ConOut( "************************* " + ::JOBNAME + " ************************* ")
			     ConOut( " " )	
		   	     ConOut( " " )
                  
                 */


			getCTE()

			ConOut( " " )
			ConOut( " " )
			ConOut( "************************* " + ::JOBNAME + " ************************* ")
			ConOut(::JOBNAME + " : AGUARDANDO NOVA CHAMADA..." + Time()   )
			ConOut( "************************* " + ::JOBNAME + " ************************* ")
			ConOut( " " )
			ConOut( " " )
			return

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

			RpcClearEnv()
			Exit
		Next nI


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


method getParam() class TJOBCTE
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



Static Function __createKey( cPathLog )
	local cServerIni := GetAdv97()
	WritePProString('TSERVICE', 'TDELAY', '5', cServerIni ) // MINUTOS OU HORA..DEPENDENDO DA CHAMADA...
	WritePProString('TSERVICE', 'TEMAIL', 'teixeira.totvs@gmail.com', cServerIni ) // ENVIAR E-MAIL COM PROCESSO EXECUTADO OU ERRO
	WritePProString('TSERVICE', 'TLOG', '\tlogs', cServerIni ) // CONTROLE DE ERROS
	WritePProString('TSERVICE', 'MAIN', 'WFLWFIN', cServerIni ) // PROGRAMA QUE FAZ A IMPORTAÇÃO...
	WritePProString('TSERVICE', 'PREPAREIN', '21', cServerIni ) // LISTA DE EMPRESAS QUE IREMOS USAR...
	WritePProString('TSERVICE', 'SXS', '0', cServerIni ) // LISTA DE EMPRESAS QUE IREMOS USAR...



	MAKEDIR( cPathLog )
	MAKEDIR( cPathLog+'\tlogs' )

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


Static Function getAppRPO(cName)
	local aData := GetAPOInfo( cName )
Return aData


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


Static Function getCTE()


	local cSQL
	local __cNameAlias

//	cSQL := " SELECT * FROM Tbl_SefazCte WHERE cStat = '100' AND xProcTOTVS = 'N' AND CST ='00' AND LEFT(dhEmi,10) = '2016-11-14' "
	cSQL := " SELECT * FROM Tbl_SefazCte WHERE cStat = '100' AND xProcTOTVS = 'N' AND CST IN( '00','040','40')  AND dhEmi LIKE '%2017-05%' "



//cSQL := " SELECT dhEmi, * FROM Tbl_SefazCte WHERE cStat = '100' "
//cSQL += " AND dhEmi LIKE '%2017-01%' AND vBC != 0   "


//    cSQL := " SELECT * FROM Tbl_SefazCte WHERE cStat = '100' AND xProcTOTVS = 'S' AND CST IN( '00','040')  AND dhEmi LIKE '%2017-02%' "


/*


	 __cNameAlias := GETNEXTALIAS()

	dbUseArea(.T.,__CONNECT,TcGenQry(,,cSQL),__cNameAlias,.T.,.T.)

	ConOut(Repl("-",80))
	ConOut(PadC("-- [ JOBCTE ] | DACTE  --",80))
    
    (__cNameAlias)->(DbGoTop())
    


	IF !(__cNameAlias)->(Eof())
 

		While !(__cNameAlias)->(Eof())
	     	   
					
			IF !isExist( (__cNameAlias)->nCT )
			doPutCte(  __cNameAlias )
		EndIF
					
			(__cNameAlias)->(dbSkip())
	EndDo
EndIF

(__cNameAlias)->(DBCloseArea())
 
*/ 
CTEPAG() // Pagamentos !!!

Return



/*
 Pagamentos !!!
*/
Static Function CTEPAG
	local cSQL
	local __cNameAlias



	RpcClearEnv()

//	RpcSetType( 3 )
	RpcSetEnv( "01", "01" )


//    cAnoMes := LEFT(DTOS(DDATABASE),4)+"-"+SUBS( DTOS(DDATABASE),5,2)   

	cAnoMes := "2017-04"
//    cSQL := " SELECT * FROM Tbl_SefazCte WHERE cStat = '100' AND xProcTOTVS = 'S' AND CST IN( '00','040')  AND dhEmi LIKE '%" + cAnoMes + "%'"  

	cSQL := " SELECT B.F2_FILIAL, A.*  FROM Tbl_SefazCte A  "
	cSQL += " INNER JOIN SF2010 B "
	cSQL += " ON "
	cSQL += " A.nfe_chave = B.F2_CHVNFE  "
//    cSQL += " WHERE A.cStat = '100' AND A.xProcTOTVS = 'S' AND A.CST IN( '00','040')  AND vLivro IS NULL  "  
	cSQL += " WHERE A.cStat = '100'  AND A.CST IN( '00','040','40' ) " // AND A.xProcTOTVS = 'S' AND A.CST IN( '00','040') "
	cSQL += " AND dhEmi LIKE '%" + cAnoMes + "%' "
	cSQL += " ORDER BY 1 "



	__cNameAlias := GETNEXTALIAS()

	dbUseArea(.T.,__CONNECT,TcGenQry(,,cSQL),__cNameAlias,.T.,.T.)

	ConOut(Repl("-",80))
	ConOut(PadC("-- [ JOBCTE ] | DACTE  --",80))

	(__cNameAlias)->(DbGoTop())


	IF !(__cNameAlias)->(Eof())


		While !(__cNameAlias)->(Eof())

                /*
                
  		        aInfo :=  doGetFor ( (__cNameAlias)->nfe_chave )
	            
	            xFil := aInfo[1][2]
	            
			IF ( ALLTRIM( xFil ) == ALLTRIM( aInfo[1][2] ) )
				IF !isLanPag ( (__cNameAlias)->nCT  )

						ConOut(Repl("-",80))
						ConOut(PadC("-- [ JOBCTE ] | DACTE  -- FILIAL : "  + xFil ,80))	 				    
						
				doFINA050(  __cNameAlias )
						
			EndIF
		EndIF

                */
	doArr( __cNameAlias )


	(__cNameAlias)->(dbSkip())
EndDo
EndIF

(__cNameAlias)->(DBCloseArea())

RpcClearEnv()

//	RpcSetType( 3 )
RpcSetEnv( "01", "01" )


doGetFis(  )  // Lançamento Fiscal CTe

Return


Static Function doFINA050(  xAlias )


	local oErr := ErrorBlock( { |e| __TO_ERR(E) } )

	Local aCabec    := {}
	Local aItem     := {}
	Local aItensT   := {}
	Local aLinha    := {}
	Local aTitulo   := {}

	Local xF3_ENTRADA := DDATABASE
	Local xF3_FISCAL := ""
	Local xF3_SERIE
	Local xF3_CLIEFOR
	Local xF3_LOJA
	Local xF3_ESTADO
	Local xF3_CFO
	Local xF3_EMISSAO
	Local xF3_ALIQICM := 18
	Local xF3_VALCONT
	Local xF3_BASEICM := 0.00
	Local xF3_VALICM
	Local xF3_ESPECIE := 'CTE'
	Local xF3_CHVNFE
	Local aInfo := {}
	Local xData
	Local xObs := ""
	Local xEmiss := ""

	PRIVATE lMsErroAuto
	BEGIN SEQUENCE




		xF3_FISCAL :=  (xAlias)->nCT
		xF3_SERIE := "1"




		IF  AllTrim( (xAlias)->CST ) == "00"


			xF3_VALCONT := (xAlias)->vBC
			xF3_BASEICM := (xAlias)->VBC
			xF3_VALICM  := (xAlias)->vICMS

		Else

			xF3_ALIQICM := 0
			xF3_VALCONT := 0
			xF3_BASEICM := (xAlias)->vTPrest
			xF3_VALICM  := 0

		EndIF




		aInfo :=  doGetFor ( (xAlias)->nfe_chave )

		xF3_ESPECIE := "CTE"
		xF3_CHVNFE := (xAlias)->chCTE
		xData :=   DATAVALIDA( CTOD ( RIGHT(  LEFT( (xAlias)->DHEMI, 10) , 2)  + '/' +  SUBSTRING(   LEFT( (xAlias)->DHEMI, 10) , 6, 2)  + '/' + LEFT(   LEFT( (xAlias)->DHEMI, 10) ,4) ) )

		xEmiss := CTOD ( RIGHT(  LEFT( (xAlias)->DHEMI, 10) , 2)  + '/' +  SUBSTRING(   LEFT( (xAlias)->DHEMI, 10) , 6, 2)  + '/' + LEFT(   LEFT( (xAlias)->DHEMI, 10) ,4) )


		xObs :=  "Frete CTe: " + ALLTRIM( (xAlias)->xObs )

		aTitulo 	:= {}
		aAdd(aTitulo, {"E2_PREFIXO" 	, "CTE"		, nil})
		aAdd(aTitulo, {"E2_NUM"			, strzero(val(ALLTRIM(xF3_FISCAL)),9)			, nil})
		aAdd(aTitulo, {"E2_PARCELA" 	, "1"		, nil})
		aAdd(aTitulo, {"E2_TIPO" 		, "NF"		, nil})
		aAdd(aTitulo, {"E2_HIST"		, xObs	, nil})
		aAdd(aTitulo, {"E2_FORNECE"		, "000273"		, nil})
		aAdd(aTitulo, {"E2_LOJA"   		, "01" 		, nil})
		aAdd(aTitulo, {"E2_NATUREZ"  	, "20703"     		, nil})
		aAdd(aTitulo, {"E2_EMISSAO"  	, xData 		, nil})
		aAdd(aTitulo, {"E2_VENCTO"  	, xData 		, nil})
		aAdd(aTitulo, {"E2_VENCREA"  	, DataValida( xData )	, nil})
		aAdd(aTitulo, {"E2_SERIE"  		, "1"		, nil})
		aAdd(aTitulo, {"E2_VALOR"  		, xF3_BASEICM		, nil})

		lMsErroAuto := .F.



		MSExecAuto({|x,y| FINA050(x,y)},aTitulo,3)

		IF lMsErroAuto
			ConOut( " -- NOTA COM ERRO : " + xF3_FISCAL + " -- " )
			// MostraErro()

			DisarmTransaction()
			Break
		Else
			ConOut( " -- NOTA PROCESSADA COM SUCESSO : " + xF3_FISCAL + " -- " )
			TCSqlExec(" UPDATE SE2010 SET E2_FILORIG = '" +  aInfo[1][2] + "', E2_FILIAL = '" +  aInfo[1][2]  + "' , E2_NOMFOR = 'C.BANDEIRANTES LTDA' WHERE E2_NUM = '" + xF3_FISCAL + "' AND E2_PREFIXO = 'CTE' " )
		EndIF



		lMsErroAuto := .F.




		RECOVER
		ErrorBlock(oErr)
	END SEQUENCE


Return

User Function doFINREC ( xAlias , xStSefaz, cNoFound )

Local aCabec    := {}
	Local aItem     := {}
	Local aItensT   := {}
	Local aLinha    := {}
	Local aTitulo   := {}

	Local xF3_ENTRADA
	Local xF3_FISCAL := ""
	Local xF3_SERIE
	Local xF3_CLIEFOR
	Local xF3_LOJA
	Local xF3_ESTADO
	Local xF3_CFO
	Local xF3_EMISSAO
	Local xF3_ALIQICM := 18
	Local xF3_VALCONT
	Local xF3_BASEICM := 0.00
	Local xF3_VALICM
	Local xF3_ESPECIE := 'CTE'
	Local xF3_CHVNFE
	Local aInfo := {}
	Local xData
	Local xObs := ""
	Local xEmiss := ""
	Local xChvCTe := ""
	Local dtPTH := ""
	Local lRet := .F.
	Local cDatCTe
	private lMsErroAuto := .F.

 
xF3_BASEICM := (xAlias)->VBC

	xF3_FISCAL :=  (xAlias)->nCT
	xF3_SERIE := "1"

	xChvCTe := AllTrim( StrTran( (xAlias)->chCte , 'CTe','') )

//	 IF ALLTRIM( (xAlias)->xTipoMov ) == "E"
//		 aInfo :=  doCteCli( (xAlias)->remCNPJ )
	//	 Else
//		 aInfo :=  doGetCli( (xAlias)->nfe_chave )                   
//	 EndIF               


	xF3_ESPECIE := "CTE"
	cDatCTe := ALLTRIM((xAlias)->DHEMI)
	xF3_CHVNFE := AllTrim( StrTran( (xAlias)->chCte , 'CTe','') )
	xData :=   DATAVALIDA( CTOD ( RIGHT(  LEFT( cDatCTe, 10) , 2)  + '/' +  SUBSTRING(   LEFT( cDatCTe, 10) , 6, 2)  + '/' + LEFT(   LEFT( cDatCTe, 10) ,4) ) )

	xEmiss := CTOD ( RIGHT(  LEFT( cDatCTe, 10) , 2)  + '/' +  SUBSTRING(   LEFT( cDatCTe, 10) , 6, 2)  + '/' + LEFT(   LEFT( cDatCTe, 10) ,4) )

	dtPTH := DTOS (   CTOD ( RIGHT(  LEFT( cDatCTe, 10) , 2)  + '/' +  SUBSTRING(   LEFT( cDatCTe, 10) , 6, 2)  + '/' + LEFT(   LEFT( cDatCTe, 10) ,4) )    )
	xObs :=  "Frete CTe: " + ALLTRIM( (xAlias)->xObs )


	IF (  xStSefaz == 1 )

		conout( xObs )


		IF ( ALLTRIM( (xAlias)->toma03 ) == "0" )
			aInfo :=  doCteCli( AllTrim( (xAlias)->remCNPJ) )

			IF( Empty(aInfo) )
				MsgAlert("Não encontrado : CNPJ/Remetente " + ALLTRIM((xAlias)->remCNPJ)  )

			EndIF

		EndIF

		IF ( ALLTRIM( (xAlias)->toma03 ) == "3" )
			aInfo :=  doCteCli(  AllTrim( (xAlias)->destcnpj) )

			IF( Empty(aInfo) )
				MsgAlert("Não encontrado : CNPJ/Destinatário " + ALLTRIM((xAlias)->destcnpj)  )

			EndIF
		EndIF




		cSQL := "	DELETE FROM SE1020 "
		cSQL += "   WHERE "
		cSQL += "   TRIM(E1_PREFIXO) = 'CTe' AND TRIM(E1_NUM) = '" + ALLTRIM(xF3_FISCAL) + "' "


		nStatus:= TCSqlExec(  cSQL )

		IF (nStatus < 0)
			MsgAlert ("TCSQLError() " + TCSQLError())
		EndIF

		TCSqlExec( "COMMIT" )

		TCRefresh("SE1020")



		aTitulo 	:= {}
		aAdd(aTitulo, {"E1_PREFIXO" 	, "CTe"		, nil})
		aAdd(aTitulo, {"E1_NUM"		, xF3_FISCAL			, nil})
		aAdd(aTitulo, {"E1_PARCELA" 	, "1"		, nil})
		aAdd(aTitulo, {"E1_TIPO" 	, "NF"		, nil})
		aAdd(aTitulo, {"E1_HIST"	, xObs	, nil})
		aAdd(aTitulo, {"E1_CLIENTE"	, aInfo[1][1]		, nil})
		aAdd(aTitulo, {"E1_LOJA"   	, aInfo[1][2] 		, nil})
		aAdd(aTitulo, {"E1_NATUREZ"  	, "10001"     		, nil})
		aAdd(aTitulo, {"E1_EMISSAO"  	, xData 		, nil})
		aAdd(aTitulo, {"E1_VENCTO"  	, xData 		, nil})
		aAdd(aTitulo, {"E1_VENCREA"  	, DataValida( xData )	, nil})
		aAdd(aTitulo, {"E1_SERIE"  	, "1"		, nil})
		aAdd(aTitulo, {"E1_VALOR"  	, xF3_BASEICM		, nil})
		aAdd(aTitulo, {"E1_VEND1"  	, "000108"		, nil})


		lMsErroAuto := .F.


		// CHARUTO PARAIBA
		MSExecAuto({|x,y| FINA040(x,y)},aTitulo,3)

		IF lMsErroAuto
			// Alert ( " -- NOTA COM ERRO : " + xF3_FISCAL + " -- " )
			TCSqlExec(" UPDATE Tbl_SefazCTe SET xProcTOTVSSaida = 'S',  vLivro = 'P', vRotinaStatus = 'FINA040-ERRO' WHERE TRIM(nCT) = " + xF3_FISCAL + " AND TRIM(cStat) = '100' " )
			  MostraErro()


		Else
			ConOut( " -- NOTA PROCESSADA COM SUCESSO : " + xF3_FISCAL + " -- " )
			TCSqlExec(" UPDATE Tbl_SefazCTe SET xProcTOTVSSaida = 'S',  vLivro = 'P', vRotinaStatus = 'FINA040-OK' WHERE TRIM(nCT) = " + xF3_FISCAL + " AND TRIM(cStat) = '100' " )
		EndIF


		lMsErroAuto := .F.
	EndIF


Return 

User Function doPutCte(  xAlias , xStSefaz, cNoFound )

//	local oErr := ErrorBlock( { |e| __TO_ERR(E) } )

	Local aCabec    := {}
	Local aItem     := {}
	Local aItensT   := {}
	Local aLinha    := {}
	Local aTitulo   := {}

	Local xF3_ENTRADA
	Local xF3_FISCAL := ""
	Local xF3_SERIE
	Local xF3_CLIEFOR
	Local xF3_LOJA
	Local xF3_ESTADO
	Local xF3_CFO
	Local xF3_EMISSAO
	Local xF3_ALIQICM := 18
	Local xF3_VALCONT
	Local xF3_BASEICM := 0.00
	Local xF3_VALICM
	Local xF3_ESPECIE := 'CTE'
	Local xF3_CHVNFE
	Local aInfo := {}
	Local xData
	Local xObs := ""
	Local xEmiss := ""
	Local xChvCTe := ""
	Local dtPTH := ""
	Local lRet := .F.
	Local cDatCTe
	private lMsErroAuto := .F.

//  	BEGIN SEQUENCE

/*

    DELETE FROM SFT020 WHERE TRIM(FT_ESPECIE) = 'CTE' and lpad(ft_entrada,6) = '201805';
    DELETE FROM SF3020 WHERE TRIM(F3_ESPECIE) = 'CTE' and lpad(f3_emissao,6) = '201805';
    DELETE from sf2020 where TRIM(F2_ESPECIE) = 'CTE' and lpad(f2_emissao,6) = '201805';
    DELETE from sD2020 where TRIM(D2_COD) = '00000050' AND  TRIM(D2_CLIENTE) = '001204'  and lpad(D2_emissao,6) = '201805';
    DELETE FROM SE1020 WHERE TRIM(E1_PREFIXO) = 'CTe' AND lpad(E1_EMISSAO,6) = '201805';
    COOMT;
*/



	xF3_FISCAL :=  (xAlias)->nCT
	xF3_SERIE := "1"

	xChvCTe := AllTrim( StrTran( (xAlias)->chCte , 'CTe','') )

//	 IF ALLTRIM( (xAlias)->xTipoMov ) == "E"
//		 aInfo :=  doCteCli( (xAlias)->remCNPJ )
	//	 Else
//		 aInfo :=  doGetCli( (xAlias)->nfe_chave )                   
//	 EndIF               


	xF3_ESPECIE := "CTE"
	cDatCTe := ALLTRIM((xAlias)->DHEMI)
	xF3_CHVNFE := AllTrim( StrTran( (xAlias)->chCte , 'CTe','') )
	xData :=   DATAVALIDA( CTOD ( RIGHT(  LEFT( cDatCTe, 10) , 2)  + '/' +  SUBSTRING(   LEFT( cDatCTe, 10) , 6, 2)  + '/' + LEFT(   LEFT( cDatCTe, 10) ,4) ) )

	xEmiss := CTOD ( RIGHT(  LEFT( cDatCTe, 10) , 2)  + '/' +  SUBSTRING(   LEFT( cDatCTe, 10) , 6, 2)  + '/' + LEFT(   LEFT( cDatCTe, 10) ,4) )

	dtPTH := DTOS (   CTOD ( RIGHT(  LEFT( cDatCTe, 10) , 2)  + '/' +  SUBSTRING(   LEFT( cDatCTe, 10) , 6, 2)  + '/' + LEFT(   LEFT( cDatCTe, 10) ,4) )    )
	xObs :=  "Frete CTe: " + ALLTRIM( (xAlias)->xObs )

 


	IF ( xStSefaz == 2 )

		IF ( ALLTRIM( (xAlias)->toma03 ) == "0" )
			aInfo :=  doCteCli( ALLTRIM((xAlias)->remCNPJ) )

			IF( Empty(aInfo) )
				MsgAlert("Não encontrado : CNPJ/Remetente " + ALLTRIM((xAlias)->remCNPJ)  )
				Return NIL
			EndIF

		EndIF

		IF ( ALLTRIM( (xAlias)->toma03 ) == "3" )
			aInfo :=  doCteCli( ALLTRIM((xAlias)->destcnpj) )

			IF( Empty(aInfo) )
				MsgAlert("Não encontrado : CNPJ/Destinatário " + ALLTRIM((xAlias)->destcnpj) )
				Return NIL
			EndIF
		EndIF

	EndIF


	IF (  xStSefaz == 2 )


		nStatus := TCSqlExec( " DELETE FROM SF3020 WHERE TRIM(F3_ESPECIE) = 'CTE'  AND TRIM(F3_NFISCAL) = '" + ALLTRIM(xF3_FISCAL) + "'" )

		IF (nStatus < 0)
			MsgAlert ("TCSQLError() " + TCSQLError())
		EndIF

		TCRefresh("SF3020")



		nStatus := TCSqlExec( "DELETE FROM SFT020 WHERE TRIM(FT_ESPECIE) = 'CTE'  AND TRIM(FT_NFISCAL) = '" + ALLTRIM(xF3_FISCAL) + "'" )

		IF (nStatus < 0)
			MsgAlert ("TCSQLError() " + TCSQLError())
		EndIF

		TCRefresh("SFT020")



		nStatus := TCSqlExec("DELETE FROM SD2020 WHERE TRIM(D2_COD) = '00000050' AND TRIM(D2_DOC) = '" + ALLTRIM(xF3_FISCAL) + "'" )

		IF (nStatus < 0)
			MsgAlert ("TCSQLError() " + TCSQLError())
		EndIF


		TCRefresh("SD2020")

		nStatus:= TCSqlExec(  "DELETE FROM SF2020 WHERE TRIM(F2_DOC) = '" + ALLTRIM(xF3_FISCAL) + "' AND TRIM(F2_ESPECIE)='CTE' " )

		IF (nStatus < 0)
			MsgAlert ("TCSQLError() " + TCSQLError())
		EndIF

		TCSqlExec( "COMMIT" )

		TCRefresh("SF2020")


		nStatus:= TCSqlExec(  "DELETE  FROM SE1020  WHERE TRIM(E1_PREFIXO) = 'CTe' AND TRIM(E1_NUM) = '" + ALLTRIM(xF3_FISCAL) + "'" )

		IF (nStatus < 0)
			MsgAlert ("TCSQLError() " + TCSQLError())
		EndIF

		TCSqlExec( "COMMIT" )

		TCRefresh("SE1020")



		IF  ALLTRIM((xAlias)->CST) == "00"

			IF ( (xAlias)->pICMS < 12 )
				xF3_ALIQICM := 7
			Else
				xF3_ALIQICM := 12
			EndIF

			xF3_VALCONT := (xAlias)->vBC
			xF3_BASEICM := (xAlias)->VBC
			xF3_VALICM  := (xAlias)->vICMS

		Else

			xF3_ALIQICM := 0
			xF3_VALCONT := 0
			xF3_BASEICM := (xAlias)->vTPrest
			xF3_VALICM  := 0

		EndIF


		IF xF3_BASEICM = 0
			xF3_BASEICM = 0.10
		EndIF

		ConOut( "GRAVANDO... " + xF3_FISCAL  )
		aAdd(aCabec,{"F2_TIPO"   ,"N"})
		aAdd(aCabec,{"F2_FORMUL" ,"N"})
		aAdd(aCabec,{"F2_DOC"    ,xF3_FISCAL })
		aAdd(aCabec,{"F2_SERIE" ,"1"})
		aAdd(aCabec,{"F2_EMISSAO",xEmiss})
		aAdd(aCabec,{"F2_CLIENTE",aInfo[1][1] })
		aAdd(aCabec,{"F2_LOJA"   ,aInfo[1][2]})
		aAdd(aCabec,{"F2_ESPECIE","CTE"})
		aAdd(aCabec,{"F2_COND","001"})
		aAdd(aCabec,{"F2_DESCONT",0})
		aAdd(aCabec,{"F2_VALBRUT", xF3_BASEICM })
		aAdd(aCabec,{"F2_VALFAT", xF3_BASEICM })
		aAdd(aCabec,{"F2_FRETE",0})
		aAdd(aCabec,{"F2_SEGURO",0})
		aAdd(aCabec,{"F2_DESPESA",0})
		aAdd(aCabec,{"F2_CHVNFE", xF3_CHVNFE })


		aAdd(aLinha,{"D2_COD" ,"00000050",Nil})
		aAdd(aLinha,{"D2_QUANT",1,Nil})
		aAdd(aLinha,{"D2_PRCVEN", xF3_BASEICM,Nil})
		aAdd(aLinha,{"D2_TOTAL", xF3_BASEICM,Nil})



		IF ( xF3_ALIQICM == 7 )
			aAdd(aLinha,{"D2_TES","502",Nil})
			aAdd(aLinha,{"D2_PICM", 7 ,Nil})
			aAdd(aLinha,{"D2_CF", (xAlias)->CFOP ,Nil})
		Else
			aAdd(aLinha,{"D2_TES","501",Nil})
			aAdd(aLinha,{"D2_PICM", 12 ,Nil})
			aAdd(aLinha,{"D2_CF", (xAlias)->CFOP ,Nil})
		EndIF

		IF xF3_ALIQICM == 0
			aAdd(aLinha,{"D2_TES","503",Nil})
			aAdd(aLinha,{"D2_CF", (xAlias)->CFOP ,Nil})
			aAdd(aLinha,{"D2_PICM", 0 ,Nil})
		EndIF



		aAdd(aItensT,aLinha)

		Begin Transaction
			lMsErroAuto := .F.
			lAutoErrNoFile	:= .F.
			lMsErroAuto	:= .F.
			l920Inclui := .T.


			MSExecAuto({|x,y,z| mata920(x,y,z)},aCabec,aItensT,3) //Inclusao

			IF lMsErroAuto
				Alert( "ERRO AO INCLUIR ! -> nCT -> " + xF3_FISCAL  )
				MostraErro()
				ConOut("ERRO AO INCLUIR ! -> nCT -> " + xF3_FISCAL )
				DisarmTransaction()
			EndIF



		End Transaction


		aTitulo 	:= {}
		aAdd(aTitulo, {"E1_PREFIXO" 	, "CTe"		, nil})
		aAdd(aTitulo, {"E1_NUM"		, xF3_FISCAL			, nil})
		aAdd(aTitulo, {"E1_PARCELA" 	, "1"		, nil})
		aAdd(aTitulo, {"E1_TIPO" 	, "NF"		, nil})
		aAdd(aTitulo, {"E1_HIST"	, xObs	, nil})
		aAdd(aTitulo, {"E1_CLIENTE"	, aInfo[1][1]		, nil})
		aAdd(aTitulo, {"E1_LOJA"   	, aInfo[1][2] 		, nil})
		aAdd(aTitulo, {"E1_NATUREZ"  	, "10001"     		, nil})
		aAdd(aTitulo, {"E1_EMISSAO"  	, xData 		, nil})
		aAdd(aTitulo, {"E1_VENCTO"  	, xData 		, nil})
		aAdd(aTitulo, {"E1_VENCREA"  	, DataValida( xData )	, nil})
		aAdd(aTitulo, {"E1_SERIE"  	, "1"		, nil})
		aAdd(aTitulo, {"E1_VALOR"  	, xF3_BASEICM		, nil})

		lMsErroAuto := .F.



		MSExecAuto({|x,y| FINA040(x,y)},aTitulo,3)

		IF lMsErroAuto
			// Alert( " -- NOTA COM ERRO : " + xF3_FISCAL + " -- " )

			MostraErro()


		Else
			ConOut( " -- CONTAS A RECEBER COM SUCESSO : " + xF3_FISCAL + " -- " )

		EndIF


		lMsErroAuto := .F.




		cSQL := " UPDATE SF3020 SET F3_CODRSEF = '135', F3_DTCANC = '" + ALLTRIM(dtPTH) + "' , F3_OBSERV  = 'NF CANCELADA', F3_CHVNFE = '" + xChvCTe + "' "
		cSQL += " WHERE "
		cSQL += " TRIM(F3_ESPECIE) = 'CTE'  AND TRIM(F3_NFISCAL) = '" + ALLTRIM(xF3_FISCAL) + "' AND TRIM(F3_CLIEFOR) = '" + ALLTRIM( aInfo[1][1] ) + "' "

		nStatus := TCSqlExec(  cSQL )

		IF (nStatus < 0)
			MsgAlert ("TCSQLError() " + TCSQLError())
		EndIF

		TCRefresh("SF3020")


		cSQL := " UPDATE SFT020 SET  FT_DTCANC = '" + ALLTRIM(dtPTH) + "' , FT_OBSERV  = 'NF CANCELADA' , FT_CHVNFE = '" + xChvCTe + "' "
		cSQL += " WHERE "
		cSQL += " TRIM(FT_ESPECIE) = 'CTE'  AND TRIM(FT_NFISCAL) = '" + ALLTRIM(xF3_FISCAL) + "' AND TRIM(FT_CLIEFOR) = '" + ALLTRIM( aInfo[1][1] ) + "' "

		nStatus := TCSqlExec(  cSQL )

		IF (nStatus < 0)
			MsgAlert ("TCSQLError() " + TCSQLError())
		EndIF

		TCRefresh("SFT020")


		cSQL := " UPDATE SE1020 SET  D_E_L_E_T_ = '*'  "
		cSQL += " WHERE "
		cSQL += " TRIM(E1_NUM) = '" + ALLTRIM(xF3_FISCAL) + "' AND TRIM(E1_PREFIXO) = 'CTe' "

		nStatus := TCSqlExec(  cSQL )

		IF (nStatus < 0)
			MsgAlert ("TCSQLError() " + TCSQLError())
		EndIF

		TCRefresh("SE1020")



	EndIF

	IF ( xStSefaz == 1 )

		IF ( ALLTRIM( (xAlias)->toma03 ) == "0" )
			aInfo :=  doCteCli( AllTrim( (xAlias)->remCNPJ) )

			IF( Empty(aInfo) )
				MsgAlert("Não encontrado : CNPJ/Remetente " + ALLTRIM((xAlias)->remCNPJ)  )

			EndIF

		EndIF

		IF ( ALLTRIM( (xAlias)->toma03 ) == "3" )
			aInfo :=  doCteCli(  AllTrim( (xAlias)->destcnpj) )

			IF( Empty(aInfo) )
				MsgAlert("Não encontrado : CNPJ/Destinatário " + ALLTRIM((xAlias)->destcnpj)  )

			EndIF
		EndIF








	EndIF


	lRet := isExist( ALLTRIM( xChvCTe ), (xAlias)->nCT )
	IF ( lRet == .F.  .And. xStSefaz == 1     )


		IF  ALLTRIM((xAlias)->CST) == "00"

			IF ( (xAlias)->pICMS < 12 )
				xF3_ALIQICM := 7
			Else
				xF3_ALIQICM := 12
			EndIF

			xF3_VALCONT := (xAlias)->vBC
			xF3_BASEICM := (xAlias)->VBC
			xF3_VALICM  := (xAlias)->vICMS

		Else

			xF3_ALIQICM := 0
			xF3_VALCONT := 0
			xF3_BASEICM := (xAlias)->vTPrest
			xF3_VALICM  := 0

		EndIF

		IF  xF3_BASEICM == 0
			xF3_BASEICM = 0.10
		EndIF

		IF ( !Empty(aInfo) )

			ConOut( "GRAVANDO... " + xF3_FISCAL  )
			aAdd(aCabec,{"F2_TIPO"   ,"N"})
			aAdd(aCabec,{"F2_FORMUL" ,"N"})
			aAdd(aCabec,{"F2_DOC"    ,xF3_FISCAL })
			aAdd(aCabec,{"F2_SERIE" ,"1"})
			aAdd(aCabec,{"F2_EMISSAO",xEmiss})
			aAdd(aCabec,{"F2_CLIENTE",aInfo[1][1] })
			aAdd(aCabec,{"F2_LOJA"   ,aInfo[1][2]})
			aAdd(aCabec,{"F2_ESPECIE","CTE"})
			aAdd(aCabec,{"F2_COND","001"})
			aAdd(aCabec,{"F2_DESCONT",0})
			aAdd(aCabec,{"F2_VALBRUT", xF3_BASEICM })
			aAdd(aCabec,{"F2_VALFAT", xF3_BASEICM })
			aAdd(aCabec,{"F2_FRETE",0})
			aAdd(aCabec,{"F2_SEGURO",0})
			aAdd(aCabec,{"F2_DESPESA",0})
			aAdd(aCabec,{"F2_CHVNFE", xF3_CHVNFE })


			aAdd(aLinha,{"D2_COD" ,"00000050",Nil})
			aAdd(aLinha,{"D2_QUANT",1,Nil})
			aAdd(aLinha,{"D2_PRCVEN", xF3_BASEICM,Nil})
			aAdd(aLinha,{"D2_TOTAL", xF3_BASEICM,Nil})



			IF ( xF3_ALIQICM == 7 )
				aAdd(aLinha,{"D2_TES","502",Nil})
				aAdd(aLinha,{"D2_PICM", 7 ,Nil})
				aAdd(aLinha,{"D2_CF", (xAlias)->CFOP ,Nil})
			Else
				aAdd(aLinha,{"D2_TES","501",Nil})
				aAdd(aLinha,{"D2_PICM", 12 ,Nil})
				aAdd(aLinha,{"D2_CF", (xAlias)->CFOP ,Nil})
			EndIF

			IF xF3_ALIQICM == 0
				aAdd(aLinha,{"D2_TES","503",Nil})
				aAdd(aLinha,{"D2_CF", (xAlias)->CFOP ,Nil})
				aAdd(aLinha,{"D2_PICM", 0 ,Nil})
			EndIF

			// 001204
			// 04

			aAdd(aItensT,aLinha)

			Begin Transaction
				lMsErroAuto 		:= .F.
				lAutoErrNoFile	:= .F.
				lMsErroAuto		:= .F.
				l920Inclui			:= .T.

				//CHARUTO
				MSExecAuto({|x,y,z| mata920(x,y,z)},aCabec,aItensT,3) //Inclusao

				IF lMsErroAuto
					ConOut("ERRO AO INCLUIR ! -> nCT -> " + xF3_FISCAL )
					//MostraErro()
					ConOut("ERRO AO INCLUIR ! -> nCT -> " + xF3_FISCAL )
					TCSqlExec(" UPDATE Tbl_SefazCTe SET xProcTOTVSSaida = 'N' ,  vLivro = 'X' WHERE nCT = '" + xF3_FISCAL + "' AND cStat = '100' " )
					DisarmTransaction()
				Else


					IF ALLTRIM( (xAlias)->xTipoMov ) == "E"
						ConOut( " -- NOTA PROCESSADA COM SUCESSO : " + xF3_FISCAL + " -- " )
						TCSqlExec(" UPDATE Tbl_SefazCTe SET xProcTOTVSSaida = 'S' ,  vLivro = 'E' WHERE nCT = '" + xF3_FISCAL + "' AND cStat = '100' " )
					Else
						ConOut( " -- NOTA PROCESSADA COM SUCESSO : " + xF3_FISCAL + " -- " )
						TCSqlExec(" UPDATE Tbl_SefazCTe SET xProcTOTVSSaida = 'S' ,  vLivro = 'P' WHERE nCT = '" + xF3_FISCAL + "' AND cStat = '100' " )
					EndIF


				EndIF
			End Transaction


			aTitulo 	:= {}
			aAdd(aTitulo, {"E1_PREFIXO" 	, "CTe"		, nil})
			aAdd(aTitulo, {"E1_NUM"		, xF3_FISCAL			, nil})
			aAdd(aTitulo, {"E1_PARCELA" 	, "1"		, nil})
			aAdd(aTitulo, {"E1_TIPO" 	, "NF"		, nil})
			aAdd(aTitulo, {"E1_HIST"	, xObs	, nil})
			aAdd(aTitulo, {"E1_CLIENTE"	, aInfo[1][1]		, nil})
			aAdd(aTitulo, {"E1_LOJA"   	, aInfo[1][2] 		, nil})
			aAdd(aTitulo, {"E1_NATUREZ"  	, "10001"     		, nil})
			aAdd(aTitulo, {"E1_EMISSAO"  	, xData 		, nil})
			aAdd(aTitulo, {"E1_VENCTO"  	, xData 		, nil})
			aAdd(aTitulo, {"E1_VENCREA"  	, DataValida( xData )	, nil})
			aAdd(aTitulo, {"E1_SERIE"  	, "1"		, nil})
			aAdd(aTitulo, {"E1_VALOR"  	, xF3_BASEICM		, nil})
			aAdd(aTitulo, {"E1_VEND1"  	, "000108"		, nil})


			lMsErroAuto := .F.


			// CHARUTO
			MSExecAuto({|x,y| FINA040(x,y)},aTitulo,3)

			IF lMsErroAuto
				// Alert ( " -- NOTA COM ERRO : " + xF3_FISCAL + " -- " )
				TCSqlExec(" UPDATE Tbl_SefazCTe SET xProcTOTVSSaida = 'S',  vLivro = 'P', vRotinaStatus = 'FINA040-ERRO' WHERE TRIM(nCT) = " + xF3_FISCAL + " AND TRIM(cStat) = '100' " )
				// MostraErro()


			Else
				ConOut( " -- NOTA PROCESSADA COM SUCESSO : " + xF3_FISCAL + " -- " )
				TCSqlExec(" UPDATE Tbl_SefazCTe SET xProcTOTVSSaida = 'S',  vLivro = 'P', vRotinaStatus = 'FINA040-OK' WHERE TRIM(nCT) = " + xF3_FISCAL + " AND TRIM(cStat) = '100' " )
			EndIF


			lMsErroAuto := .F.

		EndIF
	EndIF
//RECOVER
//    ErrorBlock(oErr)
//END SEQUENCE

Return Nil

Static Function __TO_ERR( E )
	//MsgAlert( "ERRO -> " + CHR(10) + E:DESCRIPTION )
	ConOut( "ERRO -> " + CHR(10) + E:DESCRIPTION )
Return


Return


Static Function doGetFor( xChvNFe )


	Local	__cNameAlias := GETNEXTALIAS()
	Local aInfo := {}
	Local _cQuery := ""
	Local xFil := ""

	_cQuery := "  SELECT * FROM SF2010 WHERE F2_CHVNFE = '" + xChvNFe + "' AND F2_FILIAL != '' AND D_E_L_E_T_ = '' "
	dbUseArea(.T.,__CONNECT,TcGenQry(,,_cQuery),__cNameAlias,.T.,.T.)

	//ConOut(Repl("-",80))
	//ConOut(PadC("-- [ CASAS BANDEIRANTES ] | CONTAS A RECEBER  --",80))

	(__cNameAlias)->(DbGoTop())


	IF !(__cNameAlias)->(Eof())
		aAdd( aInfo, { "000038", (__cNameAlias)->F2_FILIAL,  } )
		xFil := (__cNameAlias)->F2_FILIAL

	EndIF

	(__cNameAlias)->(DBCloseArea())

Return aInfo




Static Function doCteCli( xCNPJ )


	Local	__cNameAlias := GETNEXTALIAS()
	Local aInfo := {}
	Local _cQuery := ""
	Local xFil := ""

	_cQuery := "  SELECT  A1_COD, A1_LOJA  FROM SA1010 WHERE TRIM(A1_CGC) = '" + ALLTRIM(xCNPJ) + "'"
	dbUseArea(.T.,__CONNECT,TcGenQry(,,_cQuery),__cNameAlias,.T.,.T.)

	ConOut(" CLIENTE -> " + _cQuery )
	MemoWrite("\system\doCteCli.sql",_cQuery)


	(__cNameAlias)->(DbGoTop())


	IF !(__cNameAlias)->(Eof())
		aAdd( aInfo, { (__cNameAlias)->A1_COD , (__cNameAlias)->A1_LOJA} )
	Else
		xFil:= ""
	EndIF

	(__cNameAlias)->(DBCloseArea())

Return aInfo



Static Function doGetCli( xChvNFe )


	Local	__cNameAlias := GETNEXTALIAS()
	Local aInfo := {}
	Local _cQuery := ""
	Local xFil := ""

	//	_cQuery := "  SELECT F2_FILIAL FROM SF2010 WHERE TRIM(F2_CHVNFE) = '" + ALLTRIM(xChvNFe) + "' AND F2_FILIAL <> '*' AND D_E_L_E_T_ <> '*' "

	ConOut(" doGetCLi -> " + _cQuery )

	dbUseArea(.T.,__CONNECT,TcGenQry(,,_cQuery),__cNameAlias,.T.,.T.)

	//ConOut(Repl("-",80))
	//ConOut(PadC("-- [ CASAS BANDEIRANTES ] | CONTAS A RECEBER  --",80))

	(__cNameAlias)->(DbGoTop())


	IF !(__cNameAlias)->(Eof())
		aAdd( aInfo, { "001204", (__cNameAlias)->F2_FILIAL } )
		xFil := (__cNameAlias)->F2_FILIAL

	EndIF

	(__cNameAlias)->(DBCloseArea())

Return aInfo

Static Function isLanPag( xChave )
	local lRet := .F.
	local _cQuery := ""

	Local	__cNameAlias := GETNEXTALIAS()
	Local aInfo := {}

	_cQuery := "  SELECT * FROM SE2010 WHERE TRIM(E2_NUM) = '" + xChave + "' AND D_E_L_E_T_ <> '*'  AND TRIM(E2_PREFIXO) = 'CTE'  "
	dbUseArea(.T.,__CONNECT,TcGenQry(,,_cQuery),__cNameAlias,.T.,.T.)

	//ConOut(Repl("-",80))
	//ConOut(PadC("-- [ CASAS BANDEIRANTES ] | CONTAS A RECEBER  --",80))

	(__cNameAlias)->(DbGoTop())


	IF !(__cNameAlias)->(Eof())
		lRet := .T.
	EndIF

	(__cNameAlias)->(DBCloseArea())



Return lRet



Static Function isExist( xChave, nCT )
	local lRet := .F.
	local _cQuery := ""

	Local __cNameAlias := GETNEXTALIAS()
	Local aInfo := {}

	_cQuery := "  SELECT * FROM SF3020 WHERE TRIM(F3_CHVNFE) = '" + xChave + "' AND D_E_L_E_T_ <> '*' "
	dbUseArea(.T.,__CONNECT,TcGenQry(,,_cQuery),__cNameAlias,.T.,.T.)

	//ConOut(Repl("-",80))
	//ConOut(PadC("-- [ CASAS BANDEIRANTES ] | CONTAS A RECEBER  --",80))

	ConOut(_cQuery )


	IF !(__cNameAlias)->(Eof())

		lRet := .T.

	Else

		TCSqlExec(" delete from SD2020 where trim(D2_DOC) = '" + ALLTRIM(cValToChar(nCT)) + "'" )
		TCSqlExec(" delete from SF2020 where trim(F2_DOC) = '" + ALLTRIM(cValToChar(nCT)) + "'" )

	EndIF

	(__cNameAlias)->(DBCloseArea())



Return lRet


Static Function isExistEnt( xChave )
	local lRet := .F.
	local _cQuery := ""

	Local	__cNameAlias := GETNEXTALIAS()
	Local aInfo := {}

	_cQuery := "   SELECT * FROM SF1010 WHERE TRIM(F1_CHVNFE) = '" + xChave + "' AND D_E_L_E_T_ <> '*' "
	dbUseArea(.T.,__CONNECT,TcGenQry(,,_cQuery),__cNameAlias,.T.,.T.)

	//ConOut(Repl("-",80))
	//ConOut(PadC("-- [ CASAS BANDEIRANTES ] | CONTAS A RECEBER  --",80))

	(__cNameAlias)->(DbGoTop())


	IF !(__cNameAlias)->(Eof())
		lRet := .T.
	EndIF

	(__cNameAlias)->(DBCloseArea())



Return lRet



Static Function isLanPgto( xChave )

	local lRet := .F.
	local _cQuery := ""

	Local	__cNameAlias := GETNEXTALIAS()
	Local aInfo := {}

	_cQuery := "  SELECT * FROM SE2010 WHERE TRIM(E2_NUM) = '" + xChave + "' AND TRIM(E2_PREFIXO) = 'CTE' AND D_E_L_E_T_ <> '*' "
	dbUseArea(.T.,__CONNECT,TcGenQry(,,_cQuery),__cNameAlias,.T.,.T.)

	//ConOut(Repl("-",80))
	//ConOut(PadC("-- [ CASAS BANDEIRANTES ] | CONTAS A RECEBER  --",80))

	(__cNameAlias)->(DbGoTop())


	IF !(__cNameAlias)->(Eof())
		lRet := .T.
	EndIF

	(__cNameAlias)->(DBCloseArea())


Return lRet



Static Function putXML()

	local oErr := ErrorBlock( { |e| __TO_ERR(E) } )

	Local aCabec    := {}
	Local aItem     := {}
	Local aItensT   := {}
	Local aLinha    := {}
	Local aTitulo   := {}

	Local xF3_ENTRADA := DDATABASE
	Local xF3_FISCAL := ""
	Local xF3_SERIE
	Local xF3_CLIEFOR
	Local xF3_LOJA
	Local xF3_ESTADO
	Local xF3_CFO
	Local xF3_EMISSAO
	Local xF3_ALIQICM := 12
	Local xF3_VALCONT
	Local xF3_BASEICM := 0.00
	Local xF3_VALICM
	Local xF3_ESPECIE := 'CTE'
	Local xF3_CHVNFE
	Local aInfo := {}
	Local xData
	Local xObs := ""
	Local xEmiss := ""

	PRIVATE lMsErroAuto
	BEGIN SEQUENCE




		xF3_FISCAL :=  (xAlias)->nCT
		xF3_SERIE := "1"

		aInfo :=  doCteCli ( (xAlias)->remCNPJ )



		IF  AllTrim( (xAlias)->CST ) == "00"

			IF ( (xAlias)->pICMS < 12 )
				xF3_ALIQICM := 7
			Else
				xF3_ALIQICM := 18
			EndIF

			xF3_VALCONT := (xAlias)->vBC
			xF3_BASEICM := (xAlias)->VBC
			xF3_VALICM  := (xAlias)->vICMS

		Else

			xF3_ALIQICM := 0
			xF3_VALCONT := 0
			xF3_BASEICM := (xAlias)->vBC
			xF3_VALICM  := 0

		EndIF

		xF3_ESPECIE := "CTE"
		xF3_CHVNFE := (xAlias)->chCTE
		xData :=   DATAVALIDA( CTOD ( RIGHT(  LEFT( (xAlias)->DHEMI, 10) , 2)  + '/' +  SUBSTRING(   LEFT( (xAlias)->DHEMI, 10) , 6, 2)  + '/' + LEFT(   LEFT( (xAlias)->DHEMI, 10) ,4) ) )

		xEmiss := CTOD ( RIGHT(  LEFT( (xAlias)->DHEMI, 10) , 2)  + '/' +  SUBSTRING(   LEFT( (xAlias)->DHEMI, 10) , 6, 2)  + '/' + LEFT(   LEFT( (xAlias)->DHEMI, 10) ,4) )


		xObs :=  "Frete CTe: " + ALLTRIM( (xAlias)->xObs )




		aAdd(aCabec,{"F2_TIPO"   ,"N"})
		aAdd(aCabec,{"F2_FORMUL" ,"N"})
		aAdd(aCabec,{"F2_DOC"    ,xF3_FISCAL })
		aAdd(aCabec,{"F2_SERIE" ,"1"})
		aAdd(aCabec,{"F2_EMISSAO",xEmiss})
		aAdd(aCabec,{"F2_CLIENTE",aInfo[1][1] })
		aAdd(aCabec,{"F2_LOJA"   ,aInfo[1][2]})
		aAdd(aCabec,{"F2_ESPECIE","CTE"})
		aAdd(aCabec,{"F2_COND","001"})
		aAdd(aCabec,{"F2_DESCONT",0})
		aAdd(aCabec,{"F2_VALBRUT", xF3_BASEICM })
		aAdd(aCabec,{"F2_VALFAT", xF3_BASEICM })
		aAdd(aCabec,{"F2_FRETE",0})
		aAdd(aCabec,{"F2_SEGURO",0})
		aAdd(aCabec,{"F2_DESPESA",0})
		aAdd(aCabec,{"F2_CHVNFE", xF3_CHVNFE })


		aAdd(aLinha,{"D2_COD" ,"00000050",Nil})
		aAdd(aLinha,{"D2_QUANT",1,Nil})
		aAdd(aLinha,{"D2_PRCVEN", xF3_BASEICM,Nil})
		aAdd(aLinha,{"D2_TOTAL", xF3_BASEICM,Nil})



		IF ( xF3_ALIQICM == 7 )
			aAdd(aLinha,{"D2_TES","502",Nil})
			aAdd(aLinha,{"D2_PICM", 7 ,Nil})
			aAdd(aLinha,{"D2_CF", (xAlias)->CFOP ,Nil})
		Else
			aAdd(aLinha,{"D2_TES","501",Nil})
			aAdd(aLinha,{"D2_PICM", 12 ,Nil})
			aAdd(aLinha,{"D2_CF", (xAlias)->CFOP ,Nil})
		EndIF

		IF xF3_ALIQICM == 0
			aAdd(aLinha,{"D2_TES","503",Nil})
			aAdd(aLinha,{"D2_PICM", 0 ,Nil})
		EndIF



		aAdd(aItensT,aLinha)

		MSExecAuto({|x,y,z| mata920(x,y,z)},aCabec,aItensT,3) //Inclusao

		If lMsErroAuto
			Alert( " MSExecAuto({|x,y,z| mata920(x,y,z)},aCabec,aItensT,3) ")
			//MostraErro()
		Endif




		aTitulo 	:= {}
		aAdd(aTitulo, {"E1_PREFIXO" 	, "CTe"		, nil})
		aAdd(aTitulo, {"E1_NUM"		, xF3_FISCAL			, nil})
		aAdd(aTitulo, {"E1_PARCELA" 	, "1"		, nil})
		aAdd(aTitulo, {"E1_TIPO" 	, "NF"		, nil})
		aAdd(aTitulo, {"E1_HIST"	, xObs	, nil})
		aAdd(aTitulo, {"E1_CLIENTE"	, aInfo[1][1]		, nil})
		aAdd(aTitulo, {"E1_LOJA"   	, aInfo[1][2] 		, nil})
		aAdd(aTitulo, {"E1_NATUREZ"  	, "10001"     		, nil})
		aAdd(aTitulo, {"E1_EMISSAO"  	, xData 		, nil})
		aAdd(aTitulo, {"E1_VENCTO"  	, xData 		, nil})
		aAdd(aTitulo, {"E1_VENCREA"  	, DataValida( xData )	, nil})
		aAdd(aTitulo, {"E1_SERIE"  	, "1"		, nil})
		aAdd(aTitulo, {"E1_VALOR"  	, xF3_BASEICM		, nil})

		lMsErroAuto := .F.



		MSExecAuto({|x,y| FINA040(x,y)},aTitulo,3)

		IF lMsErroAuto
			Alert( "MSExecAuto({|x,y| FINA040(x,y)},aTitulo,3) ")
			//MostraErro()
			DisarmTransaction()
			Break
		Else
			ConOut( " -- NOTA PROCESSADA COM SUCESSO : " + xF3_FISCAL + " -- " )
			TCSqlExec(" UPDATE Tbl_SefazCTe SET xProcTOTVSSaida = 'S' WHERE nCT = '" + xF3_FISCAL + "' AND cStat = '100' " )
		EndIF



		lMsErroAuto := .F.

		RECOVER
		ErrorBlock(oErr)
	END SEQUENCE


Return

/*     

####################################################################################################
## 																								  ##																						
## BY      : JOSE TEIXEIRA                                                                        ##
##------------------------------------------------------------------------------------------------##
## BOSSWARE TECHNOLOGY                                                                            ##
##------------------------------------------------------------------------------------------------##
## CLIENTE : CASAS BANDEIRANTES                                                                   ##
##               																				  ##	 
## CHAMADA DO JOB                                                                                 ##
## ABRIR O SMARTCLIENT E DIGITAR : U_FJOB														  ##
##------------------------------------------------------------------------------------------------##
####################################################################################################
*/

User Function FJOBCTE

	private OTJOBCTE := TJOBCTE():New()

	OTJOBCTE:Start()

Return




Static Function doArr( xAlias )


	AADD( aMATA103, {  (xAlias)->nCT, (xAlias)->nfe_chave, (xAlias)->CST, (xAlias)->pICMS, (xAlias)->vBC, (xAlias)->vICMS, (xAlias)->vTPrest,;
		(xAlias)->chCTE,  (xAlias)->DHEMI, (xAlias)->xObs, (xAlias)->CFOP, (xAlias)->destUF, (xAlias)->F2_FILIAL, (xAlias)->chCTe,  (xAlias)->Toma03, (xAlias)->destCNPJ, (xAlias)->remCNPJ, (xAlias)->pICMS    } )

Return Nil




Static Function doGetFis(  )

	local oErr := ErrorBlock( { |e| __TO_ERR(E) } )

	Local aCabec    := {}
	Local aItem     := {}
	Local aItensT   := {}
	Local aLinha    := {}
	Local aTitulo   := {}

	Local xF3_ENTRADA := DDATABASE
	Local xF3_FISCAL
	Local xF3_SERIE
	Local xF3_CLIEFOR
	Local xF3_LOJA
	Local xF3_ESTADO
	Local xF3_CFO
	Local xF3_EMISSAO
	Local xF3_ALIQICM := 12
	Local xF3_VALCONT
	Local xF3_BASEICM := 0.00
	Local xF3_VALICM
	Local xF3_ESPECIE := 'CTE'
	Local xF3_CHVNFE
	Local aInfo := {}
	Local xData
	Local xObs := ""
	Local xEmiss
	Local nI := 0
	Local nCT := 0
	Local lProc := .F.
	Local xDestUF := ""
	Local xChCte := ""
	Local cSQL := ""
	PRIVATE lMsErroAuto
	BEGIN SEQUENCE



		xFil := aMATA103[ 1, 13 ]

		RpcClearEnv()
//    RpcSetType( 3 )
		RpcSetEnv( "01", xFil )



		For nI := 1 TO Len( aMATA103 )



			IF (  AllTrim( aMATA103[ nI, 13 ] )  != AllTrim( xFil )  )

				xFil := aMATA103[ nI, 13 ]

				RpcClearEnv()
//		   	RpcSetType( 3 )
				RpcSetEnv( "01", xFil )

			EndIF

			xF3_FISCAL :=  aMATA103[ nI, 1 ]
			xF3_SERIE := "1"



			xEmiss := CTOD (  RIGHT(  LEFT( aMATA103[ nI, 9 ] , 10) , 2)  + '/' +  SUBSTRING(   LEFT( aMATA103[ nI, 9 ], 10) , 6, 2)  + '/' + LEFT(   LEFT( aMATA103[ nI, 9 ], 10) ,4)   )

			xF3_VALCONT := aMATA103[ nI, 7 ]
			nCT := aMATA103[ nI, 1 ]
			xDestUF := aMATA103[ nI, 12 ]

			xChCte := ALLTRIM( StrTran( aMATA103[ nI, 14 ], "CTe","") )
//	 	IF !doIsLivro( nCT  )

			ConOut(Repl("-",80))
			ConOut(PadC("-- [ JOBCTE ] | DACTE  -- FILIAL : "  + xFil ,80))


			U_doMATA103(  nCT, xEmiss, xF3_VALCONT, xDestUF, xFil, xChCte, aMATA103[ nI, 15 ] , aMATA103[ nI, 16 ], aMATA103[ nI, 17 ], aMATA103[ nI, 18 ],  aMATA103[ nI, 2 ] ) // pICMS

//	 	EndIF	






		Next

//	doCompact()
		MsgInfo("Entrada CTe processada com sucesso !")

		RECOVER
		ErrorBlock(oErr)
	END SEQUENCE


Return




Static Function doIsLivro( xChave )
	local lRet := .F.
	local _cQuery := ""

	Local	__cNameAlias := GETNEXTALIAS()
	Local aInfo := {}

	_cQuery := "  SELECT * FROM SF3010 WHERE F3_NFISCAL = '" + xChave + "' AND D_E_L_E_T_ = ''  AND F3_ESPECIE = 'CTE' AND F3_CLIEFOR = '000273'  "
	dbUseArea(.T.,__CONNECT,TcGenQry(,,_cQuery),__cNameAlias,.T.,.T.)

	//ConOut(Repl("-",80))
	//ConOut(PadC("-- [ CASAS BANDEIRANTES ] | LIVRO FRETE CB  --",80))

	(__cNameAlias)->(DbGoTop())


	IF !(__cNameAlias)->(Eof())
		lRet := .T.
	EndIF

	(__cNameAlias)->(DBCloseArea())



Return lRet






User Function doMATA103( nCT, xEmiss, xF3_VALCONT, xDestUF, xFil, xChCte, xToma, xDestCNPJ, xRemCNPJ, pICMS, xchaveNFe )

	local nI := 0
	local cNota := ""
	local cCFOP := ""
	local cTES := ""
	local aCabec := {}
	local aItens := {}
	local aLinha := {}
	local xTpToma := ""
	local cSQL := ""
	local xNOTA := ""
	local aInfo := {}
	local nStatus := 0
	local nBaseCal := 0
	private lMSHelpAuto := .T.
	private lMsErroAuto := .F.



	IF AllTrim( xFil ) == "05"

		IF AllTrim( xDestUF ) == "PE"
			cTES := "072"
			cCFOP := "1352"
		Else
			cTES := "072"
			cCFOP := "2352"
		EndIF

	Else

		IF AllTrim( xDestUF  )== "PE"
			cTES := "036"
			cCFOP := "1353"
		Else
			cTES := "016"
			cCFOP := "2353"
		EndIF

	EndIF


	IF ( ALLTRIM( xToma ) == "3" )
		xTpToma := "D"   // Tomador Destinatário
	Else
		xTpToma :=  "F"   // Tomador Remetente
	EndIF

	IF ALLTRIM( xTpToma ) == "F" .AND. ALLTRIM(xRemCNPJ) $ "08747503000137/08747503000218/08747503000307/08747503000480/08747503000560/08747503000641/08747503000722/08747503000137/08747503000803/08747503000994/"
		xTpToma := "F"
	Else
		xTpToma := "X"
	EndIF



	IF ALLTRIM( xTpToma ) == "F"


//	   aInfo :=  fsFornec ( xRemCNPJ )

		xNOTA := nCT

//        ConOut( " LANCANDO ... -> " + xNOTA )


 /*
		TCSqlExec(" delete from SD2020 where trim(D2_DOC) = '" + ALLTRIM(cValToChar(nCT)) + "'" )
		TCSqlExec(" delete from SF2020 where trim(F2_DOC) = '" + ALLTRIM(cValToChar(nCT)) + "'" )

		cSQL := " DELETE FROM SF3010 "
		cSQL += " WHERE "
		cSQL += " TRIM(F3_ESPECIE) = 'CTE'  AND TRIM(F3_NFISCAL) = '" + ALLTRIM(xNOTA) + "' AND TRIM(F3_CLIEFOR) = '000273' "	
	
		nStatus := TCSqlExec(  cSQL )

		IF (nStatus < 0)
	    	 MsgAlert ("TCSQLError() " + TCSQLError())
		EndIF
		
	 	TCRefresh("SF3010")
	
	
		cSQL := " DELETE FROM SFT010 "
		cSQL += " WHERE "
		cSQL += " TRIM(FT_ESPECIE) = 'CTE'  AND TRIM(FT_NFISCAL) = '" + ALLTRIM(xNOTA) + "' AND TRIM(FT_CLIEFOR) = '000273' "
	
		nStatus := TCSqlExec(  cSQL )
		
		IF (nStatus < 0)
	    	 MsgAlert ("TCSQLError() " + TCSQLError())
		EndIF
		
	 	TCRefresh("SFT010")       
	 	            
	 	cSQL := "DELETE FROM SE2010 WHERE TRIM(E2_FORNECE) = '000273' AND TRIM(E2_NUM) ='" + ALLTRIM(xNOTA) + "' " 
	    nStatus := TCSqlExec( cSQL )
	    
		IF (nStatus < 0)
	    	 MsgAlert ("TCSQLError() " + TCSQLError())
		EndIF

	    
	 	TCRefresh("SE2010")       		
	 	
	 	
		cSQL := "	DELETE FROM SD1010  "
		cSQL += "   WHERE  "
		cSQL += "   TRIM(D1_COD) = '00011495' AND TRIM(D1_DOC) = '" + ALLTRIM(xNOTA) + "' AND TRIM(D1_FORNECE) = '000273' "	
	
		nStatus := TCSqlExec(  cSQL )

		IF (nStatus < 0)
	    	 MsgAlert ("TCSQLError() " + TCSQLError())
		EndIF

		
	 	TCRefresh("SD1010")


		cSQL := "	DELETE FROM SF1010 "
		cSQL += "   WHERE "
		cSQL += "   TRIM(F1_ESPECIE) = 'CTE' AND TRIM(F1_DOC) = '" + ALLTRIM(xNOTA) + "' AND TRIM(F1_FORNECE) = '000273' "
	
	
		nStatus:= TCSqlExec(  cSQL )
		
		IF (nStatus < 0)
	    	 MsgAlert ("TCSQLError() " + TCSQLError())
		EndIF

	    TCSqlExec( "COMMIT" )
	    
	 	TCRefresh("SF1010")
                
	*/          



		dDataBase := xEmiss

		IF !isExistEnt( xChCte ) .AND. xF3_VALCONT > 0

			nBaseCal := getDifVal( xF3_VALCONT, xchaveNFe )

			aCabec := { { "F1_TIPO"  , 'N'                , NIL },;
				{"F1_FORMUL"   , 'S'                , NIL },;
				{ "F1_DOC"     ,  nCT                , NIL },;
				{ "F1_SERIE"   , '1'                , NIL },;
				{ "F1_EMISSAO" , xEmiss             , NIL },;
				{ "F1_DTDIGIT" , xEmiss             , NIL },;
				{ "F1_RECBMTO" , xEmiss             , NIL },;
				{ "F1_FORNECE" , "000273"            , NIL },;
				{ "F1_LOJA"    , "01"                , NIL },;
				{ "F1_ESPECIE" , 'CTE'              , NIL },;
				{ "F1_CHVNFE"  , xChCte             , NIL },;
				{ "F1_COND"    , '001'              , NIL }}
			//	             { "F1_TOWK"     , "C", nil }}







			Aadd( aItens, {{"D1_COD"      ,"00011495"                          ,NIL},;
				{"D1_UM"       ,"UN"                                ,NIL},;
				{"D1_QUANT"    ,1                         		     ,NIL},;
				{"D1_VUNIT"    ,xF3_VALCONT                         ,NIL},;
				{"D1_TOTAL"    ,xF3_VALCONT                         ,NIL},;
				{"D1_DTDIGIT"  ,xEmiss     				         ,NIL},;
				{"D1_PICM"     , pICMS                              ,Nil},;
				{"D1_TES"      ,cTES                                ,NIL},;
				{"D1_CF"       ,cCFOP                               ,NIL},;
				{"D1_LOCAL"    ,"12"                                ,NIL} } )



			MSExecAuto({|x,y,z| MATA103(x,y,z)},aCabec,aItens,3)

			IF lMsErroAuto
				IF ( ALLTRIM(xRemCNPJ) == "08747503000994" )
					MostraErro()
				EndIF

				TCSqlExec(" UPDATE Tbl_SefazCTe SET xProcTOTVS = 'N', vLivro = 'X', vRotinaStatus = 'MATA103-ERRO' WHERE nCT = '" + nCT + "'" )
				ConOut( " -- ERRO LIVRO !  " + nCT + " -- " )

			Else
				ConOut( " -- NOTA PROCESSADA COM SUCESSO : " + nCT + " -- " )
				TCSqlExec(" UPDATE Tbl_SefazCTe SET xProcTOTVS = 'S',  vLivro = 'P', vRotinaStatus = 'MATA103-OK' WHERE nCT = '" + nCT + "' AND cStat = '100' " )

				cSQL := "	UPDATE SF3010  SET F3_ENTRADA = '" + DTOS (xEmiss ) + "'"
				cSQL += "   WHERE D_E_L_E_T_<> '*' "
				cSQL += "   AND TRIM(F3_CHVNFE) = '"+xChCte+"'"
//				cSQL += "   AND TRIM(F3_NFISCAL) = '" + ALLTRIM(xNOTA) + "' F3_ESPECIE = '' "


				nStatus:= TCSqlExec(  cSQL )

				IF (nStatus < 0)
					MsgAlert ("TCSQLError() " + TCSQLError())
				EndIF

				TCSqlExec( "COMMIT" )
				TCRefresh("SF3010")


				cSQL := " UPDATE SFT010  SET FT_ENTRADA = '" + DTOS (xEmiss ) + "'"
				cSQL += " WHERE  D_E_L_E_T_ <> '*' "
				cSQL += " AND TRIM(FT_CHVNFE) = '"+xChCte+"'"

//				cSQL += " AND TRIM(FT_NFISCAL) = '" + ALLTRIM(xNOTA) + "' AND TRIM(FT_CLIEFOR) = '000273'  "

				nStatus:= TCSqlExec(  cSQL )

				IF (nStatus < 0)
					MsgAlert ("TCSQLError() " + TCSQLError())
				EndIF

				TCRefresh("SFT010")

				cSQL := "UPDATE SE2010 SET TRIM(E2_NATUREZ) = '20703' WHERE TRIM(E2_FORNECE) = '000273' AND TRIM(E2_NUM) ='" + ALLTRIM(xNOTA) + "'  "

				nStatus:= TCSqlExec(  cSQL )

				TCSqlExec( "COMMIT" )
				//IF (nStatus < 0)
				//	 MsgAlert ("TCSQLError() " + TCSQLError())
				//EndIF

				TCRefresh("SE2010")


				cSQL := "	UPDATE SD1010  SET D1_DTDIGIT = '" + DTOS (xEmiss ) + "'"
				cSQL += "   WHERE D_E_L_E_T_ <> '*'  "
				cSQL += "   AND TRIM(D1_COD) = '00011495' AND TRIM(D1_DOC) = '" + ALLTRIM(xNOTA) + "' AND TRIM(D1_FORNECE) = '000273' "

				nStatus:= TCSqlExec(  cSQL )
				TCSqlExec( "COMMIT" )

				IF (nStatus < 0)
					MsgAlert ("TCSQLError() " + TCSQLError())
				EndIF

				TCRefresh("SD1010")


				cSQL := "	UPDATE SF1010  SET F1_DTDIGIT = '" + DTOS (xEmiss ) + "'"
				cSQL += "   WHERE D_E_L_E_T_<> '*'  "
				cSQL += "   AND F1_ESPECIE = 'CTE' AND TRIM(F1_DOC) = '" + ALLTRIM(xNOTA) + "' AND TRIM(F1_FORNECE) = '000273'"


				nStatus:= TCSqlExec(  cSQL )
				TCSqlExec( "COMMIT" )

				IF (nStatus < 0)
					MsgAlert ("TCSQLError() " + TCSQLError())
				EndIF

				TCRefresh("SF1010")


			EndIF

		Else
			ConOut( " -- NOTA NAO SERA PROCESSADA !-> " + nCT + " -- " )

		EndIF
	Else
		ConOut( " -- NOTA JA FOI PROCESSADA !-> " + nCT + " -- " )

	EndIF

Return



Static Function doCompact()

	local cSQL

/*	
	cSQL := "	UPDATE SF3010  SET F3_ENTRADA = F3_EMISSAO  "
	cSQL += "   WHERE D_E_L_E_T_=' ' AND SUBSTRING(F3_CFO,1,1)<'5' "
	cSQL += "   AND F3_TIPO<>'S' AND F3_NRLIVRO<>'99'   "
	cSQL += "   AND F3_ESPECIE = 'CTE' AND F3_SERIE = '1' "


	TCSqlExec(  cSQL )
 	TCRefresh("SF3010")


	cSQL := " UPDATE SFT010  SET FT_ENTRADA = FT_EMISSAO "
	cSQL += " WHERE  D_E_L_E_T_=' ' "
	cSQL += " AND FT_ESPECIE = 'CTE' AND FT_SERIE = '1' "

	TCSqlExec(  cSQL )
 	TCRefresh("SFT010")
*/	
Return


User Function CTEMOVENT()

	local cPerg := "CTE001"

	local xDtDe,xDtAte, xCTeDe, xCTeAte := ""
	private aMATA103 := {}
	private oProcess

	IF !Pergunte(cPerg, .T.)
		Return
	EndIF

	IF ( ALLTRIM( cEmpAnt ) != "01" )
		MsgAlert("Essa rotina deverá ser executada somente na empresa 01")
		Return
	EndIF

	xDtDe := DTOS( MV_PAR01 )
	xDtAte := DTOS( MV_PAR02 )
	xCTeDe :=  MV_PAR03
	xCTeAte :=  MV_PAR04

	IF MsgYesNo( 'Essa rotina efetuar escrituração fiscal CTe. Continua ?', 'TOTVS' )


		oProcess := MsNewProcess():New( { || doProcCTe( oProcess, xDtDe,  xDtAte , xCTeDe, xCTeAte) } , "Processando...","Movimento Entrada CTe",.F.)


		oProcess:Activate()

	EndIF

Return



Static Function doProcCTe( oProcess, xDTDe, xDtAte, xCTeDe, xCTeAte )

	local cSQL
	local __cNameAlias
	local cDataDe := ""
	local cDataAte := ""




	cDataDe := LEFT( xDTDe, 4  ) + "-" + SUBSTR( xDTDe, 5,2  ) + "-" + RIGHT( xDTDe, 2  )
	cDataAte := LEFT( xDtAte, 4  ) + "-" + SUBSTR( xDtAte, 5,2  ) + "-" + RIGHT( xDtAte, 2  )

	cSQL := " SELECT B.F2_FILIAL, A.* , ( SELECT COUNT(* ) TOPROC FROM Tbl_SefazCte A   "
	cSQL += " INNER JOIN SF2010 B  "
	cSQL += " ON  "
	cSQL += " A.nfe_chave = B.F2_CHVNFE   "
	cSQL += " WHERE A.cStat = '100'  AND A.CST IN( '00','040','40')  "
	cSQL += " AND LPAD(dhEmi,10)  BETWEEN '" + cDataDe + "' AND '" + cDataAte + "' AND nCT BETWEEN " + xCTeDe + " AND " + xCTeATe
	cSQL += "   ) TOPROC FROM Tbl_SefazCte A  "
	cSQL += " INNER JOIN SF2010 B "
	cSQL += " ON  "
	cSQL += " A.nfe_chave = B.F2_CHVNFE   "
	cSQL += " WHERE A.cStat = '100'  AND A.CST IN( '00','040','40')  "
	cSQL += " AND LPAD(dhEmi,10)  BETWEEN '" + cDataDe + "' AND '" + cDataAte + "' AND nCT BETWEEN " + xCTeDe + " AND " + xCTeATe
	cSQL += " ORDER BY 1 "



//	cSQL += " AND LEFT(dhEmi,10) BETWEEN '" + cDataDe + "' AND '" + cDataAte + "' AND xProcTOTVS = 'N' "


	MemoWrite("\system\CTeEnt.sql",cSql)


	__cNameAlias := GETNEXTALIAS()

	dbUseArea(.T.,__CONNECT,TcGenQry(,,cSQL),__cNameAlias,.T.,.T.)

	ConOut(Repl("-",80))
	ConOut(PadC("-- [ JOBCTE ] | DACTE  --",80))

	(__cNameAlias)->(DbGoTop())


	IF !(__cNameAlias)->(Eof())

		oProcess:SetRegua1( (__cNameAlias)->TOPROC )

		While !(__cNameAlias)->(Eof())

                /*
                
  		        aInfo :=  doGetFor ( (__cNameAlias)->nfe_chave )
	            
	            xFil := aInfo[1][2]
	            
			IF ( ALLTRIM( xFil ) == ALLTRIM( aInfo[1][2] ) )
				IF !isLanPag ( (__cNameAlias)->nCT  )

						ConOut(Repl("-",80))
						ConOut(PadC("-- [ JOBCTE ] | DACTE  -- FILIAL : "  + xFil ,80))	 				    
						
				doFINA050(  __cNameAlias )
						
			EndIF
		EndIF

                */
	doArr( __cNameAlias )


	(__cNameAlias)->(dbSkip())
EndDo
Else
	(__cNameAlias)->(DBCloseArea())
	MsgAlert("Importação de entrada já efetuada no período informado ! ")
Return
EndIF

(__cNameAlias)->(DBCloseArea())


U_doFiscal ( oProcess )  // Lançamento Fiscal CTe


Return


User Function doFiscal( oProcess )

//	local oErr := ErrorBlock( { |e| __TO_ERR(E) } )

	Local aCabec    := {}
	Local aItem     := {}
	Local aItensT   := {}
	Local aLinha    := {}
	Local aTitulo   := {}

	Local xF3_ENTRADA := DDATABASE
	Local xF3_FISCAL
	Local xF3_SERIE
	Local xF3_CLIEFOR
	Local xF3_LOJA
	Local xF3_ESTADO
	Local xF3_CFO
	Local xF3_EMISSAO
	Local xF3_ALIQICM := 12
	Local xF3_VALCONT
	Local xF3_BASEICM := 0.00
	Local xF3_VALICM
	Local xF3_ESPECIE := 'CTE'
	Local xF3_CHVNFE
	Local aInfo := {}
	Local xData
	Local xObs := ""
	Local xEmiss
	Local nI := 0
	Local nCT := 0
	Local lProc := .F.
	Local xDestUF := ""
	Local xChCte := ""
	Local cSQL := ""

	Local cSvFilAnt

	PRIVATE lMsErroAuto

//  	BEGIN SEQUENCE


	__cInterNet := NIL


	xFil := aMATA103[ 1, 13 ]




	RpcClearEnv()
//    RpcSetType( 3 )
	RpcSetEnv( "01", xFil )

	cSvFilAnt := cFilAnt


	For nI := 1 TO Len( aMATA103 )



		IF (  AllTrim( aMATA103[ nI, 13 ] )  != AllTrim( xFil )  )

			xFil := aMATA103[ nI, 13 ]

			cFilAnt := cSvFilAnt

			RpcClearEnv()
//		   	RpcSetType( 3 )
			RpcSetEnv( "01", xFil )

		EndIF

		xF3_FISCAL :=  aMATA103[ nI, 1 ]
		xF3_SERIE := "1"

		xF3_ENTRADA := CTOD (  RIGHT(  LEFT( aMATA103[ nI, 9 ] , 10) , 2)  + '/' +  SUBSTRING(   LEFT( aMATA103[ nI, 9 ], 10) , 6, 2)  + '/' + LEFT(   LEFT( aMATA103[ nI, 9 ], 10) ,4)   )

		xEmiss := CTOD (  RIGHT(  LEFT( aMATA103[ nI, 9 ] , 10) , 2)  + '/' +  SUBSTRING(   LEFT( aMATA103[ nI, 9 ], 10) , 6, 2)  + '/' + LEFT(   LEFT( aMATA103[ nI, 9 ], 10) ,4)   )

		xF3_VALCONT := aMATA103[ nI, 7 ]
		nCT := aMATA103[ nI, 1 ]
		xDestUF := aMATA103[ nI, 12 ]

		xChCte := ALLTRIM( StrTran( aMATA103[ nI, 14 ], "CTe","") )

//	 	IF !doIsLivro( nCT  )

		ConOut(Repl("-",80))
		ConOut(PadC("-- [ JOBCTE ] | DACTE  -- FILIAL : "  + xFil ,80))

		oProcess:IncRegua1(" Processando ..." + StrZero(nI,6 ) + " de " + StrZero(Len(aMATA103),6 )   )

		U_doMATA103(  nCT, xEmiss, xF3_VALCONT, xDestUF, xFil, xChCte, aMATA103[ nI, 15 ] , aMATA103[ nI, 16 ], aMATA103[ nI, 17 ], aMATA103[ nI, 18 ] )




		oProcess:IncRegua2("Completado...")


//	 	EndIF	




	Next




//	RECOVER
//	ErrorBlock(oErr)
//	END SEQUENCE


Return

/*
User Function CTER001
	private oReport
	private oSecItn
		
	private cPerg := "CTE001"	
	private xDtDe, xDtAte := ""  
	private cDataDe,cDataAte := "" 
	//doParamter()
	
	IF !Pergunte(cPerg, .T.)
		Return
	EndIF
	                  
	xDtDe := DTOS( MV_PAR01 )
	xDtAte := DTOS( MV_PAR02 )
    
	cDataDe := LEFT( xDTDe, 4  ) + "-" + SUBSTR( xDTDe, 5,2  ) + "-" + RIGHT( xDTDe, 2  )
	cDataAte := LEFT( xDtAte, 4  ) + "-" + SUBSTR( xDtAte, 5,2  ) + "-" + RIGHT( xDtAte, 2  )

	
	oReport := ReportDef()
	oReport:PrintDialog()
	
	
Return       
*/

/*                 
Static Function doParamter( )

PutSx1(cPerg ,"01","Do Cliente" ,"Do Cliente","Do Cliente","mv_ch1","C"  ,18       ,0       ,0      ,"G" ,""    ,"SA1" ,""     ,"","MV_PAR01",""     ,"","",""    ,""           ,"","",""         ,"","",""          ,"","","","","")
PutSx1(cPerg ,"02","Ate Cliente" ,"Ate Cliente","Ate Cliente","mv_ch2","C"  ,18       ,0       ,0      ,"G" ,""    ,"SA1" ,""     ,"","MV_PAR02",""     ,"","",""    ,""           ,"","",""         ,"","",""          ,"","","","","")

PutSx1(cPerg ,"03","Do Vendedor"  ,"Do Vendedor","Do Vendedor"   ,"mv_ch3","C"  ,18       ,0       ,0      ,"G" ,""    ,"SA3" ,""     ,"","MV_PAR03",""     ,"","",""    ,""           ,"","",""         ,"","",""          ,"","","","","")
PutSx1(cPerg ,"04","Ate Vendedor" ,"Ate Vendedor","Ate Vendedor" ,"mv_ch4","C"  ,18       ,0       ,0      ,"G" ,""    ,"SA3" ,""     ,"","MV_PAR04",""     ,"","",""    ,""           ,"","",""         ,"","",""          ,"","","","","")

PutSx1(cPerg ,"05","Compras a partir" ,"Vendas","Vendas" ,"mv_ch5","D"  ,8       ,0       ,0      ,"G" ,""    ,"" ,""     ,"","MV_PAR05",""     ,"","",""    ,""           ,"","",""         ,"","",""          ,"","","","","")

  
Return
*/

Static Function ReportDef



	oReport := TReport():New(cPerg, "Relatório CTe/XML", cPerg, {|oReport| PrintReport(oReport)})
	oReport:SetLandscape(.T.)


	oSecItn := TRSection():New(oReport, "CTE")


	TRCell():New(oSecItn, "A"	    ,,"CTe")
	TRCell():New(oSecItn, "B"	    ,,"Nome Remetente")
	TRCell():New(oSecItn, "C"	    ,,"CNPJ Remetente")
	TRCell():New(oSecItn, "D"	    ,,"CNPJ Destinatário"  	, "@!", 11)
	TRCell():New(oSecItn, "E"		,,"CFOP"		, "!@", 11)
	TRCell():New(oSecItn, "F"		,,"UF Ini"   		, "@!", 12)
	TRCell():New(oSecItn, "G"       ,,"UF Fim" 			, "!@", 11)
	TRCell():New(oSecItn, "H"		,,"Valor"  		, "@E 999,999.9999", 11)
	TRCell():New(oSecItn, "I"		,,"ICMS"  		, "@E 999,999.9999", 11)
	TRCell():New(oSecItn, "J"		,,"% ICMS"    	, "!@", 11)
	TRCell():New(oSecItn, "L"		,,"Status"     	, "!@", 11)
	TRCell():New(oSecItn, "M"		,,"Tomador"     	    , "@!", 11)
	TRCell():New(oSecItn, "N"		,,"Data"      	, "@!", 11)


Return oReport



Static Function PrintReport(oReport)

	local  cAlias := "EBI"
	local cSQL := ""
	local nMetter := 0
	local __cSQL := ""
	local cEmpFilGet := ""
	local aRel := { }

	local aArea   := GetArea()



	/* A ( nCT ), B (remxNome), C (remCNPJ), D (destCNPJ), E ( CFOP ), F(UFIni), G ( destUF), H (vTPrest), 
	I (vICMS), J (pICMS), L (cStat), M (toma03), N ( data )
	
	*/

	__cSQL += "   SELECT distinct nCT A, remxNome B, remCNPJ C,destCNPJ D, CFOP E, UFIni F, destUF G, vTPrest H,  vICMS I, pICMS J, cStat L, Toma03 M,
	__cSQL += "   to_char(to_date(lpad(dhEmi,10),'yyyy-mm-dd') ,'dd/mm/yyyy') N
	__cSQL += "   FROM Tbl_SefazCTe
	__cSQL += "   WHERE LPAD(dhEmi,10) BETWEEN '" + cDataDe + "' AND '" + cDataAte + "' "
//	__cSQL += "   AND Toma03 <> '0' "
	__cSQL += "   ORDER BY 12    "

	MemoWrite("\system\CTeRelExcel.sql",__cSQL)


	TCQUERY __cSQL NEW ALIAS "EBI"
	dbSelectArea("EBI")

	While !EBI->(Eof())
		++nMetter
		EBI->( dbSkip() )
	Enddo

	EBI->(	DbGoTop() )


	IF nMetter == 0

		Aviso("TOTVS", "Não foram encontrados registros com parâmetros informados!", {"OK"})
		EBI->( DbCloseArea() )
		Return

	EndIf

	oReport:SetMeter(nMetter)
	oSecItn:Init()

	While !EBI->(Eof())




		oSecItn:Cell("A"):SetValue(  EBI->A  )
		oSecItn:Cell("B"):SetValue(  EBI->B  )
		oSecItn:Cell("C"):SetValue(  EBI->C  )
		oSecItn:Cell("D"):SetValue(  EBI->D  )
		oSecItn:Cell("E"):SetValue(  EBI->E  )
		oSecItn:Cell("F"):SetValue(  EBI->F  )
		oSecItn:Cell("G"):SetValue(  EBI->G  )
		oSecItn:Cell("H"):SetValue(  EBI->H  )
		oSecItn:Cell("I"):SetValue(  EBI->I  )
		oSecItn:Cell("J"):SetValue(  EBI->J  )
		oSecItn:Cell("L"):SetValue(  EBI->L  )
		oSecItn:Cell("M"):SetValue(  EBI->M  )
		oSecItn:Cell("N"):SetValue(  EBI->N  )


		oSecItn:PrintLine()




		EBI->( dbSkip() )
		oReport:IncMeter()
	Enddo
	EBI->( DbCloseArea() )


	DbCloseArea()
	oSecItn:Finish()

	RestArea(aArea)

Return



User Function CTEMOVSAI()



	local cSQL
	local __cNameAlias


	local cPerg := "CTE001"
	local oProcess
	local xDtDe,xDtAte := ""
	local xStSefaz

	private aMATA103 := {}
	private oProcess

	IF !Pergunte(cPerg, .T.)
		Return
	EndIF

	xDtDe := DTOS( MV_PAR01 )
	xDtAte := DTOS( MV_PAR02 )
	xStSefaz := MV_PAR03

//	xDtDe := '20170601'
//	xDtAte := '20170630'


	IF ( ALLTRIM( cEmpAnt ) != "02" )
		MsgAlert("Essa rotina deverá ser executada somente na empresa 02")
		Return
	EndIF



	IF MsgYesNo( 'Essa rotina efetuar escrituração fiscal CTe. Continua ?', 'TOTVS' )

		oProcess := MsNewProcess():New({|lEnd| getOutCTE(@lEnd,@oProcess, xDtDe,  xDtAte, xStSefaz) },"Processando...","Movimento Saída CTe",.T.)
		oProcess:Activate()

	EndIF

Return



Static Function getOutCTE( lEnd,oProcess, xDTDe, xDtAte, xStSefaz )

	local cSQL := ""
	local nCount := 0
	local nIdx := 0
	local cDataDe
	local cDataAte
	local cTpSefaz := ""
	local chCte := ""
	local cNoFound := ""
	LOCAL aAreaAnt := GETAREA()


	cDataDe := LEFT( xDTDe, 4  ) + "-" + SUBSTR( xDTDe, 5,2  ) + "-" + RIGHT( xDTDe, 2  )
	cDataAte := LEFT( xDtAte, 4  ) + "-" + SUBSTR( xDtAte, 5,2  ) + "-" + RIGHT( xDtAte, 2  )

	IF ( xStSefaz = 1 )
		cTpSefaz := "100"
	ElseIF 	( xStSefaz = 2 )
		cTpSefaz := "135"
	ElseIF 	( xStSefaz = 3 )
		cTpSefaz := "102"
	EndIF

// 	cSQL := " SELECT COUNT(*) TOTAL FROM Tbl_SefazCte WHERE TRIM(cStat) = '" + ALLTRIM(cTpSefaz) + "' AND xProcTOTVSSaida = 'N' AND CST IN( '00','040','40') AND vTPrest != 0 "
	cSQL := " SELECT COUNT(*) TOTAL FROM Tbl_SefazCte WHERE TRIM(cStat) = '" + ALLTRIM(cTpSefaz) + "' AND CST IN( '00','040','40') AND vTPrest != 0 "
	cSQL += " AND LPAD(dhEmi,10) BETWEEN '" + cDataDe + "' AND '" + cDataAte + "'" // AND TRIM(CMUNINI) = '2512309' "

	__cNameAlias := GETNEXTALIAS()

	dbUseArea(.T.,__CONNECT,TcGenQry(,,cSQL),__cNameAlias,.T.,.T.)


	nCount := (__cNameAlias)->TOTAL

	(__cNameAlias)->(DBCloseArea())


/*
    
    DELETE FROM SFT020 WHERE TRIM(FT_ESPECIE) = 'CTE' and lpad(ft_entrada,6) = '201805';
    DELETE FROM SF3020 WHERE TRIM(F3_ESPECIE) = 'CTE' and lpad(f3_emissao,6) = '201805';
    commit;
    select * from sf2020 where TRIM(F2_ESPECIE) = 'CTE' and lpad(f2_emissao,6) = '201805';
    DELETE from sf2020 where TRIM(F2_ESPECIE) = 'CTE' and lpad(f2_emissao,6) = '201805';
    
    DELETE from sD2020 where TRIM(D2_COD) = '00000050' AND  TRIM(D2_CLIENTE) = '001204'  and lpad(D2_emissao,6) = '201805';
*/


	__cNameAlias := GETNEXTALIAS()

	//cSQL := " SELECT * FROM Tbl_SefazCte WHERE TRIM(cStat) = '" + ALLTRIM(cTpSefaz) + "' AND CST IN( '00','040','40') AND vTPrest != 0 "
	//cSQL += " AND LPAD(dhEmi,10) BETWEEN '" + cDataDe + "' AND '" + cDataAte + "' "



	cSQL := "   SELECT * FROM Tbl_SefazCTe   "
	cSQL += "   WHERE TRIM(cStat) = '" + ALLTRIM(cTpSefaz) + "' AND  LPAD(dhEmi,10) BETWEEN '" + cDataDe + "' AND '" + cDataAte + "' " // AND TRIM(CMUNINI) = '2512309' "



	dbUseArea(.T.,__CONNECT,TcGenQry(,,cSQL),__cNameAlias,.T.,.T.)

	MemoWrite("\system\CTeSai.sql",cSql)

	(__cNameAlias)->(DbGoTop())


	IF !(__cNameAlias)->(Eof())

		oProcess:SetRegua1( nCount )

		ConOut(Repl("-",80))
		ConOut(PadC("-- [ JOBCTE ] | DACTE  --",80))

		MsgInfo( "  OK ")

		While !(__cNameAlias)->(Eof())

			chCte := StrTran((__cNameAlias)->chCte, 'CTe','')


			IF ( cTpSefaz == "102" )
				//IF ( MsgYesNo("Deseja inutilizar CT-e para apuração futura ?" ))
			doInutiliza((__cNameAlias)->nCT, AllTrim( StrTran( (__cNameAlias)->chCte , 'CTe','') ) , (__cNameAlias)->DHEMI , __cNameAlias   )
			//EndIF

		Else
			nIdx += 1
			 U_doPutCte(  __cNameAlias , xStSefaz, cNoFound )
			//U_doFINREC(  __cNameAlias , xStSefaz, cNoFound )
		EndIF



		oProcess:IncRegua1(" Processando ..." + StrZero(nIdx,6 ) + " de " + cValToChar( nCount  )   )
		oProcess:IncRegua2("Completado...")


		(__cNameAlias)->(dbSkip())
	EndDo
EndIF

(__cNameAlias)->(DBCloseArea())

MsgInfo("Importação finalizada com sucesso !")

RESTAREA(aAreaAnt)


Return




User Function xGrvD1()
	local oErr := ErrorBlock( { |e| __TO_ERR(E) } )
	local	__cSQL := ""
	local aCabec := {}
	local aItens := {}
	local __cNameAlias
	local aArea

	private lMSHelpAuto := .T.
	private lMsErroAuto := .F.

	BEGIN SEQUENCE


		__cSQL := " SELECT DISTINCT  FT_VALCONT,ft_nfiscal, ft_item, ft_emissao, ft_quant, ft_produto, ft_entrada, ft_cfop FROM SFT010 WHERE FT_NFISCAL IN ( '43259') AND FT_CLIEFOR =  '000573' order by ft_nfiscal, ft_item "

//	RpcSetType( 3 )
		RpcSetEnv( "01", "03" )

		aArea   := GetArea()

		__cNameAlias := GETNEXTALIAS()

		dbUseArea(.T.,__CONNECT,TcGenQry(,,__cSQL),__cNameAlias,.T.,.T.)






		aCabec := { { "F1_TIPO"  , 'N'                , NIL },;
			{"F1_FORMUL"   , 'S'                , NIL },;
			{ "F1_DOC"     ,   (__cNameAlias)->FT_NFISCAL                , NIL },;
			{ "F1_SERIE"   , '1'                , NIL },;
			{ "F1_EMISSAO" , STOD( (__cNameAlias)->FT_EMISSAO)             , NIL },;
			{ "F1_DTDIGIT" , STOD( (__cNameAlias)->FT_ENTRADA)             , NIL },;
			{ "F1_FORNECE" , "000573"           , NIL },;
			{ "F1_LOJA"    , '01'               , NIL },;
			{ "F1_ESPECIE" , 'CTE'              , NIL },;
			{ "F1_COND"    , '001'              , NIL },;
			{ "F1_TOWK"     , "", nil }}


		While !(__cNameAlias)->(Eof())

			Aadd( aItens, {{"D1_COD"      , (__cNameAlias)->FT_PRODUTO              ,NIL},;
				{"D1_UM"       ,"UN"                                    ,NIL},;
				{"D1_QUANT"    ,1                         			     ,NIL},;
				{"D1_VUNIT"    , (__cNameAlias)->FT_VALCONT              ,NIL},;
				{"D1_TOTAL"    , (__cNameAlias)->FT_VALCONT                          ,NIL},;
				{"D1_DTDIGIT"  ,STOD( (__cNameAlias)->FT_EMISSAO)     				         , NIL },;
				{"D1_TES"      ,"016"                                   ,NIL},;
				{"D1_CF"       , (__cNameAlias)->FT_CFOP                                  ,NIL},;
				{"D1_LOCAL"    ,"01"                          ,NIL} } )



			(__cNameAlias)->( dbSkip() )
		Enddo

		(__cNameAlias)->( DbCloseArea() )
		lMsErroAuto := .F.



		MSExecAuto({|x,y,z| MATA103(x,y,z)},aCabec,aItens,3)

		if lMsErroAuto
			ConOut( " -- ERRO LIVRO !-- " )
		Else
			ConOut( " -- OOOK LIVRO !-- " )
		endif


		RestArea(aArea)

		RECOVER
		ErrorBlock(oErr)
	END SEQUENCE

Return


Static Function fsFornec( cCNPJ )


	Local	__cNameAlias := GETNEXTALIAS()
	Local aInfo := {}
	Local _cQuery := ""
	Local xFil := ""

	_cQuery := "  SELECT A2_COD, A2_LOJA  FROM SA2010 WHERE A2_CGC = '" + cCNPJ + "'  AND D_E_L_E_T_ = '' "
	dbUseArea(.T.,__CONNECT,TcGenQry(,,_cQuery),__cNameAlias,.T.,.T.)

	(__cNameAlias)->(DbGoTop())


	IF !(__cNameAlias)->(Eof())
		aAdd( aInfo, {  (__cNameAlias)->A2_COD , (__cNameAlias)->A2_LOJA  } )
	EndIF

	(__cNameAlias)->(DBCloseArea())

Return aInfo


Static  Function getChvCTe( vDoc )

	local vChave
	local __cNameAlias := GETNEXTALIAS()

	local cQuery := "  SELECT F1_CHVNFE FROM SF1010 WHERE D_E_L_E_T_ <> '*' AND F1_FORNECE = '000273' AND TRIM(F1_DOC) = '" + ALLTRIM(vDoc) +"' "


	dbUseArea(.T.,__CONNECT,TcGenQry(,,cQuery),__cNameAlias,.T.,.T.)

	vChave = (__cNameAlias)->F1_CHVNFE

	(__cNameAlias)->(DBCloseArea())

Return vChave

Static Function doInutiliza(vCTe, chave, v_data, xAlias )

	local vNOTA := vCTe
	local vSERIE := '1'
	local vCLIENTE := '999999'
	local vLOJA := '01'
	local vDTREC_SEFR :=  DTOS( CTOD ( RIGHT(  LEFT( v_data, 10) , 2)  + '/' +  SUBSTRING(   LEFT( v_data, 10) , 6, 2)  + '/' + LEFT(   LEFT( v_data, 10) ,4) ) )
	local vNFE_CHV := chave
	local vM0_CODFIL := '05'
	local vEST := 'PE'
	local vID_ENT := '000001'
	local vCSTAT_SEFR := '102'
	local vSEQUENCE := 0
	local cIns := ""
	local cQuery := ""
	local __cNameAlias
	local cValues := ""
	local nStatus
	Local aCabec    := {}
	Local aItem     := {}
	Local aItensT   := {}
	Local aLinha    := {}
	Local aTitulo   := {}

	Local xF3_ENTRADA
	Local xF3_FISCAL := ""
	Local xF3_SERIE
	Local xF3_CLIEFOR
	Local xF3_LOJA
	Local xF3_ESTADO
	Local xF3_CFO
	Local xF3_EMISSAO
	Local xF3_ALIQICM := 18
	Local xF3_VALCONT
	Local xF3_BASEICM := 0.00
	Local xF3_VALICM
	Local xF3_ESPECIE := 'CTE'
	Local xF3_CHVNFE
	Local aInfo := {}
	Local xData
	Local xObs := ""
	Local xEmiss := ""
	Local xChvCTe := ""
	local xNOTA := ""
	Local dtPTH := ""
	Local lRet := .T.
	Local cDatCTe
	local aAreaAnt := GETAREA()
	local  v_nCt
	private lMsErroAuto := .F.



	xF3_FISCAL :=  (xAlias)->nCT
	xF3_SERIE := "1"

	xChvCTe := AllTrim( StrTran( (xAlias)->chCte , 'CTe','') )




	xF3_ESPECIE := "CTE"
	cDatCTe := ALLTRIM((xAlias)->DHEMI)
	xF3_CHVNFE := AllTrim( StrTran( (xAlias)->chCte , 'CTe','') )
	xData :=   DATAVALIDA( CTOD ( RIGHT(  LEFT( cDatCTe, 10) , 2)  + '/' +  SUBSTRING(   LEFT( cDatCTe, 10) , 6, 2)  + '/' + LEFT(   LEFT( cDatCTe, 10) ,4) ) )

	xEmiss := CTOD ( RIGHT(  LEFT( cDatCTe, 10) , 2)  + '/' +  SUBSTRING(   LEFT( cDatCTe, 10) , 6, 2)  + '/' + LEFT(   LEFT( cDatCTe, 10) ,4) )

	dtPTH := DTOS (   CTOD ( RIGHT(  LEFT( cDatCTe, 10) , 2)  + '/' +  SUBSTRING(   LEFT( cDatCTe, 10) , 6, 2)  + '/' + LEFT(   LEFT( cDatCTe, 10) ,4) )    )
	xObs :=  "Frete CTe: " + ALLTRIM( (xAlias)->xObs )



	nStatus:= TCSqlExec( "UPDATE SF3020 SET F3_OBSERV = 'SEM REPERCUSSAO FISCAL', F3_ALIQICM = 0 ,F3_VALCONT = 0, F3_BASEICM = 0 , F3_VALICM = 0 , F3_BASEIPI = 0, F3_VALIPI = 0  WHERE F3_CHVNFE  = '" +vNFE_CHV + "'" )

	IF (nStatus < 0)
		ConOut ("TCSQLError() " + TCSQLError())
	EndIF

	nStatus:= TCSqlExec( "UPDATE SFT020 SET FT_OBSERV = 'SEM REPERCUSSAO FISCAL', FT_ALIQICM = 0 ,FT_VALCONT = 0 ,FT_BASEICM = 0, FT_VALICM = 0 , FT_ISENICM = 0 , FT_OUTRICM = 0, FT_BASEIPI = 0, FT_VALIPI = 0, FT_QUANT  = 0,FT_PRCUNIT = 0, FT_DESCONT = 0, FT_TOTAL = 0, FT_PESO  = 0 , FT_BASEPIS = 0,FT_ALIQPIS = 0,FT_VALPIS = 0,FT_BASECOF = 0,FT_ALIQCOF = 0,FT_VALCOF = 0  WHERE TRIM(FT_CHVNFE)  = '" +ALLTRIM(vNFE_CHV) + "'" )

	IF (nStatus < 0)
		ConOut ("TCSQLError() " + TCSQLError())
	EndIF


	IF ( ALLTRIM( (xAlias)->toma03 ) == "0" )
		aInfo :=  doCteCli( ALLTRIM((xAlias)->remCNPJ) )
	EndIF

	IF ( ALLTRIM( (xAlias)->toma03 ) == "3" )
		aInfo :=  doCteCli( ALLTRIM((xAlias)->destcnpj) )
	EndIF


	xNOTA := (xAlias)->nCT


	nStatus := TCSqlExec( " DELETE FROM SF3020 WHERE TRIM(F3_ESPECIE) = 'CTE'  AND TRIM(F3_NFISCAL) = '" + ALLTRIM(xNOTA) + "'" )

	IF (nStatus < 0)
		MsgAlert ("TCSQLError() " + TCSQLError())
	EndIF

	TCRefresh("SF3020")



	nStatus := TCSqlExec( "DELETE FROM SFT020 WHERE TRIM(FT_ESPECIE) = 'CTE'  AND TRIM(FT_NFISCAL) = '" + ALLTRIM(xNOTA) + "'" )

	IF (nStatus < 0)
		MsgAlert ("TCSQLError() " + TCSQLError())
	EndIF

	TCRefresh("SFT020")



	nStatus := TCSqlExec("DELETE FROM SD2020 WHERE TRIM(D2_COD) = '00000050' AND TRIM(D2_DOC) = '" + ALLTRIM(xNOTA) + "'" )

	IF (nStatus < 0)
		MsgAlert ("TCSQLError() " + TCSQLError())
	EndIF


	TCRefresh("SD2020")

	nStatus:= TCSqlExec(  "DELETE FROM SF2020 WHERE TRIM(F2_DOC) = '" + ALLTRIM(xNOTA) + "' AND TRIM(F2_ESPECIE)='CTE' " )

	IF (nStatus < 0)
		MsgAlert ("TCSQLError() " + TCSQLError())
	EndIF

	TCSqlExec( "COMMIT" )

	TCRefresh("SF2020")


	nStatus:= TCSqlExec(  "DELETE  FROM SE1020  WHERE TRIM(E1_PREFIXO) = 'CTe' AND TRIM(E1_NUM) = '" + ALLTRIM(xNOTA) + "'" )

	IF (nStatus < 0)
		MsgAlert ("TCSQLError() " + TCSQLError())
	EndIF

	TCSqlExec( "COMMIT" )

	TCRefresh("SE1020")







	v_nCt := (xAlias)->nCT

	lRet := isExist( ALLTRIM( xChvCTe ), (xAlias)->nCT )

	IF ( lRet == .F. .AND. !Empty(aInfo) )

		IF  ALLTRIM((xAlias)->CST) == "00"

			IF ( (xAlias)->pICMS < 12 )
				xF3_ALIQICM := 7
			Else
				xF3_ALIQICM := 12
			EndIF

			xF3_VALCONT := (xAlias)->vBC
			xF3_BASEICM := (xAlias)->VBC
			xF3_VALICM  := (xAlias)->vICMS

		Else

			xF3_ALIQICM := 0
			xF3_VALCONT := 0
			xF3_BASEICM := (xAlias)->vTPrest
			xF3_VALICM  := 0

		EndIF

		IF xF3_BASEICM = 0
			xF3_BASEICM = 0.10
		EndIF

		ConOut( "GRAVANDO... " + xF3_FISCAL  )
		aAdd(aCabec,{"F2_TIPO"   ,"N"})
		aAdd(aCabec,{"F2_FORMUL" ,"N"})
		aAdd(aCabec,{"F2_DOC"    ,xF3_FISCAL })
		aAdd(aCabec,{"F2_SERIE" ,"1"})
		aAdd(aCabec,{"F2_EMISSAO",xEmiss})
		aAdd(aCabec,{"F2_CLIENTE",aInfo[1][1] })
		aAdd(aCabec,{"F2_LOJA"   ,aInfo[1][2]})
		aAdd(aCabec,{"F2_ESPECIE","CTE"})
		aAdd(aCabec,{"F2_COND","001"})
		aAdd(aCabec,{"F2_DESCONT",0})
		aAdd(aCabec,{"F2_VALBRUT", xF3_BASEICM })
		aAdd(aCabec,{"F2_VALFAT", xF3_BASEICM })
		aAdd(aCabec,{"F2_FRETE",0})
		aAdd(aCabec,{"F2_SEGURO",0})
		aAdd(aCabec,{"F2_DESPESA",0})
		aAdd(aCabec,{"F2_CHVNFE", xF3_CHVNFE })


		aAdd(aLinha,{"D2_COD" ,"00000050",Nil})
		aAdd(aLinha,{"D2_QUANT",1,Nil})
		aAdd(aLinha,{"D2_PRCVEN", xF3_BASEICM,Nil})
		aAdd(aLinha,{"D2_TOTAL", xF3_BASEICM,Nil})



		IF ( xF3_ALIQICM == 7 )
			aAdd(aLinha,{"D2_TES","502",Nil})
			aAdd(aLinha,{"D2_PICM", 7 ,Nil})
			aAdd(aLinha,{"D2_CF", (xAlias)->CFOP ,Nil})
		Else
			aAdd(aLinha,{"D2_TES","501",Nil})
			aAdd(aLinha,{"D2_PICM", 12 ,Nil})
			aAdd(aLinha,{"D2_CF", (xAlias)->CFOP ,Nil})
		EndIF

		IF xF3_ALIQICM == 0
			aAdd(aLinha,{"D2_TES","503",Nil})
			aAdd(aLinha,{"D2_CF", (xAlias)->CFOP ,Nil})
			aAdd(aLinha,{"D2_PICM", 0 ,Nil})
		EndIF



		aAdd(aItensT,aLinha)

		Begin Transaction
			lMsErroAuto 		:= .F.
			lAutoErrNoFile	:= .F.
			lMsErroAuto		:= .F.
			l920Inclui			:= .T.


			MSExecAuto({|x,y,z| mata920(x,y,z)},aCabec,aItensT,3) //Inclusao

			IF lMsErroAuto
				MostraErro()
				ConOut("ERRO AO INCLUIR ! -> nCT -> " + xF3_FISCAL )
				TCSqlExec(" UPDATE Tbl_SefazCTe SET xProcTOTVSSaida = 'N' ,  vLivro = 'X' WHERE nCT = '" + xF3_FISCAL + "' AND cStat = '100' " )
				DisarmTransaction()

			Else

				nStatus:= TCSqlExec( "UPDATE SF3020 SET F3_OBSERV = 'SEM REPERCUSSAO FISCAL', F3_ALIQICM = 0 ,F3_VALCONT = 0, F3_BASEICM = 0 , F3_VALICM = 0 , F3_BASEIPI = 0, F3_VALIPI = 0  WHERE F3_CHVNFE  = '" +vNFE_CHV + "'" )

				IF (nStatus < 0)
					ConOut ("TCSQLError() " + TCSQLError())
				EndIF

				nStatus:= TCSqlExec( "UPDATE SFT020 SET FT_OBSERV = 'SEM REPERCUSSAO FISCAL', FT_ALIQICM = 0 ,FT_VALCONT = 0 ,FT_BASEICM = 0, FT_VALICM = 0 , FT_ISENICM = 0 , FT_OUTRICM = 0, FT_BASEIPI = 0, FT_VALIPI = 0, FT_QUANT  = 0,FT_PRCUNIT = 0, FT_DESCONT = 0, FT_TOTAL = 0, FT_PESO  = 0 , FT_BASEPIS = 0,FT_ALIQPIS = 0,FT_VALPIS = 0,FT_BASECOF = 0,FT_ALIQCOF = 0,FT_VALCOF = 0  WHERE TRIM(FT_CHVNFE)  = '" +ALLTRIM(vNFE_CHV) + "'" )

				IF (nStatus < 0)
					ConOut ("TCSQLError() " + TCSQLError())
				EndIF

			EndIF

		End Transaction




		ConOut("INUTILIZA ..: " + vCTe )

		__cNameAlias := GETNEXTALIAS()

		cQuery := "  SELECT MAX(R_E_C_N_O_)+1 vRECNO FROM SF3020 WHERE D_E_L_E_T_ <> '*' "


		dbUseArea(.T.,__CONNECT,TcGenQry(,,cQuery),__cNameAlias,.T.,.T.)

		vSEQUENCE = (__cNameAlias)->vRECNO

		(__cNameAlias)->(DBCloseArea())

		cIns := " INSERT INTO SF3020 ( F3_ENTRADA, F3_NFISCAL, F3_SERIE, F3_CLIEFOR, F3_LOJA, F3_CFO, F3_EMISSAO,  "
		cIns +=	"		F3_ALIQICM,F3_VALCONT,F3_BASEICM,F3_VALICM,F3_BASEIPI,F3_VALIPI, F3_ESPECIE, F3_FILIAL, F3_IDENTFT, "
		cIns +=	"				F3_CODRSEF,R_E_C_N_O_, F3_OBSERV, F3_CHVNFE ) "
		cIns +=	"				VALUES ( "


		cValues += "'" +ALLTRIM(vDTREC_SEFR)  + "',"
		cValues += "'" +ALLTRIM(vNOTA) + "',"
		cValues += "'" +ALLTRIM(vSERIE) + "',"
		cValues += "'" +ALLTRIM(vCLIENTE) + "',"
		cValues += "'" + vLOJA + "',"
		cValues += "'5102',"
		cValues += "'" +  vDTREC_SEFR  + "',"
		cValues += " 0,0,0,0,0,0,"
		cValues += "'SPED',"
		cValues += "'" +vM0_CODFIL + "',"
		cValues += "'" +vID_ENT + "',"
		cValues += "'" +vCSTAT_SEFR + "',"
		cValues += cValToChar(vSEQUENCE) + ","
		cValues += "'SEM REPERCUSSAO FISCAL' ,"
		cValues += "'" +vNFE_CHV + "' )"




		//nStatus := TCSqlExec( cIns + ALLTRIM(cValues) )

		IF (nStatus < 0)
			ConOut ("TCSQLError() " + TCSQLError())
		EndIF



		cIns := " INSERT INTO SFT020 (    FT_FILIAL, FT_ENTRADA, FT_EMISSAO, FT_NFISCAL, FT_SERIE, FT_CLIEFOR, FT_LOJA,FT_ESTADO,FT_CFOP, "
		cIns +=	"										FT_ALIQICM,FT_VALCONT,FT_BASEICM,FT_VALICM,FT_ISENICM,FT_OUTRICM,FT_BASEIPI,FT_VALIPI, "
		cIns +=	"										FT_ESPECIE,FT_TIPOMOV,FT_PRODUTO, FT_ITEM,FT_CLASFIS,FT_POSIPI,FT_IDENTF3, "
		cIns +=	"										FT_QUANT,FT_PRCUNIT,FT_DESCONT,FT_TOTAL,FT_PESO, "
		cIns +=	"										FT_BASEPIS,FT_ALIQPIS,FT_VALPIS,FT_BASECOF,FT_ALIQCOF,FT_VALCOF, FT_CLIENT, FT_LOJENT, "
		cIns +=	"										FT_OBSERV, FT_CHVNFE , R_E_C_N_O_ ) "



		__cNameAlias := GETNEXTALIAS()

		cQuery := "  SELECT MAX(R_E_C_N_O_)+1 vRECNO FROM SFT020 WHERE D_E_L_E_T_ <> '*' "


		dbUseArea(.T.,__CONNECT,TcGenQry(,,cQuery),__cNameAlias,.T.,.T.)

		vSEQUENCE = (__cNameAlias)->vRECNO

		(__cNameAlias)->(DBCloseArea())


		cValues := " VALUES( "
		cValues += "'" + 	vM0_CODFIL  + "',"
		cValues += "'" +	vDTREC_SEFR + "',"
		cValues += "'" +	vDTREC_SEFR + "',"
		cValues += "'" +	ALLTRIM(vNOTA) 		 + "',"
		cValues += "'" +	ALLTRIM(vSERIE) 	 + "',"
		cValues += "'" +	ALLTRIM(vCLIENTE) 	 + "',"
		cValues += "'" +	vLOJA 		 + "',"
		cValues += "'" +	vEST		 + "',"
		cValues += " '5102' " + ","
		cValues += " 0,0,0,0,0,0,0,0,'SPED','S','00000003','0001','000','70049000','000001',0,0,0,0,0,0,0,0,0,0,0, "
		cValues += "'" +	vCLIENTE + "',"
		cValues += "'" +	vLOJA + "',"
		cValues += "	'SEM REPERCUSSAO FISCAL " + "',"
		cValues += "'" +	vNFE_CHV + "',"
		cValues += 	cValToChar(vSEQUENCE) + ")"


		//nStatus := TCSqlExec( cIns + cValues )

		IF (nStatus < 0)
			ConOut ("TCSQLError() " + TCSQLError())
		EndIF
	Else

		MsgAlert("Cliente/Fornecedor :" + v_nCt + " não encontrado!" )

	EndIF

	RESTAREA(aAreaAnt)

Return



User Function GRVXCTE()


	local aCabec   := {}
	local aLinha   := {}
	local aItensT  := {}
	local aTitulo  := {}

	local xNOTA
	local vChave
	local xData
	local xObs
	local __cSQL := " SELECT * FROM SD1CTE WHERE D1_DOC >= '30501' AND D1_DOC <= '30763' AND TRIM(D1_FORNECE) = '000273' AND D_E_L_E_T_ <> '*' ORDER BY D1_DOC  "

	private lMsErroAuto := .F.

	RpcSetType( 3 )
	RpcSetEnv( "02", "01" )



	TCQUERY __cSQL NEW ALIAS "EBI"
	dbSelectArea("EBI")


	While !EBI->(Eof())

		vChave := getChvCTe( EBI->D1_DOC )

		xNOTA := EBI->D1_DOC

		xObs := "Frete CTe : " + EBI->D1_DOC

		xData := STOD(  EBI->D1_EMISSAO )

		// ConOut( " DOC : " + EBI->D1_DOC )

		aCabec   := {}
		aLinha   := {}
		aItensT  := {}
		aTitulo  := {}


		cSQL := " DELETE FROM SF3020 "
		cSQL += " WHERE "
		cSQL += " TRIM(F3_ESPECIE) = 'CTE'  AND TRIM(F3_NFISCAL) = '" + ALLTRIM(xNOTA) + "' AND TRIM(F3_CLIEFOR) = '001204' "

		nStatus := TCSqlExec(  cSQL )

		IF (nStatus < 0)
			MsgAlert ("TCSQLError() " + TCSQLError())
		EndIF

		TCRefresh("SF3020")


		cSQL := " DELETE FROM SFT020 "
		cSQL += " WHERE "
		cSQL += " TRIM(FT_ESPECIE) = 'CTE'  AND TRIM(FT_NFISCAL) = '" + ALLTRIM(xNOTA) + "' AND TRIM(FT_CLIEFOR) = '001204' "

		nStatus := TCSqlExec(  cSQL )

		IF (nStatus < 0)
			MsgAlert ("TCSQLError() " + TCSQLError())
		EndIF

		TCRefresh("SFT020")


		cSQL := "	DELETE FROM SD2020  "
		cSQL += "   WHERE  "
		cSQL += "   TRIM(D2_COD) = '00000050' AND TRIM(D2_DOC) = '" + ALLTRIM(xNOTA) + "' AND TRIM(D2_CLIENTE) = '001204' "

		nStatus := TCSqlExec(  cSQL )

		IF (nStatus < 0)
			MsgAlert ("TCSQLError() " + TCSQLError())
		EndIF


		TCRefresh("SD2020")


		cSQL := "	DELETE FROM SF2020 "
		cSQL += "   WHERE "
		cSQL += "   TRIM(F2_DOC) = '" + ALLTRIM(xNOTA) + "' AND TRIM(F2_CLIENTE) = '001204' "


		nStatus:= TCSqlExec(  cSQL )

		IF (nStatus < 0)
			MsgAlert ("TCSQLError() " + TCSQLError())
		EndIF

		TCSqlExec( "COMMIT" )

		TCRefresh("SF2020")



		cSQL := "	DELETE FROM SE1020 "
		cSQL += "   WHERE "
		cSQL += "   TRIM(E1_PREFIXO) = 'CTe' AND TRIM(E1_NUM) = '" + ALLTRIM(xNOTA) + "' AND TRIM(E1_CLIENTE) = '001204' "


		nStatus:= TCSqlExec(  cSQL )

		IF (nStatus < 0)
			MsgAlert ("TCSQLError() " + TCSQLError())
		EndIF

		TCSqlExec( "COMMIT" )

		TCRefresh("SE1020")



		aAdd(aCabec,{"F2_TIPO"   ,"N"})
		aAdd(aCabec,{"F2_FORMUL" ,"N"})
		aAdd(aCabec,{"F2_DOC"    , EBI->D1_DOC })
		aAdd(aCabec,{"F2_SERIE" ,"1"})
		aAdd(aCabec,{"F2_EMISSAO", xData })
		aAdd(aCabec,{"F2_CLIENTE","001204" })
		aAdd(aCabec,{"F2_LOJA"   ,EBI->D1_FILIAL})
		aAdd(aCabec,{"F2_ESPECIE","CTE"})
		aAdd(aCabec,{"F2_COND","001"})
		aAdd(aCabec,{"F2_DESCONT",0})
		aAdd(aCabec,{"F2_VALBRUT", EBI->D1_TOTAL })
		aAdd(aCabec,{"F2_VALFAT", EBI->D1_TOTAL })
		aAdd(aCabec,{"F2_FRETE",0})
		aAdd(aCabec,{"F2_SEGURO",0})
		aAdd(aCabec,{"F2_DESPESA",0})
		aAdd(aCabec,{"F2_CHVNFE", vChave })


		aAdd(aLinha,{"D2_COD" ,"00000050",Nil})
		aAdd(aLinha,{"D2_QUANT",1,Nil})
		aAdd(aLinha,{"D2_PRCVEN", EBI->D1_TOTAL ,Nil})
		aAdd(aLinha,{"D2_TOTAL", EBI->D1_TOTAL ,Nil})



		IF ( EBI->D1_PICM == 7 )
			aAdd(aLinha,{"D2_TES","502",Nil})
			aAdd(aLinha,{"D2_PICM", 7 ,Nil})
			aAdd(aLinha,{"D2_CF", EBI->D1_CF ,Nil})
		Else
			aAdd(aLinha,{"D2_TES","501",Nil})
			aAdd(aLinha,{"D2_PICM", 18 ,Nil})

			IF( ALLTRIM(EBI->D1_CF) $ "1353/2353" )
				aAdd(aLinha,{"D2_CF", "6353" ,Nil})
			Else
				aAdd(aLinha,{"D2_CF", "6352" ,Nil})
			EndIF
		EndIF

		IF EBI->D1_PICM == 0
			aAdd(aLinha,{"D2_TES","503",Nil})
			aAdd(aLinha,{"D2_CF", EBI->D1_CF ,Nil})
			aAdd(aLinha,{"D2_PICM", 0 ,Nil})
		EndIF



		aAdd(aItensT,aLinha)

		MSExecAuto({|x,y,z| mata920(x,y,z)},aCabec,aItensT,3) //Inclusao

		IF lMsErroAuto
			MostraErro()
			ConOut("ERRO AO INCLUIR ! -> nCT -> " + EBI->D1_DOC )

		Else


			ConOut( " -- NOTA [ FISCAL / CTE ] PROCESSADA COM SUCESSO : " + EBI->D1_DOC + " -- " )

			aTitulo 	:= {}
			aAdd(aTitulo, {"E1_PREFIXO" 	, "CTe"		, nil})
			aAdd(aTitulo, {"E1_NUM"		, EBI->D1_DOC			, nil})
			aAdd(aTitulo, {"E1_PARCELA" 	, "1"		, nil})
			aAdd(aTitulo, {"E1_TIPO" 	, "NF"		, nil})
			aAdd(aTitulo, {"E1_HIST"	, xObs	, nil})
			aAdd(aTitulo, {"E1_CLIENTE"	, "001204"		, nil})
			aAdd(aTitulo, {"E1_LOJA"   	, EBI->D1_FILIAL 		, nil})
			aAdd(aTitulo, {"E1_NATUREZ"  	, "10001"     		, nil})
			aAdd(aTitulo, {"E1_EMISSAO"  	, xData 		, nil})
			aAdd(aTitulo, {"E1_VENCTO"  	, xData 		, nil})
			aAdd(aTitulo, {"E1_VENCREA"  	, DataValida( xData )	, nil})
			aAdd(aTitulo, {"E1_SERIE"  	, "1"		, nil})
			aAdd(aTitulo, {"E1_VALOR"  	, EBI->D1_TOTAL		, nil})

			lMsErroAuto := .F.



			MSExecAuto({|x,y| FINA040(x,y)},aTitulo,3)

			IF lMsErroAuto
				ConOut( " -- NOTA COM ERRO : " + EBI->D1_DOC + " -- " )


			Else
				ConOut( " -- NOTA FINANCEIRO PROCESSADA COM SUCESSO : " + EBI->D1_DOC + " -- " )

			EndIF

		EndIF



		lMsErroAuto := .F.




		EBI->( dbSkip() )

	Enddo




Return Nil


User Function doUpdCte(  )

	local cSQL := ""
	local xNOTA := ""
	local __cNameAlias
	local nStatus
	local xEmiss
	local cDataDe := ""
	local cDataAte := ""
	local xCTeDe
	local xCTeAte
	local cPerg := "CTE001"

	IF !Pergunte(cPerg, .T.)
		Return
	EndIF


	cDataDe := DTOS( MV_PAR01 )
	cDataAte := DTOS( MV_PAR02 )
	xCTeDe :=  MV_PAR03
	xCTeAte :=  MV_PAR04



	cDataDe := LEFT( xDTDe, 4  ) + "-" + SUBSTR( xDTDe, 5,2  ) + "-" + RIGHT( xDTDe, 2  )
	cDataAte := LEFT( xDtAte, 4  ) + "-" + SUBSTR( xDtAte, 5,2  ) + "-" + RIGHT( xDtAte, 2  )

	cSQL := " SELECT B.F2_FILIAL, A.* , ( SELECT COUNT(* ) TOPROC FROM Tbl_SefazCte A   "
	cSQL += " INNER JOIN SF2010 B  "
	cSQL += " ON  "
	cSQL += " A.nfe_chave = B.F2_CHVNFE   "
	cSQL += " WHERE A.cStat = '100'  AND A.CST IN( '00','040','40')  "
	cSQL += " AND REPLACE(LPAD(dhEmi,10),'-','')  BETWEEN '" + cDataDe + "' AND '" + cDataAte + "' AND nCT BETWEEN " + xCTeDe + " AND " + xCTeATe
	cSQL += "   ) TOPROC FROM Tbl_SefazCte A  "
	cSQL += " INNER JOIN SF2010 B "
	cSQL += " ON  "
	cSQL += " A.nfe_chave = B.F2_CHVNFE   "
	cSQL += " WHERE A.cStat = '100'  AND A.CST IN( '00','040','40')  "
	cSQL += " AND REPLACE(LPAD(dhEmi,10),'-','')  BETWEEN '" + cDataDe + "' AND '" + cDataAte + "' AND nCT BETWEEN " + xCTeDe + " AND " + xCTeATe
	cSQL += " ORDER BY 1




	MemoWrite("\system\CTeEnt.sql",cSql)


	__cNameAlias := GETNEXTALIAS()

	dbUseArea(.T.,__CONNECT,TcGenQry(,,cSQL),__cNameAlias,.T.,.T.)

	ConOut(Repl("-",80))
	ConOut(PadC("-- [ JOBCTE ] | DACTE  --",80))

	(__cNameAlias)->(DbGoTop())


	IF !(__cNameAlias)->(Eof())



		While !(__cNameAlias)->(Eof())

			xEmiss := CTOD ( RIGHT(  LEFT( (__cNameAlias)->DHEMI, 10) , 2)  + '/' +  SUBSTRING(   LEFT( (__cNameAlias)->DHEMI, 10) , 6, 2)  + '/' + LEFT(   LEFT( (__cNameAlias)->DHEMI, 10) ,4) )
			xNOTA := (__cNameAlias)->nCT

			cSQL := "	UPDATE SF3010  SET F3_ENTRADA = '" + DTOS (xEmiss ) + "'"
			cSQL += "   WHERE D_E_L_E_T_<> '*'  "
			cSQL += " AND TRIM(F3_NFISCAL) = '" + ALLTRIM(xNOTA) + "' AND TRIM(F3_CLIEFOR) = '000273'  "

			ConOut(PadC("-- [ JOBCTE ] | DACTE  -- :" + xNOTA,80))


			nStatus:= TCSqlExec(  cSQL )

			IF (nStatus < 0)
				MsgAlert ("TCSQLError() " + TCSQLError())
			EndIF

			TCSqlExec( "COMMIT" )
			TCRefresh("SF3010")


			cSQL := " UPDATE SFT010  SET FT_ENTRADA = '" + DTOS (xEmiss ) + "'"
			cSQL += " WHERE  D_E_L_E_T_ <> '*' "
			cSQL += " AND TRIM(FT_NFISCAL) = '" + ALLTRIM(xNOTA) + "' AND TRIM(FT_CLIEFOR) = '000273'  "

			nStatus:= TCSqlExec(  cSQL )

			IF (nStatus < 0)
				MsgAlert ("TCSQLError() " + TCSQLError())
			EndIF

			TCRefresh("SFT010")

			cSQL := "UPDATE SE2010 SET TRIM(E2_NATUREZ) = '20703' WHERE TRIM(E2_FORNECE) = '000273' AND TRIM(E2_NUM) ='" + ALLTRIM(xNOTA) + "'  "

			nStatus:= TCSqlExec(  cSQL )

			TCSqlExec( "COMMIT" )
			//IF (nStatus < 0)
			//	 MsgAlert ("TCSQLError() " + TCSQLError())
			//EndIF

			TCRefresh("SE2010")


			cSQL := "	UPDATE SD1010  SET D1_DTDIGIT = '" + DTOS (xEmiss ) + "'"
			cSQL += "   WHERE D_E_L_E_T_ <> '*'  "
			cSQL += "   AND TRIM(D1_COD) = '00011495' AND TRIM(D1_DOC) = '" + ALLTRIM(xNOTA) + "' AND TRIM(D1_FORNECE) = '000273' "

			nStatus:= TCSqlExec(  cSQL )
			TCSqlExec( "COMMIT" )

			IF (nStatus < 0)
				MsgAlert ("TCSQLError() " + TCSQLError())
			EndIF

			TCRefresh("SD1010")


			cSQL := "	UPDATE SF1010  SET F1_DTDIGIT = '" + DTOS (xEmiss ) + "'"
			cSQL += "   WHERE D_E_L_E_T_<> '*'  "
			cSQL += "   AND F1_ESPECIE = 'CTE' AND TRIM(F1_DOC) = '" + ALLTRIM(xNOTA) + "' AND TRIM(F1_FORNECE) = '000273'"


			nStatus:= TCSqlExec(  cSQL )
			TCSqlExec( "COMMIT" )

			IF (nStatus < 0)
				MsgAlert ("TCSQLError() " + TCSQLError())
			EndIF

			TCRefresh("SF1010")





			(__cNameAlias)->(dbSkip())
		EndDo

	EndIF

	(__cNameAlias)->(DBCloseArea())


Return

Static Function getDifVal( vVal, vChave )

	local cSQL := ""
	local __cNameAlias
	local nBaseCal := 0

    /*
	cSQL := "  SELECT  NVL( ROUND( ( " + cValToChar(vVal) + " * ROUND( ( X.VAL_PROD / Y.VAL_NOTA) ,2 ) ) ,2 ),0 ) VALOR from( "
	cSQL += "  SELECT SUM(FT_VALCONT) VAL_PROD FROM SFT010 WHERE FT_CHVNFE = '"+vChave+"' AND FT_FILIAL = '03' "
	cSQL += "  AND TRIM(FT_CFOP) != '6404' "
	cSQL += "  ) X , "
	cSQL += "  (  "
	cSQL += "  SELECT SUM(FT_VALCONT) VAL_NOTA FROM SFT010 WHERE FT_CHVNFE = '"+vChave+"' AND FT_FILIAL = '03' "
	cSQL += "  ) Y "
	
	
	 MemoWrite("\system\getDifVal.sql",cSql) 
	
	    
	__cNameAlias := GETNEXTALIAS()
	
	 dbUseArea(.T.,__CONNECT,TcGenQry(,,cSQL),__cNameAlias,.T.,.T.)
	
	 nDiff :=  IIF( (__cNameAlias)->VALOR != 0, (__cNameAlias)->VALOR, vVal )
	
	 (__cNameAlias)->(DBCloseArea())
	*/	

Return nBaseCal
