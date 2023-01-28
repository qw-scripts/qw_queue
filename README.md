# qw_queue

Standalone SIRO queueing system for FiveM

## Config

```lua
Config = {}

-- DEBUG --
Config.Debug = true

Config.Queues = {
    ['house_robbery'] = {
        queue_interval = 0.5, -- in mins (How often this queue will be serviced)
        is_active = true, -- is the queue active
        queue_select_chance = 60, -- percentage chance for a queue member to be selected
        ['queue'] = {} -- needed for every queue you create
    },
    ['chop_shop'] = {
        queue_interval = 0.5,
        is_active = false,
        queue_select_chance = 60,
        ['queue'] = {}
    }
}
```

## Exported Functions

```lua
-- Adds an identifier to the selected queue

---@param queueName string
---@param ident number|string
---@return boolean, table, string|nil
AddIdentToQueue(queueName, ident)

-- Example

local success, queue, errorMessage = exports['qw_queue']:AddIdentToQueue('house_robbery', src)

if success and queue then
    print(queue)
else
    print(errorMessage)
end
```

```lua
-- Removes an identifier from the selected queue

---@param queueName string
---@param ident number|string
---@return boolean, table, string|nil
RemoveIdentFromQueue(queueName, ident)

-- Example

local success, queue, errorMessage = exports['qw_queue']:RemoveIdentFromQueue('house_robbery', src)

if success and queue then
    print(queue)
else
    print(errorMessage)
end
```

```lua
-- Updates queue data for a identifier to the selected queue

---@param queueName string
---@param ident number|string
---@param data table
---@return boolean, table, string|nil
UpdateQueueDataForIdent(queueName, ident, data)

-- Example

local success, queue, errorMessage = exports['qw_queue']:UpdateQueueDataForIdent('house_robbery', src, { is_waiting = false })

if success and queue then
    print(queue)
else
    print(errorMessage)
end
```

```lua
-- Gets queue data for a identifier to the selected queue

---@param queueName string
---@param ident number|string
---@return table|boolean
GetIdentQueueInfo(queueName, ident)

-- Example

local queueInfo = exports['qw_queue']:GetIdentQueueInfo('house_robbery', src)

if queueInfo then
    print(queueInfo)
else
    print('No Info found')
end
```

```lua
-- Updates queue data for a identifier to the selected queue

---@param queueName string
---@param ident number|string
---@return boolean
IsIdentInQueue(queueName, ident)

-- Example

local isInQueue = exports['qw_queue']:IsIdentInQueue('house_robbery', src)

if isInQueue then
    print('In Queue')
else
    print('Not in Queue')
end
```

## Net Events

```lua
-- qw_queue:server:addToQueue

AddEventHandler('qw_queue:server:addToQueue', function(queueName, ident)
    print(queueName, ident)
end)
```

```lua
-- qw_queue:server:removeFromQueue

AddEventHandler('qw_queue:server:removeFromQueue', function(queueName, ident)
    print(queueName, ident)
end)
```

```lua
-- qw_queue:server:queueDataUpdated

AddEventHandler('qw_queue:server:queueDataUpdated', function(queueName, ident, data)
    print(queueName, ident, data)
end)
```
