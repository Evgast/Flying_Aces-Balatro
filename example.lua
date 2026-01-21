FLACE.Flace {
    key = "example_flace",
    atlas = "tuning",
    subset = "Tuning",
    pos = { x = 3, y = 0 },
    --[[
        Subset defaults to "Knock-Off". It technically isn't a thing, but you can keep it at that if you want a buttonless Flace
        Now, legitimate options are "Tuning" and "Trinket"
        Tunings have two buttons to use, while Trinket set is a simpler one button option
    ]]
    set_badge_label = "Screaming Face",
    set_badge_color = G.C.FILTER,
    sub_badge_label = "Catalyst",
    sub_badge_color = G.C.PURPLE,
    --Four options to change set and subset badges. Maybe you want to Ortalab it? I dunno man
    bluebutt = G.C.CHIPS,
    redbutt = G.C.MULT,
    trinketbutt = G.C.GREEN,
    --bluebutt and redbutt respectively are used to change the color of... Red button and blue button. Now help me out here, what is trinketbutt?
    use = function (self, card)
    end,
    can_use = function (self, card)
    end,
    --You probably seen use and can_use before. In case with flaces though, those are used for TRINKET SUBSET ONLY!
    use_blue = function (self, card)
    end,
    use_red = function (self, card)
    end,
    can_use_blue = function (self, card)
    end,
    can_use_red = function (self, card)
    end,
    --Those four are the same as use and can_use, but for Tuning specifically instead
    calculate = function (self, card, context) --hi
    end,
}