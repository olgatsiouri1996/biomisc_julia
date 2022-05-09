# julia
using FASTX
using BioSequences
using ArgParse
# input parameters function
function parse_commandline()

    s = ArgParseSettings(description = "calculate %aa content from fasta and multifasta and output the ids and %aa content using user specified thresholds")
    @add_arg_table s begin
        "--in"
            help = "input fasta file"
        "--aa"
            help = "amino acid to search the content for"
        "--min"
            help = "min aa% content"
        "--max"
            help = "max aa% content"
        "--out"
            help = "output txt file"
    end
    return parse_args(s)
end

function main()
    parsed_args = parse_commandline()
    println(parsed_args)
    # create function for aa content calculation
    function aa_content(seq)
        comp = composition(seq)
        return round(comp[convert(AminoAcid, first(collect(parsed_args["aa"])))] * 100 / length(seq), digits = 2)
    end
    # main
    reader = open(FASTA.Reader, parsed_args["in"])
    open(parsed_args["out"],"a") do io
        for record in reader
            if parse(Int, parsed_args["min"]) < aa_content(FASTA.sequence(record)) < parse(Int, parsed_args["max"])
                println(io,FASTA.identifier(record),"\t",aa_content(FASTA.sequence(record)))
            end
        end
    end
    close(reader)
end

main()
