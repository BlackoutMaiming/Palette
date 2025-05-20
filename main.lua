--- STEAMODDED HEADER
--- MOD_NAME: Palette
--- MOD_ID: palette
--- PREFIX: palette
--- MOD_AUTHOR: [BlackoutMaiming]
--- MOD_DESCRIPTION: Adds colour customisability
--- VERSION: 1.0.0

palette = {}
palette.config = SMODS.current_mod.config

G.FUNCS.palette_create_first_page = function()
    return {
        n = G.UIT.ROOT,
        config = { align = 'cm', colour = G.C.CLEAR },
        nodes = {
            {
                n = G.UIT.C,
                config = { align = 'tm', colour = G.C.CLEAR },
                nodes = {
                    UIBox_button {
                        label = {"Startup Screen"},
                        colour = G.C.WHITE,
                        button = 'palette_Startup_Screen'
                    }
                }
            }
        }
    }
end

G.FUNCS.palette_Startup_Screen = function()
    sendInfoMessage("BELIAL")
    return
end


SMODS.current_mod.config_tab = function()
    return {
        n = G.UIT.ROOT,
        config = { align = 'cm', colour = G.C.CLEAR },
        nodes = {
            {
                n = G.UIT.O,
                config = {
                    id = 'palette_config_panel',
                    object = UIBox {
                        config = { align = 'cm' },
                        definition = 'create_first_page'
                    }
                }
            }
        }
    }
end