require 'win32ole'

wsh = WIN32OLE.new('Wscript.Shell')
wsh.run("cmd.exe")
#wsh.SendKeys("pik use ruby-2.3.3-p222")
#wsh.SendKeys("ruby '..\\History\\main\\save_spx.rb'")