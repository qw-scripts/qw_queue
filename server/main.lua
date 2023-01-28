local queues = {}

function GenerateQueueStructure()
    for k, v in pairs(Config.Queues) do
        queues[k] = v
    end
end

---@param queueName string
---@param ident number|string
---@return boolean, table, string|nil
function AddIdentToQueue(queueName, ident)
    if not queues[queueName] then return false, {}, 'Queue Does not Exist' end
    if not queues[queueName].is_active then return false, {}, 'Queue is not Active' end

    if queues[queueName]['queue'][ident] then return false, {}, 'Already in Queue' end


    queues[queueName]['queue'][ident] = {
        is_waiting = true
    }

    TriggerEvent('qw_queue:server:addToQueue', queueName, ident) -- NetEvent to listen for when a ident is added to a specific queue
    return true, queues[queueName], nil
end

exports('AddIdentToQueue', AddIdentToQueue)



---@param queueName string
---@param ident number|string
---@return boolean, table, string|nil
function RemoveIdentFromQueue(queueName, ident)
    if not queues[queueName] then return false, {}, 'Queue Does not Exist' end
    if not queues[queueName].is_active then return false, {}, 'Queue is not Active' end

    if not queues[queueName]['queue'][ident] then return false, {}, 'Ident does not exist in that queue' end


    queues[queueName]['queue'][ident] = nil

    TriggerEvent('qw_queue:server:removeFromQueue', queueName, ident) -- NetEvent to listen for when a ident is removed from a specific queue
    return true, queues[queueName], nil
end

exports('RemoveIdentFromQueue', RemoveIdentFromQueue)



---@param queueName string
---@param ident number|string
---@param data table
---@return boolean, table, string|nil
function UpdateQueueDataForIdent(queueName, ident, data)
    if not queues[queueName] then return false, {}, 'Queue Does not Exist' end
    if not queues[queueName].is_active then return false, {}, 'Queue is not Active' end

    if not queues[queueName]['queue'][ident] then return false, {}, 'Ident does not exist in that queue' end

    queues[queueName]['queue'][ident] = data

    TriggerEvent('qw_queue:server:queueDataUpdated', queueName, ident, data)

    return true, queues[queueName]['queue'][ident], nil
end

exports('UpdateQueueDataForIdent', UpdateQueueDataForIdent)



---@param queueName string
---@param ident number|string
---@return table|boolean
function GetIdentQueueInfo(queueName, ident)

    if not queues[queueName] then return false end
    if not queues[queueName]['queue'][ident] then return false end

    local queueInfo = queues[queueName]['queue'][ident]

    return queueInfo

end

exports('GetIdentQueueInfo', GetIdentQueueInfo)

---@param queueName string
---@param ident number|string
---@return boolean
function IsIdentInQueue(queueName, ident)
    if not queues[queueName] then return false end
    if not queues[queueName]['queue'][ident] then return false end

    return true
end

exports('IsIdentInQueue', IsIdentInQueue)

function QueueObserver()
    for k, v in pairs(queues) do
        if v.is_active then
            CreateThread(function()
                while true do
                    if Config.Debug then print('Observing Queue: ' .. k) end
                    for ident, queueInfo in pairs(v['queue']) do
                        if queueInfo.is_waiting then
                            local isGettingSelected = math.random(1, 100) < v.queue_select_chance

                            if isGettingSelected then
                                local success, identData, _ = UpdateQueueDataForIdent(k, ident, { is_waiting = false })

                                if success and identData then
                                    if Config.Debug then print(ident .. ' has been selected from the ' .. k .. ' queue') end
                                    goto continue
                                end
                            else
                                if Config.Debug then print(ident .. ' is not getting selected from the ' .. k .. ' queue') end
                            end
                        end
                    end

                    ::continue::
                    Wait(v.queue_interval * 60000)
                end
            end)
        end
    end
end

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        GenerateQueueStructure()
        Wait(1000)
        QueueObserver()
    end
end)
