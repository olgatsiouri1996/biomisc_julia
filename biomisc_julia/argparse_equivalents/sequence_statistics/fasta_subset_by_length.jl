# julia
using ArgParse
using FASTX
# main
# input parameters function
function parse_commandline()

    s = ArgParseSettings(description = "collect proteins with user specified length")
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
    open(parsed_args["out"],"a") do io
        for record in reader
            if parse(Int, parsed_args["min"]) < length(FASTA.sequence(record)) < parse(Int, parsed_args["max"])
                println(io,record)
            end
        end
    end    
    close(reader)
end

main()
