--洗牌连发
function c87241305.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,87241305+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c87241305.target)
	e1:SetOperation(c87241305.activate)
	c:RegisterEffect(e1)
end
function c87241305.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
end
function c87241305.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.ShuffleDeck(tp)
	if Duel.IsPlayerCanDraw(tp,1)
		and Duel.SelectYesNo(tp,aux.Stringid(87241305,0)) then
		Duel.BreakEffect()
		Duel.ShuffleDeck(tp)
	end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c87241305.tgcon)
	e1:SetOperation(c87241305.tgop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,87241305,RESET_PHASE+PHASE_END,0,1)
end
function c87241305.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerCanDraw(tp,1)
end
function c87241305.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ShuffleDeck(tp)
end
