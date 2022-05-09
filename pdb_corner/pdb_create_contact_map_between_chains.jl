# julia
using ArgParse
using BioStructures
using Plots
# input parameters function
function parse_commandline()

    s = ArgParseSettings(description = "retrieve contact map from all the aminoacids between 2 chains(Cβ-Cβ bonds) by importing a pdb file, selecting the chains distance cutoff value")
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
        "--dist"
            help = "distance in Angstrem to choose as cutoff for contact"
            arg_type = Float64    
        "--pdf"
            help = "output pdf file"   
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
    cm = ContactMap(cbetas_A, cbetas_B, parsed_args["dist"])
    plot(cm)
    savefig(parsed_args["pdf"])
end

main()
