function start(song)
	activate = false
    shakenote = true
    raiseNotes = false
    shakeIntensity0 = 5
    shakeIntensity1 = 5
    shakeIntensity2 = 5
    shakeIntensity3 = 5
    offsetY = -200
end

function update(elapsed)
	local currentBeat = (songPos / 1000) * (bpm / 60)
	hudX = getHudX()
	hudY = getHudY()

	if wave then
		for i=0,7 do
			setActorY(_G['defaultStrum'..i..'Y'] + offsetY + 40 * math.sin((currentBeat / 4) + i), i)
		end
    end
    
    if reduceY and offsetY < 30 then
        offsetY = offsetY + (elapsed * 100)
        if (offsetY > 30) then
            offsetY = 30
            reduceY = false
        end
    end

	if shakenote then
        setActorX(_G["defaultStrum4X"] + 2.5 * math.sin((currentBeat * shakeIntensity0) * math.pi), 4)
        setActorY(_G["defaultStrum4Y"] + 2.5 * math.cos((currentBeat * shakeIntensity0) * math.pi) + 10, 4)
		setActorX(_G["defaultStrum5X"] + 2.5 * math.sin((currentBeat * shakeIntensity1) * math.pi), 5)
        setActorY(_G["defaultStrum5Y"] + 2.5 * math.cos((currentBeat * shakeIntensity1) * math.pi) + 10, 5)
        setActorX(_G["defaultStrum6X"] + 2.5 * math.sin((currentBeat * shakeIntensity2) * math.pi), 6)
        setActorY(_G["defaultStrum6Y"] + 2.5 * math.cos((currentBeat * shakeIntensity2) * math.pi) + 10, 6)
        setActorX(_G["defaultStrum7X"] + 2.5 * math.sin((currentBeat * shakeIntensity3) * math.pi), 7)
        setActorY(_G["defaultStrum7Y"] + 2.5 * math.cos((currentBeat * shakeIntensity3) * math.pi) + 10, 7)
	end
    
    if reduceShake0 then
        shakeIntensity0 = shakeIntensity0 - elapsed
        if (shakeIntensity0 < 0) then
            shakeIntensity0 = 0
            reduceShake0 = false
        end
    end
    if reduceShake1 then
        shakeIntensity1 = shakeIntensity1 - elapsed
        if (shakeIntensity1 < 0) then
            shakeIntensity1 = 0
            reduceShake1 = false
        end
    end
    if reduceShake2 then
        shakeIntensity2 = shakeIntensity2 - elapsed
        if (shakeIntensity2 < 0) then
            shakeIntensity2 = 0
            reduceShake2 = false
        end
    end
    if reduceShake3 then
        shakeIntensity3 = shakeIntensity3 - elapsed
        if (shakeIntensity3 < 0) then
            shakeIntensity3 = 0
            reduceShake3 = false
            shakenote = false
        end
    end
end

function beatHit(beat)
end

function stepHit(step)
	-- Separate these by ranges instead of on certain steps
	-- This is so that when steps are missed from lag, the effect still goes through

	if step == 176 or step == 402 or step == 530 or step == 662 then
        startSpin()
    end
                    
    if not reduceShake0 and shakeIntensity0 == 5 and step >= 232 then
        reduceShake0 = true
    end
    if not reduceShake1 and shakeIntensity1 == 5 and step >= 264 then
        reduceShake1 = true
    end
    if not reduceShake2 and shakeIntensity2 == 5 and step >= 296 then
        reduceShake2 = true
    end
    if not reduceShake3 and shakeIntensity3 == 5 and step >= 328 then
        reduceShake3 = true
    end
    
    if step >= 832 and step < 864 and not raiseNotes then
        raiseNotes = true
        tweenPosIn(4, _G["defaultStrum4X"] - 250, _G["defaultStrum4Y"] - 50, 0.3, 'throwNote4')
        tweenPosIn(5, _G["defaultStrum5X"] - 300, _G["defaultStrum5Y"] - 50, 0.4, 'throwNote5')
        tweenPosIn(6, _G["defaultStrum6X"] - 350, _G["defaultStrum6Y"] - 50, 0.5, 'throwNote6')
        tweenPosIn(7, _G["defaultStrum7X"] - 400, _G["defaultStrum7Y"] - 50, 0.6, 'throwNote7')
        
        tweenPosIn(3, _G["defaultStrum3X"] + 250, _G["defaultStrum3Y"] - 50, 0.3, 'throwNote3')
        tweenPosIn(2, _G["defaultStrum2X"] + 300, _G["defaultStrum2Y"] - 50, 0.4, 'throwNote2')
        tweenPosIn(1, _G["defaultStrum1X"] + 350, _G["defaultStrum1Y"] - 50, 0.5, 'throwNote1')
        tweenPosIn(0, _G["defaultStrum0X"] + 400, _G["defaultStrum0Y"] - 50, 0.6, 'throwNote0')
    end
    
    if step >= 864 and not wave then
        wave = true
        reduceY = true
        for i=0,7 do
            setActorX(_G["defaultStrum"..i.."X"], i)
        end
    end
end

function startSpin()
    for i=0,7 do
        tweenAngleOut(i, -50, 0.6, 'spinNotes')
    end
end

function spinNotes()
    for i=0,7 do
        tweenAngle(i, 1620, 0.8, 'stopNotes')
    end
end

function stopNotes()
    for i=0,7 do
        tweenAngleOut(i, 1800, 0.2, 'resetAngle')
    end
end

function resetAngle()
    for i=0,7 do
        setActorAngle(0, i)
    end
end

function throwNote0()
    tweenPosOut(0, 600, -250, 1)
end

function throwNote1()
    tweenPosOut(1, 600, -250, 1)
end

function throwNote2()
    tweenPosOut(2, 600, -250, 1)
end

function throwNote3()
    tweenPosOut(3, 600, -250, 1)
end

function throwNote4()
    tweenPosOut(4, 600, -250, 1)
end

function throwNote5()
    tweenPosOut(5, 600, -250, 1)
end

function throwNote6()
    tweenPosOut(6, 600, -250, 1)
end

function throwNote7()
    tweenPosOut(7, 600, -250, 1)
end