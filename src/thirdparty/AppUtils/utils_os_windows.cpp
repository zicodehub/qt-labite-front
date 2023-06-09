/*!
 * Copyright (c) 2021 Emeric Grange
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include "utils_os_windows.h"

#if defined(Q_OS_WINDOWS)

#include <windows.h>
#include <QDebug>

/* ************************************************************************** */

void UtilsWindows::screenKeepOn(bool on)
{
    // ES_DISPLAY_REQUIRED prevents display sleep?
    // ES_SYSTEM_REQUIRED prevents idle sleep

    EXECUTION_STATE result;
    if (on)
    {
        result = SetThreadExecutionState(ES_CONTINUOUS | ES_SYSTEM_REQUIRED);
    }
    else
    {
        result = SetThreadExecutionState(ES_CONTINUOUS);
    }

    if (result == NULL)
    {
        qWarning() << "screenKeepOn() failed";
    }
}

/* ************************************************************************** */
#endif // Q_OS_WINDOWS
