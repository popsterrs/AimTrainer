local Round = {}
Round.Info = {    
    Name = "Hard",
    ImageId = "rbxassetid://5900676833",
    Description = "a warm up for the most skilled players",

    Targets = 25,
    TargetColour = Color3.fromRGB(202, 45, 2),
    TargetSize = Vector3.new(1, 1, 1),

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