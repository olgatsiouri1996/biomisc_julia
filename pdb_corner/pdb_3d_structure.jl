# julia
using ArgParse
using BioStructures
using Bio3DView
using Blink
# input parameters function
function parse_commandline()

    s = ArgParseSettings(description = "prints the 3D structure of a pdb file, by selecting the model")
    @add_arg_table s begin
        "--pdb"
            help = "input pdb file's id"
            required = true
        "--model"
            help = "model to select in the pdb file"
            arg_type = Int
            default = 1
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
        viewstruc(struc[parsed_args["model"]])
    end
    else
    	struc = read(join([parsed_args["pdb"],".pdb"],""), PDB)
    	viewstruc(struc[parsed_args["model"]])
    end	
end

main()	 
