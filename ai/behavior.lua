require("utility")
require("gameutility")

-- 
-- Behavior base class
--
class 'Behavior'

function Behavior:__init()

    self.IsActive = false;

end

function Behavior:Accept(GlobalContext, GroupContext)

    return false;

end

function Behavior:Activate(GlobalContext, GroupContext)

    self.IsActive = true;

end

function Behavior:Deactivate(GlobalContext, GroupContext)

    self.IsActive = false;

end

function Behavior:Tick(GlobalContext, GroupContext)

    return true;

end