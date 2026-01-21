G.FUNCS.swap_ability = function(args)
    if not args or not args.cycle_config then return end
    if #G.evgast.cards == 1 then
        G.evgast.cards[1].ability.extra.type = G.evgast_type[args.cycle_config.current_option].modname
    end
end

G.evgast_type = {}

function evgast_newtype(modname, x, y, key, redbutt)
    G.evgast_type[#G.evgast_type+1] = {
        modname = modname,
        x = x,
        y = y,
        loc_key = key,
        redbutt = redbutt
    }
end

evgast_newtype("Flace", 0, 0, "ace_flace_evg", G.C.MONEY)

if next(SMODS.find_mod("aikoyorisshenanigans")) then
    evgast_newtype("AikoShen", 1, 0, "ace_flace_evg_akyrs", G.C.GREEN)
end

if next(SMODS.find_mod("partner")) then
    evgast_newtype("Partner", 2, 0, "ace_flace_evg_partner", G.C.MULT)
end

if next(SMODS.find_mod("RevosVault")) then
    evgast_newtype("Revo's Vault", 3, 0, "ace_flace_evg_revo", G.C.SUITS.Spades)
end

function G.FUNCS.select_evgast(e)
    local type = G.evgast.cards[1].ability.extra.type
    G.FUNCS.exit_overlay_menu()
    e.config.ref_table.ability.extra.type = type
end

SMODS.Sound {
    key = "funny",
    path = "snd_bigcar_yelp.ogg",

}

FLACE.Flace {
    key = "evg",
    atlas = "evgast",
    subset = "Tuning",
    set_badge_label = "Self-Insert",
    set_badge_color = G.C.FILTER,
    sub_badge_label = "Slop!",
    sub_badge_color = G.C.PURPLE,
    pos = { x = 1, y = 0 },
    config = { extra = { type = "Flace", key = nil, ready = true,
    akyr_hands = 0, akyr_hands_give = 10,
    ace_it = false } },
    loc_vars = function(self, info_queue, card)
        return { key = card.ability.extra.key, vars = { card.ability.extra.type, #G.evgast_type,
        card.ability.extra.akyr_hands, card.ability.extra.akyr_hands_give,
        card.ability.extra.ace_it
        } }
    end,
    bluebutt = G.C.PURPLE,
    redbutt = G.C.MONEY,
    use_blue = function (self, card)
        G.evgast = CardArea(
            G.consumeables.T.x + 3, G.hand.T.y - 3, G.consumeables.T.w / 2.2, G.consumeables.T.h,
            {
                card_limit = 1, 
                type = 'joker', 
                highlight_limit = 0, 
                no_card_count = true 
            }
	    )
        SMODS.add_card { area = G.evgast, key = self.key }
        local joker_options = {}
        for i = 1, #G.evgast_type do
            table.insert(joker_options, localize('k_page')..' '..tostring(i)..'/'..tostring(#G.evgast_type))
        end
        G.FUNCS.overlay_menu({
            definition = create_UIBox_generic_options({
            contents = {
                { n = G.UIT.C, config = { minw = 1, minh = 1, colour = G.C.CLEAR, align = "cm" }, nodes = {
                    { n = G.UIT.R, config = { minw = 1, minh = 1, colour = G.C.CLEAR, align = "cm" }, nodes = {
                        {n = G.UIT.O, config = {object = G.evgast}},
                    }},
                    { n = G.UIT.R, config = { minw = 1, minh = 1, colour = G.C.CLEAR, align = "cm" }, nodes = {
                        create_option_cycle({options = joker_options, w = 4.5, cycle_shoulders = true, opt_callback = 'swap_ability', current_option = 1, colour = G.C.RED, no_pips = true, focus_args = {snap_to = true, nav = 'wide'}})
                    }},
                    UIBox_button{ label = {localize("flace_select_alt")}, scale = 0.5, minw = 5, minh = 1, colour = G.C.GREEN, r = 0.1, ref_table = card, button = "select_evgast" }
                }}
            }})
        })
    end,
    use_red = function (self, card)
        card.ability.extra.ready = false
        if card.ability.extra.type == "Flace" then
            play_sound("flace_funny")
        end
        if card.ability.extra.type == "AikoShen" then
            card.ability.extra.akyr_hands = 10
        end
        if card.ability.extra.type == "Partner" then
            if G.GAME.selected_partner_card then
                G.GAME.selected_partner_card:remove()
            end
            G.FUNCS.run_setup_partners_option()
        end
        if card.ability.extra.type == "Revo's Vault" then
            card.ability.extra.ace_it = true
        end
    end,
    can_use_blue = function (self, card)
        return true
    end,
    can_use_red = function (self, card)
        if card.ability.extra.ready then
            return true
        end
    end,
    update = function(self, card, dt)
        for k, v in pairs(G.evgast_type) do
            if v.modname == card.ability.extra.type then
                if v.loc_key ~= card.ability.extra.key then
                self.pos.x = v.x
                self.pos.y = v.y
                self.redbutt = v.redbutt
                card.ability.extra.key = v.loc_key
                end
            end
        end
    end,
    calculate = function (self, card, context)
        if card.ability.extra.akyr_hands > 0 and context.repetition and context.cardarea == G.play then
            return {
                repetitions = 1
            }
        end
        if card.ability.extra.ace_it and context.after then
            print(context.scoring_hand)
            G.E_MANAGER:add_event(Event({
            trigger = "after", 
            delay = 0, 
            func = function()
                for k, v in pairs(context.scoring_hand) do
                    assert(SMODS.change_base(v, nil, 'Ace'))
                end
                return true
            end
            }))
        end
        if context.after then
            card.ability.extra.akyr_hands = card.ability.extra.akyr_hands - 1
            card.ability.extra.ace_it = false
        end
        if context.ante_change and context.ante_end and not card.ability.extra.ready then
            card.ability.extra.ready = true
            return {
                message = "Yummers"
            }
        end
    end,
}

