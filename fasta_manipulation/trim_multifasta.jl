# julia
using ArgParse
using FASTX
# input parameters function
function parse_commandline()

    s = ArgParseSettings(description = "trim a multi-fasta file by start and end location")
    @add_arg_table s begin
        "--in"
            help = "input single or multi-fasta file"
            required = true
        "--out"
            help = "output single or multi-fasta file"
            required = true
        "--start"
            help = "location from the start of the sequence to start writing to fasta"
            arg_type = Int
            default = 1
            required = false
        "--end"
            help = "number of characters to remove from the end of the sequence"
            arg_type = Int
            default = 0
            required = false
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
            # remove characters from the end of the sequence
            seqend = length(FASTA.sequence(record)) - parsed_args["end"]
            id = String(join([FASTA.identifier(record),":",parsed_args["start"],"-",seqend], ""))
            seq = SubString(String(FASTA.sequence(record)),parsed_args["start"],seqend)
            rec = FASTA.Record(id, FASTA.description(record),seq)
            write(w,rec)
        end
    end
    close(reader)
end

main()
