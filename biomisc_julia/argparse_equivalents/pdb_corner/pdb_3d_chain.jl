# julia
using ArgParse
using BioStructures
using Bio3DView
using Blink
# input parameters function
function parse_commandline()

    s = ArgParseSettings(description = "prints the 3D structure from a pdb file, by specifying the model and chain")
    @add_arg_table s begin
        "--pdb"
            help = "input pdb file"
        "--model"
            help = "model to select in the pdb file(default=1)"
            arg_type = Int
            default = 1
            required = false
       	"--chain"
            help = "chain to select in the pdb file"    
    end
    return parse_args(s)
end
# main
function main()
    parsed_args = parse_commandline()
    println(parsed_args)
	struc = read(parsed_args["pdb"], PDB)
	viewstruc(struc[parsed_args["model"]][parsed_args["chain"]])	
end
 
main()	
