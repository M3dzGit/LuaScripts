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

shared.require 'CVector'

shared.ffi.cdef[[
typedef struct SCLabel SCLabel;
#pragma pack(push, 1)
struct SCLabel {
    struct IDirect3DDevice9* m_pDevice;
    struct ID3DXSprite* m_pSprite;
};
#pragma pack(pop)
]]

shared.validate_size('struct SCLabel', 0x8)

local CLabel_constructor = ffi.cast('void(__thiscall*)(SCLabel*, IDirect3DDevice9*)', 0x674D0)
local CLabel_destructor = ffi.cast('void(__thiscall*)(SCLabel*)', 0x674F0)
local function CLabel_new(...)
    local obj = ffi.gc(ffi.new('struct SCLabel[1]'), CLabel_destructor)
    CLabel_constructor(obj, ...)
    return obj
end

local SCLabel_mt = {
    OnLostDevice = ffi.cast('void(__thiscall*)(SCLabel*)', sampapi.GetAddress(0x67510)),
    OnResetDevice = ffi.cast('void(__thiscall*)(SCLabel*)', sampapi.GetAddress(0x67520)),
    HasNoObstacles = ffi.cast('BOOL(__thiscall*)(SCLabel*, SCVector)', sampapi.GetAddress(0x67530)),
    Begin = ffi.cast('void(__thiscall*)(SCLabel*)', sampapi.GetAddress(0x67590)),
    End = ffi.cast('void(__thiscall*)(SCLabel*)', sampapi.GetAddress(0x675A0)),
    Draw = ffi.cast('void(__thiscall*)(SCLabel*, SCVector*, const char*, D3DCOLOR, bool, bool)', sampapi.GetAddress(0x675B0)),
}
mt.set_handler('struct SCLabel', '__index', SCLabel_mt)

local function RefLabel() return ffi.cast('SCLabel**', sampapi.GetAddress(0x21A0C0))[0] end

return {
    new = CLabel_new,
    RefLabel = RefLabel,
}