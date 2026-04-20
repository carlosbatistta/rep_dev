#include "totvs.ch"

/*/{Protheus.doc} 
    autor: Carlos Batista
    função: getProduto
    Busca produtos com o intervalo de preço definido pelo usuário, de acordo com a descrição aproximada ou exata.
    Saída de dados no console do appserver.
/*/
User Function getProduto()

    Local oDlg
    Local oGetDesc
    Local oGetMin
    Local oGetMax
    Local oBtnBuscar

    Local cDesc     := Space(50)
    Local nPrecoMin := 11111111
    Local nPrecoMax := 99999999

    // Cria diálogo
    DEFINE MSDIALOG oDlg TITLE "Buscar Produtos" FROM 000,000 TO 200,600 PIXEL

    // Label + Campo Descrição
    @ 10, 10 SAY "Descrição:" OF oDlg PIXEL
    @ 10, 80 GET oGetDesc VAR cDesc SIZE 100,10 OF oDlg PIXEL

    // Label + Campo Preço Min
    @ 30, 10 SAY "Preço Min:" OF oDlg PIXEL
    @ 30, 80 GET oGetMin VAR nPrecoMin SIZE 80,10 OF oDlg PIXEL

    // Label + Campo Preço Max
    @ 50, 10 SAY "Preço Max:" OF oDlg PIXEL
    @ 50, 80 GET oGetMax VAR nPrecoMax SIZE 80,10 OF oDlg PIXEL

    // Botão Buscar
    @ 80, 80 BUTTON oBtnBuscar PROMPT "Buscar" SIZE 80,15 OF oDlg PIXEL ;
        ACTION ( oDlg:End(), ChamaBusca(cDesc, nPrecoMin, nPrecoMax) )

    // Botão Cancelar
    @ 80, 180 BUTTON "Cancelar" SIZE 80,15 OF oDlg PIXEL ;
        ACTION oDlg:End()

    ACTIVATE MSDIALOG oDlg CENTERED

Return

// ----------------------------------------

Static Function ChamaBusca(cDesc, nPrecoMin, nPrecoMax)

    // Validação de lógica simples para evitar consultas desnecessárias.
    If nPrecoMin > nPrecoMax
        MsgStop("Preço mínimo não pode ser maior que o máximo.")
        Return
    EndIf

    procuraProdutos(AllTrim(cDesc), nPrecoMin, nPrecoMax)

Return

// ----------------------------------------
Static Function procuraProdutos(cDesc, nPrecoMin, nPrecoMax)
    Local nRegs     := 0
    Local cAliasTMP := "" 
    Local cSql      := ""

    Default cDesc     := ""
    Default nPrecoMin := 0
    Default nPrecoMax := 99999999

    // Montagem do SQL
    cSql := " SELECT B1_COD, B1_DESC, B1_PRV1 "
    cSql += " FROM " + RetSqlName("SB1") + " SB1 "
    cSql += " WHERE B1_FILIAL = '" + xFilial("SB1") + "' "
    cSql += " AND B1_MSBLQL <> '1' "
    cSql += " AND D_E_L_E_T_ = ' ' "

    if !Empty(cDesc)
        cSql += " AND B1_DESC LIKE '%" + Upper(AllTrim(cDesc)) + "%' "
    endif

    if nPrecoMin > 0
        cSql += " AND B1_PRV1 >= " + AllTrim(Str(nPrecoMin))
    endif

    if nPrecoMax < 99999999
        cSql += " AND B1_PRV1 <= " + AllTrim(Str(nPrecoMax))
    endif

    // MPSysOpenQuery gera um alias temporário com o resultado do SQL
    cAliasTMP := MPSysOpenQuery(cSql)

    // Navegação segura no Alias gerado
    While ! (cAliasTMP)->( Eof() )
        nRegs++
        
        ConOut(;
            "ID: " + AllTrim((cAliasTMP)->B1_COD) + ;
            " | Desc: " + AllTrim((cAliasTMP)->B1_DESC) + ;
            " | Preco: " + cValToChar((cAliasTMP)->B1_PRV1) + ;
            " | Registro: " + cValToChar(nRegs) )
        
        (cAliasTMP)->( dbSkip() )
    EndDo

    // Fecha o Alias temporário.
    (cAliasTMP)->( dbCloseArea() )

Return nRegs
