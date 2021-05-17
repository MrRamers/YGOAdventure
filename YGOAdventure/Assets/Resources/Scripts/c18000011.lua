local s,id=GetID()
local lv =0
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

	--Tunners
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_NONTUNER)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetValue(TYPE_TUNER)
	c:RegisterEffect(e2)
	--NonTunners
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_NONTUNER)
	e3:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e3)
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