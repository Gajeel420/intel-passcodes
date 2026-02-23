/*
 * Frida Lua Dumper v6 - Writes to app's own cache directory
 * Target: GameVault (com.ywyjshduwihjsds.games)
 * Hooks XLua runtime to capture all Lua scripts loaded at runtime
 *
 * Usage: frida -U <PID> -l dump_lua_v6.js
 * Then: adb shell su -c 'cp -r /data/user/0/com.ywyjshduwihjsds.games/cache/lua_dump /data/local/tmp/ && chmod -R 777 /data/local/tmp/lua_dump'
 * Then: adb pull /data/local/tmp/lua_dump/ ./lua_dump/
 */

'use strict';

var dumpDir = null;
var scriptCount = 0;
var seenScripts = {};
var pendingDumps = [];

function sanitizeFilename(name) {
    if (!name || name.length === 0) return "unnamed_" + scriptCount;
    var clean = name;
    if (clean.charAt(0) === '@') clean = clean.substring(1);
    return clean.replace(/\//g, '__').replace(/[^a-zA-Z0-9._\-]/g, '_').substring(0, 200);
}

function flushPending() {
    if (!dumpDir || pendingDumps.length === 0) return;
    var toWrite = pendingDumps.splice(0);
    Java.perform(function() {
        var FileOutputStream = Java.use('java.io.FileOutputStream');
        toWrite.forEach(function(item) {
            try {
                var fos = FileOutputStream.$new(item.path);
                fos.write(item.javaBytes);
                fos.flush();
                fos.close();
                console.log("[#" + item.count + "] " + (item.isBytecode ? "BC" : "SRC") + " " + item.sizeKB + "KB | " + item.name);
            } catch(e) {
                console.log("[ERR] " + item.name + ": " + e.message);
            }
        });
    });
}

function dumpScript(buff, size, name) {
    if (size <= 0 || size > 10 * 1024 * 1024) return;

    var scriptName = name || ("unnamed_" + scriptCount);
    if (seenScripts[scriptName]) return;
    seenScripts[scriptName] = true;
    scriptCount++;

    var filename = sanitizeFilename(scriptName);
    var data = buff.readByteArray(size);
    var headerBytes = new Uint8Array(data.slice(0, Math.min(4, size)));
    var isBytecode = (headerBytes[0] === 0x1B && headerBytes[1] === 0x4C);
    var ext = isBytecode ? ".luac" : ".lua";

    var byteArr = Array.from(new Uint8Array(data)).map(function(b) { return b > 127 ? b - 256 : b; });

    Java.perform(function() {
        var javaBytes = Java.array('byte', byteArr);
        var outPath = dumpDir + "/" + filename + ext;
        pendingDumps.push({
            path: outPath,
            javaBytes: javaBytes,
            name: scriptName,
            count: scriptCount,
            isBytecode: isBytecode,
            sizeKB: (size / 1024).toFixed(1)
        });
    });
}

function initDumpDir() {
    Java.perform(function() {
        var ActivityThread = Java.use('android.app.ActivityThread');
        var app = ActivityThread.currentApplication();
        var context = app.getApplicationContext();
        var cacheDir = context.getCacheDir().getAbsolutePath();
        dumpDir = cacheDir + "/lua_dump";

        var File = Java.use('java.io.File');
        var dir = File.$new(dumpDir);
        dir.mkdirs();
        console.log("[*] Dump dir: " + dumpDir);
        console.log("[*] Pull cmd: adb shell su -c 'cp -r " + dumpDir + " /data/local/tmp/ && chmod -R 777 /data/local/tmp/lua_dump'");
        console.log("[*] Then: adb pull /data/local/tmp/lua_dump/ ./lua_dump/");
    });
}

function hookXLua() {
    var libxlua = Process.findModuleByName("libxlua.so");
    if (!libxlua) {
        console.log("[.] Waiting for libxlua.so...");
        setTimeout(hookXLua, 1500);
        return;
    }
    console.log("[*] libxlua.so @ " + libxlua.base);

    initDumpDir();

    var fn1 = libxlua.findExportByName("luaL_loadbufferx");
    if (fn1) {
        Interceptor.attach(fn1, {
            onEnter: function(args) {
                dumpScript(args[1], args[2].toInt32(), args[3].readUtf8String());
            }
        });
        console.log("[+] luaL_loadbufferx");
    }

    var fn2 = libxlua.findExportByName("xluaL_loadbuffer");
    if (fn2) {
        Interceptor.attach(fn2, {
            onEnter: function(args) {
                dumpScript(args[1], args[2].toInt32(), args[3].readUtf8String());
            }
        });
        console.log("[+] xluaL_loadbuffer");
    }

    var fn3 = libxlua.findExportByName("luaL_loadstring");
    if (fn3) {
        Interceptor.attach(fn3, {
            onEnter: function(args) {
                try {
                    var str = args[1].readUtf8String();
                    if (str && str.length > 10) {
                        dumpScript(args[1], str.length, "loadstring_" + scriptCount);
                    }
                } catch(e) {}
            }
        });
        console.log("[+] luaL_loadstring");
    }

    console.log("[*] Hooks active!");
    setInterval(flushPending, 500);
}

console.log("=== GameVault Lua Dumper v6 ===");
hookXLua();
