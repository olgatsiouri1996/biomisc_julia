# julia
using ArgParse
using BioStructures
using Plots
# input parameters function
function parse_commandline()

    s = ArgParseSettings(description = "retrieve distance map from all the aminoacids between 2 chains(Cβ-Cβ bonds) by importing a pdb file and selecting the chains")
    @add_arg_table s begin
        "--pdb"
            help = "input pdb file"
        "--model"
            help = "model to select in the pdb file"
            arg_type = Int
            default = 1
            required = false
        "--first"
            help = "1st selected chain in model" 
        "--second"
            help = "2nd selected chain in model"    
        "--out"
            help = "output png file"   
    end
    return parse_args(s)
end

function main()
    parsed_args = parse_commandline()
    println(parsed_args)
# main
    s = read(parsed_args["pdb"], PDB)
    cbetas_A = collectatoms(s[parsed_args["model"]][parsed_args["first"]], cbetaselector)
    cbetas_B = collectatoms(s[parsed_args["model"]][parsed_args["second"]], cbetaselector)
    dm = DistanceMap(cbetas_A, cbetas_B)
    plot(dm)
    png(parsed_args["out"])
end

main()
