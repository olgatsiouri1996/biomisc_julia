# julia
using ArgParse
using FASTX
using BioSequences
# input parameters function
function parse_commandline()

    s = ArgParseSettings(description = "calculate the %GC content of a multi or single fasta file and output in a tabular format with ids and descriptions by selecting max and min %GC thresholds")
    @add_arg_table s begin
        "--in"
            help = "input fasta file"
        "--min"
            help = "min gc% content"
        "--max"
            help = "max gc% content"
        "--out"
            help = "output txt file"
    end
    return parse_args(s)
end

function main()
    parsed_args = parse_commandline()
    println(parsed_args)
# create function for gc content calculation
    function gc_content(seq)
        comp = composition(seq)
        gc = comp[DNA_C] + comp[DNA_G] + comp[DNA_S]
        return round(gc * 100 / (comp[DNA_C] + comp[DNA_G] + comp[DNA_S] + comp[DNA_W] + comp[DNA_T] + comp[DNA_A]), digits = 2)
    end
    # main
    reader = open(FASTA.Reader, parsed_args["in"])
    open(parsed_args["out"],"a") do io
        for record in reader
            if parse(Int, parsed_args["min"]) < gc_content(FASTA.sequence(record)) < parse(Int, parsed_args["max"])
                println(io,FASTA.identifier(record),"\t",FASTA.description(record))
            end
        end
    end        
    close(reader)
end

main()
