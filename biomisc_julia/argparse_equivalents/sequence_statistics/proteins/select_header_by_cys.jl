# julia
using FASTX
using BioSequences
using ArgParse
# input parameters function
function parse_commandline()

    s = ArgParseSettings(description = "calculate %cys content from fasta and multifasta and output the headers using user specified thresholds")
    @add_arg_table s begin
        "--in"
            help = "input fasta file"
        "--min"
            help = "min cys% content"
        "--max"
            help = "max cys% content"
        "--out"
            help = "output fasta file"
    end
    return parse_args(s)
end

function main()
    parsed_args = parse_commandline()
    println(parsed_args)
    # create function for cys content calculation
    function cys_content(seq)
        comp = composition(seq)
        return round(comp[AA_C] * 100 / length(seq), digits = 2)
    end
    # main
    reader = open(FASTA.Reader, parsed_args["in"])
    open(parsed_args["out"],"a") do io
    for record in reader
        if parse(Int, parsed_args["min"]) < cys_content(FASTA.sequence(record)) < parse(Int, parsed_args["max"])
            println(io,FASTA.identifier(record),"\t",FASTA.description(record))
        end
    end
end
    close(reader)
end

main()