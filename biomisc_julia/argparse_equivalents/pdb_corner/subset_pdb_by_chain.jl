# julia
using ArgParse
using BioStructures
# input parameters function
function parse_commandline()

    s = ArgParseSettings(description = "input a pdb ids from PDB and subset by selecting the model and chain")
    @add_arg_table s begin
        "--id"
            help = "input pdb ids"
            required = true
        "--model"
            help = "model to make the pdb file for. Type 1 if you have only 1 model. Default 1"
            arg_type = Int
            default = 1
            required = false
        "--chain"
            help = "chain in model to make the pdb file for. SDefault A"  
            required = false
            arg_type = String
            default = "A" 
    end
    return parse_args(s)
end

function main()
    parsed_args = parse_commandline()
    println(parsed_args)
# main
    downloadpdb(parsed_args["id"]) do fp
        s = read(fp, PDB)
        subpdb = s[parsed_args["model"]][parsed_args["chain"]]
        writepdb(String(join([parsed_args["id"],parsed_args["chain"], ".pdb"], "_","")), subpdb)
    end
end

main()