
local cam
local screen

local function move_test(cam, screen)
    local x, y, z = GetPlayerLocation(GetPlayerId())
    local rx, ry, rz = GetCameraRotation(false)
    SetScreenLocation(screen, x - 250, y, z + 75)
    _SetCameraLocation(cam, x - 250, y, z + 75)
end

AddEvent("OnPackageStart", function()
    cam = CreateCamera(125773, 80246, 1660, 0, 0, 0)
    local cam2 = CreateCamera(125773, 80246, 1660, 0, 0, 0)
    SetCameraWidth(cam, 1024)
    SetCameraHeight(cam, 512)
    SetCameraWidth(cam2, 1024)
    SetCameraHeight(cam2, 512)
    screen = CreateScreen(125773, 80600, 1700, 0, 0, 0, 2, 1, 1, cam)
    local screen2 = CreateScreen(125773, 80600, 1700, 0, 0, 0, 2, 1, 1, cam)
    local screen3 = CreateScreen(125773, 80600, 1700, 0, 0, 0, 2, 1, 1, cam)
    local screen4 = CreateScreen(125773, 80600, 1700, 0, 0, 0, 2, 1, 1, cam)
    local screen5 = CreateScreen(125773, 80600, 1700, 0, 0, 0, 2, 1, 1, cam2)
    Delay(1000, function()
        SetCameraAttached(cam, ATTACH_PLAYER, GetPlayerId(), 0, 250, 75, 0, 180)
        SetCameraAttached(cam2, ATTACH_PLAYER, GetPlayerId(), 0, -250, 75, 0, 180)
        SetScreenAttached(screen, ATTACH_PLAYER, GetPlayerId(), 0, 250, 75, 0, 180)
        SetScreenAttached(screen2, ATTACH_PLAYER, GetPlayerId(), 250, 0, 75, 0, -90)
        SetScreenAttached(screen3, ATTACH_PLAYER, GetPlayerId(), -250, 0, 75, 0, 90)
        SetScreenAttached(screen4, ATTACH_PLAYER, GetPlayerId(), 0, -250, 75, 0, 0)
        SetScreenAttached(screen5, ATTACH_PLAYER, GetPlayerId(), 0, 250, 175, 0, 180)
    end)
end)

AddCommand("t_detach", function()
    SetCameraDetached(cam)
    SetScreenDetached(screen)
end)

AddCommand("t_attach", function()
    SetCameraAttached(cam, ATTACH_PLAYER, GetPlayerId(), 0, 250, 75, 0, 180)
    SetScreenAttached(screen, ATTACH_PLAYER, GetPlayerId(), 0, 250, 75, 0, 180)
end)

AddCommand("t_unlink", function()
    SetScreenCamera(screen, 0)
end)

AddCommand("t_link", function()
    SetScreenCamera(screen, cam)
end)