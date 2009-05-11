require("utility")
require("gameutility")

--
-- Find target behavior class.
--
class 'FindTargetBehavior' (Behavior)

function FindTargetBehavior:__init(FindTargetFunc)

    Behavior.__init(self)

	self.FindTargetFunc = FindTargetFunc;
	
end

function FindTargetBehavior:Accept(GlobalContext, GroupContext)

    -- Validate that the required function exists.
	if(self.FindTargetFunc == nil) then
	
	    -- Abort executing this behavior.
	    return false;
	    
	end

	local Target = self.FindTargetFunc();
    
	return (Target ~= nil);
	
end

function FindTargetBehavior:Activate(GlobalContext, GroupContext)

    Behavior.Activate(self);

	GroupContext.Target = self.FindTargetFunc(); 

end