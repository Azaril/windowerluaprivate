require("utility")
require("gameutility")

-- 
-- Decider base class
--
class 'Decider' (Behavior)

function Decider:__init()

    Behavior.__init(self);
    
    self.ActiveChild = nil;

end

function Decider:Accept(GlobalContext, GroupContext)

    self.GroupContext = { };
    self.GroupContext.ParentContext = GroupContext;

    -- Get the next child to activate.
    local NewChildToBeActive = self:GetChildToBeActive(GlobalContext, GroupContext);

    if(NewChildToBeActive ~= nil) then
    
        -- Set the new active child.
        self:SetActiveChild(NewChildToBeActive, GlobalContext, GroupContext);
        
        return true;
        
    end
    
    return false;

end

function Decider:Activate(GlobalContext, GroupContext)

    Behavior.Activate(self, GlobalContext, GroupContext);

    if(self.ActiveChild ~= nil) then
    
        self.ActiveChild:Activate(GlobalContext, self.GroupContext);
    
    end

end

function Decider:Deactivate(GlobalContext, GroupContext)

    Behavior.Deactivate(self, GlobalContext, GroupContext);
    
    self:SetActiveChild(nil);
    
end

function Decider:ChildComplete(Child)

end

function Decider:Tick(GlobalContext, GroupContext)

    -- Find the child that should be active
    local ChildToBeActive = self:GetChildToBeActive(GlobalContext, GroupContext);
    
    -- Activate the child (no-op if it's already active)
    self:SetActiveChild(ChildToBeActive, GlobalContext, GroupContext);
    
    -- Check if a child was set.
    if(self.ActiveChild ~= nil) then
    
        -- Child is complete
        if(self.ActiveChild:Tick(GlobalContext, self.GroupContext) == true) then
        
            self:ChildComplete(self.ActiveChild);
        
            -- Clear the active child.
            self:SetActiveChild(nil);
            
            -- Get the next child to activate.
            local NewChildToBeActive = self:GetChildToBeActive(GlobalContext, GroupContext);
            
            -- Set the new active child.
            self:SetActiveChild(NewChildToBeActive, GlobalContext, GroupContext);
            
            --NOTE: Don't tick the new child yet.
        
        end    
    
    end

    return (self.ActiveChild == nil);

end

function Decider:GetChildToBeActive(GlobalContext, GroupContext)

    return nil;
    
end

function Decider:SetActiveChild(Child, GlobalContext, GroupContext)

    --NOTE: Use raw equal to compare if these are the same object as luabind
    -- does not like comparing classes sometimes.
    if(rawequal(self.ActiveChild, Child)) then
    
        return;
        
    end

    if(self.ActiveChild ~= nil) then
    
        self.ActiveChild:Deactivate(GlobalContext, self.GroupContext);
    
    end

    self.ActiveChild = Child;
    
    if(self.ActiveChild ~= nil) then
        
        if(self.IsActive == true) then
        
            self.ActiveChild:Activate(GlobalContext, self.GroupContext);
        
        end
        
    end

end