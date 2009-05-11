require("utility")
require("gameutility")

--
-- Heal behavior class.
--
class 'HealBehavior' (Behavior)

function HealBehavior:__init()

    Behavior.__init(self)
	
end

function HealBehavior:__finalize()

end

function HealBehavior:Accept(GlobalContext, GroupContext)

    local Player = GetPlayer();
    
    -- Check the player can be found.
    if(Player == nil) then
    
        return false;
        
    end
    
    -- Check if healing is needed.
    if(self:IsFullyHealed()) then
    
        return false;
    
    end
        
    return true;

end

function HealBehavior:IsFullyHealed()

    local Player = GetPlayer();
    
    return (Player:GetHitPoints() == Player:GetHitPointMax() and Player:GetMagicPoints() == Player:GetMagicPointMax());

end

function HealBehavior:Activate(GlobalContext, GroupContext)

    Log("Activating healing!");

    SendInput("/heal on");
    SendInput("/heal on");
    SendInput("/heal on");
    
end

function HealBehavior:Deactivate(GlobalContext, GroupContext)

    Log("Deactivating healing!");

    SendInput("/heal off");

end

function HealBehavior:Tick(GlobalContext, GroupContext)

    local Player = GetPlayer();
    
    -- Check the player can be found.
    if(Player == nil) then
    
        return true;
        
    end

    if(self:IsFullyHealed()) then
    
        return true;
    
    end

    return false;

end