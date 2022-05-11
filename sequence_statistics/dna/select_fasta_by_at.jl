# julia
using ArgParse
using FASTX
using BioSequences
# input parameters function
function parse_commandline()

    s = ArgParseSettings(description = "calculate the %AT content of a multi or single fasta file and outputs in a fasta format by selecting max and min %AT thresholds")
    @add_arg_table s begin
        "--in"
            help = "input fasta file"
        "--min"
            help = "min at% content"
        "--max"
            help = "max at% content"
        "--out"
            help = "output fasta file"
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
    reader = open(FASTA.Reader, parsed_args["in"])
    open(FASTA.Writer,parsed_args["out"], width=60, append=true) do w
        for record in reader
            if parse(Int, parsed_args["min"]) < at_content(FASTA.sequence(record)) < parse(Int, parsed_args["max"])
                write(w,record)  
            end
        end
    end    
    close(reader)
end

main()
