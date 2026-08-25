cmake_minimum_required(VERSION 3.10)

project(adblock_engine VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_library(adblock SHARED
    ad_blocker.cpp
    ad_blocker.h
    ad_blocker_c.cpp
    ad_blocker_c.h
)

set_target_properties(adblock PROPERTIES
    CXX_VISIBILITY_PRESET hidden
    VISIBILITY_INLINES_HIDDEN ON
)

if(MSVC)
    target_compile_options(adblock PRIVATE /W4)
else()
    target_compile_options(adblock PRIVATE -Wall -Wextra)
endif()
