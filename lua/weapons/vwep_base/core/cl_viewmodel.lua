local lerpIron
function VWEP:GetViewModelPosition(pos, ang)
    if ( !IsValid(self:GetOwner()) ) then return pos, ang end

    if ( !lerpIron ) then lerpIron = 0 end

    local ft = FrameTime()
    local time = ft * 4

    local bIron = self:GetIronSights()
    if ( bIron ) then
        lerpIron = Lerp(time, lerpIron, 1)
    else
        lerpIron = Lerp(time, lerpIron, 0)
    end

    local offset = self.IronSightsPos or Vector()
    if ( self.IronSightsAng ) then
        ang = ang * 1

        ang:RotateAroundAxis(ang:Right(), self.IronSightsAng.x * lerpIron)
        ang:RotateAroundAxis(ang:Up(), self.IronSightsAng.y * lerpIron)
        ang:RotateAroundAxis(ang:Forward(), self.IronSightsAng.z * lerpIron)
    end

    pos = pos + offset.x * ang:Right() * lerpIron
    pos = pos + offset.y * ang:Forward() * lerpIron
    pos = pos + offset.z * ang:Up() * lerpIron

    local lerpIronInverted = 1 - lerpIron
    offset = self.ViewModelOffset or Vector()

    pos = pos + offset.x * ang:Right() * lerpIronInverted
    pos = pos + offset.y * ang:Forward() * lerpIronInverted
    pos = pos + offset.z * ang:Up() * lerpIronInverted

    return pos, ang
end

function VWEP:PreDrawViewModel(vm, weapon, ply)
    if ( !IsValid(vm) ) then return end
    if ( !IsValid(weapon) ) then return end
    if ( !IsValid(ply) ) then return end

    vm:SetMaterial(self.ViewModelMaterial or "")
    vm:SetColor(self.ViewModelColor or Color(255, 255, 255, 255))
    vm:SetRenderMode(self.ViewModelRenderMode or RENDERMODE_NORMAL)
    vm:SetRenderFX(self.ViewModelRenderFX or kRenderFxNone)

    if ( self.ViewModelSkin != vm:GetSkin() ) then
        vm:SetSkin(self.ViewModelSkin)
    end

    for k, v in pairs(self.ViewModelBodygroups or {}) do // don't use ipairs, can't guarantee sequential order
        if ( !isnumber(k) or !isnumber(v) ) then continue end

        if ( vm:GetBodygroup(k) != v ) then
            vm:SetBodygroup(k, v)
        end
    end

    if ( self.ViewModelDynamicLights and #self.ViewModelDynamicLights > 0 ) then
        for k, v in ipairs(self.ViewModelDynamicLights) do
            if ( !v.Pos ) then continue end

            local light = DynamicLight(vm:EntIndex() + k)
            if ( !light ) then continue end

            local col = v.Color
            col.a = col.a or 255

            light.Pos = vm:GetPos() + vm:GetAngles():Forward() * v.Pos.x + vm:GetAngles():Right() * v.Pos.y + vm:GetAngles():Up() * v.Pos.z
            light.Brightness = v.Brightness or 1
            light.Size = v.Size or 128
            light.Decay = v.Decay or 100
            light.R = col.R
            light.G = col.G
            light.B = col.B
            light.DieTime = CurTime() + ( v.DieTime or 0.1 )
        end
    end
end