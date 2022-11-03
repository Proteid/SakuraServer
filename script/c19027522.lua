--耳语记录『绿望』
function c19027522.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c19027522.sptg)
	e1:SetOperation(c19027522.spop)
	c:RegisterEffect(e1)
	--to Extra Deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c19027522.tdcon)
	e2:SetTarget(c19027522.tdtg)
	e2:SetOperation(c19027522.tdop)
	c:RegisterEffect(e2)
end
function c19027522.spfilter(c,e,tp)
	if not c:IsSetCard(0x256) then return false end
	local sp=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if c:IsType(TYPE_MONSTER) then
		return c:IsAbleToHand() or sp and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	else return c:IsAbleToHand() end
end
function c19027522.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 end
end
function c19027522.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		if g:IsExists(c19027522.spfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(19027522,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,c19027522.spfilter,1,1,nil)
			local tc=sg:GetFirst()
			if tc:IsType(TYPE_MONSTER)
				and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
				and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			else
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
			end
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			g:Sub(sg)
		end
		Duel.SortDecktop(tp,tp,g:GetCount())
		for i=1,g:GetCount() do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
		end
	end
end
function c19027522.spfilter2(c,e,tp)
	return c:IsSetCard(0x256) and c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c19027522.tdfilter(c)
	return (c:IsType(TYPE_FUSION) or c:IsType(TYPE_XYZ) or c:IsType(TYPE_SYNCHRO))
	and c:IsSetCard(0x256) and c:IsLocation(LOCATION_GRAVE)
end
function c19027522.ffilter(c)
	return c:IsFaceup() and c:IsSetCard(0x256)
end
function c19027522.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c19027522.ffilter,tp,LOCATION_MZONE,0,1,nil)
end
function c19027522.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local chkf=PLAYER_NONE
	if chk==0 then return Duel.IsPlayerCanRemove(tp)
		and Duel.IsExistingMatchingCard(c19027522.tdfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,chkf,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c19027522.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c19027522.tdfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp,chkf,nil)
	local tc=g:GetFirst()
	Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c19027522.spfilter2),tp,LOCATION_GRAVE,0,nil,e,tp)
	if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(19027522,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=sg:Select(tp,1,1,nil)
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
