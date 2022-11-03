--勾股求弦
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	e1:SetLabel(0)
	c:RegisterEffect(e1)
end
function cm.tgf3(c,e,tp,lv,lv2)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetLevel()^2==lv^2+lv2^2
end
function cm.tgf2(c,e,tp,tc)
	return c:IsFaceup() and c:IsLevelAbove(1) and Duel.IsExistingMatchingCard(cm.tgf3,tp,LOCATION_DECK,0,1,c,e,tp,c:GetLevel(),tc:GetLevel())
end
function cm.tgf1(c,e,tp)
	return c:IsFaceup() and c:IsLevelAbove(1) and Duel.IsExistingMatchingCard(cm.tgf2,tp,LOCATION_MZONE,0,1,c,e,tp,c)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.tgf1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgf1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectTarget(tp,cm.tgf1,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	local sc=Duel.SelectTarget(tp,cm.tgf2,tp,LOCATION_MZONE,0,1,1,tc,e,tp,tc):GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.tgf3,tp,LOCATION_DECK,0,1,1,nil,e,tp,g:GetFirst():GetLevel(),g:GetNext():GetLevel())
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
