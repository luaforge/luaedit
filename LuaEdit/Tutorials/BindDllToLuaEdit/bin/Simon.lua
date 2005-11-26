--[[

This file manage the Simon game by randomizing sequences and validating
results. LuaEdit's initializer logic has been implemented in Simon.dll
to allow debugging.

]]--

-- Set "constant" for Simon game
local SIMON_NONE		= 0
local SIMON_RED			= 1
local SIMON_BLUE		= 2
local SIMON_YELLOW		= 3
local SIMON_GREEN		= 4

-- Game handling variables
local GameState = true
local MainSequence = {}
local SequenceCount = 0
local UserSequenceCount = 0

-- Event handler called by simon.dll when any of the colored buttons are clicked
function simon:OnButtonClick(ButtonIndex)
	local Result = 0
	UserSequenceCount = UserSequenceCount + 1
	
	if MainSequence[UserSequenceCount] == ButtonIndex then
		simon.SetScore(simon.GetScore() + 10)
	    Result = 1
	end
	
	return Result
end

-- Add one more part to the game's sequence
function simon:AddSequence()
	SequenceCount = SequenceCount + 1
    MainSequence[SequenceCount] = math.random(4)
end  

-- Play the game's sequence
function simon:PlaySequence(Sequence)
	local v = nil
	local i = nil
	
	-- Lock controls from user to make sure no conflicts happened while palying sequence
	simon.LockControls()
	
	-- Play all sequence
    repeat
    	simon.SetLight(SIMON_NONE)
    	Sleep(300)
		i, v = next(Sequence, i)
		simon.SetLight(v)

		if i ~= nil then
			Sleep(500)
		end
    until i == nil
    
    simon.UnlockControls()
    simon.SetLight(SIMON_NONE)
end

-- Initialize the game
function simon:Initialize()
	-- Initalize variables
	simon:SetScore(0)
	GameState = true
	UserSequenceCount = 0
	SequenceCount = 0
	MainSequence = {}
	
	-- Initialize random engine
	math.randomseed(os.time())
	math.random()
	math.random()
	math.random()
end
				
-- Show Simon game main form
simon.SetMediaPath("C:\\Prog\\Delphi\\MNet\\Bin\\Medias")
simon.Create()

-- Main processing loop
while simon.GetPowerStatus() == 1 do
	if simon.GetPlayStatus() == 1 then
		simon:Initialize()
		
		-- Game processing loop
		while GameState do
			UserSequenceCount = 0
			simon:AddSequence()
			simon:DisplayMessage("Simon's Turn!", "clRed", 750)
			simon:PlaySequence(MainSequence)
			
			simon:DisplayMessage("Your Turn!", "clLime", 1000)
			GameState = simon.GetUserSequence(SequenceCount, 2000)
			
			if simon:GetScore() > 1000 then
				simon:DisplayMessage("You Win!", "clAqua", -1)
				GameState = false
			end
		end
	end
	
	-- Make sure the processor doesn't runs for no reason
	Sleep(10)
end

simon.Destroy()