local VERSION = "Driver Version"
local MJPEG = "MJPEG Endpoint"
local RTSP = "RTSP Endpoint"
local SNAPSHOT = "Snapshot Endpoint"

local GenericCamera = (function(baseClass)
    local class = {}; class.__index = class

    function class:getMJPEGQueryString(tParams)
        local str = Properties[MJPEG]

        return "<mjpeg_query_string>" .. C4:XmlEscapeString(str) .. "</mjpeg_query_string>"
    end

    function class:getRTSPH264QueryString(tParams)
        local str = Properties[RTSP]

        return "<rtsp_h264_query_string>" .. C4:XmlEscapeString(str) .. "</rtsp_h264_query_string>"
    end

    function class:getSnapshotQueryString(tParams)
        local str = Properties[SNAPSHOT]

        return "<snapshot_query_string>" .. C4:XmlEscapeString(str) .. "</snapshot_query_string>"
    end

    local mt = {
        __call = function(self, proxyId)
            local instance = baseClass and baseClass(proxyId) or {}

            setmetatable(instance, class)

            return instance
        end,

        __index = baseClass
    }

    setmetatable(class, mt)

    return class
end) (Camera)


Driver = (function()
    local class = {
        camera = GenericCamera(5001)
    }

    function class.OnDriverLateInit()
        C4:UpdateProperty(VERSION, C4:GetDriverConfigInfo("semver"))
    end

    if (Hooks) then
        Hooks.Register(class, "Driver")
    end

    return class
end)()