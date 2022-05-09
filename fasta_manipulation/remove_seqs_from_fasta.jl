# julia
using ArgParse
using FASTX
using DelimitedFiles
# input parameters function
function parse_commandline()

    s = ArgParseSettings(description = "remove fasta records from a multi-fasta file by using a txt file with fasta identifiers")
    @add_arg_table s begin
        "--in"
            help = "input multi-fasta file"
            required = true
        "--txt"
            help = "input 1-column txt file with ids"
            required = true
        "--out"
            help = "output multi-fasta file"
            required = false
        "--type"
            help = "type of fasta files to output 1. multi-fasta 2. single-fasta"
            arg_type = Int
            default = 1
            required = false
        "--dir"
            help = "directory to save the single-fasta files(relative or absolute path)"
            default = "."
            required = false
    end
    return parse_args(s)
end

function main()
    parsed_args = parse_commandline()
    println(parsed_args)
    # main
    # import txt file
    ids = readdlm(parsed_args["txt"], '\t', String, '\n',quotes=false)
    # import multi-fasta
    reader = open(FASTA.Reader, parsed_args["in"])
    # choose output type
    if parsed_args["type"]==1
        for record in reader
            if  !(FASTA.identifier(record) in ids)
                open(FASTA.Writer,parsed_args["out"], width=60, append=true) do w
                    write(w,record)
                end
            end
        end
        close(reader)

    else
        # select directory to write single-fasta files
        cd(parsed_args["dir"])
        # split each record to a seperate fasta file
        for record in reader
            if !(FASTA.identifier(record) in ids)
                open(FASTA.Writer,join([FASTA.identifier(record),".fasta"],""), width=60) do w
                    write(w,record)
                end
            end
        end
        close(reader)
    end

end

main()
