require("utility")
require("gameutility")

--
-- Attack behavior class.
--
class 'AttackBehavior' (Behavior)

function AttackBehavior:__init(StopOnDeactivate)

    Behavior.__init(self)
    
    self.StopOnDeactivate = (StopOnDeactivate ~= nil and StopOnDeactivate == true);
	
end

function AttackBehavior:__finalize()

end

function AttackBehavior:Accept(GlobalContext, GroupContext)

    local Target = FindTargetInContext(GroupContext);
    
    -- Check the player can be found.
    if(Target == nil or not IsMobValid(Target) or IsMobDead(Target) == true ) then
    
        return false;
        
    end
    
    return true;

end

function AttackBehavior:Activate(GlobalContext, GroupContext)

    local Target = FindTargetInContext(GroupContext);
    
    SendInput("/target " .. Target:GetCharacterID());
    SendInput("/attack on");
    
end

function AttackBehavior:Deactivate(GlobalContext, GroupContext)

    if(self.StopOnDeactivate) then
        SendInput("/attack off");
    end

end

function AttackBehavior:Tick(GlobalContext, GroupContext)

    local Target = FindTargetInContext(GroupContext);
    
    -- Check the player can be found.
    if(Target == nil) then
    
        return true;
        
    end
    
    if(not IsMobValid(Target) or IsMobDead(Target) == true) then
    
        return true;
    
    end

    return false;

end