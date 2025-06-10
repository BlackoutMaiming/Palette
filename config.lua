return {
    ["STARTUP"] = {
        ["COLOURO"] = "009DFF",
        ["COLOURT"] = "FFFFFF",
        ["CARD"] = "j_joker",
        ["DECK_POS"] = {x=0,y=0}
    },
    ["MAIN_MENU"] = {
        ["SPLASH"] = {
            ["COLOURO"] = "FE5F55",
            ["COLOURT"] = "009DFF",
            ["VORTSPEED"] = 0.4
        },
        ["BUTTONS"] = {
            ["PLAY"] = "009DFF",
            ["OPTIONS"] = "FDA200",
            ["QUIT"] = "FE5F55",
            ["COLLECTION"] = "56A887"
        }
    },
    ["PACKS"] = {
        ["BUFFOON"] = {
            ["COLOURO"] = "FF9A00",
            ["COLOURT"] = "374244",
            ["HUDCOLOUR"] = "FF9A00",
            ["CONTRAST"] = 2.0
        },
        ["ARCANA"] = {
            ["COLOURO"] = "8867A5",
            ["COLOURT"] = "2C3536",
            ["HUDCOLOUR"] = "EBECEC",
            ["CONTRAST"] = 1.5,
            ["SPARKLES"] = {
                ["TIMER"] = 0.015,
                ["SCALE"] = 0.2,
                ["LIFESPAN"] = 1,
                ["SPEED"] = 1.1,
                ["COLOURS"] = {
                    ["ONE"] = "FFFFFF",
                    ["TWO"] = "B7A4C9",
                    ["THREE"] = "A085B7",
                    ["FOUR"] = "EECD79"
                }
            }
        },
        ["CELESTIAL"] = {
            ["COLOUR"] = "374244",
            ["HUDCOLOUR"] = "17A4C0",
            ["CONTRAST"] = 3.0,
            ["STARS"] = {
                ["TIMER"] = 0.070,
                ["SCALE"] = 0.1,
                ["LIFESPAN"] = 15,
                ["SPEED"] = 0.1,
                ["COLOURS"] = {
                    ["ONE"] = "FFFFFF",
                    ["TWO"] = "A7D6E0",
                    ["THREE"] = "FDDCA0"
                }
            },
            ["METEORS"] = {
                ["TIMER"] = 2.000,
                ["SCALE"] = 0.05,
                ["LIFESPAN"] = 1.5,
                ["SPEED"] = 4,
                ["COLOURS"] = {
                    ["ONE"] = "FFFFFF"
                }
            }
        },
        ["SPECTRAL"] = {
            ["COLOURO"] = "4584FA",
            ["COLOURT"] = "2C3536",
            ["HUDCOLOUR"] = "447DE8",
            ["CONTRAST"] = 2.0,
            ["SPARKLES"] = {
                ["TIMER"] = 0.015,
                ["SCALE"] = 0.1,
                ["LIFESPAN"] = 3,
                ["SPEED"] = 0.2,
                ["COLOURS"] = {
                    ["ONE"] = "FFFFFF",
                    ["TWO"] = "EECD79"
                }
            }
        },
        ["STANDARD"] = {
            ["COLOURO"] = "2C3536",
            ["COLOURT"] = "FE5F55",
            ["HUDCOLOUR"] = "FE5F55",
            ["CONTRAST"] = 3.0,
            ["SPARKLES"] = {
                ["TIMER"] = 0.015,
                ["SCALE"] = 0.3,
                ["LIFESPAN"] = 3,
                ["SPEED"] = 0.2,
                ["COLOURS"] = {
                    ["ONE"] = "374244",
                    ["TWO"] = "FE5F55"
                }
            }
        }
    },
    ["UTILITY"] = {
        ["SUDCO"] = 1, --StartUpDeckCurrentOption
        ["SUDO"] = {"Red Deck","Blue Deck","Yellow Deck","Green Deck","Black Deck","Magic Deck","Nebula Deck","Ghost Deck","Abandoned Deck","Checkered Deck","Zodiac Deck","Painted Deck","Anaglyph Deck","Plasma Deck","Erratic Deck", "Foil Deck", "Daily Challenge Deck"},  --StartUpDeckOptions
        ["SUDP"] = {{x=0,y=0},{x=0,y=2},{x=1,y=2},{x=2,y=2},{x=3,y=2},{x=0,y=3},{x=3,y=0},{x=6,y=3},{x=3,y=3},{x=1,y=3},{x=3,y=4},{x=4,y=3},{x=2,y=4},{x=4,y=2},{x=2,y=3},{x=5,y=2},{x=1,y=4}}
    }
}