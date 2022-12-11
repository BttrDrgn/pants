#include "callbacks.hpp"
#include "utils/memory.hpp"

std::mutex callbacks::mtx_;
std::vector<callback_<void __cdecl()>> callbacks::once_callbacks_;
std::unordered_map<callbacks::type, std::vector<callback_<void __cdecl()>>> callbacks::basic_callbacks_;

void callbacks::init()
{
	//jump(0x0054CBD0, main_loop);

	callbacks::on(type::main_loop, []() -> void
	{
		const std::lock_guard<std::mutex> lock(callbacks::mtx_);

		for (const auto callback : callbacks::once_callbacks_)
		{
			callback();
		}

		callbacks::once_callbacks_.clear();
	});
}

void callbacks::on(callbacks::type type, callback_<void __cdecl()> callback)
{
	callbacks::basic_callbacks_[type].emplace_back(callback);
}

void callbacks::on(const std::initializer_list<callbacks::type>& types, callback_<void __cdecl()> callback)
{
	for (const auto type : types)
	{
		callbacks::basic_callbacks_[type].emplace_back(callback);
	}
}

void callbacks::once(callback_<void __cdecl()> callback)
{
	const std::lock_guard<std::mutex> lock(callbacks::mtx_);

	callbacks::once_callbacks_.emplace_back(callback);
}

void callbacks::run_basic_callbacks(callbacks::type type)
{
	for (const auto callback : callbacks::basic_callbacks_[type])
	{
		callback();
	}
}
