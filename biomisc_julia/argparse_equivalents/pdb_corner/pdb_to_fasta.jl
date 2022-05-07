# julia
using ArgParse
using BioStructures
using FASTX
# input parameters function
function parse_commandline()

    s = ArgParseSettings(description = "read a pdb file from the current directory and convert it to fasta")
    @add_arg_table s begin
        "--pdb"
            help = "input pdb file name of a pdb file from the same directory"
            required = true
        "--model"
            help = "model to make the fasta file for. Type 1 if you have only 1 model"
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
    s = read(join([parsed_args["pdb"],".pdb"], ""), PDB)
    seq = String(LongAminoAcidSeq(s[parsed_args["model"]], standardselector, gaps=false))
    id = String(parsed_args["pdb"])
    rec = FASTA.Record(id,seq)
    open(FASTA.Writer,join([id,".fasta"],""), width=60) do w
        write(w,rec)
    end
end

main()