darktable = require "darktable"
require "darktable.debug"
images = ""

local function gimp_store_callback(storage,image,format,filename,num,total,high_quality,extra_data)
  export_and_reimport_callback(storage,image,format,filename,num,total,high_quality,extra_data)
end

local function callGimp(args)
  coroutine.yield("RUN_COMMAND","gimp "..args)
end

local function gimp_store_finalize(storage,image_table)
  callGimp(images)
end

local bounce_buffer = {}

local function callback()
  images = ""
  bounce_buffer = darktable.gui.selection()
  for index,hash in pairs(bounce_buffer) do
    images = images.." "..hash['path'].."/"..hash['filename']
  end
  callGimp(images)
end

darktable.register_event("shortcut",callback,"Gimp direct")

darktable.register_storage("gimp","Export and reimport and Gimp",
gimp_store_callback, gimp_store_finalize)


--
-- vim: shiftwidth=2 expandtab tabstop=2 cindent syntax=lua

