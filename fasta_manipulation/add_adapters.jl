# julia
using ArgParse
using FASTX
# input parameters function
function parse_commandline()

    s = ArgParseSettings(description = "add a left or right adapter or both a in a single or multi-fasta file")
    @add_arg_table s begin
        "--in"
            help = "input single or multi-fasta file"
            required = true
        "--left"
            help = "adapter sequence to add to the left of a sequence"
            arg_type = String
            default = ""
            required = false
        "--right"
            help = "adapter sequence to add to the right of a sequence"
            arg_type = String
            default = ""
            required = false
        "--out"
            help = "output single or multi-fasta file"
            required = true
    end
    return parse_args(s)
end

function main()
    parsed_args = parse_commandline()
    println(parsed_args)
    # main
    reader = open(FASTA.Reader, parsed_args["in"])
    open(FASTA.Writer,parsed_args["out"], width=60, append=true) do w
        for record in reader
            # add adapters
            seq = join([parsed_args["left"],String(FASTA.sequence(record)),parsed_args["right"]],"","")
            rec = FASTA.Record(FASTA.identifier(record), FASTA.description(record),seq)
            write(w,rec)
        end
    end
    close(reader)
end

main()
