require("utility")
require("gameutility")

--
-- Root decider
--
class 'RootDecider' (Decider)

function RootDecider:__init(Child)

    Decider.__init(self);
    
    self.Timer = CTimer();
    self.OnTimerTickConnection = self.Timer:GetOnTick():Connect(self.OnTimerTick, self);
    
    self:SetChild(Child);

end

function RootDecider:GetChildToBeActive(GlobalContext, GroupContext)

    return self.Child;
    
end

function RootDecider:__finalize()

    self.Timer:Stop();

end

function RootDecider:Activate()

    self.GlobalContext = { };

    Decider.Activate(self, self.GlobalContext, nil);
    
    -- Tick the state tree with a resolution of 50ms.
    self.Timer:Start(50);
   
end

function RootDecider:Deactivate()

    self.Timer:Stop();
    
    Decider.Deactivate(self, self.GlobalContext, nil);

end

function RootDecider:OnTimerTick()

    self:Tick(self.GlobalContext, nil);

end

function RootDecider:SetChild(Child)

    self.Child = Child;

end