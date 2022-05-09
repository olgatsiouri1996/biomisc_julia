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
            required = true
        "--model"
            help = "model to select in the pdb file(default=1)"
            arg_type = Int
            default = 1
            required = false
       	"--chain"
            help = "chain to select in the pdb file"
            arg_type = String
            default = "A"
            required = false
        "--mode"
            help = "select either to inport a pdb file from the directory or to download from PDB. default is to download from PDB"
            arg_type = Int
            default = 1
            required = false    
    end
    return parse_args(s)
end
# main
function main()
    parsed_args = parse_commandline()
    println(parsed_args)
    # Choose program
    if parsed_args["mode"]==1
        downloadpdb(parsed_args["pdb"]) do fp
        struc = read(fp, PDB)
        viewstruc(struc[parsed_args["model"]][parsed_args["chain"]])
    end
    else
        struc = read(join([parsed_args["pdb"],".pdb"],""), PDB)
        viewstruc(struc[parsed_args["model"]][parsed_args["chain"]])
    end 
end
    
main()	
