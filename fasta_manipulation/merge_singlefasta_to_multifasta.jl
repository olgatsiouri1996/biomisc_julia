# julia
using ArgParse
using FASTX
# input parameters function
function parse_commandline()

    s = ArgParseSettings(description = "merge many single-fasta files to a a multi-fasta file")
    @add_arg_table s begin
        "--dir"
            help = "directory to read the single-fasta files(relative or absolute path)"
            default = "."
            required = false
        "--out"
            help = "output multi-fasta file"
            required = true
    end
    return parse_args(s)
end

function main()
    parsed_args = parse_commandline()
    println(parsed_args)
    # main
    # read single-fasta files from directory
    open(FASTA.Writer,parsed_args["out"], width=60, append=true) do w
        for f in filter(x -> endswith(x, "fasta"), readdir(parsed_args["dir"], join=true))
            reader = open(FASTA.Reader, f)
            # append each record to a multi-fasta file
            for record in reader
                write(w,record)
            end
            close(reader)
        end
    end
end

main()
