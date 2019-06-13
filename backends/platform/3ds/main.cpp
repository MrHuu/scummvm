/* ScummVM - Graphic Adventure Engine
 *
 * ScummVM is the legal property of its developers, whose names
 * are too numerous to list here. Please refer to the COPYRIGHT
 * file distributed with this source distribution.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 *
 */

#include "osystem.h"
#include <3ds.h>

int main(int argc, char *argv[]) {

//-- Standalone builds
#ifdef _GAME
	#ifdef _BBVS
		char* n_argv[] = {"BBVS[ScummVM]","--path=romfs:/game","bbvs",NULL};
	#endif
	#ifdef _COMI
		char* n_argv[] = {"COMI[ScummVM]","--path=romfs:/game","comi",NULL};
	#endif
	#ifdef _DIG
		char* n_argv[] = {"DIG[ScummVM]","--path=romfs:/game","dig",NULL};
	#endif
	#ifdef _DW
		char* n_argv[] = {"DW[ScummVM]","--path=romfs:/game","dw",NULL};
	#endif
	#ifdef _DW2
		char* n_argv[] = {"DW2[ScummVM]","--path=romfs:/game","dw2",NULL};
	#endif
	#ifdef _FT
		char* n_argv[] = {"FT[ScummVM]","--path=romfs:/game","ft",NULL};
	#endif
	#ifdef _MONKEY
		char* n_argv[] = {"MONKEY[ScummVM]","--path=romfs:/game","monkey",NULL};
	#endif
	#ifdef _MONKEY2
		char* n_argv[] = {"MONKEY2[ScummVM]","--path=romfs:/game","monkey2",NULL};
	#endif
	#ifdef _MYST
		char* n_argv[] = {"MYST[ScummVM]","--path=romfs:/game","myst",NULL};
	#endif
	#ifdef _NEVERHOOD
		char* n_argv[] = {"NEVERHOOD[ScummVM]","--path=romfs:/game","neverhood",NULL};
	#endif
	#ifdef _QUEEN
		char* n_argv[] = {"QUEEN[ScummVM]","--path=romfs:/game","queen",NULL};
	#endif
	#ifdef _RIVEN
		char* n_argv[] = {"RIVEN[ScummVM]","--path=romfs:/game","riven",NULL};
	#endif
	#ifdef _SAMNMAX
		char* n_argv[] = {"SAMNMAX[ScummVM]","--path=romfs:/game","samnmax",NULL};
	#endif
	#ifdef _TENTACLE
		char* n_argv[] = {"TENTACLE[ScummVM]","--path=romfs:/game","tentacle",NULL};
	#endif
	#ifdef _TOON
		char* n_argv[] = {"TOON[ScummVM]","--path=romfs:/game","toon",NULL};
	#endif
	argv = n_argv;
	argc = 3;
	romfsInit();
#endif


// Initialize basic libctru stuff
	gfxInitDefault();
	cfguInit();
	osSetSpeedupEnable(true);

// 	consoleInit(GFX_TOP, NULL);

	g_system = new _3DS::OSystem_3DS();
	assert(g_system);

// Invoke the actual ScummVM main entry point
// 	if (argc > 2)
// 		res = scummvm_main(argc-2, &argv[2]);
// 	else
// 		res = scummvm_main(argc, argv);
//	scummvm_main(0, nullptr);

	int res = scummvm_main(argc, argv);

	g_system->destroy();

// Turn on both screen backlights before exiting.
	if (R_SUCCEEDED(gspLcdInit())) {
		GSPLCD_PowerOnBacklight(GSPLCD_SCREEN_BOTH);
		gspLcdExit();
	}
//-- Standalone builds
#ifdef _GAME
	romfsExit();
#endif
	cfguExit();
	gfxExit();
	return res;
}
