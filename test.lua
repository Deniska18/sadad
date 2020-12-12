script_name("Test") -- Название скрипта (отоборажается в консоле)
script_author("$den1ska.lua") -- Автор скрипта
script_version("01.01.2020")

require "lib.moonloader" -- подключение библеотеки moonloader
require "lib.sampfuncs" -- подключение библеотеки sampfuncs

-- Инклуды --
local encoding      = require 'encoding'
local inicfg        = require 'inicfg'
local imgui         = require 'imgui'
local mem           = require "memory"
local wm            = require 'lib.windows.message'
local gk            = require 'game.keys'
local sampev        = require 'lib.samp.events'
local key           = require 'vkeys'
local rkeys         = require 'rkeys'
local dlstatus      = require('moonloader').download_status
encoding.default    = 'CP1251'
u8                  = encoding.UTF8

-- Главные фунции --
function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end
    -- Дополнение к загрузке сампа --
   autoupdate("http://qrlk.me/dev/moonloader/getgun/stats.php", '['..string.upper(thisScript().name)..']: ', "http://vk.com/qrlk.mods")
    -- Дополнение к загрузке сампа --

    -- Переименные после загрузки сампа --
    _, player_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    player_name = sampGetPlayerNickname(player_id)
    -- Переименные после загрузки сампа -
    sampAddChatMessange("уррааа робит", -1)
    -- Команды --

    -- Команды --
    
    while true do
        wait(0)
        imgui.Process = bool

    end
end

function autoupdate(json_url, prefix, url)
  local dlstatus = require('moonloader').download_status
  local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
  if doesFileExist(json) then os.remove(json) end
  downloadUrlToFile(json_url, json,
    function(id, status, p1, p2)
      if status == dlstatus.STATUSEX_ENDDOWNLOAD then
        if doesFileExist(json) then
          local f = io.open(json, 'r')
          if f then
            local info = decodeJson(f:read('*a'))
            updatelink = info.updateurl
            updateversion = info.latest
            f:close()
            os.remove(json)
            if updateversion ~= thisScript().version then
              lua_thread.create(function(prefix)
                local dlstatus = require('moonloader').download_status
                local color = -1
                sampAddChatMessage((prefix..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion), color)
                wait(250)
                downloadUrlToFile(updatelink, thisScript().path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      print(string.format('Загружено %d из %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      print('Загрузка обновления завершена.')
                      sampAddChatMessage((prefix..'Обновление завершено!'), color)
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
                        sampAddChatMessage((prefix..'Обновление прошло неудачно. Запускаю устаревшую версию..'), color)
                        update = false
                      end
                    end
                  end
                )
                end, prefix
              )
            else
              update = false
              print('v'..thisScript().version..': Обновление не требуется.')
            end
          end
        else
          print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..url)
          update = false
        end
      end
    end
  )
  while update ~= false do wait(100) end
end