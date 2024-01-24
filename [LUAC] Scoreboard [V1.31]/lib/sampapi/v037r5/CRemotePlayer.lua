--[[
    Project: SAMP-API.lua <https://github.com/imring/SAMP-API.lua>
    Developers: imring, LUCHARE, FYP

    Special thanks:
        SAMemory (https://www.blast.hk/threads/20472/) for implementing the basic functions.
        SAMP-API (https://github.com/BlastHackNet/SAMP-API) for the structures and addresses.
]]

local sampapi = require 'sampapi'
local shared = sampapi.shared
local mt = require 'sampapi.metatype'
local ffi = require 'ffi'

shared.require 'v037r5.CEntity'
shared.require 'v037r5.CPed'
shared.require 'CMatrix'
shared.require 'CVector'
shared.require 'v037r5.CVehicle'
shared.require 'v037r5.Animation'
shared.require 'v037r5.ControllerState'
shared.require 'v037r5.Synchronization'
shared.require 'v037r5.AimStuff'

shared.ffi.cdef[[
enum SPlayerState {
    PLAYER_STATE_NONE = 0,
    PLAYER_STATE_ONFOOT = 17,
    PLAYER_STATE_DRIVER = 19,
    PLAYER_STATE_PASSENGER = 18,
    PLAYER_STATE_WASTED = 32,
    PLAYER_STATE_SPAWNED = 33,
};
typedef enum SPlayerState SPlayerState;

enum SUpdateType {
    UPDATE_TYPE_NONE = 0,
    UPDATE_TYPE_ONFOOT = 16,
    UPDATE_TYPE_INCAR = 17,
    UPDATE_TYPE_PASSENGER = 18,
};
typedef enum SUpdateType SUpdateType;

enum SPlayerStatus {
    PLAYER_STATUS_TIMEOUT = 2,
};
typedef enum SPlayerStatus SPlayerStatus;

typedef struct SCRemotePlayer SCRemotePlayer;
#pragma pack(push, 1)
struct SCRemotePlayer {
    int field_1;
    BOOL m_bDrawLabels;
    BOOL m_bHasJetpack;
    unsigned char m_nSpecialAction;
    char pad_2[12];
    SIncarData m_incarData;
    STrailerData m_trailerData;
    SAimData m_aimData;
    SPassengerData m_passengerData;
    SOnfootData m_onfootData;
    unsigned char m_nTeam;
    unsigned char m_nState;
    unsigned char m_nSeatId;
    int field_3;
    BOOL m_bPassengerDriveBy;
    char pad_1[76];
    SCVector m_positionDifference;
    struct {
        float real;
        SCVector imag;
    } m_incarTargetRotation;
    SCVector m_onfootTargetPosition;
    SCVector m_onfootTargetSpeed;
    SCVector m_incarTargetPosition;
    SCVector m_incarTargetSpeed;
    float m_fReportedArmour;
    float m_fReportedHealth;
    SAnimation m_animation;
    unsigned char m_nUpdateType;
    TICK m_lastUpdate;
    TICK m_lastTimestamp;
    BOOL m_bPerformingCustomAnimation;
    int m_nStatus;
    struct {
        SCVector m_direction;
        TICK m_lastUpdate;
        TICK m_lastLook;
    } m_head;
    SCPed* m_pPed;
    SCVehicle* m_pVehicle;
    ID m_nId;
    ID m_nVehicleId;
    BOOL m_bMarkerState;
    struct {
        int x;
        int y;
        int z;
    } m_markerPosition;
    GTAREF m_marker;
};
#pragma pack(pop)
]]

shared.validate_size('struct SCRemotePlayer', 0x1fd)

local CRemotePlayer_constructor = ffi.cast('void(__thiscall*)(SCRemotePlayer*)', 0x165E0)
local CRemotePlayer_destructor = ffi.cast('void(__thiscall*)(SCRemotePlayer*)', 0x16660)
local function CRemotePlayer_new(...)
    local obj = ffi.gc(ffi.new('struct SCRemotePlayer[1]'), CRemotePlayer_destructor)
    CRemotePlayer_constructor(obj, ...)
    return obj
end

local SCRemotePlayer_mt = {
    ProcessHead = ffi.cast('void(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x143A0)),
    SetMarkerState = ffi.cast('void(__thiscall*)(SCRemotePlayer*, BOOL)', sampapi.GetAddress(0x14500)),
    SetMarkerPosition = ffi.cast('void(__thiscall*)(SCRemotePlayer*, int, int, int)', sampapi.GetAddress(0x14540)),
    SurfingOnVehicle = ffi.cast('BOOL(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x145F0)),
    SurfingOnObject = ffi.cast('BOOL(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x14620)),
    ProcessSurfing = ffi.cast('void(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x14650)),
    OnEnterVehicle = ffi.cast('void(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x14800)),
    OnExitVehicle = ffi.cast('void(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x148F0)),
    ProcessSpecialAction = ffi.cast('void(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x14950)),
    UpdateOnfootSpeedAndPosition = ffi.cast('void(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x14C40)),
    UpdateOnfootRotation = ffi.cast('void(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x14FF0)),
    SetOnfootTargetSpeedAndPosition = ffi.cast('void(__thiscall*)(SCRemotePlayer*, SCVector*, SCVector*)', sampapi.GetAddress(0x150D0)),
    UpdateIncarSpeedAndPosition = ffi.cast('void(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x15140)),
    UpdateIncarRotation = ffi.cast('void(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x15460)),
    SetIncarTargetSpeedAndPosition = ffi.cast('void(__thiscall*)(SCRemotePlayer*, SCMatrix*, SCVector*, SCVector*)', sampapi.GetAddress(0x155E0)),
    UpdateTrain = ffi.cast('void(__thiscall*)(SCRemotePlayer*, SCMatrix*, SCVector*, float)', sampapi.GetAddress(0x15650)),
    Update = ffi.cast('void(__thiscall*)(SCRemotePlayer*, SAimData*)', sampapi.GetAddress(0x15760)),
    Update = ffi.cast('void(__thiscall*)(SCRemotePlayer*, SAimData*)', sampapi.GetAddress(0x15760)),
    Update = ffi.cast('void(__thiscall*)(SCRemotePlayer*, SAimData*)', sampapi.GetAddress(0x15760)),
    ResetData = ffi.cast('void(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x15FA0)),
    GetDistanceToPlayer = ffi.cast('float(__thiscall*)(SCRemotePlayer*, SCRemotePlayer*)', sampapi.GetAddress(0x160A0)),
    GetDistanceToLocalPlayer = ffi.cast('float(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x16120)),
    SetColor = ffi.cast('void(__thiscall*)(SCRemotePlayer*, D3DCOLOR)', sampapi.GetAddress(0x16150)),
    GetColorAsRGBA = ffi.cast('D3DCOLOR(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x16170)),
    GetColorAsARGB = ffi.cast('D3DCOLOR(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x16180)),
    EnterVehicle = ffi.cast('void(__thiscall*)(SCRemotePlayer*, ID, BOOL)', sampapi.GetAddress(0x161A0)),
    ExitVehicle = ffi.cast('void(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x16230)),
    ChangeState = ffi.cast('void(__thiscall*)(SCRemotePlayer*, char, char)', sampapi.GetAddress(0x16270)),
    GetStatus = ffi.cast('int(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x16330)),
    Update = ffi.cast('void(__thiscall*)(SCRemotePlayer*, SAimData*)', sampapi.GetAddress(0x15760)),
    Process = ffi.cast('void(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x166B0)),
    Spawn = ffi.cast('BOOL(__thiscall*)(SCRemotePlayer*, int, int, int, SCVector*, float, D3DCOLOR, char)', sampapi.GetAddress(0x17130)),
    Update = ffi.cast('void(__thiscall*)(SCRemotePlayer*, SAimData*)', sampapi.GetAddress(0x15760)),
    Update = ffi.cast('void(__thiscall*)(SCRemotePlayer*, SAimData*)', sampapi.GetAddress(0x15760)),
    Update = ffi.cast('void(__thiscall*)(SCRemotePlayer*, SAimData*)', sampapi.GetAddress(0x15760)),
    Remove = ffi.cast('void(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x17530)),
    Kill = ffi.cast('void(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x17570)),
    Chat = ffi.cast('void(__thiscall*)(SCRemotePlayer*, const char*)', sampapi.GetAddress(0x17610)),
    DoesExist = ffi.cast('BOOL(__thiscall*)(SCRemotePlayer*)', sampapi.GetAddress(0x1080)),
}
mt.set_handler('struct SCRemotePlayer', '__index', SCRemotePlayer_mt)

local Synchronization = {}

local AimStuff = {}

return {
    new = CRemotePlayer_new,
    Synchronization = Synchronization,
    AimStuff = AimStuff,
}