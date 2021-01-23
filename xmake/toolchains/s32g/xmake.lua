toolchain("s32g")
    set_description("NXP S32G Compiler")
    set_kind("standalone")

    if is_host("linux") then
        -- sysroot = "--sysroot="
        sysroot = os.getenv("OECORE_TARGET_SYSROOT")
        if sysroot == nil then
            print("error:  Please setup the environment of S32G first")
            return
        end

        set_toolset("cc", "aarch64-fsl-linux-gcc")
        set_toolset("ld", "aarch64-fsl-linux-g++", "aarch64-fsl-linux-gcc")
        set_toolset("cxx", "aarch64-fsl-linux-g++")
        set_toolset("as", "aarch64-fsl-linux-as")
        set_toolset("ar", "aarch64-fsl-linux-ar")
        set_toolset("nm", "aarch64-fsl-linux-nm")

        add_cflags("--sysroot=".. sysroot .. " -O2 -pipe -g -feliminate-unused-debug-types")
        add_cxxflags("--sysroot=".. sysroot .. " -O2 -pipe -g -feliminate-unused-debug-types")
        add_ldflags("--sysroot=".. sysroot .. " -Wl,-O1 -Wl,--hash-style=gnu -Wl,--as-needed")

        -- check toolchain
        on_check(function (toolchain)
            return import("lib.detect.find_tool")("aarch64-fsl-linux-gcc")
        end)
    else
        print("error:  Only supports linux as the build host")
        return
    end
