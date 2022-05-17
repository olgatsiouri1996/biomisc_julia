# julia
using ArgParse
using FASTX
using DelimitedFiles
# input parameters function
function parse_commandline()

    s = ArgParseSettings(description = "trim a multi-fasta file with proteins using a tab seperated txt file with protein id, start and end locations on each row respectively")
    @add_arg_table s begin
        "--in"
            help = "input single or multi-fasta file"
            required = true
        "--fai"
            help = "input .fai index file(created using samtools faidx)"
            required = true
        "--txt"
            help = "input 1-column txt file with ids"
            required = true
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
    # import txt file
    coords = readdlm(parsed_args["txt"], '\t', String, '\n',quotes=false)
    # select ids start and end positions in vectors
    ids = coords[:,1]
    start = coords[:,2]
    stop = coords[:,3]
    # import multi-fasta
    reader = open(FASTA.Reader, parsed_args["in"], index= parsed_args["fai"])
    open(FASTA.Writer,parsed_args["out"], width=60, append=true) do w
        for (id, st, sp) in zip(ids, start, stop)
            record = reader[String(id)]
            # remove characters from the begining and end of the sequence
            id = String(join([FASTA.identifier(record),":",parse(Int,st),"-",parse(Int,sp)], ""))
            seq = SubString(String(FASTA.sequence(record)),parse(Int,st),parse(Int,sp))
            rec = FASTA.Record(id, FASTA.description(record),seq)
            write(w,rec)
        end
    end
    close(reader)
end

main()
