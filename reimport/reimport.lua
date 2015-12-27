darktable = require "darktable"
require "darktable.debug"
images = ""

function filename_is_available(name)
  local f=io.open(name,"r")
  if f~=nil then io.close(f) return false else return true end
end

function export_and_reimport_callback(storage,image,format,filename,num,total,high_quality,extra_data)
  -- move to path
  new_extension  = string.match(filename,'....$')
  basename = image['path'].."/"..image['filename']
  basename = string.gsub(basename,'....$','') -- no extension. TODO: better regexp
  newname = ""
  for i=0,100,1 do
    newname = basename.."_REIMPORT"..tostring(i)..new_extension
    if (filename_is_available(newname)) then
      break
    end
  end
  os.execute("cp "..filename.." "..newname) -- not so cool :/

  image = darktable.database.import(newname)
  images=newname.." "
end


local function export_and_reimport_finalize_callback(storage,image_table)
  darktable.print("reimported")
end

local bounce_buffer = {}

darktable.register_storage("export_reimport","Export and reimport",
export_and_reimport_callback, export_and_reimport_finalize_callback)

--
-- vim: shiftwidth=2 expandtab tabstop=2 cindent syntax=lua

