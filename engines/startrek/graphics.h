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

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 *
 * $URL: https://scummvm-startrek.googlecode.com/svn/trunk/graphics.h $
 * $Id: graphics.h 2 2009-09-12 20:13:40Z clone2727 $
 *
 */

#ifndef STARTREK_GRAPHICS_H
#define STARTREK_GRAPHICS_H

#include "startrek/bitmap.h"
#include "startrek/startrek.h"
#include "startrek/font.h"

#include "common/rect.h"
#include "common/stream.h"

namespace StarTrek {

class Font;
class StarTrekEngine;


const int SCREEN_WIDTH = 320;
const int SCREEN_HEIGHT = 200;

const int MAX_SPRITES = 32;


struct Sprite {
	uint16 x,y;
	uint16 drawPriority;
	uint16 field6;
	uint16 field8;
	Bitmap *bitmap;
	uint16 drawMode;
	uint16 textColor;
	uint16 bitmapChanged;
	uint16 redrawCondition2;
	uint16 redrawCondition3;
	uint16 field16;
	Common::Rect rectangle1;
	Common::Rect clickRectangle;
	Common::Rect rectangle2;
	uint16 drawX,drawY;
};


class Graphics {
public:
	Graphics(StarTrekEngine *vm);
	~Graphics();
	
	void loadEGAData(const char *egaFile);
	void drawBackgroundImage(const char *filename);

	void loadPalette(const Common::String &paletteFile);
	void loadPri(const char *priFile);

	void redrawScreen();
	void drawSprite(const Sprite &sprite);
	void drawSprite(const Sprite &sprite, const Common::Rect &rect);
	void drawAllSprites();

	void addSprite(Sprite *sprite);
	void delSprite(Sprite *sprite);
	
	
private:
	void drawBitmapToScreen(Bitmap *bitmap);


	StarTrekEngine *_vm;
	Font *_font;
	
	bool _egaMode;
	byte *_egaData;
	byte *_priData;
	byte *_lutData;

	Common::Rect _screenRect;
	Bitmap *_backgroundImage;
	Bitmap *_canvas;

	Sprite *_sprites[MAX_SPRITES];
	int _numSprites;
};

}

#endif