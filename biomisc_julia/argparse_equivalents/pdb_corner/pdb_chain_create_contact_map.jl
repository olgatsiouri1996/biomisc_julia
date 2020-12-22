# julia
using ArgParse
using BioStructures
using Plots
# input parameters function
function parse_commandline()

    s = ArgParseSettings(description = "retrieve contact map from all the aminoacids of a chain(Cβ-Cβ bonds) by importing a pdb file, selecting a chain and the distance cuttof")
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
         "--dist"
            help = "distance in Angstrem to choose as cutoff for contact"
            arg_type = Float64
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
    cm = ContactMap(collectatoms(s[parsed_args["model"]][parsed_args["chain"]], cbetaselector), parsed_args["dist"])
    plot(cm)
    png(parsed_args["out"])
end

main()
