# julia
using ArgParse
using FASTX
# input parameters function
function parse_commandline()

    s = ArgParseSettings(description = "change the number of characters per line in a fasta file")
    @add_arg_table s begin
        "--in"
            help = "input single or multi-fasta file"
            required = true
        "--out"
            help = "output single or multi-fasta file"
            required = true
        "--width"
            help = " number of characters per line"
            arg_type = Int
            default = 60
            required = false
    end
    return parse_args(s)
end

function main()
    parsed_args = parse_commandline()
    println(parsed_args)
    # main
    reader = open(FASTA.Reader, parsed_args["in"])
    # change the number of characters per file for each fasta record and output to file
    for record in reader
        open(FASTA.Writer,parsed_args["out"], width=parsed_args["width"], append=true) do w
            write(w,record)
        end
    end
    close(reader)
end

main()
