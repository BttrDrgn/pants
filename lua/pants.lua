newoption {
	trigger = "example-mod",
	description = "Adds the example-mod to the solution."
 }

workspace "Pants"
	startproject "Pants"
	location "../build/"
	targetdir "%{wks.location}/bin/%{cfg.buildcfg}-%{cfg.platform}/"
	objdir "%{wks.location}/obj/%{prj.name}/%{cfg.buildcfg}-%{cfg.platform}/"
	buildlog "%{wks.location}/obj/%{cfg.platform}/%{cfg.buildcfg}-%{prj.name}.log"

	largeaddressaware "on"
	editandcontinue "off"
	staticruntime "on"

	systemversion "latest"
	characterset "unicode"
	warnings "extra"

	flags {
		"shadowedvariables",
		"undefinedidentifiers",
		"multiprocessorcompile",
	}

	platforms {
		"x86",
	}

	configurations {
		"Release",
		"Debug",
	}

	defines {
		"_SILENCE_ALL_CXX17_DEPRECATION_WARNINGS",
	}

	--x86
	filter "platforms:x86"	
		architecture "x86"
	--end

	filter "Release"
		defines "NDEBUG"
		optimize "full"
		runtime "debug"
		symbols "off"

	filter "Debug"
		defines "DEBUG"
		optimize "debug"
		runtime "debug"
		symbols "on"

	project "Pants"
		targetname "pants-sdk"
		language "c++"
		kind "sharedlib"
		warnings "off"

		pchheader "stdafx.hpp"
		pchsource "../src/pants/stdafx.cpp"
		forceincludes "stdafx.hpp"

		dependson {
			"MinHook",
		}

		links {
			"MinHook",
		}

		includedirs {
			"../src/pants/",
			"../deps/minhook/include/",
		}

		files {
			"../src/pants/**",
		}

if _OPTIONS["example-mod"] then
	project "Example-Mod"
		targetname "example-mod"
		language "c++"
		kind "sharedlib"
		warnings "off"

		pchheader "stdafx.hpp"
		pchsource "../src/example-mod/stdafx.cpp"
		forceincludes "stdafx.hpp"

		dependson {
			"MinHook",
			"pants",
		}

		links {
			"MinHook",
			"pants",
		}

		includedirs {
			"../src/example-mod/",
			"../src/pants/",
			"../deps/minhook/include/",
		}

		files {
			"../src/example-mod/**",
		}
end

	group "Dependencies"

	project "MinHook"
		targetname "MinHook"

		language "c++"
		kind "staticlib"

		files {
			"../deps/minhook/src/**",
		}

		includedirs {
			"../deps/minhook/include/",
		}
