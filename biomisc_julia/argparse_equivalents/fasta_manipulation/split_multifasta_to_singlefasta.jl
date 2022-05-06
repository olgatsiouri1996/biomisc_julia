# julia
using ArgParse
using FASTX
# input parameters function
function parse_commandline()

    s = ArgParseSettings(description = "split a multi-fasta file to many single-fasta files with 1 fasta record per file")
    @add_arg_table s begin
        "--in"
            help = "input multi-fasta file"
            required = true
        "--dir"
            help = "directory to save the single-fasta files"
            default = "."
            required = false
    end
    return parse_args(s)
end

function main()
    parsed_args = parse_commandline()
    println(parsed_args)
    # main
    reader = open(FASTA.Reader, parsed_args["in"])
    # select directory to write single-fasta files
    cd(parsed_args["dir"])
    # split each record to a seperate fasta file
    for record in reader
        open(FASTA.Writer,join([FASTA.identifier(record),".fasta"],""), width=60) do w
            write(w,record)
        end
    end
    close(reader)
end

main()
