# julia
using ArgParse
using FASTX
# main
# input parameters function
function parse_commandline()

    s = ArgParseSettings(description = "collect sequences with user specified length")
    @add_arg_table s begin
        "--in"
            help = "input fasta file"
        "--min"
            help = "min length"
        "--max"
            help = "max length"
        "--out"
            help = "output fasta file"
    end
    return parse_args(s)
end

function main()
    parsed_args = parse_commandline()
    println(parsed_args)
    reader = open(FASTA.Reader, parsed_args["in"])
    open(FASTA.Writer,parsed_args["out"], width=60, append=true) do w
        for record in reader
            if parse(Int, parsed_args["min"]) < length(FASTA.sequence(record)) < parse(Int, parsed_args["max"])
                write(w,record)
            end
        end
    end    
    close(reader)
end

main()
