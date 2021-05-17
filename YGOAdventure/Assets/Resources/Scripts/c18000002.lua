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

	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_ALL)
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)

	--LoseCondition
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_ALL)
	e3:SetCondition(s.Lcondition)
	e3:SetTarget(s.Ltarget)
	e3:SetOperation(s.Lactivate)
	c:RegisterEffect(e3)

	--cannot lose for draw
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_LOSE_DECK)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetTargetRange(1,0)
	e4:SetValue(1)
	c:RegisterEffect(e4)

	--cannot lose for dmg
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_LOSE_LP)
	e5:SetRange(LOCATION_REMOVED)
	e5:SetTargetRange(1,0)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end

function s.Lcondition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,e,tp) and ep==1-tp
end
function s.cfilter(c,e,tp)
	return c:IsCode(25833572)
end
function s.Ltarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,5000)
end
function s.Lactivate(e,tp,eg,ep,ev,re,r,rp)
--	Duel.Recover(tp,5000,REASON_EFFECT)
	Duel.Win(1-tp,WIN_REASON_DECK_MASTER)
end
-----
function s.condition(e,tp,eg,ev,ep,re,r,rp)
	return Duel.GetTurnCount()==1
end
function s.filter(c,e,tp)
	return c:IsCode(62340868) or c:IsCode(25955164) or c:IsCode(98434877) or c:IsCode(25833572)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_ALL,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_ALL,0,9,9,nil,e,tp)
	if #g>0 then
		Duel.SendtoDeck(g,1-tp,2,REASON_EFFECT)
	end
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