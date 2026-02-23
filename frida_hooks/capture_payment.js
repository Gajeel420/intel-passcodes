/*
 * GameVault Payment + Lua Capture
 * Hooks XLua loads + WebView URLs + URL constructor for payment flow capture
 *
 * Usage: frida -U <PID> -l capture_payment.js
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
                console.log("[SAVED] " + item.name);
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
        pendingDumps.push({ path: outPath, javaBytes: javaBytes, name: scriptName });
    });
}

function initDumpDir() {
    Java.perform(function() {
        var ActivityThread = Java.use('android.app.ActivityThread');
        var app = ActivityThread.currentApplication();
        var context = app.getApplicationContext();
        var cacheDir = context.getCacheDir().getAbsolutePath();
        dumpDir = cacheDir + "/payment_capture";
        var File = Java.use('java.io.File');
        var dir = File.$new(dumpDir);
        dir.mkdirs();
        console.log("[*] Payment capture dir: " + dumpDir);
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

    console.log("[*] Lua hooks active!");
    hookNetwork();
    setInterval(flushPending, 500);
}

function hookNetwork() {
    Java.perform(function() {
        try {
            var WebView = Java.use("android.webkit.WebView");
            WebView.loadUrl.overload("java.lang.String").implementation = function(url) {
                console.log("\n[WEBVIEW] >>> " + url);
                return this.loadUrl(url);
            };
            console.log("[+] WebView.loadUrl hooked");
        } catch(e) {
            console.log("[-] WebView: " + e);
        }

        try {
            var URL = Java.use("java.net.URL");
            URL.$init.overload("java.lang.String").implementation = function(spec) {
                if (spec) {
                    var lower = spec.toLowerCase();
                    if (lower.indexOf("pay") !== -1 || lower.indexOf("order") !== -1 ||
                        lower.indexOf("recharge") !== -1 || lower.indexOf("validate") !== -1 ||
                        lower.indexOf("cardpay") !== -1 || lower.indexOf("denomin") !== -1) {
                        console.log("\n[PAY-URL] >>> " + spec);
                    }
                }
                return this.$init(spec);
            };
            console.log("[+] URL constructor hooked (payment filter)");
        } catch(e) {
            console.log("[-] URL: " + e);
        }
    });
}

console.log("=== GameVault Payment Capture ===");
hookXLua();
