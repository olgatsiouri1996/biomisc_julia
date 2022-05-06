# julia
using ArgParse
using BioStructures
# input parameters function
function parse_commandline()

    s = ArgParseSettings(description = "input a pdb name from  PDB or a pdb file of the current directory and split each chain into a seperate pdb file")
    @add_arg_table s begin
        "--id"
            help = "input pdb ids"
            required = true
        "--dir"
            help = "directory of output pdb files"
            default="."
            required = false
        "--mode"
            help = "select either to inport a pdb file from the directory or to download from PDB. default is to download from PDB"
            arg_type = Int
            default = 1
            required = false
    end
    return parse_args(s)
end

function main()
    parsed_args = parse_commandline()
    println(parsed_args)
# main
# Choose program
    if parsed_args["mode"]==1
        downloadpdb(parsed_args["id"]) do fp
        s = read(fp, PDB)
    end 
    else
        s = read(join([parsed_args["id"],".pdb"],""), PDB)
    end
# select the model
    mod = s[1]
# change directory
    cd(parsed_args["dir"])
# iterate for each chain
    for ch in mod
        subpdb = mod[chainid(ch)]
        writepdb(String(join([parsed_args["id"],chainid(ch), ".pdb"], "_","")), subpdb)
    end
end

main()