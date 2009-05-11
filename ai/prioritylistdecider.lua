require("utility")
require("gameutility")

--
-- Priority list decider
--

class 'PriorityListDecider' (Decider)

function PriorityListDecider:__init(Children)

    Decider.__init(self);

    self.Children = { };

    if(type(Children) == "table") then
    
        for i = 1, #Children do
        
            self:AddChild(Children[i]);
        
        end
        
    
    else
    
        self:AddChild(Children);
    
    end

end

function PriorityListDecider:AddChild(Child)

    table.insert(self.Children, Child);

end

function PriorityListDecider:GetChildToBeActive(GlobalContext, GroupContext)

    for i = 1, #self.Children do
    
        local CurrentChild = self.Children[i];
        
        if(CurrentChild.IsActive == true or CurrentChild:Accept(GlobalContext, self.GroupContext) == true) then
        
            return CurrentChild;
        
        end
    
    end
    
    return nil;
    
end