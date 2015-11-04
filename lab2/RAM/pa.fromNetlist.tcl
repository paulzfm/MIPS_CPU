
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name RAM -dir "E:/XProjects/MIPS_CPU/lab2/RAM/planAhead_run_1" -part xc3s1200efg320-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "E:/XProjects/MIPS_CPU/lab2/RAM/RAMController.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {E:/XProjects/MIPS_CPU/lab2/RAM} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "RAMController.ucf" [current_fileset -constrset]
add_files [list {RAMController.ucf}] -fileset [get_property constrset [current_run]]
link_design
