require("utility")

NavigationTargetType_Point = 0;
NavigationTargetType_Mob = 1;

class 'Navigator'

function Navigator:__init()

    self.IsStarted = false;
    self.Target = nil;
    self.Timer = CTimer();
    self.TimerTickConnection = self.Timer:GetOnTick():Connect(self.Tick, self);
    self.TurnTimer = CTimer();
    self.TurnTimerTickConnection = self.TurnTimer:GetOnTick():Connect(self.OnTurnTimerTick, self);

end

function Navigator:__finalize()

    self:Stop();

end

function Navigator:GetCurrentPosition()

    local Player = GetPlayer();
    
    return { X = Player:GetXPosition(), Y = Player:GetYPosition(), Z = Player:GetZPosition(), Rotation = Player:GetRotation() };

end

function Navigator:GetTargetPosition()

    if(self.TargetType == NavigationTargetType_Point) then

        return self.Target;
        
    elseif(self.TargetType == NavigationTargetType_Mob) then
    
        return { X = self.Target:GetXPosition(), Y = self.Target:GetYPosition(), Z = self.Target:GetZPosition() };
    
    end    
    
    return nil;

end

function Navigator:SetTarget(TargetX, TargetY, TargetZ)

    self.Target = { X = TargetX, Y = TargetY, Z = TargetZ };
    self.TargetType = NavigationTargetType_Point;
    self.LastTargetPosition = self:GetTargetPosition();

end

function Navigator:FollowMob(Target)

    self.Target = Target;
    self.TargetType = NavigationTargetType_Mob;
    
end

function Navigator:GetDistanceToTarget()

    local Distance = 0;

    if(self.Target ~= nil) then
        
        local Player = GetPlayer();    
        
        if(self.TargetType == NavigationTargetType_Point) then
    
            Distance = math.sqrt(math.pow(self.Target.X - Player:GetXPosition(), 2) + math.pow(self.Target.Y - Player:GetYPosition(), 2));
            
        elseif(self.TargetType == NavigationTargetType_Mob) then
        
            Distance = GetDistanceToMob(self.Target);
        
        end
                        
    end
    
    return Distance;

end

function Navigator:HasTarget()

    return (self.Target ~= nil);

end

function Navigator:SetTurnLeft(Enable, BypassCheck)

    if(BypassCheck == true or GetKeyState(Key.NumPad4) ~= Enable) then
        SetKeyState(Key.NumPad4, Enable);        
    end
end

function Navigator:SetTurnRight(Enable, BypassCheck)

    if(BypassCheck == true or GetKeyState(Key.NumPad6) ~= Enable) then
        SetKeyState(Key.NumPad6, Enable);        
    end
    
end

function Navigator:SetMoveForward(Enable)

    if(GetKeyState(Key.NumPad8) ~= Enable) then
        SetKeyState(Key.NumPad8, Enable);        
    end
    
end

function Navigator:Start()

    if(self.IsStarted == true) then
        return;
    end
    
    self.IsStarted = true;
    self.LastPosition = self:GetCurrentPosition();
    self.LastTick = os.clock() - 1;

    self.Timer:Start(100);

end

function Navigator:Stop()

    if(self.IsStarted == false) then
        return;
    end
    
    self.IsStarted = false;
    
    self.Timer:Stop();
    self.TurnTimer:Stop();
    
    self:SetMoveForward(false);
    self:SetTurnLeft(false);
    self:SetTurnRight(false);

end

function IsPositionDataEqual(Pos1, Pos2)

    return (Pos1.X == Pos2.X and Pos1.Y == Pos2.Y and Pos1.Z == Pos2.Z and Pos1.Rotation == Pos2.Rotation);

end

function Navigator:Tick()

    if(self.Target ~= nil) then
    
        local CurrentTick = os.clock();
        
        local CurrentPos = self:GetCurrentPosition();
        
        -- Update when position changes or at least second.
        if(not IsPositionDataEqual(self.LastPosition, CurrentPos) or CurrentTick - self.LastTick > 1.0) then
        
            self.TurnTimer:Stop();
        
            local TargetPos = self:GetTargetPosition();
            
            local VectorX = TargetPos.X - CurrentPos.X;
            local VectorY = TargetPos.Y - CurrentPos.Y;

            local DistanceToTarget = self:GetDistanceToTarget();
            local AngleToTarget = math.atan2(VectorY, VectorX);
            
            local ActualAngle = ((255 - CurrentPos.Rotation) / 255.0) * (math.pi * 2.0);
            
            if(ActualAngle > math.pi) then
                ActualAngle = ActualAngle - (2.0 * math.pi) ;
            end
                   
            local AngleDifference = math.abs(ActualAngle - AngleToTarget);
            
            local MoveForward = (AngleDifference < 1.5 and DistanceToTarget > 1);
            
            self:SetMoveForward(MoveForward);
            
            if(AngleDifference < 0.1) then
                
                self:SetTurnLeft(false);
                self:SetTurnRight(false);
                
            else
                
                local TurnLeft = (ActualAngle - AngleToTarget < 0);
                
                if(math.abs(AngleDifference) > math.pi) then
                
                    TurnLeft = not TurnLeft;
                    
                end
                
                self:SetTurnLeft(TurnLeft);
                self:SetTurnRight(not TurnLeft);
                
                -- Assume 1.2 seconds for a 180 degree rotation.
                local TurnTime = ((AngleDifference / math.pi) * 1200);
                
                self.TurnTimer:Start(TurnTime);
                
            end
        
            self.LastPosition = CurrentPos;
            self.LastTick = CurrentTick;      
            
        end
        
    end

end

function Navigator:OnTurnTimerTick()

    self.TurnTimer:Stop();
    
    self:SetTurnLeft(false);
    self:SetTurnRight(false);

end