#Include 'Protheus.ch'

/*/{Protheus.doc} 
    autor: Carlos Batista
    função: TreportClientesVendas
    Gera relatório de clientes com vendas registradas apresentando seu total.
/*/
User Function TreportClientesVendas()
    Local oReport    As Object
    Local oSection   As Object

    // Cria o objeto TReport
    oReport := TReport():New( ;
        "RELCLIVEND"    , ; 
        "Clientes com Vendas", ; 
        NIL             , ; 
        { |oRpt| PrintReport( oRpt ) }, ;
        "Lista clientes ativos que possuem vendas registradas" ;
    )

    oSection := TRSection():New( oReport, "SA1" )

    // Define as colunas do relatório
    TRCell():New( oSection, "A1_COD"   , "SA1", "Codigo" )
    TRCell():New( oSection, "A1_NOME"  , "SA1", "Nome" )
    TRCell():New( oSection, "A1_NREDUZ"   , "SA1", "N Fantasia" )
    TRCell():New( oSection, "A1_END"   , "SA1", "Endereco" )
    TRCell():New( oSection, "A1_EST"   , "SA1", "UF" )
    TRCell():New( oSection, "A1_MUN"   , "SA1", "Municipio" )
    TRCell():New( oSection, "A1_TIPO"   , "SA1", "Tipo" )

    // Para campos calculados
    TRCell():New( oSection, "VLRTOTAL" , "SA1", "Total Venda", /*cPicture*/ "@E 999,999,999.99" )

    oReport:PrintDialog()

Return

// --- CHAMADA DE IMPRESSÃO DO RELATÓRIO ---
Static Function PrintReport( oReport )
    Local oSection  As Object

    oSection := oReport:Section(1)

    // -------------------------------------------------
    // Monta query com JOIN SA1 x SC5 x SC6
    // Retorna apenas clientes com pelo menos 1 venda
    // -------------------------------------------------
BeginSQL Alias "QRYRELCLI"
        SELECT
            SA1.A1_COD,
            SA1.A1_LOJA, 
            SA1.A1_NOME,
            SA1.A1_NREDUZ,
            SA1.A1_END,
            SA1.A1_MUN,
            SA1.A1_EST,
            SA1.A1_TIPO,
            SUM(SC6.C6_VALOR) AS VLRTOTAL
        FROM
            %Table:SA1% SA1
            INNER JOIN %Table:SC5% SC5
                ON  SC5.C5_CLIENTE = SA1.A1_COD
                AND SC5.C5_LOJACLI    = SA1.A1_LOJA
                AND SC5.%NotDel%
            INNER JOIN %Table:SC6% SC6
                ON  SC6.C6_NUM     = SC5.C5_NUM
                AND SC6.C6_FILIAL  = SC5.C5_FILIAL
                AND SC6.%NotDel%
        WHERE
            SA1.A1_FILIAL  = %xFilial:SA1%
            AND SC5.C5_FILIAL = %xFilial:SC5%
            AND SC6.C6_FILIAL = %xFilial:SC6%
            AND SA1.A1_MSBLQL <> '1'
            AND SA1.%NotDel%
        GROUP BY
            SA1.A1_COD,
            SA1.A1_LOJA,
            SA1.A1_NOME,
            SA1.A1_NREDUZ,
            SA1.A1_END,
            SA1.A1_MUN,
            SA1.A1_EST,
            SA1.A1_TIPO
        HAVING
            SUM(SC6.C6_VALOR) > 0
        ORDER BY
            SA1.A1_NOME
    EndSQL

    // Percorre os registros e imprime cada detalhe
    oSection:Init()

    QRYRELCLI->( DbGoTop() )

    While QRYRELCLI->( !Eof() )
        oSection:Cell("A1_COD"   ):SetValue( QRYRELCLI->A1_COD    )
        oSection:Cell("A1_NOME"  ):SetValue( QRYRELCLI->A1_NOME   )
        oSection:Cell("A1_NREDUZ"   ):SetValue( QRYRELCLI->A1_NREDUZ    )
        oSection:Cell("A1_END"   ):SetValue( QRYRELCLI->A1_END    )
        oSection:Cell("A1_MUN"   ):SetValue( QRYRELCLI->A1_MUN    )
        oSection:Cell("A1_EST"   ):SetValue( QRYRELCLI->A1_EST    )
        oSection:Cell("A1_TIPO"   ):SetValue( QRYRELCLI->A1_TIPO    )
        oSection:Cell("VLRTOTAL" ):SetValue( QRYRELCLI->VLRTOTAL  )

        oSection:PrintLine()

        QRYRELCLI->( DbSkip() )
    EndDo

    oSection:Finish()

    QRYRELCLI->( DbCloseArea() ) // Fecha a query

Return
