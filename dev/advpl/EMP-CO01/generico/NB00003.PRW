//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//Variáveis Estáticas
Static cTitulo := "Cadastro de Ocorrências"

/*/{Protheus.doc} U_NB00003
Função para cadastro de Ocorrências (Modelo 3 - NB0, NB1 e NB2)
@Carlos Batista
@since 25/09/2025
@version 2.1
/*/

User Function U_NB00003()
	Local aArea   := GetArea()
	Local oBrowse
	
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("NB1")
	oBrowse:SetDescription(cTitulo)

	// Vincula o Browse ao menu MVC
	oBrowse:SetMenuDef("MENUDEF.NB00003")
	
	oBrowse:Activate()
	
	RestArea(aArea)
Return Nil


/*---------------------------------------------------------------------*
 | Func:  MENUDEF.NB00003                                              |
 *---------------------------------------------------------------------*/
User Function MENUDEF.NB00003()
	Local aRot := {}
	
	// DEBUG: confirmar que o MenuDef está sendo chamado
	FWAlert("Entrou no MENUDEF.NB00003")

	ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.NB00003' OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.NB00003' OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.NB00003' OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.NB00003' OPERATION MODEL_OPERATION_DELETE ACCESS 0

Return aRot


/*---------------------------------------------------------------------*
 | Func:  MODELDEF.NB00003                                             |
 *---------------------------------------------------------------------*/
User Function MODELDEF.NB00003()
	Local oModel 		:= Nil
	Local oStPai 		:= FWFormStruct(1, 'NB0')
	Local oStFilho 		:= FWFormStruct(1, 'NB1')
	Local aNBRel		:= {}
	
	//Propriedades NB0 (cabeçalho)
	oStPai:SetProperty('NB0_COD', MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN, '.F.'))
	oStPai:SetProperty('NB0_COD', MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, 'GetSXENum("NB0", "NB0_COD")'))
	oStPai:SetProperty('NB0_DATA', MODEL_FIELD_OBRIGAT, .F.)
	oStPai:SetProperty('NB0_OCORRE', MODEL_FIELD_OBRIGAT, .F.)

	//Propriedades NB1 (detalhe)
	oStFilho:SetProperty('NB1_PRODUT',  MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN, '.F.'))
	oStFilho:SetProperty('NB1_QTDO',    MODEL_FIELD_OBRIGAT, .F.)    
	oStFilho:SetProperty('NB1_MOTIVO',  MODEL_FIELD_OBRIGAT, .F.)
	oStFilho:SetProperty('NB1_CODIGO',  MODEL_FIELD_INIT,   FwBuildFeature(STRUCT_FEATURE_INIPAD, 'u_zIniMus()'))
	
	//Criando o modelo
	oModel := MPFormModel():New('NB00003')
	oModel:AddFields('NB0MASTER',,oStPai)
	oModel:AddGrid('NB1DETAIL','NB0MASTER',oStFilho)

	//Relacionamento Pai x Filho
	aAdd(aNBRel, {'NB0_FILIAL','NB1_FILIAL'})
	aAdd(aNBRel, {'NB0_COD','NB1_OCORR'})
	oModel:SetRelation('NB1DETAIL', aNBRel, NB1->(IndexKey(1)))

	//Chave primária do cabeçalho
	oModel:SetPrimaryKey({"NB0_FILIAL","NB0_COD"})

	//Controle de duplicidade no detalhe
	oModel:GetModel('NB1DETAIL'):SetUniqueLine({"NB1_CODIGO"})

	//Descrições
	oModel:SetDescription("Grupo de Ocorrências - Mod. 3")
	oModel:GetModel('NB0MASTER'):SetDescription('Cabeçalho')
	oModel:GetModel('NB1DETAIL'):SetDescription('Itens')

Return oModel


/*---------------------------------------------------------------------*
 | Func:  VIEWDEF.NB00003                                              |
 *---------------------------------------------------------------------*/
User Function VIEWDEF.NB00003()
	Local oView			:= Nil
	Local oModel		:= FWLoadModel('NB00003')
	Local oStPai		:= FWFormStruct(2, 'NB0')
	Local oStFilho		:= FWFormStruct(2, 'NB1')
	
	// DEBUG: confirmar que o ViewDef está sendo chamado
	FWAlert("Entrou no VIEWDEF.NB00003")

	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	oView:AddField('VIEW_NB0',oStPai,'NB0MASTER')
	oView:AddGrid('VIEW_NB1',oStFilho,'NB1DETAIL')
	
	oView:CreateHorizontalBox('CABEC',30)
	oView:CreateHorizontalBox('GRID',70)
	oView:SetOwnerView('VIEW_NB0','CABEC')
	oView:SetOwnerView('VIEW_NB1','GRID')
	
	oView:EnableTitleView('VIEW_NB0','Cabeçalho')
	oView:EnableTitleView('VIEW_NB1','Itens')
	oView:SetCloseOnOk({||.T.})
	
Return oView


/*/{Protheus.doc} zIniMus
Função que inicia o código sequencial da grid
/*/
User Function zIniMus()
	Local aArea := GetArea()
	Local cCod  := StrTran(Space(TamSX3('NB1_CODIGO')[1]), ' ', '0')
	Local oModelPad  := FWModelActive()
	Local oModelGrid := oModelPad:GetModel('NB1DETAIL')
	Local nLinAtu    := oModelGrid:nLine
	Local nPosCod    := aScan(oModelGrid:aHeader, {|x| AllTrim(x[2]) == AllTrim("NB1_CODIGO")})
	
	If nLinAtu < 1
		cCod := Soma1(cCod)
	Else
		cCod := oModelGrid:aCols[nLinAtu][nPosCod]
		cCod := Soma1(cCod)
	EndIf
	
	RestArea(aArea)
Return cCod
