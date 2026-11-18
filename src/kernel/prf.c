#include <prf.h>
#include <portab.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdarg.h>

extern void _con(uint8_t);

static char* lltoa(long long n, char* s, int base)
{
    uint64_t u;
    char *p, *q;
    int neg = 0;
    char c;

    if (n < 0 && base == -10)
    {
        neg = 1;
        u = (uint64_t)(-n);
    }
    else
    {
        u = (uint64_t)n;
    }
    if (base == -10) base = 10;

    p = s;

    do
    {
        *p++ = "0123456789abcdef"[u % base];
    } while ((u /= base) > 0);
    
    if (neg) *p++ = '-';

    *p = '\0';

    q = s;
    char *end = p - 1;
    while (q < end)
    {
        c = *q;
        *q++ = *end;
        *end-- = c;
    }

    return s;
}

void do_printf(const char* fmt, va_list args);

#define PRF_ST_NORMAL       0
#define PRF_ST_LEN          1
#define PRF_ST_SPEC         2

#define PRF_LEN_NORMAL      0
#define PRF_LEN_SHORT       1
#define PRF_LEN_LONG        2
#define PRF_LEN_LONG_LONG   3

void printf(const char* fmt, ...)
{
    va_list args;
    va_start(args, fmt);
    do_printf(fmt, args);
    va_end(args);
}

void do_printf(const char* fmt, va_list args)
{
    int state = PRF_ST_NORMAL;
    int len = PRF_LEN_NORMAL;
    int base = 10;
    bool sign = false;
    bool number = false;

    while (*fmt)
    {
        switch (state)
        {
        case PRF_ST_NORMAL:
            if (*fmt == '%')
            {
                state = PRF_ST_LEN;
            }
            else
            {
                _con(*fmt);
            }
            break;
        case PRF_ST_LEN:
            if (*fmt == 'h')
            {
                len = PRF_LEN_SHORT;
                break;
            }
            else if (*fmt == 'l')
            {
                if (len == PRF_LEN_LONG)
                {
                    len = PRF_LEN_LONG_LONG;
                }
                else
                {
                    len = PRF_LEN_LONG;
                }
                break;
            }
            state = PRF_ST_SPEC;
        case PRF_ST_SPEC:
            switch (*fmt)
            {
            case 'c':
                _con((char)va_arg(args, int));
                break;
            case 's':
            {
                const char* str = (const char*)va_arg(args, const char*);
                while (*str) _con(*(str++));
                break;
            }
            case '%':
                _con('%');
                break;
            case 'd':
            case 'i':
                base = 10;
                sign = true;
                number = true;
                break;
            case 'u':
                base = 10;
                sign = false;
                number = true;
                break;
            case 'X':
            case 'x':
            case 'p':
                base = 16;
                sign = false;
                number = true;
                break;
            case 'o':
                base = 8;
                sign = false;
                number = true;
                break;
            }

            if (number)
            {
                char buf[64];
                long long val;

                if (len == PRF_LEN_LONG_LONG)
                {
                    val = va_arg(args, long long);
                }
                else if (len == PRF_LEN_LONG)
                {
                    val = va_arg(args, long);
                }
                else
                {
                    val = va_arg(args, int);
                }

                int effective_base = (sign && val < 0) ? -base : base;
                char* s = lltoa(val, buf, effective_base);
                while (*s) _con(*(s++));
            }

            state = PRF_ST_NORMAL;
            len = PRF_LEN_NORMAL;
            base = 10;
            sign = false;
            number = false;

            break;
        }

        fmt++;
    }
}