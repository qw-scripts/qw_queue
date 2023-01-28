Config = {}

-- DEBUG --
Config.Debug = true

Config.Queues = {
    ['house_robbery'] = {
        queue_interval = 0.5, -- in mins
        is_active = true, -- is the queue active
        queue_select_chance = 60, -- percentage
        ['queue'] = {}
    },
    ['chop_shop'] = {
        queue_interval = 0.5,
        is_active = false,
        queue_select_chance = 60,
        ['queue'] = {}
    }
}
