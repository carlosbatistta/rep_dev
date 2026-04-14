//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//Variáveis Estáticas
Static cTitulo := "Ocorrências"

/*/{Protheus.doc} zOCORR
Função para cadastro de Ocorrências
@author Carlos Batista
@since 25/09/2025
@version 1.0
	@return Nil, Função não tem retorno
	@example
	u_zOCORR()
/*/

User Function zOCORR()
	Local aArea   := GetArea()
	Local oBrowse
	
	//Instânciando FWMBrowse - Somente com dicionário de dados
	oBrowse := FWMBrowse():New()
	
	//Setando a tabela de cadastro de ocorrências (Cabeçalho)
	oBrowse:SetAlias("NB0")

	//Setando a descrição da rotina
	oBrowse:SetDescription(cTitulo)
	
	//Ativa a Browse
	oBrowse:Activate()
	
	RestArea(aArea)
Return Nil

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Carlos Batista                                               |
 | Data:  25/09/2025                                                   |
 | Desc:  Criação do menu MVC                                          |
 *---------------------------------------------------------------------*/

Static Function MenuDef()
	Local aRot := {}
	
	//Adicionando opções
	ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.zOCORR' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.zOCORR' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.zOCORR' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.zOCORR' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5

Return aRot

/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Carlos Batista                                              |
 | Data:  25/09/2025                                                  |
 | Desc:  Criação do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/

Static Function ModelDef()
	Local oModel 		:= Nil
	Local oStPai 		:= FWFormStruct(1, 'NB0') //zz2
	Local oStFilho 	    := FWFormStruct(1, 'NB1') //zz3
	Local aZZ3Rel		:= {}
	
	//Definições dos campos
	oStPai:SetProperty('NB0_COD',    MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'u_zIniNB0()'))       //Ini Padrão
	//oStFilho:SetProperty('NB1_OCORR', MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'u_zIniMus()'))                         //Ini Padrão
	
	//Criando o modelo e os relacionamentos
	oModel := MPFormModel():New('zOCORRM')
	oModel:AddFields('NB0MASTER',/*cOwner*/,oStPai)
	oModel:AddGrid('NB1DETAIL','NB0MASTER',oStFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	
	//Fazendo o relacionamento entre o Pai e Filho
	aAdd(aZZ3Rel, {'NB1_FILIAL','NB0_FILIAL'} )
	aAdd(aZZ3Rel, {'NB1_OCORR',	'NB0_COD'})
	aAdd(aZZ3Rel, {'NB1_NFE','NB0_NFE'}) 
	
	oModel:SetRelation('NB1DETAIL', aZZ3Rel, NB1->(IndexKey(1))) //IndexKey -> quero a ordenação e depois filtrado
	oModel:GetModel('NB1DETAIL'):SetUniqueLine({"NB1_PRODUT"})	//Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
	oModel:SetPrimaryKey({})
	
	//Setando as descrições
	oModel:SetDescription("Ocorrências")
	oModel:GetModel('NB0MASTER'):SetDescription('Cabeçalho')
	oModel:GetModel('NB1DETAIL'):SetDescription('Item')
Return oModel

/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Carlos Batista                                               |
 | Data:  25/09/2025                                                   |
 | Desc:  Criação da visão MVC                                         |
 *---------------------------------------------------------------------*/

Static Function ViewDef()
	Local oView		:= Nil
	Local oModel		:= FWLoadModel('zOCORR')
	Local oStPai		:= FWFormStruct(2, 'NB0')
	Local oStFilho	:= FWFormStruct(2, 'NB1')
	
	//Criando a View
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	//Adicionando os campos do cabeçalho e o grid dos filhos
	oView:AddField('VIEW_NB0',oStPai,'NB0MASTER')
	oView:AddGrid('VIEW_NB1',oStFilho,'NB1DETAIL')
	
	//Setando o dimensionamento de tamanho
	oView:CreateHorizontalBox('CABEC',35)
	oView:CreateHorizontalBox('GRID',65)
	
	//Amarrando a view com as box
	oView:SetOwnerView('VIEW_NB0','CABEC')
	oView:SetOwnerView('VIEW_NB1','GRID')
	
	//Habilitando título
	oView:EnableTitleView('VIEW_NB0','Cabeçalho - Ocorrência')
	oView:EnableTitleView('VIEW_NB1','Grid - Itens')
	
	//Força o fechamento da janela na confirmação
	oView:SetCloseOnOk({||.T.})
	
	//Remove os campos de NFE
	oStFilho:RemoveField('NB1_NFE')
	oStFilho:RemoveField('NB1_OCORR')
//	oStFilho:RemoveField('ZZ3_CODCD')
Return oView

/*/{Protheus.doc} zIniMus
Função que inicia o código sequencial da grid
@type function
@author Carlos Batista
@since 25/09/2025
@version 1.0
/*/

User Function zIniMus()
	Local aArea := GetArea()
	Local cCod  := StrTran(Space(TamSX3('NB1_OCORR')[1]), ' ', '0')
	Local oModelPad  := FWModelActive()
	Local oModelGrid := oModelPad:GetModel('NB1DETAIL')
	Local nOperacao  := oModelPad:nOperation
	Local nLinAtu    := oModelGrid:nLine
	Local nPosCod    := aScan(oModelGrid:aHeader, {|x| AllTrim(x[2]) == AllTrim("NB1_OCORR")})
	
	//Se for a primeira linha
	If nLinAtu < 1
		cCod := Soma1(cCod)
	
	//Senão, pega o valor da última linha
	Else
		cCod := oModelGrid:aCols[nLinAtu][nPosCod]
		cCod := Soma1(cCod)
	EndIf
	
	RestArea(aArea)
Return cCod

User Function zIniNB0()
    Local cCod := AllTrim(GetSXENum("NB0"))
Return PadL(cCod)



/*
User Function zIniNB0()
	Local aArea := GetArea()
	Local cCod  := StrTran(Space(TamSX3('NB0_COD')[1]), ' ', '0')
	Local oModelPad  := FWModelActive()
	Local oModelGrid := oModelPad:GetModel('NB0MASTER')
	Local nOperacao  := oModelPad:nOperation
	Local nLinAtu    := oModelGrid:nLine
	Local nPosCod    := aScan(oModelGrid:aHeader, {|x| AllTrim(x[2]) == AllTrim("NB0_COD")})
	
	//Se for a primeira linha
	If nLinAtu < 1
		cCod := Soma1(cCod)
	
	//Senão, pega o valor da última linha
	Else
		cCod := oModelGrid:aCols[nLinAtu][nPosCod]
		cCod := Soma1(cCod)
	EndIf
	
	RestArea(aArea)
Return cCod
*/
