# julia
using ArgParse
using FASTX
# input parameters function
function parse_commandline()

    s = ArgParseSettings(description = "merge many single-fasta files to a a multi-fasta file")
    @add_arg_table s begin
        "--dir"
            help = "change directory to read the single-fasta files(relative or absolute path)"
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
    # change directory
    cd(parsed_args["dir"])
    # read single-fasta files from directory
    for f in filter(x -> endswith(x, "fasta"), readdir())
        reader = open(FASTA.Reader, f)
        # split each record to a seperate fasta file
        for record in reader
            open(FASTA.Writer,parsed_args["out"], width=60, append=true) do w
                write(w,record)
            end
        end
        close(reader)
    end
end

main()
