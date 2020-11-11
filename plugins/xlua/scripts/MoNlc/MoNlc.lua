start_valveL = find_dataref("sim/flightmodel2/engines/starter_is_running[0]")
start_valveR = find_dataref("sim/flightmodel2/engines/starter_is_running[1]")
N1L = find_dataref("sim/cockpit2/engine/indicators/N1_percent[0]")
N1R = find_dataref("sim/cockpit2/engine/indicators/N1_percent[1]")
StartL = create_dataref("MoNlc/B777/engines/startL", "number")
StartR = create_dataref("MoNlc/B777/engines/startR", "number")

fuel_flowL = find_dataref("sim/flightmodel2/engines/has_fuel_flow_after_mixture[0]")
fuel_flowR = find_dataref("sim/flightmodel2/engines/has_fuel_flow_after_mixture[1]")
ShutdownL = create_dataref("MoNlc/B777/engines/shutdownL", "number")
ShutdownR = create_dataref("MoNlc/B777/engines/shutdownR", "number")

APU_spooldn = find_dataref("sim/aircraft/engine/acf_APU_spooldn_time")

APU_spool = find_dataref("sim/aircraft/engine/acf_APU_spoolup_time")
APU_spool_alias = APU_spool
APU_spool_end = 0

APU_N1 = find_dataref("sim/cockpit/engine/APU_N1")
APU_running = find_dataref("sim/cockpit/engine/APU_running")
APU_switch = find_dataref("sim/cockpit/engine/APU_switch")

APU_N1_2 = find_dataref("sim/cockpit2/electrical/APU_N1_percent")
APU_running_2 = find_dataref("sim/cockpit2/electrical/APU_running")
APU_switch_2 = find_dataref("sim/cockpit2/electrical/APU_starter_switch")


APU_start_ratio = create_dataref("MoNlc/B777/systems/APU_start_ratio", "number")
APU_N1_2_last = 0

APU_off = find_command("sim/bleed_air/apu_off")
APU_on = find_command("sim/bleed_air/apu_on")


function B777_APU_start_ratio() 

	APU_start_ratio = (APU_N1_2 - APU_N1_2_last)
	  APU_N1_2_last = APU_N1_2
      
end


function B777_APU_start_ratio_update() 
          
B777_APU_start_ratio()

end




function B777_Apu_running()

        if APU_switch_2 == 0 and APU_start_ratio > 0 then
           APU_switch_2 = 2
	

        end
end

function B777_APU_spoolup_time()


          APU_spool_end = APU_spool_alias * (38 / 10)        
          APU_spool = APU_spool_end
          APU_spooldn = 20
end



function B777_engine_startL()

        if (start_valveL == 1 and N1L < 25) then
                 StartL = 1
        end
end

function B777_APU_spoolup_time_set()
        
        APU_spool_2 = APU_spool
end

function B777_engine_startL_cut()
        
        if N1L >= 25 then
                 StartL = 0
        end
end

function B777_engine_startR()

        if (start_valveR == 1 and N1R < 25) then
                 StartR = 1
        end
end

function B777_engine_startR_cut()
        
        if N1R >= 25 then
                 StartR = 0
        end
end

function B777_engine_shutdownL()

        if (fuel_flowL == 0 and N1L < 26) then
                 ShutdownL = 1
        end
end

function B777_engine_shutdownL_cut()
        if (N1L >= 25 or N1L <= 12) then
                 ShutdownL = 0 
        end
end

function B777_engine_shutdownR()

        if (fuel_flowR == 0 and N1R < 26) then
                 ShutdownR = 1
        end
end

function B777_engine_shutdownR_cut()
        if (N1R >= 25 or N1R <= 12) then
                 ShutdownR = 0 
        end
end


function update_datarefs() 
	
        B777_engine_startL()
        B777_engine_startL_cut()
        B777_engine_startR()
        B777_engine_startR_cut()
        B777_engine_shutdownL()
        B777_engine_shutdownL_cut()
        B777_engine_shutdownR()
        B777_engine_shutdownR_cut()
        B777_APU_spoolup_time()
        B777_Apu_running()
        B777_APU_start_ratio_update()
end 

function after_physics()

	update_datarefs()

end

function after_replay()

	update_datarefs()

end


