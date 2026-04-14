/*/
    PE: A010CUST
    Ajusta o custo apenas quando a TES = 101,
    e sempre usando o custo do armazÃ©m 11 (B2_LOCAL = '11').
/*/
User Function A103CUST()

    Local nCusto := 0           // custo padrÃ£o calculado pelo Protheus
    Local cTES   := ""          // TES do item
    Local cProd  := ""          // produto
    Local cFil   := "0101"
    Local cLocal := "11"        // armazém desejado

    nCusto := SD1->D1_CUSTO
    cTES   := AllTrim(SD1->D1_TES)  
    cProd  := AllTrim(SD1->D1_COD)

    FWAlertSuccess("Entrou na rotina A103CUST.prw para ajuste de custo do produto "+cProd+" Custo:"+nCusto+" TES:"+cTES)   


    // Regra: sÃ³ altera custo quando TES for 101
    If cTES == "101"

        FWAlertSuccess("Ajustando custo do produto "+cProd+" pela rotina A103CUST.prw")   
        
        // Abrindo SB2
        DbSelectArea("SB2")
        
        // inndice mais comum: B2_FILIAL + B2_LOCAL + B2_COD
        SB2->(DbSetOrder(2))

        If SB2->(DbSeek(cFil + cLocal + cProd))
            // Prioridade do custo utilizada no mercado
            If SB2->B2_CM1 > 0
                nCusto := SB2->B2_CM1     // custo médio do armazém 11
            Else
                FWAlertError("Produto "+cProd+" não encontrado", "Falha DbSeek")
            EndIf

        EndIf
    EndIf

Return nCusto
