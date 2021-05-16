# julia
using ArgParse
using FASTX
# input parameters function
function parse_commandline()

    s = ArgParseSettings(description = "merge sequences on a multifasta file to a single fasta")
    @add_arg_table s begin
        "--in"
            help = "input fasta file"
        "--header"
            help = "output fasta header"
        "--out"
            help = "output fasta file"
    end
    return parse_args(s)
end

function main()
    parsed_args = parse_commandline()
    println(parsed_args)
    open(parsed_args["out"],"a") do io
        println(io,">",parsed_args["header"])
    end
    reader = open(FASTA.Reader, parsed_args["in"])
    open(parsed_args["out"],"a") do io
        for record in reader
            print(io,join(FASTA.sequence(record)))
        end
    end
    close(reader)
end

main()
