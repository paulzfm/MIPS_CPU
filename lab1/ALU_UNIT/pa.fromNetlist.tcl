
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name ALU_UNIT -dir "E:/XProjects/MIPS_CPU/lab1/ALU_UNIT/planAhead_run_4" -part xc3s1200efg320-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "E:/XProjects/MIPS_CPU/lab1/ALU_UNIT/ALU_UNIT.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {E:/XProjects/MIPS_CPU/lab1/ALU_UNIT} }
set_property target_constrs_file "ALU_UNIT.ucf" [current_fileset -constrset]
add_files [list {ALU_UNIT.ucf}] -fileset [get_property constrset [current_run]]
link_design
