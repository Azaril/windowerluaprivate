require("utility")
require("gameutility")

--
-- Follow behavior class.
--
class 'FollowBehavior' (Behavior)

function FollowBehavior:__init(TargetDistance, IdleTimeout)

    Behavior.__init(self)
    
    self.TargetDistance = TargetDistance;
        
    self.Navigator = Navigator();
    self.IdleTimer = CTimer();
    self.IdleTimerConnection = self.IdleTimer:GetOnTick():Connect(self.OnIdleTimerTick, self);
    self.IsIdleTimerActive = false;
    self.IdleState = false;
    
    if(IdleTimeout ~= nil) then
        self.IdleTimeout = IdleTimeout;
    else
        self.IdleTimeout = 3000;
    end
	
end

function FollowBehavior:__finalize()

    self.Navigator:Stop();
    
end

function FollowBehavior:Accept(GlobalContext, GroupContext)

    local Target = FindTargetInContext(GroupContext);

    -- Check the target can be found.
    if(Target == nil) then
    
        return false;
        
    end
    
    local DistanceToTarget = GetDistanceToMob(Target);
    
    -- Check if the target is already within range.
    if(DistanceToTarget < self.TargetDistance) then
    
        return false;
        
    end
    
    return true;

end

function FollowBehavior:Activate(GlobalContext, GroupContext)

    Behavior.Activate(self);
    
    local Target = FindTargetInContext(GroupContext);
    
    -- Check the target can be found.
    if(Target == nil) then
        
        return;
        
    end    
    
    self.IdleState = false;

    self.Navigator:FollowMob(Target);
    
    self.Navigator:Start();
    
end

function FollowBehavior:Deactivate(GlobalContext, GroupContext)

    Behavior.Deactivate(self);
    
    self.Navigator:Stop();
    
    self:StopIdleTimer();

end

function FollowBehavior:Tick(GlobalContext, GroupContext)

    local DistanceToTarget = self.Navigator:GetDistanceToTarget();
    
    -- Check if the target is within range.
    if(DistanceToTarget < self.TargetDistance) then
    
        self.Navigator:Stop();
    
        self:StartIdleTimer();
        
    else
    
        self.Navigator:Start();
        
        self:StopIdleTimer();
    
    end
    
    return self.IdleState;

end

function FollowBehavior:StartIdleTimer()

    if(self.IsIdleTimerActive == false) then
        self.IsIdleTimerActive = true;
        self.IdleTimer:Start(self.IdleTimeout);
    end

end

function FollowBehavior:StopIdleTimer()

    if(self.IsIdleTimerActive == true) then
        self.IsIdleTimerActive = false;
        self.IdleTimer:Stop();
    end

end

function FollowBehavior:OnIdleTimerTick()

    self:StopIdleTimer();
    self.IdleState = true;

end