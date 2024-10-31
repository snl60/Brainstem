#include "register_types.h"
#include "HelloWorld.h"

#include <gdextension_interface.h>
#include <godot_cpp/core/defs.hpp>
#include <godot_copp/core/class_db.hpp>
#include <godot_cppgodot.hpp>

using namespace godot;

void initialize_hello_world(ModuleInitializationLevel p_level) {
    if(p_level != MODULE_INITIALIZATION_LEVEL_SCENE){
        return;
    }

    ClassDB::register_class<HelloWorld>();
}

void unitialize_hello_world(ModuleInitializationLevel p_level) {
    if(p_level != MODULE_INITIALIZATION_LEVEL_SCENE){
        return;
    }
}

extern "C" {
    GDWExtensionBool GDE_EXPORT hello_world_init(WTF)
}