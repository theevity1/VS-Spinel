function start (song)
    defaultZoom = 0.53
    camZoom = 0.53
end

function update (elapsed)

	local currentBeat = (songPos / 1000)*(bpm/60)
	hudX = getHudX()
    hudY = getHudY()
    
    -- Ugh I have to do the lerp zooming myself
    if camZoom > defaultZoom then
        camZoom = camZoom - (elapsed * 0.5)
        if (camZoom < defaultZoom) then
            camZoom = defaultZoom
        end
    end
    
    setCamZoom(camZoom)

    if sway then
        camHudAngle = 5 * math.sin(currentBeat * 0.504)
    else
        camHudAngle = 0
    end
    
    if wave then
		for i=0,7 do
			setActorY(_G['defaultStrum'..i..'Y'] + 16 * math.sin(currentBeat + i), i)
		end
    elseif fastWave then
        for i=0,7 do
            setActorX(_G['defaultStrum'..i..'X'] + 4 * math.cos((currentBeat + i) * 3), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 16 * math.sin((currentBeat + i) * 3), i)
		end
    end
end

function beatHit (beat)
    if (beat >= 80 and beat < 88) then
        camZoom = 0.575
    elseif (beat >= 232 and beat < 262) or (beat >= 264 and beat < 286) and beat % 2 == 0 then
        camZoom = 0.575
    end
end

function stepHit (step)

	-- Separate these by ranges instead of on certain steps
	-- This is so that when steps are missed from lag, the effect still goes through
	
	-- fix for placement desync due to possible lag
	--if (step >= 578 and step < 600) or (step >= 706 and step < 760) and (step >= 840 and step < 896) or (step >= 1030 and step < 1144) then
    --    for i=0,7 do
	--		setActorX(_G['defaultStrum'..i..'X'],i)
	--		setActorAngle(0, i)
    --    end
	--end
    
    if (step >= 352 and step < 367) and step % 2 == 0 then
        camZoom = 0.6
    end
	
	if (step >= 256 and step < 384) or (step >= 640 and step < 896) or step >= 1152 and not wave then
		wave = true
	end
    
    if (step >= 384 and step < 640) or (step >= 928 and step < 1152) and not fastWave then
        fastWave = true
        sway = true
    end
    
    if (step >= 384 and step < 640) or (step >= 896 and step < 1152) and wave then
        wave = false
        setActorY(_G['defaultStrum'..i..'X'], i)
        setActorY(_G['defaultStrum'..i..'Y'], i)
    end
    
    if (step >= 640 and step < 928) or step >= 1152 and fastWave then
        fastWave = false
        sway = false
        setActorY(_G['defaultStrum'..i..'X'], i)
        setActorY(_G['defaultStrum'..i..'Y'], i)
    end
	
	-- spin transitions
	if step >= 256 and step % 64 == 0 then
		for i=0,7 do
			tweenAngle(i, getActorAngle(i) + 360, 0.2)
		end
	end
end