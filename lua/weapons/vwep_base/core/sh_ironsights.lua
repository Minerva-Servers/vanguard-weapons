function VWEP:CanIronSight()
    local ply = self:GetOwner()
    if ( !IsValid(ply) ) then return false end

    if ( !self.IronSightsEnabled ) then return false end
    if ( self:GetReloading() ) then return false end
    if ( ply:KeyDown(IN_USE) ) then return false end

    if ( self.IronSightsCanMove ) then
        local runSpeed = ply:GetRunSpeed()
        local vel = ply:GetVelocity():Length2D() / runSpeed
        vel = math.Round(vel, 2)
        vel = math.Clamp(vel, 0, 1)

        if ( vel > self.IronSightsRunSpeed ) then
            return self.IronSightsCanMoveRun and true or false
        end
    end

    return true
end

function VWEP:ThinkIronSights()
    local ply = self:GetOwner()
    if ( self:GetIronSights() and !self:CanIronSight() ) then
        self:SetIronSights(false)
        return
    end

    if ( IsFirstTimePredicted() ) then
        if ( self:GetIronSights() and !ply:KeyDown(IN_ATTACK2) ) then
            self:SetIronSights(false)
        elseif ( !self:GetIronSights() and ply:KeyDown(IN_ATTACK2) and self:CanIronSight() ) then
            self:SetIronSights(true)
        end
    end
end