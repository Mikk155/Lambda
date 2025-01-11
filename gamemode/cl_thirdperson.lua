/*
    Third Person toggle
*/

// Is third person enabled?
local third_person_enabled = false

local camera_distance = CreateClientConVar( "lambda_thirdperson_distance", "140", true, false, "Distance for third person view", 40, 160)

local camera_height = CreateClientConVar("lambda_thirdperson_height", "13", true, false, "Height for third person view", 0, 18)

function toggle_third_person()

    third_person_enabled = not third_person_enabled

end

function calc_thirdperson(ply, pos, angles, fov)

    if IsValid(ply) then

        if third_person_enabled then

            local endpos = pos - ( angles:Forward() * camera_distance:GetInt() )

            endpos.z = endpos.z + camera_height:GetInt()

            local trace = util.TraceHull( {
                start = pos,
                endpos = endpos,
                filter = function(ent)
                    return ent ~= ply and ent:GetOwner() ~= ply
                end,
                mins = Vector(-10, -10, -10),
                maxs = Vector(10, 10, 10),
                mask = MASK_SOLID_BRUSHONLY
            } )

            local view = {}

            if trace.Hit then

                local collisionPos = trace.HitPos

                view.origin = collisionPos + angles:Up() * 2

            else

                view.origin = endpos

            end

            view.angles = angles

            view.fov = fov

            return view

        end

    end

end

hook.Add( "CalcView", "calc_thirdperson", calc_thirdperson )

hook.Add("ShouldDrawLocalPlayer", "MyHax ShouldDrawLocalPlayer", function(ply)

    return third_person_enabled

end)

concommand.Add( "lambda_thirdperson_toggle", toggle_third_person )
