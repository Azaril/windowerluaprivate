require("utility")
require("gameutility")

--
-- Sequential list decider
--

class 'SequentialListDecider' (Decider)

function SequentialListDecider:__init(Children, Optional)

    Decider.__init(self);

    self.Children = { };

    if(type(Children) == "table") then
    
        for i = 1, #Children do
        
            local OptionalChild = false;
            
            if(type(Optional) == "table") then
            
                OptionalChild = (Optional[i] ~= nil and Optional[i] == true);
            
            end
        
            self:AddChild(Children[i], OptionalChild);
        
        end
        
    
    else
    
        local OptionalChild = (Optional ~= nil and Optional == true);
    
        self:AddChild(Children, OptionalChild);
    
    end
    
    self.CurrentChildIndex = 1;

end

function SequentialListDecider:Deactivate(GlobalContext, GroupContext)

    Decider.Deactivate(self, GlobalContext, GroupContext);
    
    self.CurrentChildIndex = 1;
    
end

function SequentialListDecider:AddChild(ChildToAdd, OptionalChild)

    table.insert(self.Children, { Child = ChildToAdd, Optional = OptionalChild } );

end

function SequentialListDecider:ChildComplete(Child)

    Decider.ChildComplete(self, Child);

    self.CurrentChildIndex = self.CurrentChildIndex + 1;

end

function SequentialListDecider:GetChildToBeActive(GlobalContext, GroupContext)

    while(self.CurrentChildIndex <= #self.Children) do
    
        local CurrentChild = self.Children[self.CurrentChildIndex].Child;
        
        if(CurrentChild.IsActive == true or CurrentChild:Accept(GlobalContext, self.GroupContext) == true) then
        
            return CurrentChild;
        
        end
        
        if(self.Children[self.CurrentChildIndex].Optional == true) then
        
            self.CurrentChildIndex = self.CurrentChildIndex + 1;
        
        else
        
            break;
        
        end
    
    end
    
    --
    -- Reset the child index.
    --
    self.CurrentChildIndex = 1;
    
    return nil;
    
end