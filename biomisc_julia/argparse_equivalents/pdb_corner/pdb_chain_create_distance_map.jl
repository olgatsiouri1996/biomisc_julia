# julia
using ArgParse
using BioStructures
using Plots
# input parameters function
function parse_commandline()

    s = ArgParseSettings(description = "retrieve distance map from all the aminoacids of a chain(Cβ-Cβ bonds) by importing a pdb file and selecting a chain")
    @add_arg_table s begin
        "--pdb"
            help = "input pdb file"
        "--model"
            help = "model to select in the pdb file"
            arg_type = Int
            default = 1
            required = false
        "--chain"
            help = "chain to select in the pdb file" 
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
    dists = DistanceMap(collectatoms(s[parsed_args["model"]][parsed_args["chain"]], cbetaselector))
    plot(dists)
    png(parsed_args["out"])
end

main()
