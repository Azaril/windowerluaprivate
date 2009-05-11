require("utility")
require("gameutility")

function FindNonplayersWithinRangeOfPlayerFunc(Range)

    return 
        function()
            return FindNonplayersWithinRangeOfPlayer(Range);
        end

end

--
-- Find a group of players from a list of names.
--
function FindPlayers(Names)

    local Players = { };

    for i = 1, #Names do
    
        local Player = FindPlayer(Names[i]);
        
        if(Player ~= nil) then
        
            table.insert(Players, Player);
        
        end
    
    end
    
    if(#Players == 0) then
    
        Players = nil;
        
    end
    
    return Players;

end

--
-- Returns a function that finds a specific player.
--
function FindPlayerFunc(Name)
    return 
        function() 
            -- Find the specified player.
            local Player = FindPlayer(Name);
            return Player;
        end
end

--
-- Returns a function that finds a specified set of players.
--
function FindPlayersFunc(Names)
    return 
        function() 
            -- Find the specified player.
            local Players = FindPlayers(Names);
            if(Players ~= nil and #Players > 0) then
                return Players;
            else
                return nil;
            end;
        end
end

--
-- Finds a target that matches a specified condition function.
--
function FindTargetWithCondition(FindFunc, ConditionFunc)

    -- Get all the targets that the find function matches.
    local Targets = FindFunc();
    
    -- Check some form of target was returned.
    if(Targets ~= nil) then
    
        -- Check if a table was returned.
        if(type(Targets) == "table") then
        
            -- Search the table for a matching target.
            for i = 1, #Targets do
            
                -- Cache the target.
                local TestTarget = Targets[i];
                
                -- Check if the target matches the condition.
                if(ConditionFunc == nil or ConditionFunc(TestTarget)) then
                
                    -- A target was found.
                    return TestTarget;
                    
                end
            
            end
            
        else
        
            -- Check if the target matches the condition.
            if(ConditionFunc == nil or ConditionFunc(Targets)) then
            
                -- A target was found.
                return Targets;
                
            end
            
        end
    
    end
    
    -- No matching target was found.
    return nil;

end

--
-- Returns a function that finds a target given a search function
-- and a condition function.
--
function FindTargetWithConditionFunc(FindFunc, ConditionFunc)

    return 
        function()
            -- Find a target with the specified condition.
            return FindTargetWithCondition(FindFunc, ConditionFunc);
        end

end

function ConditionCombinerAnd(Conditions, Arg1, Arg2, Arg3, Arg4)

    if(Conditions ~= nil) then
    
        if(type(Conditions) == "table") then
        
            for i = 1, #Conditions do
            
                if(Conditions[i](Arg1, Arg2, Arg3, Arg4) == false) then
                
                    return false;
                
                end
            
            end
        
        end
    
    end
    
    return true;

end

function ConditionCombinerAndFunc(Conditions)

    return
        function(Arg1, Arg2, Arg3, Arg4)
            return ConditionCombinerAnd(Conditions, Arg1, Arg2, Arg3, Arg4);
        end

end

--
-- Cast a spell with an optional target.
--
function CastSpell(Spell, Target)

    Log("Casting spell: " .. Spell);

    -- Check if a target was specified.
    if(Target == nil) then
    
        -- Cast the spell with no target specified.
        SendInput("/ma " .. Spell);
        
    else
    
        -- Cast the spell with the specified target.
        SendInput("/ma " .. Spell .. " " .. Target:GetName());
        
    end

end

--
-- Create a function that takes a target and casts a specific spell.
--
function CastSpellFunc(Spell, CastTime, RecastTime)

    -- TODO: Dynamically look up cast time and recast time for the spell.
    return
        function(Target)
            CastSpell(Spell, Target)
            return CastTime, RecastTime;
        end
end

--
-- Use an ability with an optional target.
--
function UseJobAbility(Ability, Target)

    Log("Using job ability: " .. Ability);

    -- Check if a target was specified.
    if(Target == nil) then
    
        -- Use the ability with no target specified.
        SendInput("/ja " .. Ability);
        
    else
    
        -- Use the ability with the specified target.
        SendInput("/ja " .. Ability .. " " .. Target:GetName());
        
    end

end

--
-- Create a function that takes a target and uses a specific job ability.
--
function UseJobAbilityFunc(Ability, CastTime, RecastTime)

    -- TODO: Dynamically look up cast time and recast time for the ability.
    return
        function(Target)
            UseJobAbility(Ability, Target)
            return CastTime, RecastTime;
        end
end

--
-- Use a weapon skill with an optional target.
--
function UseWeaponSkill(Skill, Target)

    Log("Using weapon skill: " .. Skill);

    -- Check if a target was specified.
    if(Target == nil) then
    
        -- Use the skill with no target specified.
        SendInput("/ja " .. Skill);
        
    else
    
        -- Use the skill with the specified target.
        SendInput("/ja " .. Skill .. " " .. Target:GetName());
        
    end

end

--
-- Create a function that takes a target and uses a specific weapon skill.
--
function UseWeaponSkillFunc(Skill, CastTime, RecastTime)

    -- TODO: Dynamically look up cast time and recast time for the skill.
    return
        function(Target)
            UseWeaponSkill(Skill, Target)
            return CastTime, RecastTime;
        end
end

--
-- Returns a function that returns true if the HP% is less than the
-- specified value.
--
function HPPLessThan(Val)

    return
        function(Target)
            -- Check if the HP% is less than the specified value.
            return (Target:GetHitPointPercentage() < Val); 
        end
    
end

--
-- Returns a function that returns true if the HP% is equal to the
-- specified value.
--
function HPPEquals(Val)

    return
        function(Target)
            -- Check if the HP% is equal to the specified value.
            return (Target:GetHitPointPercentage() == Val); 
        end
    
end

function IsPlayerTPPGreaterThan(Val)

    return
        function()
            local Player = GetPlayer();
            return (Player ~= nil and Player:GetTechniquePointPercentage() > Val);
        
        end

end

--
-- Returns a function that returns true if the distance from the player
-- to the target is greater than the specified value.
--
function DistanceGreaterThan(Val)

    return
        function(Mob)
            -- Check if the HP% is less than the specified value.
            return GetDistanceToMob(Mob) > Val; 
        end
    
end

function IsMobInCombat(Mob)

    return (Mob ~= nil and Mob:IsEngaged());

end

function IsMobOutOfCombat(Mob)

    return (Mob ~= nil and not Mob:IsEngaged());
    
end

function IsPlayerInCombat()

    local Player = GetPlayer();

    --TODO: Fix this as it doesn't appear to return the correct value.    
    return IsMobInCombat(Player);

end

function IsPlayerOutOfCombat()

    local Player = GetPlayer();
    
    --TODO: Fix this as it doesn't appear to return the correct value.        
    return IsMobOutOfCombat(Player);

end

function IsMobAlive(Mob)

    return (Mob ~= nil and not Mob:IsDead());

end

function IsMobDead(Mob)

    return (Mob ~= nil and Mob:IsDead());

end

function IsMobValid(Mob)

    return (Mob ~= nil and Mob:IsValid());

end

function IsMobInvalid(Mob)

    return (Mob ~= nil or not Mob:IsValid());

end

function IsMobAttackable(Mob)

    return (Mob ~= nil and Mob:IsAttackable());

end

function IsMobUnattackable(Mob)

    return (mob ~= nil and Mob:IsUnattackable());

end

function IsMobSpawned(Mob)

    return (Mob ~= nil and Mob:IsSpawned());

end

function IsMobDespawned(Mob)

    return (Mob ~= nil and Mob:IsDespawned());

end

function FindTargetInContext(Context)

    local CurrentContext = Context;
    
    while (CurrentContext ~= nil) do
    
        if(CurrentContext.Target ~= nil) then
        
            return CurrentContext.Target;
        
        end
        
        CurrentContext = CurrentContext.ParentContext;
    
    end
    
    return nil;

end

function IsTargetValid(GlobalContext, GroupContext)

    local Target = FindTargetInContext(GroupContext);
    
    return IsMobValid(Target);

end