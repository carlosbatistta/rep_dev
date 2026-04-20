#Include "PROTHEUS.CH"
#Include "RWMAKE.CH"
#Include "RPTDEF.CH"
#INCLUDE "TBICONN.CH"

User Function GDETQPRT()
	// Local oReport
	Local oButton1
	// Local oComboBo1
	Local oProdAcab
	Local oMatPrima
	Local oInsumo
	Local oEmbalagem
	Local oProdQuim
	Local oRetrabal
	Local oAvaria
	Local oAprovado
	Local oAnalise
	Local oReprovado
	Local oPaginaA4
	Local nCopias

	Static oDlg
	_hora:=TIME()
	_data:=DATE()

	vPRODUTO := space(20)
	vENDEREC := space(20)
	vNUMNFE := space(20)
	vNUMLOTE := space(20)
	vDTFABRI := ctod("  /  /  ")
	vDTVALID := ctod("  /  /  ")
	vQUANTID := space(20)
	vVOLUME := space(20)
	vFORNECE := space(20)
	vCLINTE := space(20)
	vVISTO := space(50)
	vDTAPROV := ctod("  /  /  ")
	vQuantPg := space(3)
	nQtdCopias := space(3)

	lProdAcab  := .f.
	lMatPrima  := .f.
	lInsumo  := .f.
	lEmbalagem  := .f.
	lProdQuim  := .f.
	lRetrabal  := .f.
	lAvaria  := .f.
	lAprovado  := .f.
	lAnalise  := .f.
	lReprovado  := .f.
	lPaginaA4  := .f.

	nL := 0
	nC := 0
// Alert(SD3->D3_DOC)
	DEFINE MSDIALOG oDlg TITLE "Gerar Etiqueta" FROM 000, 000  TO 640, 520 COLORS 0, 16777215 PIXEL
	nL := nL + 010

	@ nL+005, nC+010 SAY "Produto" PIXEL
	@ nL+013, nC+010 MSGET vPRODUTO SIZE 60,10 F3 "SB1" PIXEL

	@ nL+005, nC+080 SAY "Endereçamento" PIXEL
	@ nL+013, nC+080 MSGET vENDEREC SIZE 60,10 PIXEL

	@ nL+030, nC+010 SAY "Número da NF-e" PIXEL
	@ nL+038, nC+010 MSGET vNUMNFE SIZE 60,10 PIXEL

	@ nL+030, nC+080 SAY "Número do Lote" PIXEL
	@ nL+038, nC+080 MSGET vNUMLOTE SIZE 60,10 PIXEL

	@ nL+055, nC+010 SAY "Data Fabricação" PIXEL
	@ nL+063, nC+010 MSGET vDTFABRI SIZE 60,10 PIXEL

	@ nL+055, nC+080 SAY "Data Validade" PIXEL
	@ nL+063, nC+080 MSGET vDTVALID SIZE 60,10 PIXEL

	@ nL+080, nC+010 SAY "Quantidade" PIXEL
	@ nL+088, nC+010 MSGET vQUANTID SIZE 60,10 PIXEL

	@ nL+080, nC+080 SAY "Volume" PIXEL
	@ nL+088, nC+080 MSGET vVOLUME SIZE 60,10 PIXEL

	@ nL+105, nC+010 SAY "Fornecedor" PIXEL
	@ nL+113, nC+010 MSGET vFORNECE SIZE 60,10 F3 "SA2" PIXEL

	@ nL+105, nC+080 SAY "Cliente" PIXEL
	@ nL+113, nC+080 MSGET vCLINTE SIZE 60,10 F3 "SA1" PIXEL

	// @ nL+105, nC+080 SAY "Centro de Custo" PIXEL
	// @ nL+113, nC+080 CHECKBOX oOsv VAR lOsv PROMPT "Produto Acabado" SIZE 55,08 PIXEL
	// TIPO oPrint:Box( 130,10,600,900 );
	@ nL+130, nC+010 SAY "TIPO" PIXEL
	@ nL+140, nC+010 CHECKBOX oProdAcab VAR lProdAcab PROMPT "Produto Acabado" SIZE 55,08 PIXEL
	@ nL+140, nC+080 CHECKBOX oMatPrima VAR lMatPrima PROMPT "Matéria Prima" SIZE 55,08 PIXEL
	@ nL+140, nC+130 CHECKBOX oInsumo VAR lInsumo PROMPT "Insumo" SIZE 55,08 PIXEL
	@ nL+140, nC+200 CHECKBOX oEmbalagem VAR lEmbalagem PROMPT "Embalagem" SIZE 55,08 PIXEL

	@ nL+150, nC+010 CHECKBOX oProdQuim VAR lProdQuim PROMPT "Produto Químico/Limpeza" SIZE 100,08 PIXEL
	@ nL+150, nC+130 CHECKBOX oRetrabal VAR lRetrabal PROMPT "Retrabalho" SIZE 55,08 PIXEL
	@ nL+150, nC+200 CHECKBOX oAvaria VAR lAvaria PROMPT "Avaria" SIZE 55,08 PIXEL
	// @ nL+155, nC+200 CHECKBOX oMatPrima VAR lMatPrima PROMPT "Embalagem" SIZE 55,08 PIXEL

	// STATUS
	@ nL+165, nC+010 SAY "STATUS" PIXEL
	@ nL+175, nC+010 CHECKBOX oAprovado VAR lAprovado PROMPT "Aprovado" SIZE 55,08 PIXEL
	@ nL+175, nC+080 CHECKBOX oAnalise VAR lAnalise PROMPT "Em Análise" SIZE 55,08 PIXEL
	@ nL+175, nC+130 CHECKBOX oReprovado VAR lReprovado PROMPT "Reprovado" SIZE 55,08 PIXEL

	@ nL+200, nC+010 SAY "Visto" PIXEL
	@ nL+200, nC+080 MSGET vVISTO SIZE 100,10 PIXEL
	@ nL+225, nC+010 SAY "Dt.Aprov" PIXEL
	@ nL+225, nC+080 MSGET vDTAPROV SIZE 60,10 PIXEL

	@ nL+250, nC+010 SAY "Quantidade de etiquetas" PIXEL
	@ nL+260, nC+010 MSGET nQtdCopias PICTURE "999" SIZE 60,10 PIXEL
	// @ nL+265, nC+080 CHECKBOX oPaginaA4 VAR lPaginaA4 PROMPT "Modelo A4" SIZE 55,08 PIXEL

	@ nL+280, 010 BUTTON oButton1 PROMPT "Etiqueta 100x150" SIZE 050, 012  ACTION Processa( {|| xPrtEtq1() } ) PIXEL
	@ nL+280, 100 BUTTON oButton1 PROMPT "Etiqueta 80x30" SIZE 050, 012  ACTION Processa( {|| xPrtEtq2() } ) PIXEL
	@ nL+280, 190 BUTTON oButton1 PROMPT "Etiqueta A4" SIZE 050, 012  ACTION Processa( {|| xPrtEtqA4() } ) PIXEL
	ACTIVATE MSDIALOG oDlg CENTERED

Return

Static Function xPrtEtq1()  // 1cm +/- 117,5 px  ( 100MM x 150MM - 1.175px X 1.762,5px

	Local cPorta      := "USB005"
	Local cImpressora := "ZDesigner ZD220-203dpi ZPL"  // deverá existir a impressora no windows

	// Local cPorta     := "GENERIC"
	// Local cImpressora := "ZPLVIRTUAL"

	Local cModelo := "ZEBRA"

	Local nX := 0

	Private cAlias      := getNextAlias() //cria um alias temporário
	Private cAliasF     := getNextAlias() //cria um alias temporário

	BeginSql Alias cAlias
        SELECT
            B1_COD,
            B1_DESC,
			B1_UM
        FROM
            %table:SB1%
        WHERE
            B1_COD   = %exp:vPRODUTO%
        ORDER BY
            B1_COD
	EndSql

	(cAlias)->(dbGoTop())

	BeginSql Alias cAliasF
        SELECT
            A2_COD,
            A2_NOME
        FROM
            %table:SA2%
        WHERE
            A2_COD   = %exp:vFORNECE%
        ORDER BY
            A2_COD
	EndSql

	(cAliasF)->(dbGoTop())

	MSCBPRINTER(cModelo, cPorta,,10,.F.,,,,,,.T.,"c:\temp\",cImpressora)
	MSCBChkStatus(.F.) //Alguns modelos exigem esse comando
	MSCBInfoEti("ETIQUETA", "ROTULO")
	MSCBBegin(Val(nQtdCopias), 6, 150) // INICIA A IMPRESSÃO //Qtde de copias, velocidade (1 a 6) e tamanho da etiqueta em mm

	IF !(cAlias)->(Eof())

		// _prod := alltrim((cAlias)->B1_COD) + '-' + SubStr(Posicione("SB1",1,xFilial("SB1")+(cAlias)->B1_COD,"SB1->B1_DESC"),1 ,40)
		_prod := SubStr(Posicione("SB1",1,xFilial("SB1")+(cAlias)->B1_COD,"SB1->B1_DESC"),1 ,40)
		_fornec := SubStr(alltrim((cAliasF)->A2_NOME),1 ,40)
		// _fornec := alltrim(vFORNECE) + '-' + SubStr(alltrim((cAliasF)->A2_NOME),1 ,30)

		ckProdAcab := Iif(lProdAcab == .t., "X", " ")
		ckMatPrima := Iif(lMatPrima == .t., "X", " ")
		ckInsumo := Iif(lInsumo == .t., "X", " ")
		ckEmbalagem := Iif(lEmbalagem == .t., "X", " ")
		ckProdQuim := Iif(lProdQuim == .t., "X", " ")
		ckRetrabal := Iif(lRetrabal == .t., "X", " ")
		cklAvaria := Iif(lAvaria == .t., "X", " ")
		ckAprovado := Iif(lAprovado == .t., "X", " ")
		ckAnalise := Iif(lAnalise == .t., "X", " ")
		ckReprovado := Iif(lReprovado == .t., "X", " ")

		nX := 085
		nY := 003
		MSCBSay(nX, nY, "INDUSTRIA COM MENDONCA BARRETO LTDA", "R", "0", "060, 050")
		nX := nX -10
		MSCBSay(nX, nY, "No. NF-e: " + alltrim(vNUMNFE), "R", "0", "040, 044", .F.)
		MSCBSay(nX, 080, "No. Lote: " + alltrim(vNUMLOTE), "R", "0", "040, 044", .F.)

		nX := nX -6
		MSCBSay(nX, nY, "Quantidade: " + alltrim(vQUANTID), "R", "0", "040, 044", .F.)
		MSCBSay(nX, 080, "Volume: " + alltrim(vVOLUME), "R", "0", "040, 044", .F.)

		nX := nX -6
		MSCBSay(nX, nY, "Dt.Fabricação: " + DtoC(vDTFABRI), "R", "0", "040, 044", .F.)
		MSCBSay(nX, 080, "Dt.Validade: " + DtoC(vDTVALID), "R", "0", "040, 044", .F.)

		nX := nX -6
		MSCBSay(nX, nY, "Produto: " + _prod, "R", "0", "040, 044", .F.)
		nX := nX -6
		MSCBSay(nX, nY, "Fornecedor: " + _fornec, "R", "0", "040, 044", .F.)

		nX := nX -10
		MSCBSay(nX, nY, 'Produto Acabado ['+ckProdAcab+'] Matéria Prima ['+ckMatPrima+'] Insumo ['+ckInsumo+'] Embalagem ['+ckEmbalagem+']', "R", "0", "040, 044", .F.)
		nX := nX -6
		MSCBSay(nX, nY, 'Produto Químico/Limpeza ['+ckProdQuim+'] Retrabalho ['+ckRetrabal+'] Avaria ['+cklAvaria+']', "R", "0", "040, 044", .F.)
		nX := nX -10
		MSCBSay(nX, nY, 'Aprovado ['+ckAprovado+'] Em Análise ['+ckAnalise+'] Reprovado ['+ckReprovado+']', "R", "0", "040, 044", .F.)

		// nX := nX -10
		// MSCBSay(nX, nY, "Fornecedor: " + _fornec, "R", "0", "040, 044", .F.)

		// nX := nX -8
		// MSCBSay(nX, nY, 'Visto:' + vVISTO, "R", "0", "040, 044", .F.)
		// MSCBSay(nX, 080, 'Dt. Aprov:' + DtoC(vDTAPROV), "R", "0", "040, 044", .F.)

		nX := nX -9
		MSCBSay(nX, 003, "PRODUTO", "R", "0", "040, 044", .F.)
		MSCBSay(nX, 070, "LOTE", "R", "0", "040, 044", .F.)
		nX := nX -9
		MSCBSAYBAR(nX, 003, OemToAnsi(alltrim((cAlias)->B1_COD)),"R","MB07",10,.F.,.T.,.F.,,2,2,.F.,.F.,"1",.T.)
		MSCBSAYBAR(nX, 070, OemToAnsi(alltrim(vNUMLOTE)),"R","MB07",10,.F.,.T.,.F.,,2,2,.F.,.F.,"1",.T.)

	ENDIF

	//Finaliza a etiqueta
	MSCBEnd() // FINALIZA IMPRESSÃO
	MSCBClosePrinter() // FINALIZA CONEXÃO COM A IMPRESSORA

	(cAlias)->(dbCloseArea())

Return

/*
#########################################################
#########################################################
# ETIQUETA 2
#########################################################
#########################################################
*/
Static Function xPrtEtq2()  // 1cm +/- 117,5 px  ( 30MM X 80MM  = 352,5px X 940px)

	Local cPorta     := "USB005"
	Local cImpressora := "ZDesigner ZD220-203dpi ZPL"  // deverá existir a impressora no windows

	// Local cPorta     := "GENERIC"
	// Local cImpressora := "ZPLVIRTUAL"

	Local cModelo := "ZEBRA"

	Local sDescProd := space(50)

	Private cAlias      := getNextAlias() //cria um alias temporário

	BeginSql Alias cAlias
        SELECT
            B1_COD,
            B1_DESC,
			B1_UM
        FROM
            %table:SB1%
        WHERE
            B1_COD   = %exp:vPRODUTO%
        ORDER BY
            B1_COD
	EndSql

	(cAlias)->(dbGoTop())

	// nQtdPag := (vQuantPg % 2)
	// iif(nQtdPag = 0, nQtdPag := Int(vQuantPg/2), nQtdPag := Int(vQuantPg/2) + 1)

	MSCBPRINTER(cModelo, cPorta,,10,.F.,,,,,,.T.,"c:\temp\",cImpressora)
	MSCBChkStatus(.F.) //Alguns modelos exigem esse comando
	MSCBInfoEti("ETIQUETA", "ROTULO")
	MSCBBegin(Val(nQtdCopias), 6, 80) // INICIA A IMPRESSÃO //Qtde de copias, velocidade (1 a 6) e tamanho da etiqueta em mm

	IF !(cAlias)->(Eof())
		sDescProd := SubStr(Posicione("SB1",1,xFilial("SB1")+(cAlias)->B1_COD,"SB1->B1_DESC"),1 ,60)
		// sDescProd := SubStr(alltrim((cAlias)->B1_DESC) + alltrim((cAlias)->B1_DESC),1 ,50)

		MSCBSay(003, 003, "CÓD: " + alltrim((cAlias)->B1_COD), "N", "0", "024, 030")
		MSCBSay(003, 007, sDescProd, "N", "0", "020, 020")
		MSCBSay(003, 011, "FAB: " + DtoC(vDTFABRI), "N", "0", "024, 034", .F.)
		MSCBSay(036, 011, "VAL: " + DtoC(vDTVALID), "N", "0", "024, 034", .F.)
		MSCBSay(003, 015, "Peso Líquido/Quantidade: " + alltrim(vQUANTID) + " "+ alltrim((cAlias)->B1_UM), "N", "0", "024, 034", .F.)
		MSCBSay(003, 019, "LOTE", "N", "0", "020, 020", .F.)
		MSCBSAYBAR(003, 022,OemToAnsi(alltrim(vNUMLOTE)),"N","MB07",4,.F.,.T.,.F.,,2,2,.F.,.F.,"1",.T.)

	ENDIF

	//Finaliza a etiqueta
	MSCBEnd() // FINALIZA IMPRESSÃO
	MSCBClosePrinter() // FINALIZA CONEXÃO COM A IMPRESSORA

	(cAlias)->(dbCloseArea())

Return







Static Function xPrtxx()

	Local nX        := 0
	Local nQtdPag   := 0

	Private oPrint
	Private cAlias      := getNextAlias()
	Private cAliasF     := getNextAlias()
	Private oFont06     := TFont():New('Arial',,06,,.F.,,,,.F.,.F.)
	Private oFont06n    := TFont():New('Arial',,06,,.T.,,,,.F.,.F.)
	Private oFont08     := TFont():New('Arial',,08,,.F.,,,,.F.,.F.)
	Private oFont08n    := TFont():New('Arial',,08,,.T.,,,,.F.,.F.)
	Private oFont10     := TFont():New('Arial',,10,,.F.,,,,.F.,.F.)
	Private oFont10n    := TFont():New('Arial',,10,,.T.,,,,.F.,.F.)
	Private oFont12     := TFont():New('Arial',,12,,.F.,,,,.F.,.F.)
	Private oFont12n    := TFont():New('Arial',,12,,.T.,,,,.F.,.F.)
	Private oFont14     := TFont():New('Arial',,14,,.F.,,,,.F.,.F.)
	Private oFont14n    := TFont():New('Arial',,14,,.T.,,,,.F.,.F.)
	Private oFont26     := TFont():New('Arial',,26,,.F.,,,,.F.,.F.)
	Private oFont26n    := TFont():New('Arial',,26,,.T.,,,,.F.,.F.)
	Private oFont40    := TFont():New('Arial',,40,,.T.,,,,.F.,.F.)
	Private nLin        := 0

	BeginSql Alias cAlias
        SELECT
            B1_COD,
            B1_DESC
        FROM
            %table:SB1%
        WHERE
            B1_COD   = %exp:vPRODUTO%
        ORDER BY
            B1_COD
	EndSql

	(cAlias)->(dbGoTop())


	BeginSql Alias cAliasF
        SELECT
            A2_COD,
            A2_NOME
        FROM
            %table:SA2%
        WHERE
            A2_COD   = %exp:vFORNECE%
        ORDER BY
            A2_COD
	EndSql

	(cAliasF)->(dbGoTop())

	oPrint := TMSPrinter():New(OemToAnsi('Etiqueta de produto'))
	oPrint:SetLandscape()

	nQtdPag := (vQuantPg % 2)
	iif(nQtdPag = 0, nQtdPag := Int(vQuantPg/2), nQtdPag := Int(vQuantPg/2) + 1)

	While !(cAlias)->(Eof())
		For nX := 1 to nQtdPag
			oPrint:StartPage()
			_prod := alltrim((cAlias)->B1_COD) + '-' + SubStr(alltrim((cAlias)->B1_DESC),1 ,30)
			_fornec := alltrim(vFORNECE) + '-' + SubStr(alltrim((cAliasF)->A2_NOME),1 ,30)

			ckProdAcab := Iif(lProdAcab == .t., "X", " ")
			ckMatPrima := Iif(lMatPrima == .t., "X", " ")
			ckInsumo := Iif(lInsumo == .t., "X", " ")
			ckEmbalagem := Iif(lEmbalagem == .t., "X", " ")
			ckProdQuim := Iif(lProdQuim == .t., "X", " ")
			ckRetrabal := Iif(lRetrabal == .t., "X", " ")
			cklAvaria := Iif(lAvaria == .t., "X", " ")
			ckAprovado := Iif(lAprovado == .t., "X", " ")
			ckAnalise := Iif(lAnalise == .t., "X", " ")
			ckReprovado := Iif(lReprovado == .t., "X", " ")

			nLin  := 0050
			oPrint:Say(nLin,0100,OemToAnsi('INDUSTRIA COM MENDONCA BARRETO LTDA'),oFont26n,,,,0)

			nLin += 0050
			oPrint:Say(nLin,0050,OemToAnsi('No. NF-e: ' + alltrim(vNUMNFE)),oFont14,,,,0)
			oPrint:Say(nLin,0800,OemToAnsi('No. Lote: ' + alltrim(vNUMLOTE)),oFont14,,,,0)

			nLin += 0050
			oPrint:Say(nLin,0050,OemToAnsi('Produto: ' + _prod),oFont14,,,,0)

			nLin += 0050
			oPrint:Say(nLin,0050,OemToAnsi('Fornecedor: ' + _fornec),oFont14,,,,0)

			nLin += 0060
			oPrint:Say(nLin,0050,OemToAnsi('Quantidade: ' + alltrim(vQUANTID)),oFont14,,,,0)
			oPrint:Say(nLin,0800,OemToAnsi('Volume: ' + alltrim(vVOLUME)),oFont14,,,,0)

			nLin += 0050
			oPrint:Say(nLin,0050,OemToAnsi('Dt.Fabricação: ' + DtoC(vDTFABRI)),oFont14,,,,0)
			oPrint:Say(nLin,0800,OemToAnsi('Dt.Validade: ' + DtoC(vDTVALID)),oFont14,,,,0)

			nLin += 0100
			oPrint:Say(nLin,0050,OemToAnsi('Produto Acabado ['+ckProdAcab+'] Matéria Prima ['+ckMatPrima+'] Insumo ['+ckInsumo+'] Embalagem ['+ckEmbalagem+']'),oFont14,,,,0)

			nLin += 0050
			oPrint:Say(nLin,0050,OemToAnsi('Produto Químico/Limpeza ['+ckProdQuim+'] Retrabalho ['+ckRetrabal+'] Avaria ['+cklAvaria+']'),oFont14,,,,0)

			nLin += 0100
			oPrint:Say(nLin,0050,OemToAnsi('Aprovado ['+ckAprovado+'] Em Análise ['+ckAnalise+'] Reprovado ['+ckReprovado+']'),oFont14,,,,0)

			nLin += 0100
			oPrint:Say(nLin,0050,OemToAnsi('Visto: ' + vVISTO ),oFont14,,,,0)
			oPrint:Say(nLin,0800,OemToAnsi('Dt. Aprov: ' + DtoC(vDTAPROV)),oFont14,,,,0)

			nLin += 0060
			oPrint:Say(nLin,0100, OemToAnsi('PRODUTO'),oFont10,,,,0)
			MSBAR('CODE128',6.5,0.9, alltrim((cAlias)->B1_COD),oPrint,.F.,,.T., 0.03, 0.95,,,,.F.)
			oPrint:Say(nLin,0590, OemToAnsi('LOTE'),oFont10,,,,0)
			MSBAR('CODE128',6.5,5, alltrim(vNUMLOTE),oPrint,.F.,,.T., 0.03, 0.95,,,,.F.)

			oPrint:EndPage()


		Next nX
		(cAlias)->(dbSkip())
	enddo

	(cAlias)->(dbCloseArea())

	oPrint:Preview()
	oPrint:end()

Return










User Function tstEtiq()
	// Local cPorta     := "USB005"
	// Local cImpressora := "ZDesigner ZD220-203dpi ZPL"  // deverá existir a impressora no windows

	Local cPorta     := "GENERIC"
	Local cImpressora := "ZPLVIRTUAL"

	Local cModelo := "ZEBRA"
	Local nQtdCopias := 1

	Local lProdAcab  := .f.
	Local lMatPrima  := .f.
	Local lInsumo  := .f.
	Local lEmbalagem  := .f.
	Local lProdQuim  := .f.
	Local lRetrabal  := .f.
	Local lAvaria  := .f.
	Local lAprovado  := .f.
	Local lAnalise  := .f.
	Local lReprovado  := .f.
	Local lPaginaA4  := .f.

	ckProdAcab := Iif(lProdAcab == .t., "X", " ")
	ckMatPrima := Iif(lMatPrima == .t., "X", " ")
	ckInsumo := Iif(lInsumo == .t., "X", " ")
	ckEmbalagem := Iif(lEmbalagem == .t., "X", " ")
	ckProdQuim := Iif(lProdQuim == .t., "X", " ")
	ckRetrabal := Iif(lRetrabal == .t., "X", " ")
	cklAvaria := Iif(lAvaria == .t., "X", " ")
	ckAprovado := Iif(lAprovado == .t., "X", " ")
	ckAnalise := Iif(lAnalise == .t., "X", " ")
	ckReprovado := Iif(lReprovado == .t., "X", " ")

	MSCBPRINTER(cModelo, cPorta,,10,.F.,,,,,,.T.,"c:\temp\",cImpressora)
	MSCBChkStatus(.F.) //guns modelos exigem esse comando
	MSCBInfoEti("ETIQUETA", "ROTULO")
	MSCBBegin(nQtdCopias, 6, 100) // INICIA A IMPRESSÃO //Qtde de copias, velocidade (1 a 6) e tamanho da etiqueta em mm
	// MSCBBox(01, 01, 80, 30, 1)
	// MSCBSay(X, Y
	nX := 090
	nY := 003
	MSCBSay(nX, nY, "INDUSTRIA COM MENDONCA BARRETO LTDA", "R", "0", "034, 034")
	nX := nX -4
	MSCBSay(nX, nY, "No. NF-e: " + "123456789000", "R", "0", "024, 034", .F.)
	MSCBSay(nX, 060, "No. Lote: " + "000009876431", "R", "0", "024, 034", .F.)

	nX := nX -4
	MSCBSay(nX, 003, "Produto: " + "ABCDEFGHIJKLMNOPQRSTU VXYWZ12345678901 234567890", "R", "0", "024, 034", .F.)

	nX := nX -4
	MSCBSay(nX, 003, "Fornecedor: " + "ABCDEFGHIJKLMNOPQRSTU VXYWZ12345678901 234567890", "R", "0", "024, 034", .F.)

	nX := nX -4
	MSCBSay(nX, 003, "Quantidade: " + "123456", "R", "0", "024, 034", .F.)
	MSCBSay(nX, 080, "Volume: " + "654987", "R", "0", "024, 034", .F.)

	nX := nX -4
	MSCBSay(nX, 003, "Dt.Fabricação: " + "01/10/2024", "R", "0", "024, 034", .F.)
	MSCBSay(nX, 080, "Dt.Validade: " + "15/12/2024", "R", "0", "024, 034", .F.)

	MSCBLineH(003, 070, 003,3,"R")

	nX := nX -8
	MSCBSay(nX, 003, 'Produto Acabado ['+ckProdAcab+'] Matéria Prima ['+ckMatPrima+'] Insumo ['+ckInsumo+'] Embalagem ['+ckEmbalagem+']', "R", "0", "024, 034", .F.)
	nX := nX -4
	MSCBSay(nX, 003, 'Produto Químico/Limpeza ['+ckProdQuim+'] Retrabalho ['+ckRetrabal+'] Avaria ['+cklAvaria+']', "R", "0", "024, 034", .F.)
	nX := nX -8
	MSCBSay(nX, 003, 'Aprovado ['+ckAprovado+'] Em Análise ['+ckAnalise+'] Reprovado ['+ckReprovado+']', "R", "0", "024, 034", .F.)

	nX := nX -8
	MSCBSay(nX, 003, 'Visto:' + "ALTENIR ALMEIDA DA GAMA", "R", "0", "020, 034", .F.)
	MSCBSay(nX, 080, 'Dt. Aprov:' + "15/12/2024", "R", "0", "020, 034", .F.)

	nX := nX -5
	MSCBSay(nX, 010, "PRODUTO", "R", "0", "010, 020", .F.)
	MSCBSay(nX, 080, "LOTE", "R", "0", "010, 020", .F.)
	nX := nX -4
	MSCBSAYBAR(nX, 010, "12345","R","MB07",4,.F.,.T.,.F.,,2,2,.F.,.F.,"1",.T.)
	MSCBSAYBAR(nX, 080, OemToAnsi("12345"),"R","MB07",4,.F.,.T.,.F.,,2,2,.F.,.F.,"1",.T.)




	//Finaliza a etiqueta
	MSCBEnd() // FINALIZA IMPRESSÃO
	MSCBClosePrinter() // FINALIZA CONEXÃO COM A IMPRESSORA



Return


Static Function xPrtEtqA4()

	Local nX        := 0
	Local nQtdPag   := 0

	Private oPrint
	Private cAlias      := getNextAlias()
	Private cAliasF     := getNextAlias()
	Private oFont06     := TFont():New('Arial',,06,,.F.,,,,.F.,.F.)
	Private oFont06n    := TFont():New('Arial',,06,,.T.,,,,.F.,.F.)
	Private oFont08     := TFont():New('Arial',,08,,.F.,,,,.F.,.F.)
	Private oFont08n    := TFont():New('Arial',,08,,.T.,,,,.F.,.F.)
	Private oFont10     := TFont():New('Arial',,10,,.F.,,,,.F.,.F.)
	Private oFont10n    := TFont():New('Arial',,10,,.T.,,,,.F.,.F.)
	Private oFont12     := TFont():New('Arial',,12,,.F.,,,,.F.,.F.)
	Private oFont12n    := TFont():New('Arial',,12,,.T.,,,,.F.,.F.)
	Private oFont14     := TFont():New('Arial',,14,,.F.,,,,.F.,.F.)
	Private oFont14n    := TFont():New('Arial',,14,,.T.,,,,.F.,.F.)
	Private oFont26     := TFont():New('Arial',,26,,.F.,,,,.F.,.F.)
	Private oFont26n    := TFont():New('Arial',,26,,.T.,,,,.F.,.F.)
	Private oFont50n    := TFont():New('Arial',,50,,.T.,,,,.F.,.F.)
	Private oFont40     := TFont():New('Arial',,30,,.F.,,,,.F.,.F.)
	Private oFont40n    := TFont():New('Arial',,30,,.T.,,,,.F.,.F.)
	Private oFont150n   := TFont():New('Arial',,150,,.T.,,,,.F.,.F.)
	Private oFont300n   := TFont():New('Arial',,300,,.T.,,,,.F.,.F.)
	Private nLin        := 0

	BeginSql Alias cAlias
        SELECT
            B1_COD,
            B1_EAN14,
            // B1_XCODBAR,
            B1_DESC,
			B1_UM,
			B1_SEGUM,
			B1_PESO,
			B1_PESBRU
        FROM
            %table:SB1%
        WHERE
            B1_COD   = %exp:vPRODUTO%
        ORDER BY
            B1_COD
	EndSql

	(cAlias)->(dbGoTop())


	BeginSql Alias cAliasF
        SELECT
            A1_COD,
            A1_NOME
        FROM
            %table:SA1%
        WHERE
            A1_COD   = %exp:vCLINTE%
        ORDER BY
            A1_COD
	EndSql

	(cAliasF)->(dbGoTop())

	oPrint := TMSPrinter():New(OemToAnsi('Etiqueta de produto'))
	oPrint:SetLandscape()
	IF !(cAlias)->(Eof())
		oPrint:StartPage()

		_prod := alltrim((cAlias)->B1_COD)
		_prodesc := SubStr(Posicione("SB1",1,xFilial("SB1")+(cAlias)->B1_COD,"SB1->B1_DESC"),1 ,30)
		_prodesc2 := SubStr(Posicione("SB1",1,xFilial("SB1")+(cAlias)->B1_COD,"SB1->B1_DESC"),31 ,30)

		// tentativa de pegar os cósigos via posicione
		_ean14 := Posicione("SB1",1,xFilial("SB1")+(cAlias)->B1_COD,"SB1->B1_EAN14")
		// _xcod := Posicione("SB1",1,xFilial("SB1")+(cAlias)->B1_COD,"SB1->B1_XCODBAR")

		_cliente := alltrim(vCLINTE)
		_nomecli := SubStr(Posicione("SA1",1,xFilial("SA1")+alltrim((cAliasF)->A1_COD),"SA1->A1_NOME"),1 ,30)
		_nomecli2 := SubStr(Posicione("SA1",1,xFilial("SA1")+alltrim((cAliasF)->A1_COD),"SA1->A1_NOME"),31 ,30)

		ckProdAcab 	:= Iif(lProdAcab == .t., "X", " ")
		ckMatPrima 	:= Iif(lMatPrima == .t., "X", " ")
		ckInsumo 	:= Iif(lInsumo 	== .t., "X", " ")
		ckEmbalagem := Iif(lEmbalagem == .t., "X", " ")
		ckProdQuim 	:= Iif(lProdQuim == .t., "X", " ")
		ckRetrabal 	:= Iif(lRetrabal == .t., "X", " ")
		cklAvaria 	:= Iif(lAvaria == .t., "X", " ")
		ckAprovado 	:= Iif(lAprovado == .t., "X", " ")
		ckAnalise 	:= Iif(lAnalise == .t., "X", " ")
		ckReprovado := Iif(lReprovado == .t., "X", " ")

		oPrint:Say(200,2000, OemToAnsi(PadL(cValToChar(Month(vDTVALID)), 2, '0')),oFont300n,,,,0)
		oPrint:Say(1250,2000, OemToAnsi(cValToChar(Year(vDTVALID))),oFont150n,,,,0)

		nLin  := 0040
		oPrint:SayBitmap(0050, 050, "\system\logo-cococia.bmp", 400, 400)
		oPrint:Say(nLin,0450,OemToAnsi('INDUSTRIA COM MENDONCA BARRETO LTDA'),oFont40n,,,,0)

		// nLin += 0200
		// oPrint:Say(nLin,0450,OemToAnsi('No. NF-e: ' + alltrim(vNUMNFE)),oFont26n,,,,0)
		// oPrint:Say(nLin,1800,OemToAnsi('No. Lote: ' + alltrim(vNUMLOTE)),oFont26n,,,,0)

		nLin += 0450
		oPrint:Say(nLin,0050,OemToAnsi('PRODUTO:'),oFont26n,,,,0)
		oPrint:Say(nLin,0570,OemToAnsi(_prod),oFont26,,,,0)
		nLin += 0100
		oPrint:Say(nLin,0050,OemToAnsi(_prodesc),oFont26,,,,0)
		nLin += 0100
		oPrint:Say(nLin,0050,OemToAnsi(_prodesc2),oFont26,,,,0)

		nLin += 0150
		oPrint:Say(nLin,0050,OemToAnsi('CLIENTE:'),oFont26n,,,,0)
		oPrint:Say(nLin,0500,OemToAnsi(_cliente),oFont26,,,,0)
		nLin += 0100
		oPrint:Say(nLin,0050,OemToAnsi(_nomecli),oFont26,,,,0)
		nLin += 0100
		oPrint:Say(nLin,0050,OemToAnsi(_nomecli2),oFont26,,,,0)

		nLin += 0150
		oPrint:Say(nLin,0050,OemToAnsi('QTDE:'),oFont26n,,,,0)
		oPrint:Say(nLin,0350,OemToAnsi(alltrim(vQUANTID)),oFont26,,,,0)
		oPrint:Say(nLin,0900,OemToAnsi('VOL:'),oFont26n,,,,0)
		oPrint:Say(nLin,1150,OemToAnsi(alltrim(vVOLUME)),oFont26,,,,0)

		nLin += 0150
		oPrint:Say(nLin,0050,OemToAnsi('FAB:'),oFont26n,,,,0)
		oPrint:Say(nLin,0290,OemToAnsi(DtoC(vDTFABRI)),oFont26,,,,0)
		oPrint:Say(nLin,0900,OemToAnsi('VAL:'),oFont26n,,,,0)
		oPrint:Say(nLin,1150,OemToAnsi(DtoC(vDTVALID)),oFont26,,,,0)

		// nLin += 0200
		// oPrint:Say(nLin,0050,OemToAnsi('Produto Acabado ['+ckProdAcab+'] Matéria Prima ['+ckMatPrima+'] Insumo ['+ckInsumo+'] Embalagem ['+ckEmbalagem+']'),oFont26n,,,,0)

		// nLin += 0100
		// oPrint:Say(nLin,0050,OemToAnsi('Produto Químico/Limpeza ['+ckProdQuim+'] Retrabalho ['+ckRetrabal+'] Avaria ['+cklAvaria+']'),oFont26n,,,,0)

		// nLin += 0200
		// oPrint:Say(nLin,0050,OemToAnsi('Aprovado ['+ckAprovado+'] Em Análise ['+ckAnalise+'] Reprovado ['+ckReprovado+']'),oFont26n,,,,0)

		nLin += 0100
		oPrint:Say(nLin,0050,OemToAnsi("PESO LIQ:"),oFont26n,,,,0)
		oPrint:Say(nLin,0550,OemToAnsi(cValToChar((cAlias)->B1_PESO) + " " +(cAlias)->B1_UM),oFont26,,,,0)
		oPrint:Say(nLin,0900,OemToAnsi("BRUTO:"),oFont26n,,,,0)
		oPrint:Say(nLin,1300,OemToAnsi(cValToChar((cAlias)->B1_PESBRU) + " " +(cAlias)->B1_UM),oFont26,,,,0)

		nLin += 0150
		oPrint:Say(nLin,0050,OemToAnsi('APROVADO:'),oFont26n,,,,0)
		oPrint:Say(nLin,0650,OemToAnsi(vVISTO),oFont26,,,,0)
		//nLin += 0100
		//oPrint:Say(nLin,0050,OemToAnsi('Dt. Aprov: ' + DtoC(vDTAPROV)),oFont26n,,,,0)

		nLin += 250
		oPrint:Say(nLin,0050,OemToAnsi('PRODUTO'),oFont26n,,,,0)
		oPrint:Say(nLin,1710,OemToAnsi('LOTE'),oFont26n,,,,0)

		// oPrinter:PrintBarCode( (cAlias)->B1_COD, "EAN14", 200, 50 ) 
		MSBAR('EAN128',17,1, alltrim(_ean14),oPrint,.F.,,.T., 0.07, 2,,,,.F.) // linha do código de barras
		MSBAR('CODE128',17,15, alltrim(vNUMLOTE),oPrint,.F.,,.T., 0.07, 2,,,,.F.)// linha do código de barras

		nLin += 0370
		oPrint:Say(nLin,0050, alltrim(_ean14),oFont26n,,,,0) // linha abaixo do código de barras
		oPrint:Say(nLin,1710, alltrim(vNUMLOTE),oFont26n,,,,0)// linha abaixo do código de barras

		oPrint:EndPage()
	ENDIF
	(cAlias)->(dbCloseArea())

	oPrint:Preview()
	oPrint:end()

Return
