radioConfig = {
    Controls = {
        Activator = { -- Open/Close Radio
            Name = "INPUT_FRONTEND_RRIGHT", -- Control name
            Key = 194, -- BACKSPACE
        },
        Toggle = { -- Toggle radio on/off
            Name = "INPUT_CONTEXT", -- Control name
            Key = 51, -- E
        },
        Input = { -- Choose Frequency
            Name = "INPUT_FRONTEND_ACCEPT", -- Control name
            Key = 201, -- Enter
            Pressed = false,
        },
        ToggleClicks = { -- Toggle radio click sounds
            Name = "INPUT_SELECT_WEAPON", -- Control name
            Key = 37, -- Tab
        }
    },
    Frequency = {
        Private = { -- List of private frequencies
            [96] = true,
            [2] = true,
            [3] = true
        },
        Current = 1, -- Don't touch
        CurrentIndex = 1, -- Don't touch
        Min = 1, -- Minimum frequency
        Max = 999, -- Max number of frequencies
        List = {}, -- Frequency list, Don't touch
        Access = {
            [96] = {'police'},
            [97] = {'police'},
            [98] = {'police'},
            [99] = {'police'},
            [100] = {'police'},
            [5] = {'mecano'},
            [4] = {'ambulance'}
        }
    },
    AllowRadioWhenClosed = true -- Allows the radio to be used when not open (uses police radio animation) 
}