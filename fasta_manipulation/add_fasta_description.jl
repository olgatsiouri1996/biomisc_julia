# julia
using ArgParse
using FASTX
using DelimitedFiles
# input parameters function
function parse_commandline()

    s = ArgParseSettings()
    @add_arg_table s begin
        "--in"
            help = "input single or multi-fasta file"
            required = true
        "--txt"
            help = "1-column txt file with fasta descriptions"
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
    fasta_descriptions = readdlm(parsed_args["txt"], '\t', String, '\n',quotes=false, skipblanks=false)
    reader = open(FASTA.Reader, parsed_args["in"])
    open(FASTA.Writer,parsed_args["out"], width=60, append=true) do w
        for (record, fasta_description)  in zip(reader, fasta_descriptions)
            # add description
            rec = FASTA.Record(FASTA.identifier(record), String(fasta_description),FASTA.sequence(record))
            write(w,rec)
        end
    end
    close(reader)
end

main()
