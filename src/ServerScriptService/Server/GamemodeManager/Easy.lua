local Round = {}
Round.Info = {    
    Name = "Easy",
    ImageId = "rbxassetid://5108369416",
    Description = "an easy warm up for new players",

    Targets = 15,
    TargetColour = Color3.fromRGB(34, 162, 20),
    TargetSize = Vector3.new(4, 4, 4),

    Region = Region3.new(Vector3.new(-48.5, -6.75, -24.75), Vector3.new(48.5, 21.25, -60.75))
}

function Round.GeneratePositions()
    local positions = {}

    for i = 0, Round.Info.Targets do
          local function getRandomInBounds(n)
            if n < 0 then
                return math.random(n, -n)
            else
                return math.random(-n, n)
            end
          end
        
          local x = getRandomInBounds(Round.Info.Region.Size.X / 2)
          local y = getRandomInBounds(Round.Info.Region.Size.Y / 2)
          local z = getRandomInBounds(Round.Info.Region.Size.Z / 2)

        table.insert(positions, (Round.Info.Region.CFrame.Position + Vector3.new(x, y, z)))
    end

    return positions
end

return Round