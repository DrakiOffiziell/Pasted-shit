--Pasted by draki_offiziell
--stand.dll aka Lena helped me with my paste, thx to her
--pasted from addict and themilkman and some french guy



if async_http.have_access() then
	local SCRIPT_VERSION = '0.2'
	local resp = false
	async_http.init(
		'raw.githubusercontent.com/DrakiOffiziell/Pasted-shit/main/version',
		nil,
		function(body, headers, status_code)
			if soup.version_compare(SCRIPT_VERSION, body) == -1 then
				menu.my_root():action(
					'Update Script',
					{},
					$"\"{body}\" is available, you are currently on \"{SCRIPT_VERSION}\".",
					function()
						async_http.init(
						'raw.githubusercontent.com/DrakiOffiziell/Pasted-shit/main/Best Money Lua pasted by draki_offiziell.lua',
						nil,
						function(body_)
							local f = assert(io.open($'{filesystem.scripts_dir()}{SCRIPT_RELPATH}', 'wb'))
							assert(f:write(body_))
							f:close()
							util.restart_script()
						end)
						async_http.dispatch()
					end
				)
				menu.my_root():divider('')
			end
			resp = true
		end,
		function()
			resp = true
		end
	)
	async_http.dispatch()
	repeat
		util.yield()
	until resp
end




util.keep_running()
util.require_natives(1672190175)
local root = menu.my_root()
--shameless skidded from MB
local function SetGlobalInt(address, value)
    memory.write_int(memory.script_global(address), value)
end

if not SCRIPT_SILENT_START then
    util.toast("Pasted by Draki")
end


local objtab = {}
local vsh
local psh
local obj_shot
local function vshot(hash, camcoords, CV, rot)
    if not ENTITY.DOES_ENTITY_EXIST(vsh) then
        vsh = entities.create_vehicle(hash, camcoords, CV)
        ENTITY.SET_ENTITY_ROTATION(vsh, rot.x, rot.y, rot.z, 0, true)
        VEHICLE.SET_VEHICLE_FORWARD_SPEED(vsh, 1000)
        VEHICLE.SET_VEHICLE_DOORS_LOCKED_FOR_ALL_PLAYERS(vsh, true)
        VEHICLE.SET_VEHICLE_DOORS_LOCKED_FOR_NON_SCRIPT_PLAYERS(vsh, true)
        table.insert(objtab, vsh)
    else
        local veh_sec = entities.create_vehicle(hash, camcoords, CV)
        ENTITY.SET_ENTITY_ROTATION(veh_sec, rot.x, rot.y, rot.z, 0, true)
        VEHICLE.SET_VEHICLE_FORWARD_SPEED(veh_sec, 1000)
        VEHICLE.SET_VEHICLE_DOORS_LOCKED_FOR_ALL_PLAYERS(vsh, true)
        VEHICLE.SET_VEHICLE_DOORS_LOCKED_FOR_NON_SCRIPT_PLAYERS(vsh, true)
        table.insert(objtab, veh_sec)
    end
end

local function pshot(hash, camcoords, CV, rot)
    if not ENTITY.DOES_ENTITY_EXIST(psh) then
        psh = entities.create_ped(1, hash, camcoords, CV)
        ENTITY.SET_ENTITY_INVINCIBLE(psh, true)
        util.yield(30)
        ENTITY.SET_ENTITY_ROTATION(psh, rot.x, rot.y, rot.z, 0, true)
        ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(psh, 1, 0, 5000, 0, 0, true, true, true, true)
        table.insert(objtab, psh)
    else
        local sped = entities.create_ped(1, hash, camcoords, CV)
        ENTITY.SET_ENTITY_INVINCIBLE(sped, true)
        util.yield(30)
        ENTITY.SET_ENTITY_ROTATION(sped, rot.x, rot.y, rot.z, 0, true)
        ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(sped, 1, 0, 5000, 0, 0, true, true, true, true)
        table.insert(objtab, sped)
    end
end
local function oshot(hash, camcoords, rot)
    if not ENTITY.DOES_ENTITY_EXIST(obj_shot) then
        local objs = OBJECT.CREATE_OBJECT(hash, camcoords.x, camcoords.y, camcoords.z, true, true, true)
        ENTITY.SET_ENTITY_NO_COLLISION_ENTITY(objs, players.user_ped(), false)
        util.yield(20)
        ENTITY.SET_ENTITY_ROTATION(objs, rot.x, rot.y, rot.z, 0, true)
        
        ENTITY.APPLY_FORCE_TO_ENTITY(objs, 2, camcoords.x ,  15000, camcoords.z , 0, 0, 0, 0,  true, false, true, false, true)
        table.insert(objtab, objs)
        else
            local sobjs = OBJECT.CREATE_OBJECT(hash, camcoords.x, camcoords.y, camcoords.z, true, true, true)
            ENTITY.SET_ENTITY_NO_COLLISION_ENTITY(sobjs, players.user_ped(), false)
            util.yield(20)
            ENTITY.SET_ENTITY_ROTATION(sobjs, rot.x, rot.y, rot.z, 0, true)
            ENTITY.APPLY_FORCE_TO_ENTITY(sobjs, 2, camcoords.x ,  15000, camcoords.z , 0, 0, 0, 0,  true, false, true, false, true)
            table.insert(objtab, sobjs)
    end
end

local function objshots(hash, obj, camcoords)
    local CV = CAM.GET_GAMEPLAY_CAM_RELATIVE_HEADING()
    local rot = CAM.GET_GAMEPLAY_CAM_ROT(0)
    if STREAMING.IS_MODEL_A_VEHICLE(hash) then
        vshot(hash, camcoords, CV, rot)
        
        for i, car in ipairs(objtab) do
            if obj.expl then
                if ENTITY.HAS_ENTITY_COLLIDED_WITH_ANYTHING(car) then
                    local expcoor = ENTITY.GET_ENTITY_COORDS(car)
                    FIRE.ADD_EXPLOSION(expcoor.x, expcoor.y, expcoor.z, 81, 5000, true, false, 0.0, false)
                    entities.delete_by_handle(car)
                end
            end
            if i >= 150 then
                for index, vehs in ipairs(objtab) do
                    entities.delete_by_handle(vehs)
                    objtab ={}
                end
            end
            local carc = ENTITY.GET_ENTITY_COORDS(car)
            local tar2 = ENTITY.GET_ENTITY_COORDS(players.user_ped())
            local disbet = SYSTEM.VDIST2(tar2.x, tar2.y, tar2.z, carc.x, carc.y, carc.z)
            if disbet > 15000 then
                entities.delete_by_handle(car)
            end
        end

    elseif STREAMING.IS_MODEL_A_PED(hash) then
       pshot(hash, camcoords, CV, rot)
        for i, psho in ipairs(objtab) do
        if obj.expl then
            if ENTITY.HAS_ENTITY_COLLIDED_WITH_ANYTHING(psho) then
                local expcoor = ENTITY.GET_ENTITY_COORDS(psho)
                FIRE.ADD_EXPLOSION(expcoor.x, expcoor.y, expcoor.z, 81, 5000, true, false, 0.0, false)
                entities.delete_by_handle(psho)
            end
            local pedc = ENTITY.GET_ENTITY_COORDS(psh)
            local tar2 = ENTITY.GET_ENTITY_COORDS(players.user_ped())
            local disbet = SYSTEM.VDIST2(tar2.x, tar2.y, tar2.z, pedc.x, pedc.y, pedc.z)
            if disbet > 15000 then
                entities.delete_by_handle(psh)
            end
        end
        if i >= 40 then
            for index, p_shot in ipairs(objtab) do
                entities.delete_by_handle(p_shot)
                objtab ={}
            end
        end
    end
    elseif STREAMING.IS_MODEL_VALID(hash) then
    oshot(hash, camcoords, rot)
    for i, objs in ipairs(objtab) do
        if obj.expl then
            if ENTITY.HAS_ENTITY_COLLIDED_WITH_ANYTHING(objs) then
                local expcoor = ENTITY.GET_ENTITY_COORDS(objs)
                FIRE.ADD_EXPLOSION(expcoor.x, expcoor.y, expcoor.z, 81, 5000, true, false, 0.0, false)
                entities.delete_by_handle(objs)
            end
                local objc = ENTITY.GET_ENTITY_COORDS(objs)
                local tar2 = ENTITY.GET_ENTITY_COORDS(players.user_ped())
                local disbet = SYSTEM.VDIST2(tar2.x, tar2.y, tar2.z, objc.x, objc.y, objc.z)
                if disbet > 15000 then
                    entities.delete_by_handle(objs)
                end
            end
            if i >= 40 then
                for index, p_shot in ipairs(objtab) do
                    entities.delete_by_handle(p_shot)
                    objtab ={}
                end
            end
        end
    end
end

function Streament(hash)
    STREAMING.REQUEST_MODEL(hash)
    while STREAMING.HAS_MODEL_LOADED(hash) ==false do
    util.yield()
    end
end

local next_preview
local image_preview
local function rotation_to_direction(rotation)
    local adjusted_rotation =
    {
        x = (math.pi / 180) * rotation.x,
        y = (math.pi / 180) * rotation.y,
        z = (math.pi / 180) * rotation.z
    }
    local direction =
    {
        x = -math.sin(adjusted_rotation.z) * math.abs(math.cos(adjusted_rotation.x)),
        y =  math.cos(adjusted_rotation.z) * math.abs(math.cos(adjusted_rotation.x)),
        z =  math.sin(adjusted_rotation.x)
    }
    return direction
end
local function get_offset_from_camera(distance)
    local cam_rot = CAM.GET_FINAL_RENDERED_CAM_ROT(0)
    local cam_pos = CAM.GET_FINAL_RENDERED_CAM_COORD()
    local direction = rotation_to_direction(cam_rot)
    local destination =
    {
        x = cam_pos.x + direction.x * distance,
        y = cam_pos.y + direction.y * distance,
        z = cam_pos.z + direction.z * distance
    }
    return destination
end

local function objams(obj_hash, obj, camcoords)
    local CV = CAM.GET_GAMEPLAY_CAM_RELATIVE_HEADING()
    if STREAMING.IS_MODEL_A_VEHICLE(obj_hash) then
        obj.prev = VEHICLE.CREATE_VEHICLE(obj_hash, camcoords.x, camcoords.y, camcoords.z, CV, true, true, false)
        ENTITY.SET_ENTITY_NO_COLLISION_ENTITY(obj.prev, players.user_ped(), false)
      elseif STREAMING.IS_MODEL_A_PED(obj_hash) then
        obj.prev = entities.create_ped(1, obj_hash, camcoords, CV)
        ENTITY.SET_ENTITY_NO_COLLISION_ENTITY(obj.prev, players.user_ped(), false)
      elseif STREAMING.IS_MODEL_VALID(obj_hash) then
        obj.prev = OBJECT.CREATE_OBJECT(obj_hash, camcoords.x, camcoords.y, camcoords.z, true, true, true)
        ENTITY.SET_ENTITY_NO_COLLISION_ENTITY(obj.prev, players.user_ped(), false)
    end
end

SEC = ENTITY.SET_ENTITY_COORDS


local function player(pid)
    menu.divider(menu.player_root(pid), "Money things")

	moneydrop = menu.list(menu.player_root(pid), "Money Drop settings", {""}, "")

    local PenisZerstörer_delay = 2500

    menu.click_slider(moneydrop, "Delay (ms)", {}, "", 100, 10000, PenisZerstörer_delay, 500, function(val)
        PenisZerstörer_delay = val
    end)

	
	
    moneydrop = menu.toggle_loop(menu.player_root(pid), "Drop the Money", {""}, "it is recommended to put the delay to 3500, so no transaction error appears", function(toggled)
        local coords = players.get_position(pid)
        local cash = MISC.GET_HASH_KEY("PICKUP_VEHICLE_MONEY_VARIABLE")
        coords.z = coords.z + 1.5
        STREAMING.REQUEST_MODEL(cash)
        if STREAMING.HAS_MODEL_LOADED(cash) == false then  
            STREAMING.REQUEST_MODEL(cash)
        end
        OBJECT.CREATE_AMBIENT_PICKUP(1704231442, coords.x, coords.y, coords.z, 0, 2000, cash, false, true)
        util.yield(PenisZerstörer_delay)
    end)
	
	menu.toggle_loop(menu.player_root(pid), "Drop the levels loop", {""}, "", function(toggled)
        local coords = players.get_position(pid)
        coords.z = coords.z + 1.5
        local random_hash = 0x4D6514A3
        local random_int = math.random(1, 8)
        if random_int == 1 then
            random_hash = 0x4D6514A3
        elseif random_int == 2 then
            random_hash = 0x748F3A2A
        elseif random_int == 3 then
            random_hash = 0x1A9736DA
        elseif random_int == 4 then
            random_hash = 0x3D1B7A2F
        elseif random_int == 5 then
            random_hash = 0x1A126315
        elseif random_int == 6 then
            random_hash = 0xD937A5E9
        elseif random_int == 7 then
            random_hash = 0x23DDE6DB
        elseif random_int == 8 then
            random_hash = 0x991F8C36
        end
        STREAMING.REQUEST_MODEL(random_hash)
        if STREAMING.HAS_MODEL_LOADED(random_hash) == false then  
            STREAMING.REQUEST_MODEL(random_hash)
        end
        OBJECT.CREATE_AMBIENT_PICKUP(-1009939663, coords.x, coords.y, coords.z, 0, 1, random_hash, false, true)
        util.yield(500)
	end)
end 



menu.divider(root, "Reports")

local root = menu.my_root()
menu.action(root,"delete report", {}, "", function()
util.toast("Successfully deleted reports, you are safe now!") -- ;)
    STATS.STAT_SET_INT("MPPLY_REPORT_STRENGTH", 0)
    STATS.STAT_SET_INT("MPPLY_COMMEND_STRENGTH", 0)
    STATS.STAT_SET_INT("MPPLY_GRIEFING", 0)
    STATS.STAT_SET_INT("MPPLY_VC_ANNOYINGME", 0)
    STATS.STAT_SET_INT("MPPLY_VC_HATE", 0)
    STATS.STAT_SET_INT("MPPLY_TC_ANNOYINGME", 0)
    STATS.STAT_SET_INT("MPPLY_TC_HATE", 0)
    STATS.STAT_SET_INT("MPPLY_OFFENSIVE_LANGUAGE", 0)
    STATS.STAT_SET_INT("MPPLY_OFFENSIVE_TAGPLATE", 0)
    STATS.STAT_SET_INT("MPPLY_OFFENSIVE_UGC", 0)
    STATS.STAT_SET_INT("MPPLY_BAD_CREW_NAME", 0)
    STATS.STAT_SET_INT("MPPLY_BAD_CREW_MOTTO", 0)
    STATS.STAT_SET_INT("MPPLY_BAD_CREW_STATUS", 0)
    STATS.STAT_SET_INT("MPPLY_BAD_CREW_EMBLEM", 0)
    STATS.STAT_SET_INT("MPPLY_EXPLOITS", 0)
    STATS.STAT_SET_INT("MPPLY_BECAME_BADSPORT_NUM", 0)
    STATS.STAT_SET_INT("MPPLY_DESTROYED_PVEHICLES", 0)
    STATS.STAT_SET_INT("MPPLY_BECAME_CHEATER_NUM", 0)
    STATS.STAT_SET_INT("MPPLY_BADSPORT_MESSAGE", 0)
    STATS.STAT_SET_INT("MPPLY_GAME_EXPLOITS", 0)
    STATS.STAT_SET_INT("MPPLY_PLAYER_MENTAL_STATE", 0)
    STATS.STAT_SET_INT("MPPLY_PLAYERMADE_TITLE", 0)
    STATS.STAT_SET_INT("MPPLY_PLAYERMADE_DESC", 0)
    STATS.STAT_SET_BOOL("MPPLY_ISPUNISHED", false)
    STATS.STAT_SET_BOOL("MPPLY_WAS_I_BAD_SPORT", false)
    STATS.STAT_SET_BOOL("MPPLY_WAS_I_CHEATER", false)
    STATS.STAT_SET_BOOL("MPPLY_CHAR_IS_BADSPORT", false)
    STATS.STAT_SET_INT("MPPLY_OVERALL_BADSPORT", 0)
    STATS.STAT_SET_INT("MPPLY_OVERALL_CHEAT", 0)
end)

menu.divider(root, "Money Loops")

function trigger_transaction(hash, amount)
    SetGlobalInt(4536533+ 1, 2147483646)
    SetGlobalInt(4536533+ 7, 2147483647)
    SetGlobalInt(4536533+ 6, 0)
    SetGlobalInt(4536533+ 5, 0)
    SetGlobalInt(4536533+ 3, hash)
    SetGlobalInt(4536533+ 2, amount)
    SetGlobalInt(4536533,2)
	end
	
	
   
menu.toggle_loop(menu.my_root(),"1M Loop (RECOMMENDED)", {}, "", function()
    trigger_transaction(0x615762F1, 1000000)
	util.yield()
end)



menu.toggle_loop(menu.my_root(),"50K Loop", {}, "", function()
    trigger_transaction(0x610F9AB4, 50000)
	util.yield()
end)

menu.toggle_loop(menu.my_root(),"40m Loop (slow)", {}, "", function()
    trigger_transaction(0x176D9D54, 15000000)
	trigger_transaction(0xED97AFC1, 7000000)
	trigger_transaction(0xA174F633, 15000000)
	trigger_transaction(0x314FB8B0, 1000000)
	trigger_transaction(0x4B6A869C, 2000000)
	util.yield(40000)
end)

menu.action(menu.my_root(), "Biggest Money Explosion in your bank/wallet (idk how safe)", {}, "PRESS ONLY ONCE!!! or more idk", function()
    trigger_transaction(joaat("SERVICE_EARN_JOB_BONUS"), 15000000)
    trigger_transaction(joaat("SERVICE_EARN_BEND_JOB"), 15000000)
    trigger_transaction(joaat("SERVICE_EARN_GANGOPS_AWARD_MASTERMIND_4"), 15000000    )    
    trigger_transaction(joaat("SERVICE_EARN_JOB_BONUS_CRIMINAL_MASTERMIND"), 15000000  )
    trigger_transaction(joaat("SERVICE_EARN_GANGOPS_AWARD_MASTERMIND_3"), 7000000)
    trigger_transaction(joaat("SERVICE_EARN_CASINO_HEIST_FINALE"), 3619000)
    trigger_transaction(joaat("SERVICE_EARN_AGENCY_STORY_FINALE"), 3000000)
    trigger_transaction(joaat("SERVICE_EARN_GANGOPS_AWARD_MASTERMIND_2"), 3000000)
    trigger_transaction(joaat("SERVICE_EARN_ISLAND_HEIST_FINALE"), 2550000)
    trigger_transaction(joaat("SERVICE_EARN_GANGOPS_FINALE"), 2550000)
    trigger_transaction(joaat("SERVICE_EARN_JOB_BONUS_HEIST_AWARD"), 2000000)
    trigger_transaction(joaat("SERVICE_EARN_TUNER_ROBBERY_FINALE"), 2000000)
    trigger_transaction(joaat("SERVICE_EARN_GANGOPS_AWARD_ORDER"), 2000000)
    trigger_transaction(joaat("SERVICE_EARN_FROM_BUSINESS_HUB_SELL"), 2000000)
    trigger_transaction(joaat("SERVICE_EARN_GANGOPS_AWARD_LOYALTY_AWARD_4"), 1500000  )
    trigger_transaction(joaat("SERVICE_EARN_BOSS_AGENCY"), 1200000)
    trigger_transaction(joaat("SERVICE_EARN_DAILY_OBJECTIVES"), 1000000)
    trigger_transaction(joaat("SERVICE_EARN_MUSIC_STUDIO_SHORT_TRIP"), 1000000)
    trigger_transaction(joaat("SERVICE_EARN_DAILY_OBJECTIVE_EVENT"), 1000000)
    trigger_transaction(joaat("SERVICE_EARN_JUGGALO_STORY_MISSION"), 1000000)
    trigger_transaction(joaat("SERVICE_EARN_GANGOPS_AWARD_LOYALTY_AWARD_3"), 700000   )
    trigger_transaction(joaat("SERVICE_EARN_BETTING"), 680000)
    trigger_transaction(joaat("SERVICE_EARN_FROM_VEHICLE_EXPORT"), 620000)
    trigger_transaction(joaat("SERVICE_EARN_ISLAND_HEIST_AWARD_MIXING_IT_UP"), 500000)
    trigger_transaction(joaat("SERVICE_EARN_WINTER_22_AWARD_JUGGALO_STORY"), 500000)
    trigger_transaction(joaat("SERVICE_EARN_CASINO_AWARD_STRAIGHT_FLUSH"), 500000)
    trigger_transaction(joaat("SERVICE_EARN_ISLAND_HEIST_AWARD_PROFESSIONAL"), 400000)
    trigger_transaction(joaat("SERVICE_EARN_ISLAND_HEIST_AWARD_CAT_BURGLAR"), 400000)
    trigger_transaction(joaat("SERVICE_EARN_ISLAND_HEIST_AWARD_ELITE_THIEF"), 400000)
    trigger_transaction(joaat("SERVICE_EARN_ISLAND_HEIST_AWARD_THE_ISLAND_HEIST"), 400000)
    trigger_transaction(joaat("SERVICE_EARN_CASINO_HEIST_AWARD_ELITE_THIEF"), 350000)
    trigger_transaction(joaat("SERVICE_EARN_AMBIENT_JOB_BLAST"), 300000)
    trigger_transaction(joaat("SERVICE_EARN_PREMIUM_JOB"), 300000)
    trigger_transaction(joaat("SERVICE_EARN_GANGOPS_AWARD_LOYALTY_AWARD_2"), 300000)
    trigger_transaction(joaat("SERVICE_EARN_CASINO_HEIST_AWARD_ALL_ROUNDER"), 300000)
    trigger_transaction(joaat("SERVICE_EARN_ISLAND_HEIST_AWARD_PRO_THIEF"), 300000)
    trigger_transaction(joaat("SERVICE_EARN_YOHAN_SOURCE_GOODS"), 300000)
    trigger_transaction(joaat("SERVICE_EARN_SMUGGLER_AGENCY"), 270000)
    trigger_transaction(joaat("SERVICE_EARN_FIXER_AWARD_AGENCY_STORY"), 250000)
    trigger_transaction(joaat("SERVICE_EARN_CASINO_HEIST_AWARD_PROFESSIONAL"), 250000)
    trigger_transaction(joaat("SERVICE_EARN_GANGOPS_AWARD_SUPPORTING"), 200000)
    trigger_transaction(joaat("SERVICE_EARN_COLLECTABLES_ACTION_FIGURES"), 200000)
    trigger_transaction(joaat("SERVICE_EARN_ISLAND_HEIST_AWARD_GOING_ALONE"), 200000)
    trigger_transaction(joaat("SERVICE_EARN_JOB_BONUS_FIRST_TIME_BONUS"), 200000)
    trigger_transaction(joaat("SERVICE_EARN_GANGOPS_AWARD_FIRST_TIME_XM_SILO"), 200000)
    trigger_transaction(joaat("SERVICE_EARN_DOOMSDAY_FINALE_BONUS"), 200000)
    trigger_transaction(joaat("SERVICE_EARN_GANGOPS_AWARD_FIRST_TIME_XM_BASE"), 200000)
    trigger_transaction(joaat("SERVICE_EARN_COLLECTABLE_COMPLETED_COLLECTION"), 200000)
    trigger_transaction(joaat("SERVICE_EARN_ISLAND_HEIST_ELITE_CHALLENGE"), 200000)
    trigger_transaction(joaat("SERVICE_EARN_AMBIENT_JOB_CHECKPOINT_COLLECTION"), 200000)
    trigger_transaction(joaat("SERVICE_EARN_GANGOPS_AWARD_FIRST_TIME_XM_SUBMARINE"), 200000)
    trigger_transaction(joaat("SERVICE_EARN_ISLAND_HEIST_AWARD_TEAM_WORK"), 200000)
    trigger_transaction(joaat("SERVICE_EARN_CASINO_HEIST_ELITE_DIRECT"), 200000)
    trigger_transaction(joaat("SERVICE_EARN_CASINO_HEIST_ELITE_STEALTH"), 200000)
    trigger_transaction(joaat("SERVICE_EARN_AMBIENT_JOB_TIME_TRIAL"), 200000)
    trigger_transaction(joaat("SERVICE_EARN_CASINO_HEIST_AWARD_UNDETECTED"), 200000)
    trigger_transaction(joaat("SERVICE_EARN_CASINO_HEIST_ELITE_SUBTERFUGE"), 200000)
    trigger_transaction(joaat("SERVICE_EARN_GANGOPS_ELITE_XM_SILO"), 200000)
    trigger_transaction(joaat("SERVICE_EARN_VEHICLE_SALES"), 190000)
    trigger_transaction(joaat("SERVICE_EARN_JOBS"), 180000)
    trigger_transaction(joaat("SERVICE_EARN_AMBIENT_JOB_RC_TIME_TRIAL"), 165000)
    trigger_transaction(joaat("SERVICE_EARN_AMBIENT_JOB_BEAST"), 150000)
    trigger_transaction(joaat("SERVICE_EARN_CASINO_HEIST_AWARD_IN_PLAIN_SIGHT"), 150000)
    trigger_transaction(joaat("SERVICE_EARN_AMBIENT_JOB_SOURCE_RESEARCH"), 150000)
    trigger_transaction(joaat("SERVICE_EARN_GANGOPS_ELITE_XM_SUBMARINE"), 150000)
    trigger_transaction(joaat("SERVICE_EARN_AMBIENT_JOB_KING"), 120000)
    trigger_transaction(joaat("SERVICE_EARN_AMBIENT_JOB_PENNED_IN"), 120000)
    trigger_transaction(joaat("SERVICE_EARN_SIGHTSEEING_REWARD"), 115000)
    trigger_transaction(joaat("SERVICE_EARN_CASINO_AWARD_HIGH_ROLLER_PLATINUM"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_TUNER_AWARD_BOLINGBROKE_ASS"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_CASINO_AWARD_FULL_HOUSE"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_AGENCY_SECURITY_CONTRACT"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_DAILY_STASH_HOUSE_COMPLETED"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_CASINO_AWARD_MISSION_SIX_FIRST_TIME"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_AMBIENT_JOB_CHALLENGES"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_AMBIENT_JOB_METAL_DETECTOR"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_AMBIENT_JOB_HOT_PROPERTY"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_AMBIENT_JOB_CLUBHOUSE_CONTRACT"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_TUNER_AWARD_FLEECA_BANK"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_AMBIENT_JOB_SMUGGLER_PLANE"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_FIXER_AWARD_SHORT_TRIP"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_AMBIENT_JOB_SMUGGLER_TRAIL"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_TUNER_AWARD_METH_JOB"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_CASINO_HEIST_AWARD_SMASH_N_GRAB"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_AGENCY_STORY_PREP"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_WINTER_22_AWARD_DAILY_STASH"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_JUGGALO_PHONE_MISSION"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_AMBIENT_JOB_GOLDEN_GUN"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_AMBIENT_JOB_URBAN_WARFARE"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_AGENCY_PAYPHONE_HIT"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_TUNER_AWARD_FREIGHT_TRAIN"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_WINTER_22_AWARD_DEAD_DROP"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_CLUBHOUSE_DUFFLE_BAG"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_WINTER_22_AWARD_RANDOM_EVENT"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_TUNER_AWARD_MILITARY_CONVOY"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_JUGGALO_STORY_MISSION_PARTICIPATION"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_AMBIENT_JOB_CRIME_SCENE"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_TUNER_AWARD_IAA_RAID"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_ARENA_CAREER_TIER_PROGRESSION_4"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_AUTO_SHOP_DELIVERY_AWARD"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_CASINO_AWARD_TOP_PAIR"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_TUNER_AWARD_UNION_DEPOSITORY"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_AMBIENT_JOB_UNDERWATER_CARGO"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_COLLECTABLE_ITEM"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_WINTER_22_AWARD_ACID_LAB"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_AMBIENT_JOB_MAZE_BANK"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_GANGOPS_ELITE_XM_BASE"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_WINTER_22_AWARD_TAXI"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_TUNER_DAILY_VEHICLE_BONUS"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_TUNER_AWARD_BUNKER_RAID"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_AMBIENT_JOB_AMMUNATION_DELIVERY"), 100000)
    trigger_transaction(joaat("SERVICE_EARN_GANGOPS_SETUP"), 90000)
    trigger_transaction(joaat("SERVICE_EARN_AMBIENT_JOB_DEAD_DROP"), 80000)
    trigger_transaction(joaat("SERVICE_EARN_AMBIENT_JOB_HOT_TARGET_DELIVER"), 80000)
    trigger_transaction(joaat("SERVICE_EARN_ARENA_CAREER_TIER_PROGRESSION_3"), 75000)
    trigger_transaction(joaat("SERVICE_EARN_AMBIENT_JOB_XMAS_MUGGER"), 70000)
    trigger_transaction(joaat("SERVICE_EARN_IMPORT_EXPORT"), 65000)
    trigger_transaction(joaat("SERVICE_EARN_FROM_CLUB_MANAGEMENT_PARTICIPATION"), 60000)
    trigger_transaction(joaat("SERVICE_EARN_NIGHTCLUB_DANCING_AWARD"), 60000)
    trigger_transaction(joaat("SERVICE_EARN_ARENA_CAREER_TIER_PROGRESSION_2"), 55000)
    trigger_transaction(joaat("SERVICE_EARN_FROM_BUSINESS_BATTLE"), 50000)
    trigger_transaction(joaat("SERVICE_EARN_ISLAND_HEIST_DJ_MISSION"), 50000)
    trigger_transaction(joaat("SERVICE_EARN_ARENA_SKILL_LVL_AWARD"), 50000)
    trigger_transaction(joaat("SERVICE_EARN_AMBIENT_JOB_GANG_CONVOY"), 50000)
    trigger_transaction(joaat("SERVICE_EARN_COLLECTABLES_SIGNAL_JAMMERS_COMPLETE"), 50000)
    trigger_transaction(joaat("SERVICE_EARN_AMBIENT_JOB_HELI_HOT_TARGET"), 50000)
    trigger_transaction(joaat("SERVICE_EARN_ACID_LAB_SELL_PARTICIPATION"), 50000)
    trigger_transaction(joaat("SERVICE_EARN_FROM_CONTRABAND"), 50000)
    trigger_transaction(joaat("SERVICE_EARN_CASINO_AWARD_MISSION_THREE_FIRST_TIME"), 50000)
    trigger_transaction(joaat("SERVICE_EARN_GOON"), 50000)
    trigger_transaction(joaat("SERVICE_EARN_FIXER_AWARD_PHONE_HIT"), 50000)
    trigger_transaction(joaat("SERVICE_EARN_CASINO_AWARD_MISSION_FOUR_FIRST_TIME"), 50000)
    trigger_transaction(joaat("SERVICE_EARN_TAXI_JOB"), 50000)
    trigger_transaction(joaat("SERVICE_EARN_CASINO_AWARD_MISSION_ONE_FIRST_TIME"), 50000)
    trigger_transaction(joaat("SERVICE_EARN_AMBIENT_JOB_SHOP_ROBBERY"), 50000)
    trigger_transaction(joaat("SERVICE_EARN_ARENA_WAR"), 50000)
    trigger_transaction(joaat("SERVICE_EARN_CASINO_AWARD_MISSION_FIVE_FIRST_TIME"), 50000)
    trigger_transaction(joaat("SERVICE_EARN_CASINO_AWARD_LUCKY_LUCKY"), 50000)
    trigger_transaction(joaat("SERVICE_EARN_AMBIENT_JOB_PASS_PARCEL"), 50000)
    trigger_transaction(joaat("SERVICE_EARN_TUNER_CAR_CLUB_MEMBERSHIP"), 50000)
    trigger_transaction(joaat("SERVICE_EARN_CASINO_AWARD_MISSION_TWO_FIRST_TIME"), 50000)
    trigger_transaction(joaat("SERVICE_EARN_AMBIENT_JOB_HOT_TARGET_KILL"), 50000)

    
end)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
menu.divider(root, "Special Money things")

-- dbase = facility
-- businesshub = bunker

local items = {
    settings = {
        root = nil
    },
    presets = {
        root = nil,
        nightclub = {
            root = nil,
            choice = nil,
            afk = nil,
            first_nightclub = nil,
            second_nightclub = nil,
        },
        arcade = {
            root = nil,
            choice = nil
        },
        autoshop = {
            root = nil,
            choice = nil
        },
        agency = {
            root = nil,
            choice = nil
        },
        hanger = {
            root = nil,
            choice = nil
        },
        facility = {
            root = nil,
            choice = nil
        }
    },
    custom = {
        root = nil,
        nightclub = {
            root = nil
        },
        arcade = {
            root = nil
        },
        autoshop = {
            root = nil
        },
        agency = {
            root = nil
        },
        hanger = {
            root = nil
        },
        facility = {
            root = nil
        },
    },
    dax_mission = {
        root = nil,
    },
    casino_figures = {
        root = nil
    }
}

local settings = {
    ownership_check = true,
    verbose = false
}

local stats = {
    nightclub = util.joaat("mp" .. util.get_char_slot() .. "_prop_nightclub_value"),
    arcade = util.joaat("mp" .. util.get_char_slot() .. "_prop_arcade_value"),
    autoshop = util.joaat("mp" .. util.get_char_slot() .. "_prop_auto_shop_value"),
    agency = util.joaat("mp" .. util.get_char_slot() .. "_prop_fixer_hq_value"),
    hanger = util.joaat("mp" .. util.get_char_slot() .. "_prop_hangar_value"),
    office = util.joaat("mp" .. util.get_char_slot() .. "_prop_office_value"),
    bunker = util.joaat("mp" .. util.get_char_slot() .. "_prop_businesshub_value"), -- might not be correct
    facility = util.joaat("mp" .. util.get_char_slot() .. "_prop_defuncbase_value"),
    nightclub_owned = util.joaat("mp" .. util.get_char_slot() .. "_nightclub_owned"),
    arcade_owned = util.joaat("mp" .. util.get_char_slot() .. "_arcade_owned"),
    autoshop_owned = util.joaat("mp" .. util.get_char_slot() .. "_auto_shop_owned"),
    agency_owned = util.joaat("mp" .. util.get_char_slot() .. "_fixer_hq_owned"),
    hanger_owned = util.joaat("mp" .. util.get_char_slot() .. "_hangar_owned"),
    office_owned = util.joaat("mp" .. util.get_char_slot() .. "_office_owned"),
    bunker_owned = util.joaat("mp" .. util.get_char_slot() .. "_businesshub_owned"), -- might not be correct
    facility_owned = util.joaat("mp" .. util.get_char_slot() .. "_dbase_owned")
}

local property_ids = {
    nightclubs = {
        ["La Mesa"] = 1,
        ["Mission Row"] = 2,
        ["Strawberry"] = 3,
        ["West Vinewood"] = 4,
        ["Cypress Flats"] = 5,
        ["LSIA"] = 6,
        ["Elysian Island"] = 7,
        ["Downtown Vinewood"] = 8,
        ["Del Perro"] = 9,
        ["Vespucci Canals"] = 10
    },
    arcades = {
        ["Warehouse - Davis"] = 3,
        ["Eight Bit"] = 4,
        ["Insert Coin - Rockford Hills"] = 5,
        ["La Mesa"] = 6
    },
    autoshops = {
        ["La Mesa"] = 1,
        ["Strawberry"] = 2,
        ["Burton"] = 3,
        ["Rancho"] = 4,
        ["Mission Row"] = 5
    },
    agencies = {
        ["Hawick"] = 1,
        ["Rockford Hills"] = 2,
        ["Little Seoul"] = 3,
        ["Vespucci Canals"] = 4
    },
    hangers = {
        ["LSIA 1"] = 1,
        ["LSIA A17"] = 2,
        ["Fort Zancudo Hangar A2"] = 3,
        ["Fort Zancudo Hangar 3497"] = 4,
        ["Fort Zancudo Hangar 3499"] = 5
    },
    bunkers = {
        
    },
    facilities = {
        ["Grand Senora Desert"] = 1,
        ["Route 68"] = 2,
        ["Sandy Shores"] = 3,
        ["Mount Gordo"] = 4,
        ["Paleto Bay"] = 5,
        ["Fort Zancudo"] = 6,
        ["Ron Alternates Wind Farm"] = 8,
        ["Land Act Reservoir"] = 9
    }
}

local function simulate_control_key(key, times, control=0)
    for i = 1, times do
        PAD.SET_CONTROL_VALUE_NEXT_FRAME(control, key, 1)
        util.yield(300)
    end

    util.yield(100)
end

local function move_cursor(x, y)
    PAD.SET_CURSOR_POSITION(x, y)
    util.yield(200)
end

local function purchase_property()
    simulate_control_key(201, 1)
    move_cursor(0.30, 0.73) -- buy button
    simulate_control_key(201, 1)
    move_cursor(0.30, 0.93) -- buy button
    simulate_control_key(201, 1)
    move_cursor(0.78, 0.91) -- buy button
    simulate_control_key(201, 1)
    simulate_control_key(176, 1)
    simulate_control_key(201, 1, 2)
end

local function purchase_mazebank_property(property_curloc_func)
    local purchase = function()
        simulate_control_key(201, 1)
        move_cursor(0.30, 0.73) -- buy button
        simulate_control_key(201, 1)
        move_cursor(0.30, 0.93) -- buy button
        simulate_control_key(201, 1)
        move_cursor(0.78, 0.91) -- buy button
        simulate_control_key(201, 1)
        simulate_control_key(176, 1)
        simulate_control_key(201, 1, 2)
    end

    simulate_control_key(27, 1) -- bring up the phone
    simulate_control_key(172, 3) -- go to the internet
    simulate_control_key(176, 1) -- open internet
    move_cursor(0.25, 0.7) -- mazebank foreclosure
    simulate_control_key(201, 1) -- press enter
    move_cursor(0.5, 0.83) -- enter button
    simulate_control_key(201, 1) -- press enter
    move_cursor(0.78, 0.28) -- nightclub filter
    simulate_control_key(201, 1) -- press enter
    property_curloc_func() -- move cursor to property
    purchase() -- purchase property
    move_cursor(0.81, 0.10) -- close browser
    util.yield(1500) -- wait for transaction to complete
    simulate_control_key(201, 1) -- press enter
end

local nightclub_curloc = {
    [1] = function() -- la mesa
        move_cursor(0.69, 0.58)
    end,
    [2] = function() -- mission row
        move_cursor(0.644, 0.51)
    end,
    [3] = function() -- Strawberry
        move_cursor(0.59, 0.56)
    end,
    [4] = function()-- west vinewood
        move_cursor(0.61, 0.28) 
    end,
    [5] = function()-- cypress flats
        move_cursor(0.70, 0.74) 
    end,
    [6] = function()-- LSIA
        move_cursor(0.53, 0.80) 
    end,
    [7] = function() -- Elysian Island
        move_cursor(0.63, 0.94) 
    end,
    [8] = function() -- downtown vinewood
        move_cursor(0.647, 0.28)
    end,
    [9] = function() -- del perro
        move_cursor(0.46, 0.457)
    end,
    [10] = function() -- vespucci canals
        move_cursor(0.479, 0.54)
    end
}

local options = {
    "50,000,000", "100,000,000", "150,000,000", "200,000,000",
    "250,000,000", "300,000,000", "350,000,000", "400,000,000",
    "450,000,000", "500,000,000", "550,000,000", "600,000,000",
    "650,000,000", "700,000,000", "750,000,000", "800,000,000", 
    "850,000,000", "900,000,000", "950,000,000","1,000,000,000",
}

local function convert_value(value)
    switch value do
        case "50,000,000": return 50000000 break
        case "100,000,000": return 100000000 break
        case "150,000,000": return 150000000 break
        case "200,000,000": return 200000000 break
        case "250,000,000": return 250000000 break
        case "300,000,000": return 300000000 break
        case "350,000,000": return 350000000 break
        case "400,000,000": return 400000000 break
        case "450,000,000": return 450000000 break
        case "500,000,000": return 500000000 break
        case "550,000,000": return 550000000 break
        case "600,000,000": return 600000000 break
        case "650,000,000": return 650000000 break
        case "700,000,000": return 700000000 break
        case "750,000,000": return 750000000 break
        case "800,000,000": return 800000000 break
        case "850,000,000": return 850000000 break
        case "900,000,000": return 900000000 break
        case "950,000,000": return 950000000 break
        case "1,000,000,000": return 1000000000 break
        case "Maximum": return (2 << 30) - 1 break
        default: return (2 << 30) - 1 break
    end
end

local function is_owned(stat)
    local pOwned = memory.alloc_int()
    if STATS.STAT_GET_INT(stat, pOwned, -1) then
        local prop_id = memory.read_int(pOwned)
        if settings.verbose then util.toast("Stat Value: " .. prop_id) end
        return prop_id > 0
    else
        if settings.verbose then util.toast("Reading stat failed") end
    end

    return false
end

local function tunable(value)
    return memory.script_global(262145 + value)
end

local function simulate_control_key(key, times)
    for i = 1, times do
        PAD.SET_CONTROL_VALUE_NEXT_FRAME(0, key, 1)
        util.yield(300)
    end

    util.yield(100)
end

local function move_cursor(x, y)
    PAD.SET_CURSOR_POSITION(x, y)
    util.yield(200)
end

local function get_owned_property(property, as_id)
    local ptr = memory.alloc(4)

    switch property do
        case "Nightclub":
            if STATS.STAT_GET_INT(stats.nightclub_owned, ptr, -1) then
                local prop_id = memory.read_int(ptr)
                if prop_id > 0 then
                    if not as_id then
                        return property_ids.nightclubs[prop_id]
                    else
                        return prop_id
                    end
                end
            end
            break
        end
end

local function get_property_names(property)
    switch property do
        case "Nightclub":
            local names = {}
            for name, id in pairs(property_ids.nightclubs) do
                table.insert(names, name)
            end
            return names
            break
        case "Arcade": return {} break
        case "Autoshop": return {} break
        case "Agency": return {} break
        case "Hanger": return {} break
        case "Facility": return {} break
        default: return {} break
    end
end

local show_usage = {
    nightclub = os.time(),
    arcade = os.time(),
    autoshop = os.time(),
    agency = os.time(),
    hanger = os.time(),
    facility = os.time(),
}

local usage_timer = 20

items.settings.root = root:list("Settings", {}, "Settings for the script")
items.presets.root = root:list("Presets", {}, "Preset values for convenience (not all presets will be the exact value")
items.custom.root = root:list("Custom", {}, "Customisable values for fine-tuning to your own liking")
-- i pressed crtl+a;crtl;c;crtl+v and now im selling it. L bozo to whoever buying this from me xddddddd
items.settings.root:toggle("Disable Ownership Check", {}, "Disable ownership check for properties (useful if reading the stat is failing)", function(state) settings.ownership_check = state end)
items.settings.root:toggle("Verbose", {}, "Show verbose output", function(state) settings.verbose = state end)
items.presets.root:divider("MazeBank Properties", "MazeBank Properties")
items.presets.nightclub.root = items.presets.root:list("Nightclub", {}, "Preset values for nightclub")
items.presets.arcade.root = items.presets.root:list("Arcade", {}, "Preset values for arcade")
items.presets.autoshop.root = items.presets.root:list("Autoshop", {}, "Preset values for autoshop")
items.presets.hanger.root = items.presets.root:list("Hanger", {}, "Preset values for hanger")
items.presets.facility.root = items.presets.root:list("Facility", {}, "Preset values for facility")
items.presets.root:divider("Dynasty8Executive Properties", "Dynasty8Executive Properties")
items.presets.agency.root = items.presets.root:list("Agency", {}, "Preset values for agency")

items.presets.nightclub.root:divider("Nightclub", "Nightclub")
items.presets.nightclub.choice = items.presets.nightclub.root:list_select("Money", {}, "The nightclub trade-in price", options, 1, function(index) end)
items.presets.nightclub.root:toggle_loop("Enable", {}, "Enable the preset value for your nightclub", function()
    local ref =  menu.ref_by_rel_path(items.presets.nightclub.root, "Enable")
    local value = convert_value(options[items.presets.nightclub.choice.value])

    if settings.ownership_check then
        if not is_owned(stats.nightclub_owned) then
            ref.value = false
            util.toast("[Recovery]: You do not own a nightclub")
            return
        end
    end

    if not STATS.STAT_SET_INT(stats.nightclub, ((value * 2) + 4500000), true) then
        ref.value = false
        util.toast("[Recovery]: Failed to set nightclub trade-in price")
    end

    if show_usage.nightclub - os.time() <= 0 then
        show_usage.nightclub = os.time() + usage_timer
        util.show_corner_help("Goto mazebank foreclosure website and purchase a new nightclub to get the money")
    end
end)

local nc_owned = get_owned_property("Nightclub", true)
local nc_options = {
    first = {"La Mesa", "Mission Row", "West Vinewood", "Cypress Flats", "LSIA", "Elysian Island", "Downtown Vinewood", "Del Perro", "Vespucci Canals"},
    second = {"Vespucci Canals", "Del Perro", "Downtown Vinewood", "Elysian Island", "LSIA", "Cypress Flats", "West Vinewood", "Mission Row", "La Mesa"}
}

table.remove(nc_options.first, nc_owned)

items.presets.nightclub.root:divider("AFK Money Loop", "AFK Money Loop")
items.presets.nightclub.first_nightclub = items.presets.nightclub.root:list_select("First Nightclub", {}, "First nightclub to purchase", nc_options.first, "1", function(index) end)
items.presets.nightclub.second_nightclub = items.presets.nightclub.root:list_select("Second Nightclub", {}, "Second nightclub to purchase", nc_options.second, "1", function(index) end)
items.presets.nightclub.root:toggle_loop("Modify Value $1.07B", {}, "Modify the value to $1.07B", function()
    STATS.STAT_SET_INT(stats.nightclub, (2 << 30) - 1, true)
end)

items.presets.nightclub.root:toggle_loop("AFK Loop", {}, "AFK money loop", function()
    while menu.is_open() do
        util.toast("[Recovery]: Please close Stand menu.")
        util.yield()
    end

    local enable =  menu.ref_by_rel_path(items.presets.nightclub.root, "Enable")
    enable.value = false

    local afk_loop =  menu.ref_by_rel_path(items.presets.nightclub.root, "AFK Loop")
    local value = convert_value(options[items.presets.nightclub.choice.value])
    local first_nc_name = nc_options.first[tonumber(items.presets.nightclub.first_nightclub.value)]
    local second_nc_name = nc_options.second[tonumber(items.presets.nightclub.second_nightclub.value)]
    local first_nc = property_ids.nightclubs[first_nc_name]
    local second_nc = property_ids.nightclubs[second_nc_name]

    purchase_mazebank_property(nightclub_curloc[first_nc])
    util.yield(1000)
    purchase_mazebank_property(nightclub_curloc[second_nc])
    util.yield(1000)
end)

items.presets.arcade.choice = items.presets.arcade.root:list_select("Money", {}, "The arcade trade-in price", options, 1, function() end)
items.presets.arcade.root:toggle_loop("Enable", {}, "Enable the preset value for your arcade", function()
    local ref =  menu.ref_by_rel_path(items.presets.arcade.root, "Enable")
    local value = convert_value(options[items.presets.arcade.choice.value]) 

    if settings.ownership_check then
        if not is_owned(stats.arcade_owned) then
            ref.value = false
            util.toast("[Recovery]: You do not own an arcade")
            return
        end
    end

    if not STATS.STAT_SET_INT(stats.arcade, ((value - 255000) * 2) + 4500000, true) then
        menu.ref_by_rel_path(items.presets.arcade.root, "Enable").value = false
        util.toast("[Recovery]: Failed to set arcade trade-in price")
    end

    if show_usage.arcade - os.time() <= 0 then
        show_usage.arcade = os.time() + usage_timer
        util.show_corner_help("Goto mazebank foreclosure website and purchase a new arcade to get the money")
    end
end)

items.presets.autoshop.choice = items.presets.autoshop.root:list_select("Money", {}, "The autoshop trade-in price", options, 1, function() end)
items.presets.autoshop.root:toggle_loop("Enable", {}, "Enable the preset value for your autoshop", function()
    local ref = menu.ref_by_rel_path(items.presets.autoshop.root, "Enable")
    local value = convert_value(options[items.presets.autoshop.choice.value])
    
    if settings.ownership_check then
        if not is_owned(stats.autoshop_owned) then
            ref.value = false
            util.toast("[Recovery]: You do not own an autoshop")
            return
        end
    end

    if not STATS.STAT_SET_INT(stats.autoshop, (value * 2) + 4500000, true) then
        menu.ref_by_rel_path(items.presets.autoshop.root, "Enable").value = false
        util.toast("[Recovery]: Failed to set autoshop trade-in price")
    end

    if show_usage.autoshop - os.time() <= 0 then
        show_usage.autoshop = os.time() + usage_timer
        util.show_corner_help("Goto mazebank foreclosure website and purchase a new autoshop to get the money")
    end
end)

items.presets.hanger.choice = items.presets.hanger.root:list_select("Money", {}, "The hanger trade-in price", options, 1, function() end)
items.presets.hanger.root:toggle_loop("Enable", {}, "Enable the preset value for your hanger", function()
    local ref = menu.ref_by_rel_path(items.presets.hanger.root, "Enable")
    local value = convert_value(options[items.presets.hanger.choice.value])

    if settings.ownership_check then
        if not is_owned(stats.hanger_owned) then
            ref.value = false
            util.toast("[Recovery]: You do not own a hanger")
            return
        end
    end

    if not STATS.STAT_SET_INT(stats.hanger, ((value - 645000) * 2) + 4500000, true) then
        menu.ref_by_rel_path(items.presets.hanger.root, "Enable").value = false
        util.toast("[Recovery]: Failed to set hanger trade-in price")
    end

    if show_usage.hanger - os.time() <= 0 then
        show_usage.hanger = os.time() + usage_timer
        util.show_corner_help("Goto mazebank foreclosure website and purchase a new hanger to get the money")
    end
end)

items.presets.facility.choice = items.presets.facility.root:list_select("Money", {}, "The facility trade-in price", options, 1, function() end)
items.presets.facility.root:toggle_loop("Enable", {}, "Enable the preset value for your facility", function()
    local ref = menu.ref_by_rel_path(items.presets.facility.root, "Enable")
    local value = convert_value(options[items.presets.facility.choice.value])

    if settings.ownership_check then
        if not is_owned(stats.facility_owned) then
            ref.value = false
            util.toast("[Recovery]: You do not own a facility")
            return
        end
    end

    if not STATS.STAT_SET_INT(stats.facility, (value * 2) + 4500000, true) then
        menu.ref_by_rel_path(items.presets.facility.root, "Enable").value = false
        util.toast("[Recovery]: Failed to set facility trade-in price")
    end

    if show_usage.facility - os.time() <= 0 then
        show_usage.facility = os.time() + usage_timer
        util.show_corner_help("Goto mazebank foreclosure website and purchase a new facility to get the money")
    end
end)

items.presets.agency.choice = items.presets.agency.root:list_select("Money", {}, "The agency trade-in price", options, 1, function() end)
items.presets.agency.root:toggle_loop("Enable", {}, "Enable the preset value for your agency", function()
    local ref = menu.ref_by_rel_path(items.presets.agency.root, "Enable")
    local value = convert_value(options[items.presets.agency.choice.value])
    
    if settings.ownership_check then
        if not is_owned(stats.agency_owned) then
            ref.value = false
            util.toast("[Recovery]: You do not own an agency")
            return
        end
    end

    if not STATS.STAT_SET_INT(stats.agency, ((value - 897500) * 2) + 4500000, true) then
        menu.ref_by_rel_path(items.presets.agency.root, "Enable").value = false
        util.toast("[Recovery]: Failed to set agency trade-in price")
    end

    if show_usage.agency - os.time() <= 0 then
        show_usage.agency = os.time() + usage_timer
        util.show_corner_help("Goto dynasty8executive website and purchase a new agency to get the money")
    end
end)

items.custom.root:divider("MazeBank Properties", "MazeBank Properties")
items.custom.nightclub.root = items.custom.root:list("Nightclub", {}, "Customisable values for nightclub")
items.custom.arcade.root = items.custom.root:list("Arcade", {}, "Customisable values for arcade")
items.custom.autoshop.root = items.custom.root:list("Autoshop", {}, "Customisable values for autoshop")
items.custom.hanger.root = items.custom.root:list("Hanger", {}, "Customisable values for hanger")
items.custom.facility.root = items.custom.root:list("Facility", {}, "Customisable values for facility")
items.custom.root:divider("Dynasty8Executive Properties", "Dynasty8Executive Properties")
items.custom.agency.root = items.custom.root:list("Agency", {}, "Customisable values for agency")

items.custom.nightclub.root:text_input("Money", {"nightclubvalue"}, "The nightclub trade-in price", function(value) 
    if settings.ownership_check then
        if not is_owned(stats.nightclub_owned) then
            util.toast("[Recovery]: You do not own a nightclub")
            return
        end
    end

    value = tonumber(value)

    if not STATS.STAT_SET_INT(stats.nightclub, (value * 2) + 4500000, true) then
        ref.value = false
        util.toast("[Recovery]: Failed to set nightclub trade-in price")
    end

    util.show_corner_help("Goto maze bank foreclosure website and purchase a new nightclub to get the money")
end, "0")

items.custom.nightclub.root:toggle_loop("Enable", {}, "", function()
    local ref = menu.ref_by_rel_path(items.custom.nightclub.root, "Enable")
    local value = tonumber(menu.ref_by_rel_path(items.custom.nightclub.root, "Money").value)
    
    if settings.ownership_check then
        if not is_owned(stats.nightclub_owned) then
            ref.value = false
            util.toast("[Recovery]: You do not own a nightclub")
            return
        end
    end

    if not STATS.STAT_SET_INT(stats.nightclub, (value * 2) + 4500000, true) then
        ref.value = false
        util.toast("[Recovery]: Failed to set nightclub trade-in price")
    end

    if show_usage.nightclub - os.time() <= 0 then
        show_usage.nightclub = os.time() + 15
        util.show_corner_help("Goto mazebank foreclosure website and purchase a new nightclub to get the money")
    end
end)

items.custom.arcade.root:text_input("Money", {"arcadevalue"}, "The arcade trade-in price", function(value) 
    if settings.ownership_check then
        if not is_owned(stats.arcade_owned) then
            util.toast("[Recovery]: You do not own an arcade")
            return
        end
    end

    value = tonumber(value)

    if not STATS.STAT_SET_INT(stats.arcade, ((value - 255000) * 2) + 4500000, true) then
        ref.value = false
        util.toast("[Recovery]: Failed to set arcade trade-in price")
    end

    util.show_corner_help("Goto maze bank foreclosure website and purchase a new arcade to get the money")
end, "0")

items.custom.arcade.root:toggle_loop("Enable", {}, "", function()
    local ref = menu.ref_by_rel_path(items.custom.arcade.root, "Enable")
    local value = tonumber(menu.ref_by_rel_path(items.custom.arcade.root, "Money").value)
    
    if settings.ownership_check then
        if not is_owned(stats.arcade_owned) then
            ref.value = false
            util.toast("[Recovery]: You do not own an arcade")
            return
        end
    end

    if not STATS.STAT_SET_INT(stats.arcade, ((value - 255000) * 2) + 4500000, true) then
        ref.value = false
        util.toast("[Recovery]: Failed to set arcade trade-in price")
    end

    if show_usage.arcade - os.time() <= 0 then
        show_usage.arcade = os.time() + 15
        util.show_corner_help("Goto mazebank foreclosure website and purchase a new arcade to get the money")
    end
end)

items.custom.autoshop.root:text_input("Money", {"autoshopvalue"}, "The autoshop trade-in price", function(value) 
    if settings.ownership_check then
        if not is_owned(stats.autoshop_owned) then
            util.toast("[Recovery]: You do not own an autoshop")
            return
        end
    end

    value = tonumber(value)

    if not STATS.STAT_SET_INT(stats.autoshop, (value * 2) + 4500000, true) then
        ref.value = false
        util.toast("[Recovery]: Failed to set autoshop trade-in price")
    end

    util.show_corner_help("Goto mazebank foreclosure website and purchase a new autoshop to get the money")
end, "0")

items.custom.autoshop.root:toggle_loop("Enable", {}, "", function()
    local ref = menu.ref_by_rel_path(items.custom.autoshop.root, "Enable")
    local value = tonumber(menu.ref_by_rel_path(items.custom.autoshop.root, "Money").value)
    
    if settings.ownership_check then
        if not is_owned(stats.autoshop_owned) then
            ref.value = false
            util.toast("[Recovery]: You do not own an autoshop")
            return
        end
    end

    if not STATS.STAT_SET_INT(stats.autoshop, (value * 2) + 4500000, true) then
        ref.value = false
        util.toast("[Recovery]: Failed to set autoshop trade-in price")
    end

    if show_usage.autoshop - os.time() <= 0 then
        show_usage.autoshop = os.time() + 15
        util.show_corner_help("Goto mazebank foreclosure website and purchase a new autoshop to get the money")
    end
end)

items.custom.hanger.root:text_input("Money", {"hangervalue"}, "The hanger trade-in price", function(value) 
    if settings.ownership_check then
        if not is_owned(stats.hanger_owned) then
            util.toast("[Recovery]: You do not own a hanger")
            return
        end
    end

    value = tonumber(value)

    if not STATS.STAT_SET_INT(stats.hanger, ((value - 255000) * 2) + 4500000, true) then
        ref.value = false
        util.toast("[Recovery]: Failed to set hanger trade-in price")
    end

    util.show_corner_help("Goto mazebank foreclosure website and purchase a new hanger to get the money")
end, "0")

items.custom.hanger.root:toggle_loop("Enable", {}, "", function()
    local ref = menu.ref_by_rel_path(items.custom.hanger.root, "Enable")
    local value = tonumber(menu.ref_by_rel_path(items.custom.hanger.root, "Money").value)
    
    if settings.ownership_check then
        if not is_owned(stats.hanger_owned) then
            ref.value = false
            util.toast("[Recovery]: You do not own a hanger")
            return
        end
    end

    if not STATS.STAT_SET_INT(stats.hanger, ((value - 255000) * 2) + 4500000, true) then
        ref.value = false
        util.toast("[Recovery]: Failed to set hanger trade-in price")
    end

    if show_usage.hanger - os.time() <= 0 then
        show_usage.hanger = os.time() + 15
        util.show_corner_help("Goto mazebank foreclosure website and purchase a new hanger to get the money")
    end
end)

items.custom.facility.root:text_input("Money", {"facilityvalue"}, "The facility trade-in price", function(value) 
    if settings.ownership_check then
        if not is_owned(stats.facility_owned) then
            util.toast("[Recovery]: You do not own a facility")
            return
        end
    end

    value = tonumber(value)

    if not STATS.STAT_SET_INT(stats.facility, (value * 2) + 4500000, true) then
        ref.value = false
        util.toast("[Recovery]: Failed to set facility trade-in price")
    end

    util.show_corner_help("Goto mazebank foreclosure website and purchase a new facility to get the money")
end, "0")

items.custom.facility.root:toggle_loop("Enable", {}, "", function()
    local ref = menu.ref_by_rel_path(items.custom.facility.root, "Enable")
    local value = tonumber(menu.ref_by_rel_path(items.custom.facility.root, "Money").value)
    
    if settings.ownership_check then
        if not is_owned(stats.facility_owned) then
            ref.value = false
            util.toast("[Recovery]: You do not own a facility")
            return
        end
    end

    if not STATS.STAT_SET_INT(stats.facility, (value * 2) + 4500000, true) then
        ref.value = false
        util.toast("[Recovery]: Failed to set facility trade-in price")
    end

    if show_usage.facility - os.time() <= 0 then
        show_usage.facility = os.time() + 15
        util.show_corner_help("Goto mazebank foreclosure website and purchase a new facility to get the money")
    end
end)

items.custom.agency.root:text_input("Money", {"agencyvalue"}, "The agency trade-in price", function(value) 
    if settings.ownership_check then
        if not is_owned(stats.agency_owned) then
            util.toast("[Recovery]: You do not own an agency")
            return
        end
    end

    value = tonumber(value)

    if not STATS.STAT_SET_INT(stats.agency, ((value - 645000) * 2) + 4500000, true) then
        ref.value = false
        util.toast("[Recovery]: Failed to set agency trade-in price")
    end

    util.show_corner_help("Goto mazebank foreclosure website and purchase a new agency to get the money")
end, "0")

items.custom.agency.root:toggle_loop("Enable", {}, "", function()
    local ref = menu.ref_by_rel_path(items.custom.agency.root, "Enable")
    local value = tonumber(menu.ref_by_rel_path(items.custom.agency.root, "Money").value)
    
    if settings.ownership_check then
        if not is_owned(stats.agency_owned) then
            ref.value = false
            util.toast("[Recovery]: You do not own an agency")
            return
        end
    end

    if not STATS.STAT_SET_INT(stats.agency, ((value - 645000) * 2) + 4500000, true) then
        ref.value = false
        util.toast("[Recovery]: Failed to set agency trade-in price")
    end

    if show_usage.agency - os.time() <= 0 then
        show_usage.agency = os.time() + 15
        util.show_corner_help("Goto dynasty8executive website and purchase a new agency to get the money")
    end
end)

items.dax_mission.root = root:list("Dax Mission", {"daxmission"}, "Make easy money from the dax mission required to unlock the freakshop", function() util.show_corner_help("Check 'enable cash boost' option and start one of the new dax missions (if you haven't completed the first mission the 'Start Mission' will automatically start the first mission for you, the R on the map at sandy shores), once the mission has started you need to kill yourself immediately to fail the mission and you will recieve $1,000,000, take too long to kill yourself during the mission and you won\'t get any money") end)
items.dax_mission.root:divider("Help", "How to use this menu")
items.dax_mission.root:action("How To Use", {}, "", function()
    util.show_corner_help("Check 'enable cash boost' option and start one of the new dax missions (if you haven't completed the first mission the 'Start Mission' will automatically start the first mission for you, the R on the map at sandy shores), once the mission has started you need to kill yourself immediately to fail the mission and you will recieve $1,000,000, take too long to kill yourself during the mission and you won\'t get any money")
end)

items.dax_mission.root:divider("Options", "Recovery options using Dax Mission")
items.dax_mission.root:action("Start Mission", {}, "This will teleport you to the mission trigger and start it (if you've not completed the job already)", function()
    local ped = PLAYER.PLAYER_PED_ID()
    ENTITY.SET_ENTITY_COORDS(ped, 1394.4620361328, 3598.4528808594, 34.990489959717)
    util.yield(200)
    PAD.SET_CONTROL_VALUE_NEXT_FRAME(0, 51, 1)
end)

items.dax_mission.root:toggle_loop("Enable Cash Boost", {}, "", function()
    local cash = tunable(0)
    local ref = menu.ref_by_rel_path(items.dax_mission.root, "Enable RP Boost")
    
    if not ref.value then
        memory.write_float(cash, 5000.0) -- setting this value higher causes you to get no money (1m is the limit)
    end
end)

items.dax_mission.root:toggle_loop("Enable RP Boost", {}, "", function()
    local cash = tunable(0)
    local rp = tunable(1)
    local ref = menu.ref_by_rel_path(items.dax_mission.root, "Enable Cash Boost")
    
    memory.write_float(rp, 2000.0)
    if ref.value then
        memory.write_float(cash, 500.0)
    end
end)

items.casino_figures.root = root:list("Casino Figures", {"casinofigures"}, "Changes the amount of money you recieve from 1 figure to $200,000")
items.casino_figures.root:toggle_loop("Enable", {}, "Drops figures that give you $200,000", function()
    local cash = tunable(27123)

    memory.write_int(cash, 200000)
    menu.trigger_commands("rp" .. players.get_name(players.user()) .. " on")
end, function()
    local cash = tunable(27123)

    memory.write_int(cash, 1000)
    menu.trigger_commands("rp" .. players.get_name(players.user()) .. " off")
end)

items.casino_figures.root:toggle("Disable RP", {}, "Disables RP from casino figures", function(state)
    local rp = tunable(1)

    if state then
        memory.write_float(rp, 0)
    else
        memory.write_float(rp, 1.0)
    end
end)


menu.divider(root, "Money Gun")

menu.toggle_loop(menu.my_root(), "Skip warning Message v1", {""}, "works only for u", function()
    local message_hash = HUD.GET_WARNING_SCREEN_MESSAGE_HASH()
    local hashes = {1990323196, 1748022689, -396931869, -896436592, 583244483, -991495373, }
    for hashes as hash do
        if message_hash == hash then
            PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 201, 1.0)
            util.yield(50)
        end
    end
end)
local function GET_INT_GLOBAL(global)
    return memory.read_int(memory.script_global(global))
end
local function SET_INT_GLOBAL(global, value)
    memory.write_int(memory.script_global(global), value)
end

menu.toggle_loop(menu.my_root(),"Skip warning Message v2 (RECOMMENDED)", {}, "works only for u", function()
            if not util.is_session_started() then return end
            if GET_INT_GLOBAL(4536683) == 4 or 20 then
                SET_INT_GLOBAL(4536677, 0)
            end
        end)
        


local obj = {expl = false}	
menu.toggle_loop(menu.my_root(), "Money Gun", {""}, "", function(toggled)
    local hash = util.joaat("prop_money_bag_01")
    Streament(hash)
    if PLAYER.IS_PLAYER_FREE_AIMING(players.user()) and not PED.IS_PED_IN_ANY_VEHICLE(players.user_ped()) then
        local rot = CAM.GET_GAMEPLAY_CAM_ROT(0)
        local camcoords = get_offset_from_camera(10)
        if not ENTITY.DOES_ENTITY_EXIST(obj.prev) then
            objams(hash, obj, camcoords)
        else
            SEC(obj.prev, camcoords.x, camcoords.y, camcoords.z, false, true, true, false)
        end
        ENTITY.SET_ENTITY_ROTATION(obj.prev, rot.x, rot.y, rot.z, 1, true)
        
    elseif ENTITY.DOES_ENTITY_EXIST(obj.prev) and not PLAYER.IS_PLAYER_FREE_AIMING(players.user()) then
        entities.delete_by_handle(obj.prev)
    end
    if PED.IS_PED_SHOOTING(players.user_ped()) then  
        local camcoords = get_offset_from_camera(10)
        local cash = MISC.GET_HASH_KEY("prop_money_bag_01")
        STREAMING.REQUEST_MODEL(cash)
        if STREAMING.HAS_MODEL_LOADED(cash) == false then  
            STREAMING.REQUEST_MODEL(cash)
        end
        OBJECT.CREATE_AMBIENT_PICKUP(1704231442, camcoords.x, camcoords.y, camcoords.z, 0, 2000, cash, false, true)
        entities.delete_by_handle(obj.prev)
        util.yield(20)
    end
end)

menu.divider(root, "Money Gone")

local function SetGlobalInt(address, value)
    memory.write_int(memory.script_global(address), value)
end

local function CLICK_KEYBOARD(key, num) 
    for i = 1, num do
        PAD.SET_CONTROL_VALUE_NEXT_FRAME(0, key, 1)
        util.yield(200)
    end
end

local function IA_MENU_OPEN_OR_CLOSE()
    CLICK_KEYBOARD(244, 1)
end
local function IA_MENU_ENTER(num)
    CLICK_KEYBOARD(176, num)
end

local function SET_PACKED_STAT_BOOL_CODE(stat, value)
    STATS.SET_PACKED_STAT_BOOL_CODE(stat, value, util.get_char_slot())
end

local money_to_remove = 1000000
local money_to_remove_delay = 1000

MoneyRemover = menu.list(root, "Money Remover settings", {""}, "")

menu.click_slider(MoneyRemover, "Delay (ms)", {}, "", 100, 100000, money_to_remove_delay, 100, function(val)
    money_to_remove_delay = val
end)
menu.click_slider(MoneyRemover, "Money Amount", {}, "", 1, 2000000000, money_to_remove, 500000, function(val)
    money_to_remove = val
end)

menu.toggle_loop(root, "Removes 1 mio", {}, "Removes 1 mio per sec if possible use it with *Skip warning Message v2*", function()
    util.toast(money_to_remove .. ": " .. money_to_remove_delay)
    SetGlobalInt(262145 + 20468, money_to_remove) 
    SET_PACKED_STAT_BOOL_CODE(15382, true) 
    SET_PACKED_STAT_BOOL_CODE(9461, true)
    menu.trigger_commands("nopimenugrey on")
    if util.is_interaction_menu_open() then IA_MENU_OPEN_OR_CLOSE() end
    SetGlobalInt(2766622, 85)
    IA_MENU_OPEN_OR_CLOSE()
    IA_MENU_ENTER(1)
    util.yield(money_to_remove_delay)
end)


menu.divider(menu.my_root(), "Panic button")

menu.action(menu.my_root(), "Yeet", {"ye"}, "Instantly sending yourself to desktop. (USE HOTKEY)", function()
    MISC.QUIT_GAME() -- os.exit() not working?
end)




players.on_join(player)
players.dispatch_on_join() 
