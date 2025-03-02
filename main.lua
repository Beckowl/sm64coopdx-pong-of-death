-- name:Pong Of Death
-- description:\\#ffff33\\-- Pong Of Death --\n\nA direct lua translation of Frauber's original Pong of Death GameShark code. In their words:\\#ffffff\\\n\n"What if, besides playing Mario 64, you had also to beat the computer in a game of Pong?"\n\nControl the left paddle with \\#ffff33\\D-Up/D-Down\\#ffffff\\; the right paddle is controlled by the computer. First to \\#ffff33\\10\\#ffffff\\ points wins:\n\    - Mario wins: Earn rewards\n    - Computer wins: Mario dies\n\nComputer skill and ball speed increase each stage.

-- note: This is a direct translation of the original code (not my own work) – blame Frauber for the weird code!

local INITIAL_Y_POS = 110
local MAX_Y_POS = 200
local MIN_Y_POS = 10

local pad = 0
local score_1 = 0
local score_2 = 0
local other_counter = 0
local y_pos_1 = 0
local y_pos_2 = 0
local set_pos = 0
local ball_x_pos = 0
local ball_y_pos = 0
local ball_direction_x = 0
local ball_direction_y = 0
local ball_speed = 0
local run_once = 0
local next_level = 0
local level = 0
local pad_speed = 0
local count_before_start = 0
local restart_counter = 0
local first_run = 0
local crazy_shot = 0

local function print_xy(x, y, text)
    local cx = djui_hud_get_screen_width() / 2
    local cy = djui_hud_get_screen_height() / 2

    djui_hud_print_text(text, cx + (x - 320/2), cy - (y - 240/2) - 16, 1)
end

local run = function()
    if (first_run == 0) then
        next_level = 1
        first_run = 1
        level = 0
    end

    if (next_level == 0) then

        other_counter = other_counter + 3
        hud_set_value(HUD_DISPLAY_FLAGS, 0)

        if (run_once == 0) then
            y_pos_1 = INITIAL_Y_POS
            y_pos_2 = INITIAL_Y_POS
            run_once = 1
            set_pos = 0
            count_before_start = 0
            ball_speed = 4
            pad_speed = 2
            score_1 = 0
            score_2 = 0
            restart_counter = 0
            level = level + 1

            if (level >= 3) then
                ball_speed = ball_speed + (level - 3)
            end
            if (level >= 8) then
                ball_speed = 9
            end
        end

        if (set_pos == 0) then
            if (ball_direction_x == 0 or ball_direction_x == 2) then
                ball_x_pos = 50
                ball_direction_x = 0
            elseif (ball_direction_x == 1 or ball_direction_x == 3) then
                ball_x_pos = 250
                ball_direction_x = 1
            end

            if(ball_direction_x == 2) then
                ball_direction_y = 0 end
            if (ball_direction_y == 3) then
                ball_direction_y = 1 end

            ball_y_pos = INITIAL_Y_POS
            count_before_start = 0

            if (score_2 > 9) then
                next_level = 1
                level = 0
                gMarioStates[0].health = 0
            elseif (score_1 > 9) then
                if (gNetworkPlayers[0].currLevelNum ~= LEVEL_CASTLE) then
                    local mario = gMarioStates[0]
                    if (other_counter % 5 + 1 == 3) then
                        spawn_sync_object(id_bhvKoopaShell, E_MODEL_KOOPA_SHELL, mario.pos.x, mario.pos.y, mario.pos.z, nil) -- koopa shell
                    elseif (other_counter % 5 + 1 == 4) then
                        spawn_sync_object(id_bhvMetalCap, E_MODEL_MARIOS_METAL_CAP, mario.pos.x, mario.pos.y, mario.pos.z, nil) -- metap-cap
                    elseif (other_counter % 5 + 1 == 2) then
                        spawn_sync_object(id_bhvWingCap, E_MODEL_MARIOS_WING_CAP, mario.pos.x, mario.pos.y, mario.pos.z, nil) -- wing-cap
                    else
                        spawn_sync_object(id_bhv1upWalking, E_MODEL_1UP, mario.pos.x, mario.pos.y, mario.pos.z, nil) -- 1-up
                    end
                end
                next_level = 1
            end

            set_pos = 1
            crazy_shot = 0
        end

        -- print paddles and score

        print_xy(5, 215, tostring(score_1))
        print_xy(305, 215, tostring(score_2))
        
        print_xy(25, y_pos_1, "I")
        print_xy(25, y_pos_1 + 5, "I")
        print_xy(25, y_pos_1 + 10, "I")
        print_xy(25, y_pos_1 + 15, "I")
        
        print_xy(275, y_pos_2, "I")
        print_xy(275, y_pos_2 + 5, "I")
        print_xy(275, y_pos_2 + 10, "I")
        print_xy(275, y_pos_2 + 15, "I")

        -- print the ball

        print_xy(ball_x_pos, ball_y_pos, "$")

        count_before_start = count_before_start + 1

        if (count_before_start > 30) then
            if (ball_direction_x == 0) then
                ball_x_pos = ball_x_pos + ball_speed
            elseif (ball_direction_x == 1) then
                ball_x_pos = ball_x_pos - ball_speed
            elseif (ball_direction_x == 2) then
                ball_x_pos = ball_x_pos + ball_speed + 2
            elseif (ball_direction_x == 3) then
                ball_x_pos = ball_x_pos - ball_speed - 2
            end

            if (ball_direction_y == 0) then
                ball_y_pos = ball_y_pos + ball_speed
            elseif (ball_direction_y == 1) then
                ball_y_pos = ball_y_pos - ball_speed
            elseif (ball_direction_y == 2) then
                ball_y_pos = ball_y_pos + ball_speed + 2
            elseif (ball_direction_y == 3) then
                ball_y_pos = ball_y_pos - ball_speed - 2
            end

            if (crazy_shot == 1) then
                if (ball_direction_x == 0 or ball_direction_x == 2) then
                    ball_x_pos = ball_x_pos + 4 
                end
                if (ball_direction_x == 1 or ball_direction_x == 3) then
                    ball_x_pos = ball_x_pos - 4      
                end
                
                djui_hud_print_text("OMFG SUPERSHOT", 150, 100, 1)
            end
        end

        -- check for collision with paddles and reverse directions

        if (ball_x_pos > 262) then
            if (not ((y_pos_2 + 20 < ball_y_pos - 8) or (y_pos_2 - 8 > ball_y_pos + 8))) then -- rectangle collision
                
                if (other_counter % 101 + 1 > 40) then -- randomize for different reflection angles
                    if (ball_direction_x == 0) then
                        ball_direction_x = 1
                    elseif (ball_direction_x == 2) then
                        ball_direction_x = 1
                    end

                    crazy_shot = 0
                elseif (other_counter % 101 + 1 < 40) then
                    if (ball_direction_x == 0) then
                        ball_direction_x = 3
                    elseif (ball_direction_x == 2) then
                        ball_direction_x = 3
                    end

                    crazy_shot = 0
                end

                if (other_counter % 101 + 1 < 5) then
                    crazy_shot = 1
                end

                if (count_before_start % 100 + 1 > 30) then
                    if (ball_direction_y == 2) then
                        ball_direction_y = 0
                    elseif (ball_direction_y == 3) then
                        ball_direction_y = 1
                    end
                elseif (count_before_start % 100 + 1 < 30) then
                    if (ball_direction_y == 0) then
                        ball_direction_y = 2
                    elseif (ball_direction_y == 1) then
                        ball_direction_y = 3
                    end
                end

                play_sound(SOUND_ENV_ELEVATOR1, gMarioStates[0].pos)
            else

                if (ball_x_pos >= 270) then
                    score_1 = score_1 + 1
                    ball_direction_x = 1
                    set_pos = 0
                end
            end
        elseif (ball_x_pos <= 33) then
            if (not((y_pos_1 + 20 < ball_y_pos - 8) or (y_pos_1 - 8 > ball_y_pos + 8))) then
                if (other_counter % 101 + 1 > 40) then
                    if (ball_direction_x == 1) then
                        ball_direction_x = 0
                    elseif (ball_direction_x == 3) then
                        ball_direction_x = 0
                    end

                    crazy_shot = 0
                elseif (other_counter % 101 + 1 < 40) then
                    if (ball_direction_x == 1) then
                        ball_direction_x = 2
                    elseif (ball_direction_x == 3) then
                        ball_direction_x = 2
                    end

                    crazy_shot = 0
                end

                if (other_counter % 101 + 1 < 4) then
                    crazy_shot = 1
                end

                if (count_before_start % 100 + 1 > 30) then
                    if (ball_direction_y == 2) then
                        ball_direction_y = 0
                    elseif (ball_direction_y == 3) then
                        ball_direction_y = 1
                    end
                elseif (count_before_start % 100 + 1 < 30) then
                    if (ball_direction_y == 0) then
                        ball_direction_y = 2
                    elseif (ball_direction_y == 1) then
                        ball_direction_y = 3
                    end
                end

                play_sound(SOUND_ENV_ELEVATOR1, gMarioStates[0].pos)
            else
                if (ball_x_pos <= 27) then
                    score_2 = score_2 + 1
                    set_pos = 0
                end
            end
        end

        if (ball_y_pos >= 215) then
            if (ball_direction_y == 0) then
                ball_direction_y = 1
            elseif (ball_direction_y) == 2 then
                ball_direction_y = 3
            end
        elseif (ball_y_pos <= 8) then
            if (ball_direction_y == 1) then
                ball_direction_y = 0
            elseif (ball_direction_y == 3) then
                ball_direction_y = 2
            end
        end

        if (pad & 4 > 0) then
            if (not ((y_pos_1) >= MAX_Y_POS)) then
                y_pos_1 = y_pos_1 + (3 + pad_speed)
            end
        end
        if (pad & 8 > 0) then
            if (not ((y_pos_1) <= MIN_Y_POS)) then
                y_pos_1 = y_pos_1 - (3 + pad_speed)
            end
        end

        -- Computer AI

        if (ball_x_pos >= 140 - (level * 8)) then
            if (ball_direction_y == 0 or ball_direction_y == 2) then
                if (not(y_pos_2 >= MAX_Y_POS)) then
                    y_pos_2 = y_pos_2 + ball_speed
                end

                -- compensate opposite direction when the ball is near
                if (ball_x_pos > 215 - (level * 2)) then
                    if (y_pos_2 > ball_y_pos and not(y_pos_2 <= MIN_Y_POS) and not(ball_direction_x == 1 or ball_direction_x == 3)) then
                        y_pos_2 = y_pos_2 - (ball_speed * 2)
                    end
                end
            elseif (ball_direction_y == 1 or ball_direction_y == 3) then
                if (not(y_pos_2 <= MIN_Y_POS)) then
                    y_pos_2 = y_pos_2 - ball_speed
                end

                if (ball_x_pos > 215 - (level * 2)) then
                    if (y_pos_2 < ball_y_pos and not(y_pos_2 >= MAX_Y_POS) and not(ball_direction_x == 1 or ball_direction_x == 3)) then
                        y_pos_2 = y_pos_2 + (ball_speed * 2)
                    end
                end
            end

            if (y_pos_2 < MIN_Y_POS) then
                y_pos_2 = MIN_Y_POS + 1
            end
            if (y_pos_2 > MAX_Y_POS) then
                y_pos_2 = MAX_Y_POS - 1
            end
        end
    elseif (next_level == 1) then
        restart_counter = restart_counter + 1

        print_xy(80, restart_counter + 50, "GET READY FOR")
        print_xy(80, restart_counter + 30, "PONG OF DEATH")
        print_xy(80, restart_counter + 10, string.format("  STAGE  %d", level + 1))
        
        if (restart_counter > 150) then
            next_level = 0
            run_once = 0
            set_pos = 0
        end
    end
end

local function can_update_game()
    return not (
    hud_is_hidden() or
    is_game_paused() or
    get_dialog_box_state() ~= 0 or
    obj_count_objects_with_behavior_id(id_bhvActSelector) > 0
    )
end

hook_event(HOOK_ON_HUD_RENDER_BEHIND, function()
    if (can_update_game()) then
        djui_hud_set_resolution(RESOLUTION_N64)
        djui_hud_set_font(FONT_HUD)
        run()
    end
end)

hook_event(HOOK_UPDATE, function(m)
    pad = gControllers[0].buttonDown >> 8
end)