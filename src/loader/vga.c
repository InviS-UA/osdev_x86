#include "vga.h"
#include "io.h"

uint8_t* g_VgaBuffer = (uint8_t*)0xB8000;

unsigned int g_VgaX = 0;
unsigned int g_VgaY = 0;

const unsigned int g_VgaWidth = 80;
const unsigned int g_VgaHeight = 25;

uint8_t g_Color = 0x07;

void VgaPutChar(char c, unsigned int x, unsigned int y, uint8_t color)
{
    g_VgaBuffer[2 * (y * g_VgaWidth + x)] = c;
    g_VgaBuffer[2 * (y * g_VgaWidth + x) + 1] = color;
}

char VGAGetChar(int x, int y)
{
    return g_VgaBuffer[2 * (y * g_VgaWidth + x)];
}

uint8_t VGAGetColor(int x, int y)
{
    return g_VgaBuffer[2 * (y * g_VgaWidth + x) + 1];
}

void VgaSetCursor(unsigned int x, unsigned int y)
{
    unsigned int pos = y * g_VgaWidth + x;

    outb(0x3D4, 0x0F);
    outb(0x3D5, (uint8_t)(pos & 0xFF));
    outb(0x3D4, 0x0E);
    outb(0x3D5, (uint8_t)((pos >> 8) & 0xFF));
}

void VgaClear(uint8_t color)
{
    for (int y = 0; y < g_VgaHeight; y++)
        for (int x = 0; x < g_VgaWidth; x++)
            VgaPutChar('\0', x, y, color);

    g_VgaX = 0, g_VgaY = 0;
    g_Color = color;
    VgaSetCursor(g_VgaX, g_VgaY);
}

void VgaScrollBack(int lines)
{
    for (int y = lines; y < g_VgaHeight; y++)
        for (int x = 0; x < g_VgaWidth; x++)
            VgaPutChar(VGAGetChar(x, y), x, y - lines, VGAGetColor(x, y));

    for (int y = g_VgaHeight - lines; y < g_VgaHeight; y++)
        for (int x = 0; x < g_VgaWidth; x++)
            VgaPutChar('\0', x, y, g_Color);

    g_VgaY -= lines;
}

void VgaPutc(char c, int colored, uint8_t color)
{
    switch (c)
    {
        case '\n':
            g_VgaX = 0;
            g_VgaY++;
            break;
        case '\t':
            for (int i = 0; i < 4 - (g_VgaX % 4); i++)
                VgaPutc(' ', 1, !colored ? g_Color : color);
            break;
        case '\r':
            g_VgaX = 0;
            break;
        default:
            VgaPutChar(c, g_VgaX, g_VgaY, !colored ? g_Color : color);
            g_VgaX++;
            break;
    }

    if (g_VgaX >= g_VgaWidth)
    {
        g_VgaY++;
        g_VgaX = 0;
    }
    if (g_VgaY >= g_VgaHeight)
        VgaScrollBack(1);

    VgaSetCursor(g_VgaX, g_VgaY);
}