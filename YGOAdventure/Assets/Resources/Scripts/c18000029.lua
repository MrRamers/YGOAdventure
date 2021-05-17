local s,id=GetID()
function s.initial_effect(c)
	--active and remove
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCountLimit(1)
	e1:SetCondition(s.aco)
	e1:SetOperation(s.aop)
	c:RegisterEffect(e1)

	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_ALL)
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
function s.condition(e,tp,eg,ev,ep,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Destroy(sg,REASON_EFFECT)
end
-------------------------------------------------------------------------------------------------
function s.aco(e,tp,eg,ev,ep,re,r,rp)
	return Duel.GetTurnCount()==1
end

function s.cond(e,tp,eg,ev,ep,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end


function s.aop(e,tp,eg,ev,ep,re,r,rp)
	--remove card
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,id)
	Duel.RegisterFlagEffect(0,id,0,0,0)
	local lol=LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_DECK
	Duel.DisableShuffleCheck()
	--Duel.c(c,tp,-2,REASON_RULE)
	Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	if c:GetPreviousLocation()==LOCATION_HAND then
		Duel.Draw(tp,1,REASON_RULE)
	end
end