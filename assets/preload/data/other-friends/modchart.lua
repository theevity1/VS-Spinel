function start (song)
    offsetX1 = 0
    offsetX2 = 0
    defaultZoom = 0.5
    camZoom = 0.5
    zooming = false
end

function update (elapsed)

	local currentBeat = (songPos / 1000)*(bpm/60)
	hudX = getHudX()
    hudY = getHudY()
    
     -- Ugh I have to do the lerp zooming myself
    if camZoom > defaultZoom and not zooming then
        camZoom = camZoom - (elapsed * 0.5)
        if (camZoom < defaultZoom) then
            camZoom = defaultZoom
        end
    end
    
    setCamZoom(camZoom)
    
    if dance1 then
		for i=0,3 do
            setActorX(_G['defaultStrum'..i..'X'] + offsetX1 + 8 * math.sin(currentBeat), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 4 * math.sin(currentBeat * 5), i)
		end
    end
    
    if dance2 then
        for i=4,7 do
            setActorX(_G['defaultStrum'..i..'X'] + offsetX2 + 8 * -math.sin(currentBeat), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 4 * math.sin(currentBeat * 5), i)
        end
    end
    
    if focus1 then
        if offsetX1 < 100 then
            offsetX1 = offsetX1 + (elapsed * 100)
            if (offsetX1 > 100) then
                offsetX1 = 100
            end
        end
        if offsetX2 < 0 then
            offsetX2 = offsetX2 + (elapsed * 100)
            if (offsetX2 > 0) then
                offsetX2 = 0
            end
        end
    elseif focus2 then
        if offsetX1 > 0 then
            offsetX1 = offsetX1 - (elapsed * 100)
            if (offsetX1 < 0) then
                offsetX1 = 0
            end
        end
        if offsetX2 > -100 then
            offsetX2 = offsetX2 - (elapsed * 100)
            if (offsetX2 < -100) then
                offsetX2 = -100
            end
        end
    elseif focusBoth then
        if offsetX1 < 100 then
            offsetX1 = offsetX1 + (elapsed * 100)
            if (offsetX1 > 100) then
                offsetX1 = 100
            end
        end
        if offsetX2 > -100 then
            offsetX2 = offsetX2 - (elapsed * 100)
            if (offsetX2 < -100) then
                offsetX2 = -100
            end
        end
    else
        if offsetX1 > 0 then
            offsetX1 = offsetX1 - (elapsed * 100)
            if (offsetX1 < 0) then
                offsetX1 = 0
            end
        end
        if offsetX2 < 0 then
            offsetX2 = offsetX2 + (elapsed * 100)
            if (offsetX2 > 0) then
                offsetX2 = 0
            end
        end
    end
    
    if zooming then
        camZoom = camZoom + (elapsed * 0.1)
    end
end

function beatHit (beat)
end

function stepHit (step)

	-- Separate these by ranges instead of on certain steps
	-- This is so that when steps are missed from lag, the effect still goes through
    
    if step >= 192 then
        dance1 = true
        dance2 = true
    end
    
    if step == 286 then
        tweenAngle(0, getActorAngle(0) + 360, 0.1)
        tweenAngle(4, getActorAngle(4) + 360, 0.1)
    elseif step == 287 then
        tweenAngle(2, getActorAngle(2) + 360, 0.1)
        tweenAngle(6, getActorAngle(6) + 360, 0.1)
    elseif step == 288 then
        tweenAngle(3, getActorAngle(3) + 360, 0.1)
        tweenAngle(7, getActorAngle(7) + 360, 0.1)
    elseif step == 290 then
        tweenAngle(0, getActorAngle(0) + 360, 0.1)
        tweenAngle(4, getActorAngle(4) + 360, 0.1)
    elseif step == 291 then
        tweenAngle(2, getActorAngle(2) + 360, 0.1)
        tweenAngle(6, getActorAngle(6) + 360, 0.1)
    elseif step == 292 then
        tweenAngle(3, getActorAngle(3) + 360, 0.1)
        tweenAngle(7, getActorAngle(7) + 360, 0.1)
    elseif step == 294 then
        tweenAngle(0, getActorAngle(0) + 360, 0.1)
        tweenAngle(4, getActorAngle(4) + 360, 0.1)
    elseif step == 295 then
        tweenAngle(2, getActorAngle(2) + 360, 0.1)
        tweenAngle(6, getActorAngle(6) + 360, 0.1)
    elseif step == 296 then
        tweenAngle(3, getActorAngle(3) + 360, 0.1)
        tweenAngle(7, getActorAngle(7) + 360, 0.1)
    elseif step == 298 then
        tweenAngle(0, getActorAngle(0) + 360, 0.1)
        tweenAngle(4, getActorAngle(4) + 360, 0.1)
    elseif step == 299 then
        tweenAngle(2, getActorAngle(2) + 360, 0.1)
        tweenAngle(6, getActorAngle(6) + 360, 0.1)
    elseif step == 300 then
        tweenAngle(3, getActorAngle(3) + 360, 0.1)
        tweenAngle(7, getActorAngle(7) + 360, 0.1)
    elseif step == 302 then
        tweenAngle(0, getActorAngle(0) + 360, 0.1)
        tweenAngle(4, getActorAngle(4) + 360, 0.1)
    elseif step == 303 then
        tweenAngle(1, getActorAngle(1) + 360, 0.1)
        tweenAngle(5, getActorAngle(5) + 360, 0.1)
    elseif step == 304 then
        tweenAngle(3, getActorAngle(3) + 360, 0.1)
        tweenAngle(7, getActorAngle(7) + 360, 0.1)
    end
    
    if (step >= 448 and step < 480) or (step >= 688 and step < 696) or (step >= 704 and step < 712) or (step >= 720 and step < 728) and not focus1 then
        focus1 = true
    elseif (step >= 480 and step < 512) or (step >= 696 and step < 704) or (step >= 712 and step < 720) or (step >= 728 and step < 736) and not focus2 then
        focus1 = false
        focus2 = true
    elseif (step >= 512 and step < 576) or (step >= 736 and step < 752) and not focusBoth then
        focus2 = false
        focusBoth = true
    elseif (step >= 576 and step < 688) or (step >= 752) and focusBoth then
        focusBoth = false
    end
    
    if (step >= 544 and step < 576) and not zooming then
        zooming = true
    elseif (step >= 576) and zooming then
        zooming = false
    end
end