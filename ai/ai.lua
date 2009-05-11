require("utility")
require("gameutility")

--dofile("ai\\aiutility.lua");
CFFXiHook.Instance():GetConsole():RunScriptFile(GetScriptFilePath("ai\\aiutility.lua"));

--dofile("ai\\behavior.lua");
CFFXiHook.Instance():GetConsole():RunScriptFile(GetScriptFilePath("ai\\behavior.lua"));
--dofile("ai\\decider.lua");
CFFXiHook.Instance():GetConsole():RunScriptFile(GetScriptFilePath("ai\\decider.lua"));

--dofile("ai\\actionbehavior.lua");
CFFXiHook.Instance():GetConsole():RunScriptFile(GetScriptFilePath("ai\\actionbehavior.lua"));
--dofile("ai\\followbehavior.lua");
CFFXiHook.Instance():GetConsole():RunScriptFile(GetScriptFilePath("ai\\followbehavior.lua"));
--dofile("ai\\healbehavior.lua");
CFFXiHook.Instance():GetConsole():RunScriptFile(GetScriptFilePath("ai\\healbehavior.lua"));
--dofile("ai\\findtargetbehavior.lua");
CFFXiHook.Instance():GetConsole():RunScriptFile(GetScriptFilePath("ai\\findtargetbehavior.lua"));
--dofile("ai\\attackbehavior.lua");
CFFXiHook.Instance():GetConsole():RunScriptFile(GetScriptFilePath("ai\\attackbehavior.lua"));

--dofile("ai\\rootdecider.lua");
CFFXiHook.Instance():GetConsole():RunScriptFile(GetScriptFilePath("ai\\rootdecider.lua"));
--dofile("ai\\prioritylistdecider.lua");
CFFXiHook.Instance():GetConsole():RunScriptFile(GetScriptFilePath("ai\\prioritylistdecider.lua"));
--dofile("ai\\sequentiallistdecider.lua");
CFFXiHook.Instance():GetConsole():RunScriptFile(GetScriptFilePath("ai\\sequentiallistdecider.lua"));
--dofile("ai\\booleandecider.lua");
CFFXiHook.Instance():GetConsole():RunScriptFile(GetScriptFilePath("ai\\booleandecider.lua"));


--TODO: Add a command handler.
--if(Command:lower() == "rgpl") then
    --CFFXiHook.Instance():GetConsole():RunScriptFile(GetScriptFilePath("navigation.lua"));
	--CFFXiHook.Instance():GetConsole():RunScriptFile(GetScriptFilePath("ai\\ai.lua"));
    --CreatePLBot();		
	--return true;
--elseif(Command:lower() == "rgmnk") then
    --CFFXiHook.Instance():GetConsole():RunScriptFile(GetScriptFilePath("navigation.lua"));
	--CFFXiHook.Instance():GetConsole():RunScriptFile(GetScriptFilePath("ai\\ai.lua"));
    --CreateMonkBot();		
	--return true;		
--elseif(Command:lower() == "rung") then
	--if(CurrentRootDecider ~= nil) then
		--CurrentRootDecider:Activate();
	--end
	--return true;
--elseif(Command:lower() == "stopg") then
	--if(CurrentRootDecider ~= nil) then
		--CurrentRootDecider:Deactivate();
	--end
	--return true;
--end

--
-- Test Code
--

if(CurrentRootDecider ~= nil) then
	CurrentRootDecider:Deactivate();
	CurrentRootDecider = nil;
end

--
-- Creates a behavior that can run a white mage PL player.
--
function CreatePLBot()

CurrentRootDecider = RootDecider(
--
-- Root list of behaviors to execute in priority order.
--
PriorityListDecider(
{
    --
    -- Behavior for curing
    --
    SequentialListDecider(
    {
        --
        -- Find target with HPP < 50%
        --
        FindTargetBehavior(
            FindTargetWithConditionFunc(
                FindPlayerFunc("Azaril"),
                ConditionCombinerAndFunc(
                {
                    IsMobAlive,
                    HPPLessThan(50)
                })
            )
        ),
        
        --
        -- Ensure target is in range.
        --
        FollowBehavior(
            -- Move within 20 units.
            20.0,
            -- Only wait for 0.5 sec idle.
            500
        ),
        
        --
        -- Cast cure on the target.
        --
        ActionBehavior(
            CastSpellFunc('"Cure II"', 4000, 6000)
        )
    },
    --
    -- Flag which behaviors are optional. 
    --
    {
        false,
        --
        -- Moving within range is optional as the target
        -- may already be within range.
        --
        true,
        false
    }), 
    
    --
    -- Behavior for curing
    --
    SequentialListDecider(
    {
        --
        -- Find target with HPP < 70%
        --
        FindTargetBehavior(
            FindTargetWithConditionFunc(
                FindPlayerFunc("Azaril"),
                ConditionCombinerAndFunc(
                {
                    IsMobAlive,
                    HPPLessThan(70)
                })
            )
        ),
        
        --
        -- Ensure target is in range.
        --
        FollowBehavior(
            -- Move within 20 units.
            20.0,
            -- Only wait for 0.5 sec idle.
            500
        ),
        
        --
        -- Cast cure on the target.
        --
        ActionBehavior(
            CastSpellFunc('"Cure"', 4000)
        )
    },
    --
    -- Flag which behaviors are optional. 
    --
    {
        false,
        --
        -- Moving within range is optional as the target
        -- may already be within range.
        --
        true,
        false
    }),
    
    --
    -- Behavior for raising
    --
    SequentialListDecider(
    {
        --
        -- Find target that is dead.
        --
        FindTargetBehavior(
            FindTargetWithConditionFunc(
                FindPlayerFunc("Azaril"),
                IsMobDead
            )
        ),
        
        --
        -- Ensure target is in range.
        --
        FollowBehavior(
            -- Move within 20 units.
            20.0,
            -- Only wait for 0.5 sec idle.
            500
        ),
        
        --
        -- Cast Raise II on the target.
        --
        ActionBehavior(
            CastSpellFunc('"Raise II"', 14000, 60000)
        )
    },
    --
    -- Flag which behaviors are optional. 
    --
    {
        false,
        --
        -- Moving within range is optional as the target
        -- may already be within range.
        --
        true,
        false
    }),
    
    --
    -- Ensure that the leader stays in range.
    --
    SequentialListDecider(
    {
        --
        -- Find the leader character.
        --
        FindTargetBehavior(
            FindTargetWithConditionFunc(
                FindPlayerFunc("Azaril"),
                DistanceGreaterThan(3)
            )
        ),
        
        --
        -- Follow the character.
        --
        FollowBehavior(
            2.0)
    }),
    
    --
    -- Out of combat actions.
    --
    BooleanDecider(
        IsOutOfCombat,
        true,
        PriorityListDecider(
        {
            --
            -- Behavior for curing
            --
            SequentialListDecider(
            {
                --
                -- Find target with HPP < 100% and out of combat.
                --
                FindTargetBehavior(
                    FindTargetWithConditionFunc(
                        FindPlayerFunc("Azaril"),
                        ConditionCombinerAndFunc(
                        {
                            IsMobAlive,
                            HPPLessThan(100),
                            IsMobOutOfCombat
                        })
                    )
                ),
                
                --
                -- Ensure target is in range.
                --
                FollowBehavior(
                    -- Move within 20 units.
                    20.0,
                    -- Only wait for 0.5 sec idle.
                    500
                ),
                
                --
                -- Cast cure on the target.
                --
                ActionBehavior(
                    CastSpellFunc('"Cure"', 4000)
                )
            },
            --
            -- Flag which behaviors are optional. 
            --
            {
                false,
                --
                -- Moving within range is optional as the target
                -- may already be within range.
                --
                true,
                false
            })
        })
    )
})
);
                                
end


--
-- Creates a behavior that can run a monk player.
--
function CreateMonkBot()

CurrentRootDecider = RootDecider(
--
-- Root list of behaviors to execute in priority order.
--
PriorityListDecider(
{
    --
    -- Pre-combat actions.
    --
    --BooleanDecider(
        --IsPlayerOutOfCombat,
        --true,
        --PriorityListDecider(
        --{
            --HealBehavior(
            --)
        --})
    --),
        
    
    --
    -- Find and acquire target.
    --
    BooleanDecider(
        IsPlayerOutOfCombat,
        false,
        SequentialListDecider(
        {
            --
            -- Find the closest target that's alive with HPP == 100%.
            --
            FindTargetBehavior(
                FindTargetWithConditionFunc(
                    FindNonplayersWithinRangeOfPlayerFunc(100),
                    ConditionCombinerAndFunc(
                    {
                        IsMobSpawned,
                        IsMobAttackable,
                        IsMobAlive,
                        HPPEquals(100)
                    })
                )
            ),
            
            BooleanDecider(
                IsTargetValid,
                true,
                PriorityListDecider(
                {
                    --
                    -- Ensure target is in range.
                    --
                    FollowBehavior(
                        -- Move within 1.5 units.
                        1.5,
                        -- Only wait for 0 sec idle.
                        0
                    ),
                    
                    --
                    -- Use combo on the target.
                    --
                    BooleanDecider(
                        ConditionCombinerAndFunc(
                        {
                            IsPlayerInCombat,
                            IsPlayerTPPGreaterThan(100)
                        }),
                        false,
                        ActionBehavior(
                            UseWeaponSkillFunc('"Combo"', 2000)
                        )
                    ),
                    
                    --
                    -- Initiate attacking.
                    --
                    AttackBehavior(
                    )
                })
            )
        })
    )
})
);

end                                                         