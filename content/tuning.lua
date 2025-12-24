    FLACE.Flace {
        key = "fm",
        atlas = "tuning",
        subset = "Tuning", --Actually isn't needed since the Tuning subset is the default one
        pos = { x = 0, y = 0 },
        config = { extra = { moxie = 100, moxie_gain = 20, moxie_blue = 40, moxie_red = 25, moxie_max = 100 } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.moxie, card.ability.extra.moxie_gain, card.ability.extra.moxie_blue, card.ability.extra.moxie_red, card.ability.extra.moxie_max } }
        end,
        use_blue = function (self, card)
            SMODS.modify_rank(G.hand.highlighted[1], 1)
            card.ability.extra.moxie = card.ability.extra.moxie - card.ability.extra.moxie_blue
            G.hand.highlighted[1]:add_sticker("flace_rankup", true)
        end,
        use_red = function (self, card)
            G.FUNCS.draw_from_hand_to_deck()
            SMODS.draw_cards(#G.hand.cards)
            card.ability.extra.moxie = card.ability.extra.moxie - card.ability.extra.moxie_red
        end,
        can_use_blue = function (self, card)
            if #G.hand.highlighted == 1 and card.ability.extra.moxie >= card.ability.extra.moxie_blue and not G.hand.highlighted[1].ability.flace_rankup then
                return true
            end
        end,
        can_use_red = function (self, card)
            if card.ability.extra.moxie >= card.ability.extra.moxie_red and #G.hand.cards > 0 then
                return true
            end
        end,
        calculate = function (self, card, context)
            if context.before then
                card.ability.extra.ready = true
                card.ability.extra.moxie = card.ability.extra.moxie + card.ability.extra.moxie_gain
                if card.ability.extra.moxie > card.ability.extra.moxie_max then
                    card.ability.extra.moxie = card.ability.extra.moxie_max
                end
            end
        end,
    }

    FLACE.Flace {
        key = "go",
        atlas = "tuning",
        pos = { x = 2, y = 0 },
        config = { extra = { moxie = 100, moxie_gain = 20, moxie_blue = 40, moxie_red = 40, moxie_max = 100 } },
	    loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.moxie, card.ability.extra.moxie_gain, card.ability.extra.moxie_blue, card.ability.extra.moxie_red, card.ability.extra.moxie_max } }
        end,
        use_blue = function (self, card)
            SMODS.modify_rank(G.hand.highlighted[1], 2)
            card.ability.extra.moxie = card.ability.extra.moxie - card.ability.extra.moxie_blue
            G.hand.highlighted[1]:add_sticker("flace_rankup2", true)
        end,
        use_red = function (self, card)
            G.card_selector = {}
            local suits = {}
            local areas = {}
            for k, v in pairs(G.playing_cards) do
                if v.area == G.deck then
                local contained = false
                local current_suit = v.base.suit
                for k, v in pairs(suits) do
                    if v == current_suit then
                        contained = true
                    end
                end
                if not contained then
                    table.insert(suits, current_suit)
                end
                end
            for k, v in pairs(suits) do
                if not G.card_selector[v] then
                    G.card_selector[v] = CardArea(0, 0, G.CARD_W * (8 + 0.1), (G.CARD_H/2) * 1.1, {
                        card_limit = 0,
                        view_deck = false,
                        type = "hand",
                        no_card_count = true
                    })
                    print(v)
                    areas[#areas+1] = {n=G.UIT.R, config={align = "cm", no_fill = true}, nodes={
                                        {n=G.UIT.O, config={object = G.card_selector[v] }}
                    }}
                end
            end
            end
            for k, v in pairs(G.playing_cards) do
                if v.area == G.deck then
                    local copy = copy_card(v)
                    copy.ref = v
                    copy.T.w = v.T.w/2
                    copy.T.h = v.T.h/2
                    G.card_selector[v.base.suit]:emplace(copy)
                end
            end
        G.FUNCS.overlay_menu({
                definition = create_UIBox_generic_options({
                    contents = {
                        { n = G.UIT.C, config = {minw=1, minh=1, colour = G.C.CLEAR }, nodes = {
                        { n = G.UIT.C, config={align = "cm", r = 0.1, colour = G.C.BLACK, emboss = 0.05 }, nodes = areas }}}}
                })
            })
        card.ability.extra.moxie = card.ability.extra.moxie - card.ability.extra.moxie_red
        end,
        can_use_blue = function (self, card)
            if #G.hand.highlighted == 1 and card.ability.extra.moxie >= card.ability.extra.moxie_blue and not G.hand.highlighted[1].ability.flace_rankup2 then
                return true
            end
        end,
        can_use_red = function (self, card)
            if card.ability.extra.moxie >= card.ability.extra.moxie_red and #G.hand.cards > 0 then
                return true
            end
        end,
        calculate = function (self, card, context)
            if context.before then
                card.ability.extra.moxie = card.ability.extra.moxie + card.ability.extra.moxie_gain
                if card.ability.extra.moxie > card.ability.extra.moxie_max then
                    card.ability.extra.moxie = card.ability.extra.moxie_max
                end
            end
        end,
    }

    FLACE.Flace {
        key = "ut",
        atlas = "tuning",
        subset = "Tuning",
        pos = { x = 1, y = 0 },
        config = { extra = { moxie = 100, moxie_gain = 10, moxie_blue = 40, ready = true, moxie_max = 100 } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.moxie, card.ability.extra.moxie_gain, card.ability.extra.moxie_blue, card.ability.extra.moxie_max } }
        end,
        use_blue = function (self, card)
            local suits = {}
            for k, v in pairs(G.playing_cards) do
                if v.area == G.deck then
                local contained = false
                local current_suit = v.base.suit
                for k, v in pairs(suits) do
                    if v == current_suit then
                        contained = true
                    end
                end
                if not contained then
                    table.insert(suits, current_suit)
                end
            end
            end
            G.suit_selector = CardArea(0, 0, G.CARD_W * (#suits + 0.1), G.CARD_H * 1.1, {
                card_limit = #suits,
                type = "hand",
                view_deck = false,
                highlight_limit = 1,
            })
            for k, v in pairs(suits) do
                SMODS.add_card{set = "Base", area = G.suit_selector, rank = "A", suit = v }
            end
            G.FUNCS.overlay_menu({
                definition = create_UIBox_generic_options({
                    contents = {
                        { n = G.UIT.O, config = { minw = 1, minh = 1, object = G.suit_selector } } 
                    }
                })
            })
            card.ability.extra.moxie = card.ability.extra.moxie - card.ability.extra.moxie_blue
        end,
        use_red = function (self, card)
            card.ability.extra.ready = false
            card.ability.extra.moxie = card.ability.extra.moxie + card.ability.extra.moxie_gain
            G.FUNCS.discard_cards_from_highlighted(nil, true)
            G.hand:unhighlight_all()
        end,
        can_use_blue = function (self, card)
            if #G.hand.cards > 0 and card.ability.extra.moxie >= card.ability.extra.moxie_blue then
                return true
            end
        end,
        can_use_red = function (self, card)
            if #G.hand.highlighted == 2 then
                return true
            end
        end,
        calculate = function (self, card, context)
            if context.before then
                card.ability.extra.ready = true
                card.ability.extra.moxie = card.ability.extra.moxie + card.ability.extra.moxie_gain
                if card.ability.extra.moxie > card.ability.extra.moxie_max then
                    card.ability.extra.moxie = card.ability.extra.moxie_max
                end
            end
        end,
    }

SMODS.Sticker {
	key = 'rankup',
	hide_badge = true,
	atlas = "stick",
	no_collection = true,
	pos = { x = 0, y = 0 },
	loc_vars = function(self, info_queue, card)
	end,
	calculate = function (self, card, context)
		if context.end_of_round then
			card.ability.flace_rankup = nil
			SMODS.modify_rank(card, -1)
		end
	end,
	rate = 0.0,
}

SMODS.Sticker {
	key = 'rankup2',
	hide_badge = true,
	atlas = "stick",
	no_collection = true,
	pos = { x = 1, y = 0 },
	loc_vars = function(self, info_queue, card)
	end,
	calculate = function (self, card, context)
		if context.end_of_round then
			card.ability.flace_rankup = nil
			SMODS.modify_rank(card, -2)
		end
	end,
	rate = 0.0,
}

function G.FUNCS.go_draw(e)
    local card_to_draw = e.parent.parent.parent.parent.ref
    draw_card(G.deck, G.hand, nil, "up", true, card_to_draw)
    G.FUNCS.exit_overlay_menu()
end

function G.FUNCS.ut_draw(e)
    local suit = e.parent.parent.parent.parent.base.suit
    local draw_pool = {}
    local random_draw = {}
    local to_draw = 2
    local draw_index = 0
    for k, v in pairs(G.playing_cards) do
        if v.base.suit == suit and v.area == G.deck then
            draw_pool[#draw_pool + 1] = v
        end
    end
    if #draw_pool < 2 then
        to_draw = 1
    end
    for i = 1, to_draw do
        random_draw, draw_index = pseudorandom_element(draw_pool, "draw_random_from_suit")
        table.remove(draw_pool, draw_index)
        draw_card(G.deck, G.hand, nil, "up", true, random_draw)
    end
    G.FUNCS.exit_overlay_menu()
end