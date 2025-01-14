--!A cross-platform build utility based on Lua
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
-- Copyright (C) 2015-present, TBOOX Open Source Group.
--
-- @author      ruki
-- @file        find_toolname.lua
--

-- imports
import("core.sandbox.module")

-- find tool name from the given program
function _find(program)

    -- attempt to find it directly first
    if module.find("detect.tools.find_" .. program) then
        return program
    end

    -- get file name first
    name = path.filename(program):lower()

    -- remove arguments: " -xxx" or " --xxx"
    name = name:gsub("%s%-+%w+", " ")

    -- get the last name by ' ': xxx xxx toolname
    local names = name:split("%s")
    if #names > 0 then
        name = names[#names]
    end

    -- remove suffix: ".xxx"
    name = name:gsub("%.%w+", "")

    -- find_toolname.lua exists? found
    local toolname = name:gsub("[%+%-]", function (ch) return ifelse(ch == "+", "x", "_") end)
    if module.find("detect.tools.find_" .. toolname) then
        return toolname
    end

    -- get the last valid name: xxx-xxx-toolname-5
    local partnames = {}
    for partname in name:gmatch("([%a%+]+)") do
        table.insert(partnames, partname)
    end
    if #partnames > 0 then
        name = partnames[#partnames]
    end

    -- find_toolname.lua exists? found
    toolname = name:gsub("%+", "x")
    if module.find("detect.tools.find_" .. toolname) then
        return toolname
    end
end

-- find tool name
--
-- e.g.
-- "xcrun -sdk macosx clang":   clang
-- "/usr/bin/arm-linux-gcc":    gcc
-- "link.exe -lib":             link
-- "gcc-5":                     gcc
-- "arm-android-clang++":       clangxx
-- "pkg-config":                pkg_config
--
-- @param program   the program path or name
--
-- @return          the tool name
--
function main(program)

    -- init cache
    local toolnames = _g._TOOLNAMES or {}

    -- get it from the cache first
    local toolname = toolnames[program]
    if toolname ~= nil then
        return ifelse(toolname, toolname, nil)
    end

    -- find the tool name
    toolname = _find(program)

    -- save result to cache
    toolnames[program] = ifelse(toolname, toolname, false)
    _g._TOOLNAMES = toolnames

    -- found?
    return toolname
end
