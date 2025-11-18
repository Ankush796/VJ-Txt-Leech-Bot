# utils.py
# Don't Remove Credit Tg - @VJ_Botz
# Subscribe YouTube Channel For Amazing Bot https://youtube.com/@Tech_VJ
# Ask Doubt on telegram @KingVJ01

import time
import math
import os
import asyncio
from pyrogram.errors import FloodWait
from datetime import datetime, timedelta

class Timer:
    def __init__(self, time_between=5):
        self.start_time = time.time()
        self.time_between = time_between

    def can_send(self):
        if time.time() > (self.start_time + self.time_between):
            self.start_time = time.time()
            return True
        return False


def hrb(value, digits=2, delim="", postfix=""):
    """Return a human-readable file size."""
    if value is None:
        return None
    try:
        v = float(value)
    except Exception:
        return str(value)
    chosen_unit = "B"
    for unit in ("KiB", "MiB", "GiB", "TiB"):
        if v > 1000:
            v /= 1024
            chosen_unit = unit
        else:
            break
    return f"{v:.{digits}f}" + delim + chosen_unit + postfix


def hrt(seconds, precision=0):
    """Return a human-readable time delta as a string."""
    try:
        seconds = float(seconds)
    except Exception:
        seconds = 0
    value = timedelta(seconds=seconds)

    pieces = []
    if value.days:
        pieces.append(f"{value.days}d")

    sec = value.seconds

    if sec >= 3600:
        hours = int(sec / 3600)
        pieces.append(f"{hours}h")
        sec -= hours * 3600

    if sec >= 60:
        minutes = int(sec / 60)
        pieces.append(f"{minutes}m")
        sec -= minutes * 60

    if sec > 0 or not pieces:
        pieces.append(f"{sec}s")

    if not precision:
        return "".join(pieces)

    return "".join(pieces[:precision])


timer = Timer()


async def progress_bar(current, total, reply, start):
    """
    Update an existing message `reply` with a progress bar.
    current, total should be numeric (bytes).
    start is the start timestamp (time.time()).
    """
    if not timer.can_send():
        return

    now = time.time()
    diff = now - start
    if diff < 1:
        return

    # safe conversions
    try:
        cur = float(current)
    except Exception:
        cur = 0.0
    try:
        tot = float(total)
    except Exception:
        tot = 0.0

    # avoid division by zero
    if tot <= 0:
        perc = "0.0%"
        completed_length = 0
        remaining_length = 11
        sp = hrb(0) + "/s"
        eta = "-"
        cur_hr = hrb(cur) if cur else "0B"
        tot_hr = hrb(tot) if tot else "0B"
    else:
        perc = f"{cur * 100 / tot:.1f}%"
        elapsed_time = round(diff) if diff >= 1 else 1
        speed = cur / elapsed_time if elapsed_time > 0 else 0
        remaining_bytes = max(0.0, tot - cur)
        if speed > 0:
            eta_seconds = remaining_bytes / speed
            eta = hrt(eta_seconds, precision=1)
        else:
            eta = "-"
        sp = str(hrb(speed)) + "/s"
        tot_hr = hrb(tot)
        cur_hr = hrb(cur)
        bar_length = 11
        completed_length = int(cur * bar_length / tot)
        completed_length = max(0, min(bar_length, completed_length))
        remaining_length = bar_length - completed_length

    progress_bar_str = "▰" * completed_length + "▱" * remaining_length

    try:
        await reply.edit(
            f'<b>\n ╭──⌯════🆄︎ᴘʟᴏᴀᴅɪɴɢ⬆️⬆️═════⌯──╮ \n'
            f'├⚡ {progress_bar_str}|﹝{perc}﹞ \n'
            f'├🚀 Speed » {sp} \n'
            f'├📟 Processed » {cur_hr}\n'
            f'├🧲 Size - ETA » {tot_hr} - {eta} \n'
            f'├🤖 𝔹ʏ » @VJ_Botz\n'
            f'╰─═══ ✪ @VJ_Botz ✪ ═══─╯\n</b>'
        )
    except FloodWait as e:
        # FloodWait may expose seconds as .x or .value depending on pyrogram version.
        wait_seconds = getattr(e, "x", None) or getattr(e, "value", None)
        try:
            wait_seconds = float(wait_seconds)
        except Exception:
            wait_seconds = 1
        await asyncio.sleep(wait_seconds)
    except Exception:
        # ignore other edit errors (MessageNotModified, BadRequest, etc.)
        return
