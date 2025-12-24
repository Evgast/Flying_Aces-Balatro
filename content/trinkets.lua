function D6_CARD(card)
    local reroll = SMODS.create_card({ set = card.ability.set})
    reroll.states.visible = false
    card:set_ability(reroll.config.center.key)
    card:set_cost()
    reroll:remove()
end

FLACE.Flace {
    key = "D6",
    atlas = "tuning",
    subset = "Trinket",
    pos = { x = 3, y = 0 },
    config = { extra = { ready = true } },
    use = function (self, card)
        if #G.shop_jokers.highlighted > 0 then
            D6_CARD(G.shop_jokers.highlighted[1])
        end
        if #G.shop_booster.highlighted > 0 then
            D6_CARD(G.shop_booster.highlighted[1])
        end
        if #G.shop_vouchers.highlighted > 0 then
            D6_CARD(G.shop_vouchers.highlighted[1])
        end
        card.ability.extra.ready = false
    end,
    can_use = function (self, card)
        if ((G.shop_jokers and #G.shop_jokers.highlighted == 1 and #G.shop_booster.highlighted == 0 and #G.shop_vouchers.highlighted == 0) or (G.shop_booster and #G.shop_booster.highlighted == 1 and #G.shop_jokers.highlighted == 0 and #G.shop_vouchers.highlighted == 0) or (G.shop_vouchers and #G.shop_vouchers.highlighted == 1 and #G.shop_jokers.highlighted == 0 and #G.shop_booster.highlighted == 0)) and card.ability.extra.ready then
            return true
        end
    end,
    calculate = function (self, card, context)
        if not card.ability.extra.ready and context.starting_shop then
            card.ability.extra.ready = true
            return {
                message = "Charged up!"
            }
        end
    end,
}

FLACE.Flace {
    key = "blank",
    atlas = "tuning",
    subset = "Trinket",
    pos = { x = 4, y = 0 },
    loc_vars = function(self, info_queue, card)
        return { vars = { G.GAME.moxie } }
    end,
    use = function (self, card)
        G.consumeables.highlighted[1]:use_consumeable()
    end,
    can_use = function (self, card)
        if #G.consumeables.highlighted == 1 and G.consumeables.highlighted[1]:can_use_consumeable() and card.ability.extra.ready then
            return true
        end
    end,
    calculate = function (self, card, context)
        if not card.ability.extra.ready and context.starting_shop then
            card.ability.extra.ready = true
            return {
                message = "Charged up!"
            }
        end
    end,
}

function Diplopia(card)
    local diplocard = copy_card(card)
    diplocard.T.w = card.T.w
    diplocard.T.h = card.T.h
    create_shop_card_ui(diplocard)
    card.area:emplace(diplocard)
end

FLACE.Flace {
    key = "diplopia",
    atlas = "tuning",
    subset = "Trinket",
    pos = { x = 5, y = 0 },
    config = { extra = { ready = true } },
    use = function (self, card)
        if #G.shop_jokers.highlighted > 0 then
            Diplopia(G.shop_jokers.highlighted[1])
        end
        if #G.shop_booster.highlighted > 0 then
            Diplopia(G.shop_booster.highlighted[1])
        end
        card.ability.extra.ready = false
    end,
    can_use = function (self, card)
        if ((G.shop_jokers and #G.shop_jokers.highlighted == 1 and #G.shop_booster.highlighted == 0) or (G.shop_booster and #G.shop_booster.highlighted == 1 and #G.shop_jokers.highlighted == 0)) and card.ability.extra.ready then
            return true
        end
    end,
    calculate = function (self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and context.beat_boss and not card.ability.extra.ready then
            card.ability.extra.ready = true
            return {
                message = "Charged up!"
            }
        end
    end,
}