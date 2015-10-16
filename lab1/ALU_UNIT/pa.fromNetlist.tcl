
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name ALU_UNIT -dir "C:/Users/pc/Documents/GitHub/MIPS_CPU/lab1/ALU_UNIT/planAhead_run_3" -part xc3s1200efg320-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/Users/pc/Documents/GitHub/MIPS_CPU/lab1/ALU_UNIT/ALU_UNIT.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Users/pc/Documents/GitHub/MIPS_CPU/lab1/ALU_UNIT} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "ALU_UNIT.ucf" [current_fileset -constrset]
add_files [list {ALU_UNIT.ucf}] -fileset [get_property constrset [current_run]]
link_design
