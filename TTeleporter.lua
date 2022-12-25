local function TTeleporter(par_speed)
    local TTeleporterFunctions = {}
    local Speed = par_speed or 100

    function TTeleporterFunctions:Teleport(par_part, par_cframe, par_mag_tolerance)
        if (par_part.Position - par_cframe.Position).Magnitude < par_mag_tolerance then
            par_part.CFrame = par_cframe
        end

        local val = Instance.new("CFrameValue")
        val.Value = par_part.CFrame
    
        local tween = game:GetService("TweenService"):Create(
            val, 
            TweenInfo.new((par_part.Position - par_cframe.Position).Magnitude / Speed, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), 
            {Value = par_cframe}
        )
    
        tween:Play()
    
        local completed
        tween.Completed:Connect(function()
            completed = true
        end)
    
        while not completed do
            if (par_part.Position - par_cframe.Position).Magnitude > par_mag_tolerance then
                par_part.CFrame = val.Value
            else
                tween:Stop()
                val:Destroy()
                completed = true
                par_part.CFrame = par_cframe
            end
            task.wait()
        end
    
        val:Destroy()
    end

    function TTeleporterFunctions:SetSpeed(par_speed) 
        Speed = par_speed
    end

    return TTeleporterFunctions
end

return TTeleporter
