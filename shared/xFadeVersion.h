#pragma once

/***************************************************************
 * This source files comes from the xLights project
 * https://www.xlights.org
 * https://github.com/xLightsSequencer/xLights
 * See the github commit history for a record of contributing
 * developers.
 * Copyright claimed based on commit dates recorded in Github
 * License: https://github.com/xLightsSequencer/xLights/blob/master/License.txt
 **************************************************************/

#include <string>

 // Update these before building a release

#if __has_include("xfade_build_version.h")
#include "xfade_build_version.h"
#else
static const std::string xfade_version_string  = "2026.04.1";
#endif
#ifdef DEBUG
static const std::string xfade_qualifier       = " DEBUG";
#else
static const std::string xfade_qualifier       = ""; // " BETA,ALPHA,PROD";
#endif
static const std::string xfade_build_date      = __DATE__;

const std::string &GetBitness();
std::string GetDisplayVersionString();

#define WXWIDGETS_VERSION "33"
