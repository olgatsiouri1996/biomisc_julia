# julia
using ArgParse
using BioStructures
using FASTX
# input parameters function
function parse_commandline()

    s = ArgParseSettings(description = "read a pdb file from PDB and convert it to fasta without the need to download it choosing the model and chain")
    @add_arg_table s begin
        "--pdb"
            help = "input pdb ids"
            required = true
        "--model"
            help = "model to make the fasta file for. Type 1 if you have only 1 model. Default 1"
            arg_type = Int
            default = 1
            required = false
        "--chain"
            help = "chain in model to make the fasta file for. Default A"
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
    downloadpdb(parsed_args["pdb"]) do fp
        s = read(fp, PDB)
        id = String(join([parsed_args["pdb"],parsed_args["chain"]], "_"))
        seq = String(LongAminoAcidSeq(s[parsed_args["model"]][parsed_args["chain"]], standardselector, gaps=false))
        rec = FASTA.Record(id,seq)
        open(FASTA.Writer,join([id,".fasta"],""), width=60) do w
            write(w,rec)
        end
    end
end

main()
