--耳语记录『回忆』
function c13226163.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c13226163.sptg)
	e1:SetOperation(c13226163.spop)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c13226163.retcon)
	e2:SetTarget(c13226163.rettg)
	e2:SetOperation(c13226163.retop)
	c:RegisterEffect(e2)
end
function c13226163.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c13226163.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c13226163.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local res=Duel.IsExistingMatchingCard(c13226163.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c13226163.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c13226163.spop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c13226163.filter1,nil,e)
	local sg1=Duel.GetMatchingGroup(c13226163.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c13226163.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
function c13226163.cfilter(c,e,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) 
	and c:IsSetCard(0x256) and c:IsReason(REASON_COST)
end
function c13226163.spfilter(c,e,tp)
	return c:IsSetCard(0x256) and c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c13226163.retcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x256) and eg:IsExists(c13226163.cfilter,1,nil,tp,rp)
end
function c13226163.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c13226163.retop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c13226163.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
		if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(13226163,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=sg:Select(tp,1,1,nil)
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
end