require("utility")
require("gameutility")

--
-- Action behavior class.
--
class 'ActionBehavior' (Behavior)

function ActionBehavior:__init(ExecuteFunc)

    Behavior.__init(self)

	self.FindTargetFunc = FindTargetFunc;
	self.ExecuteFunc = ExecuteFunc;
	
	self.TimeoutState = true;	
	self.TimeoutTimer = CTimer();
	self.TimeoutTimerTickConnection = self.TimeoutTimer:GetOnTick():Connect(self.OnTimeoutTimerTick, self);
	
	self.RecastState = true;	
	self.RecastTimer = CTimer();
	self.RecastTimerTickConnection = self.RecastTimer:GetOnTick():Connect(self.OnRecastTimerTick, self);
	
end

function ActionBehavior:__finalize()

    self.TimeoutTimer:Stop();
    self.RecastTimer:Stop();

end

function ActionBehavior:Accept(GlobalContext, GroupContext)

    -- Validate that the required function exists.
	if(self.ExecuteFunc == nil) then
	
	    -- Abort executing this behavior.
	    return false;
	    
	end
	
	-- Validate that the action is in a reset state.
	if(self.TimeoutState == false or self.RecastState == false) then
	
	    return false;
	    
	end
	
	-- Validate that a target has been selected.
	if(FindTargetInContext(GroupContext) == nil) then
	
	    return false;
	
	end
	
	return true;
end

function ActionBehavior:Activate(GlobalContext, GroupContext)

    Behavior.Activate(self);
    
    local Target = FindTargetInContext(GroupContext);

	--
	-- The executing function will return the time it takes
	-- for the action to complete and the time before the
	-- action can be used again.
	--
	local Timeout = nil;
	local Recast = nil;
	
	-- Execute the action.
    Timeout, Recast = self.ExecuteFunc(Target);
    
    -- Check if there is a timeout for this action.
    if(Timeout ~= nil and Timeout > 0) then
    
        -- Flag that the timeout has been set.
	    self.TimeoutState = false;
	
	    -- Start the timeout timer.
	    self.TimeoutTimer:Start(Timeout);	
	    
	end
	
	-- Check if there is a recast for this action.
	if(Recast ~= nil and Recast > 0) then
	
	    -- Flag that the recast has been set.
	    self.RecastState = false;
	    
	    -- Start the recast timeout timer.
	    self.RecastTimer:Start(Recast);
	    
	end

end

function ActionBehavior:Deactivate(GlobalContext, GroupContext)

    Behavior.Deactivate(self);
    
    --TODO: Handle action cancellation.

end

function ActionBehavior:Tick(GlobalContext, GroupContext)

    -- Check if the action has completed.
	return (self.TimeoutState == true);

end

function ActionBehavior:OnTimeoutTimerTick()

	self.TimeoutTimer:Stop();
	self.TimeoutState = true;

end

function ActionBehavior:OnRecastTimerTick()

	self.RecastTimer:Stop();
	self.RecastState = true;

end