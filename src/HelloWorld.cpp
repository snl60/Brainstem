#include "HelloWorld.h"
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/godot.hpp>

using namespace godot;

void HelloWorld::_bind_methods(){

}

HelloWorld::HelloWorld(){
    UtilityFunctions::print("Hello World!");
}

HelloWorld::~HelloWorld(){
    
}

void HelloWorld::hello_world(String words){

}

void HelloWorld::_process(double delta){
    UtilityFunction::print("Hello from process!");
}