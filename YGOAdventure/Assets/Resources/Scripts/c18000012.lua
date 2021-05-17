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
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
end
function s.filter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_XYZ) 
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc)  end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local xyzc=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
	Duel.SelectTarget(tp,s.atchfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	e:SetLabelObject(xyzc)
end
function s.atchfilter(c)
	return c
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	if #g<=1 then return end
	local xyzc,tgc=(function()
		local c1=g:GetFirst()
		local c2=g:GetNext()
		if c1==e:GetLabelObject() then return c1,c2 else return c2,c1 end
	end)()
	if xyzc:IsRelateToEffect(e) and tgc:IsRelateToEffect(e) and
	   not xyzc:IsImmuneToEffect(e) and not tgc:IsImmuneToEffect(e) then
		local og=tgc:GetOverlayGroup()
		if #og>0 then Duel.SendtoGrave(og,REASON_RULE) end
		Duel.Overlay(xyzc,tgc)
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