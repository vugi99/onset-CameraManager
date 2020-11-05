
LoadPak("RenderTargetManager", "/RenderTargetManager/", "../../../OnsetModding/Plugins/RenderTargetManager/Content")

local cameras = {}
local screens = {}

local function table_last_count(tbl)
    local nb = 0
    for i, v in ipairs(tbl) do
       nb = nb + 1
    end
    return nb
end

function CreateCamera(x, y, z, rx, ry, rz)
    if (x and y and z) then
        rx = rx or 0
        ry = ry or 0
        rz = rz or 0
        local cam = GetWorld():SpawnActor(UClass.LoadFromAsset("/RenderTargetManager/CameraBP"), FVector(x, y, z), FRotator(rx, ry, rz))
        --print(tostring(cam))
        local last_nb = table_last_count(cameras)
        cameras[last_nb + 1] = cam
        cam:ProcessEvent("InitCameraBP", last_nb + 1)
        return last_nb + 1
    end
    return false
end
AddFunctionExport("CreateCamera", CreateCamera)

function CreateScreen(x, y, z, rx, ry, rz, sx, sy, sz, camera_id)
    if (x and y and z) then
        rx = rx or 0
        ry = ry or 0
        rz = rz or 0
        sx = sx or 1
        sy = sy or 1
        sz = sz or 1
        camera_id = camera_id or 0
        local screen = GetWorld():SpawnActor(UClass.LoadFromAsset("/RenderTargetManager/ScreenBP"), FVector(x, y, z), FRotator(rx, ry, rz))
        --print(tostring(screen))
        screen:SetActorScale3D(FVector(sx, sy, sz))
        local last_nb = table_last_count(screens)
        screens[last_nb + 1] = screen
        local cam_found = screen:ProcessEvent("InitScreenBP", camera_id)
        return last_nb + 1
    end
    return false
end
AddFunctionExport("CreateScreen", CreateScreen)

function SetScreenCamera(screen_id, cam_id)
   if (screens[screen_id] and (cameras[cam_id] or cam_id == 0)) then
       screens[screen_id]:ProcessEvent("SetRenderTarget", cam_id)
       return true
   end
   return false
end
AddFunctionExport("SetScreenCamera", SetScreenCamera)

function _SetCameraLocation(cam_id, x, y, z)
    if (cameras[cam_id] and x and y and z) then
        cameras[cam_id]:SetActorLocation(FVector(x, y, z))
        return true
    end
    return false
end
AddFunctionExport("SetCameraLocation", _SetCameraLocation)

function _SetCameraRotation(cam_id, rx, ry, rz)
    if (cameras[cam_id] and rx and ry and rz) then
        cameras[cam_id]:SetActorRotation(FRotator(rx, ry, rz))
        return true
    end
    return false
end
AddFunctionExport("SetCameraRotation", _SetCameraRotation)

function SetScreenLocation(screen_id, x, y, z)
    if (screens[screen_id] and x and y and z) then
        screens[screen_id]:SetActorLocation(FVector(x, y, z))
        return true
    end
    return false
end
AddFunctionExport("SetScreenLocation", SetScreenLocation)

function SetScreenRotation(screen_id, rx, ry, rz)
    if (screens[screen_id] and rx and ry and rz) then
        screens[screen_id]:SetActorRotation(FRotator(rx, ry, rz))
        return true
    end
    return false
end
AddFunctionExport("SetScreenRotation", SetScreenRotation)

function SetScreenScale(screen_id, sx, sy, sz)
    if (screens[screen_id] and sx and sy and sz) then
        screens[screen_id]:SetActorScale3D(FVector(sx, sy, sz))
        return true
    end
    return false
end
AddFunctionExport("SetScreenScale", SetScreenScale)

function DestroyCamera(cam_id)
    if cameras[cam_id] then
        cameras[cam_id]:Destroy()
        cameras[cam_id] = nil
        return true
    end
    return false
end
AddFunctionExport("DestroyCamera", DestroyCamera)

function DestroyScreen(screen_id)
    if screens[screen_id] then
        screens[screen_id]:Destroy()
        screens[screen_id] = nil
        return true
    end
    return false
end
AddFunctionExport("DestroyScreen", DestroyScreen)

function SetCameraWidth(cam_id, width)
    if (cameras[cam_id] and width and width > 0) then
        width = math.floor(width)
        cameras[cam_id]:ProcessEvent("SetCameraWidth", width)
        return true
    end
    return false
end
AddFunctionExport("SetCameraWidth", SetCameraWidth)

function SetCameraHeight(cam_id, height)
    if (cameras[cam_id] and height and height > 0) then
        height = math.floor(height)
        cameras[cam_id]:ProcessEvent("SetCameraHeight", height)
        return true
    end
    return false
end
AddFunctionExport("SetCameraHeight", SetCameraHeight)

function GetAllScreens()
    local tbl = {}
    for k, v in pairs(screens) do
        table.insert(tbl, k)
    end
    return tbl
end
AddFunctionExport("GetAllScreens", GetAllScreens)

function GetAllCameras()
    local tbl = {}
    for k, v in pairs(cameras) do
        table.insert(tbl, k)
    end
    return tbl
end
AddFunctionExport("GetAllCameras", GetAllCameras)

function GetScreenLocation(screen_id)
    if screens[screen_id] then
        local loc = screens[screen_id]:GetActorLocation()
        return loc.X, loc.Y, loc.Z
    end
    return false
end
AddFunctionExport("GetScreenLocation", GetScreenLocation)

function GetScreenRotation(screen_id)
    if screens[screen_id] then
        local rot = screens[screen_id]:GetActorRotation()
        return rot.Pitch, rot.Yaw, rot.Roll
    end
    return false
end
AddFunctionExport("GetScreenRotation", GetScreenRotation)

function GetScreenScale(screen_id)
    if screens[screen_id] then
        local scale = screens[screen_id]:GetActorScale3D()
        return scale.X, scale.Y, scale.Z
    end
    return false
end
AddFunctionExport("GetScreenScale", GetScreenScale)

function _GetCameraLocation(cam_id)
    if cameras[cam_id] then
        local loc = cameras[cam_id]:GetActorLocation()
        return loc.X, loc.Y, loc.Z
    end
    return false
end
AddFunctionExport("GetCameraLocation", _GetCameraLocation)

function _GetCameraRotation(cam_id)
    if cameras[cam_id] then
        local rot = cameras[cam_id]:GetActorRotation()
        return rot.Pitch, rot.Yaw, rot.Roll
    end
    return false
end
AddFunctionExport("GetCameraRotation", _GetCameraRotation)

local function GetActorFromAttachTypeAndAttachId(attach_type, attach_id)
    local actor
    if attach_type == ATTACH_PLAYER then
        actor = GetPlayerActor(attach_id)
    elseif attach_type == ATTACH_VEHICLE then
        actor = GetVehicleActor(attach_id)
    elseif attach_type == ATTACH_OBJECT then
        actor = GetObjectActor(attach_id)
    elseif attach_type == ATTACH_NPC then
        actor = GetNPCActor(attach_id)
    end
    return actor
end

local function IsAttached(actor)
    local attach_parent = actor:GetAttachParentActor()
    if attach_parent then
        return true
    end
    return false
end

local function DetachActor(actor)
    actor:DetachFromActor(FDetachmentTransformRules(EDetachmentRule.KeepWorld, true))
end

local function AttachToActor(actor, to_actor)
    actor:AttachToActor(to_actor, FAttachmentTransformRules(EAttachmentRule.SnapToTarget, true), "")
end

function SetCameraAttached(cam_id, attach_type, attach_id, x, y, z, rx, ry, rz)
    rx = rx or 0
    ry = ry or 0
    rz = rz or 0
    if (cameras[cam_id] and attach_type and attach_id and x and y and z) then
        local attach_to_actor = GetActorFromAttachTypeAndAttachId(attach_type, attach_id)
        if attach_to_actor then
            if IsAttached(cameras[cam_id]) then
                DetachActor(cameras[cam_id])
            end
            AttachToActor(cameras[cam_id], attach_to_actor)
            cameras[cam_id]:SetActorRelativeLocation(FVector(y, x, z))
            cameras[cam_id]:SetActorRelativeRotation(FRotator(rx, ry, rz))
            cameras[cam_id]:SetActorScale3D(FVector(1, 1, 1))
            return true
        end
    end
    return false
end
AddFunctionExport("SetCameraAttached", SetCameraAttached)

function SetCameraDetached(cam_id)
    if cameras[cam_id] then
        DetachActor(cameras[cam_id])
        return true
    end
    return false
end
AddFunctionExport("SetCameraDetached", SetCameraDetached)

function IsCameraAttached(cam_id)
    if cameras[cam_id] then
        return IsAttached(cameras[cam_id])
    end
end
AddFunctionExport("IsCameraAttached", IsCameraAttached)

function SetScreenAttached(screen_id, attach_type, attach_id, x, y, z, rx, ry, rz)
    rx = rx or 0
    ry = ry or 0
    rz = rz or 0
    if (screens[screen_id] and attach_type and attach_id and x and y and z) then
        local attach_to_actor = GetActorFromAttachTypeAndAttachId(attach_type, attach_id)
        if attach_to_actor then
            if IsAttached(screens[screen_id]) then
                DetachActor(screens[screen_id])
            end
            local actor_scale = screens[screen_id]:GetActorScale3D()
            AttachToActor(screens[screen_id], attach_to_actor)
            screens[screen_id]:SetActorRelativeLocation(FVector(y, x, z))
            screens[screen_id]:SetActorRelativeRotation(FRotator(rx, ry, rz))
            screens[screen_id]:SetActorScale3D(actor_scale)
            return true
        end
    end
    return false
end
AddFunctionExport("SetScreenAttached", SetScreenAttached)

function SetScreenDetached(screen_id)
    if screens[screen_id] then
        DetachActor(screens[screen_id])
        return true
    end
    return false
end
AddFunctionExport("SetScreenDetached", SetScreenDetached)

function IsScreenAttached(screen_id)
    if screens[screen_id] then
        return IsAttached(screens[screen_id])
    end
end
AddFunctionExport("IsScreenAttached", IsScreenAttached)