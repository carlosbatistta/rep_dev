#INCLUDE "rwmake.ch"

User Function GDPARSZX

    Local cVldAlt := ".T."
    Local cVldExc := ".T."

    Private cString := "SZX"
    dbSelectArea("SZX")
    dbSetOrder(1)

    AxCadastro(cString," PARAMETROS DA CONSOLIDAÇÃO DA CARGA - GDPARSZX",cVldExc,cVldAlt)

Return
