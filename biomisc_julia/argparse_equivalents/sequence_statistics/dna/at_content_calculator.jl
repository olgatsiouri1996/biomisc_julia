# julia
using ArgParse
using FASTX
using BioSequences
# input parameters function
function parse_commandline()

    s = ArgParseSettings(description = "calculate %AT content from fasta and multifasta and output the ids and %AT content using user specified thresholds")
    @add_arg_table s begin
        "--in"
            help = "input fasta file"
        "--min"
            help = "min at% content"
        "--max"
            help = "max at% content"
        "--out"
            help = "output txt file"
    end
    return parse_args(s)
end

function main()
    parsed_args = parse_commandline()
    println(parsed_args)
# create function for at content calculation
    function at_content(seq)
        comp = composition(seq)
        at = comp[DNA_A] + comp[DNA_T] + comp[DNA_W]
        return round(at * 100 / (comp[DNA_C] + comp[DNA_G] + comp[DNA_S] + comp[DNA_W] + comp[DNA_T] + comp[DNA_A]), digits = 2)
    end
    # main
    eader = open(FASTA.Reader, parsed_args["in"])
    open(parsed_args["out"],"a") do io
    for record in reader
        if parse(Int, parsed_args["min"]) < at_content(FASTA.sequence(record)) < parse(Int, parsed_args["max"])
            println(io,FASTA.identifier(record),"\t",at_content(FASTA.sequence(record)))
        end
    end
end    
    close(reader)
end

main()
