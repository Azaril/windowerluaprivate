require("utility")
require("gameutility")

--
-- Boolean decider
--

class 'BooleanDecider' (Decider)

function BooleanDecider:__init(Test, CheckOnTick, Child)

    Decider.__init(self);

    self.Test = Test;
    self.CheckOnTick = (CheckOnTick ~= nil and CheckOnTick == true);
    self.Child = Child;

end

function BooleanDecider:SetChild(Child)

    self.Child = Child;

end

function BooleanDecider:Accept(GlobalContext, GroupContext)

    if(self.Test ~= nil and self.Test(GlobalContext, GroupContext)) then
    
        return Decider.Accept(self, GlobalContext, GroupContext);
    
    end

    return false;
    
end

function BooleanDecider:GetChildToBeActive(GlobalContext, GroupContext)

    if(self.Child ~= nil and (self.Child.IsActive == true or self.Child:Accept(GlobalContext, self.GroupContext) == true)) then
    
        return self.Child;
    
    end
    
    return nil;
    
end

function BooleanDecider:Tick(GlobalContext, GroupContext)

    if(self.CheckOnTick == true) then
    
        if(self.Test(GlobalContext, GroupContext) == false) then
        
            return true;
        
        end
    
    end
    
    return Decider.Tick(self, GlobalContext, GroupContext);

end