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



Static Function doParamter( )

PutSx1(cPerg ,"01","Do Cliente" ,"Do Cliente","Do Cliente","mv_ch1","C"  ,18       ,0       ,0      ,"G" ,""    ,"SA1" ,""     ,"","MV_PAR01",""     ,"","",""    ,""           ,"","",""         ,"","",""          ,"","","","","")
PutSx1(cPerg ,"02","Ate Cliente" ,"Ate Cliente","Ate Cliente","mv_ch2","C"  ,18       ,0       ,0      ,"G" ,""    ,"SA1" ,""     ,"","MV_PAR02",""     ,"","",""    ,""           ,"","",""         ,"","",""          ,"","","","","")

PutSx1(cPerg ,"03","Do Vendedor"  ,"Do Vendedor","Do Vendedor"   ,"mv_ch3","C"  ,18       ,0       ,0      ,"G" ,""    ,"SA3" ,""     ,"","MV_PAR03",""     ,"","",""    ,""           ,"","",""         ,"","",""          ,"","","","","")
PutSx1(cPerg ,"04","Ate Vendedor" ,"Ate Vendedor","Ate Vendedor" ,"mv_ch4","C"  ,18       ,0       ,0      ,"G" ,""    ,"SA3" ,""     ,"","MV_PAR04",""     ,"","",""    ,""           ,"","",""         ,"","",""          ,"","","","","")

PutSx1(cPerg ,"05","Compras a partir" ,"Vendas","Vendas" ,"mv_ch5","D"  ,8       ,0       ,0      ,"G" ,""    ,"" ,""     ,"","MV_PAR05",""     ,"","",""    ,""           ,"","",""         ,"","",""          ,"","","","","")

  
Return
 
                 
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
