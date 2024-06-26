import sys
import traceback


def byte(c):
    if isinstance(c, str):
        return ord(c)
    return c


def le16(val):
    return (val & 0xff), ((val >> 8) & 0xff)


def uint16(val0, val1):
    return (val0 & 0xff) | ((val1 & 0xff) << 8)


def int16(val0, val1):
    if (val1 & 0xff) != 0:
        return ((val0 & 0xff) | ((val1 & 0xff) << 8)) - 0x10000
    else:
        return (val0 & 0xff) | ((val1 & 0xff) << 8)

def single(a,b,c,d):
    return struct.unpack('<f',bytes([a,b,c,d]))[0]
    
def byte_to_hexstring(buf):
    if isinstance(buf, str):
        return ''.join(["%02x " % ord(x) for x in buf]).strip()

    return ''.join(["%02x " % ord(chr(x)) for x in buf]).strip()


def show_exception(ex):
    exc_type, exc_value, exc_traceback = sys.exc_info()
    traceback.print_exception(exc_type, exc_value, exc_traceback)

def log_exeception(ex,LOGGER,level="ERROR"):
    exc_type, exc_value, exc_traceback = sys.exc_info()
    str=traceback.format_exception(exc_type, exc_value, exc_traceback)
    for s in str:
        if level=="INFO":
            LOGGER.info(s)
        elif level=="ERROR":
            LOGGER.error(s)
        elif level=="DEBUG":   
            LOGGER.debug(s)
        