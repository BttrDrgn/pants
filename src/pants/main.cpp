#include "sdk/SexySDK.hpp"
#include "callbacks/callbacks.hpp"

HMODULE self = 0;

void init()
{
	if (MH_Initialize() == MH_OK);
	{
		callbacks::init();	//Although not related to minhook starting, its useless without it

		MH_EnableHook(MH_ALL_HOOKS);
	}
}

DWORD WINAPI OnAttachImpl(LPVOID lpParameter)
{
	init();
	return 0;
}

DWORD WINAPI OnAttach(LPVOID lpParameter)
{
	__try
	{
		return OnAttachImpl(lpParameter);
	}
	__except (0)
	{
		FreeLibraryAndExitThread((HMODULE)lpParameter, 0xDECEA5ED);
	}

	return 0;
}

BOOL WINAPI DllMain(HMODULE hModule, DWORD dwReason, LPVOID lpReserved)
{
	switch (dwReason)
	{
	case DLL_PROCESS_ATTACH:
		self = hModule;
		DisableThreadLibraryCalls(self);
		CreateThread(nullptr, 0, OnAttach, self, 0, nullptr);
		return true;
	}

	return false;
}
