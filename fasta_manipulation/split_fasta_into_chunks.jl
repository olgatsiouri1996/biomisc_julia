# julia
using ArgParse
using FASTX
# input parameters function
function parse_commandline()

    s = ArgParseSettings(description = "split fasta sequences by window and step")
    @add_arg_table s begin
        "--in"
            help = "input single or multi-fasta file"
            required = true
        "--out"
            help = "output multi-fasta file"
            required = false
        "--win"
            help = "window to slice a sequence"
            arg_type = Int
            required = true
        "--step"
            help = "step to slice a sequence"
            arg_type = Int
            required = true
        "--type"
            help = "type of fasta files to output 1. multi-fasta 2. single-fasta"
            arg_type = Int
            default = 1
            required = false

    end
    return parse_args(s)
end

function main()
    parsed_args = parse_commandline()
    println(parsed_args)
    # main
    reader = open(FASTA.Reader, parsed_args["in"])
    # choose output type
    if parsed_args["type"]==1
        open(FASTA.Writer,parsed_args["out"], width=60, append=true) do w
            # split by window and step
            for record in reader
                for i in range(1, step= parsed_args["step"], length(FASTA.sequence(record)) - parsed_args["win"] + 1)
                    seq = SubString(String(FASTA.sequence(record)), i,Int(i + parsed_args["win"]))
                    id = String(join([FASTA.identifier(record),i,Int(i + parsed_args["win"])],"_"))
                    rec = FASTA.Record(id,FASTA.description(record),seq)
                    write(w,rec)
                end
            end
            close(reader)
        end

            else
                # split by window and step
                for record in reader
                    for i in range(1, step= parsed_args["step"], length(FASTA.sequence(record)) - parsed_args["win"] + 1)
                        seq = SubString(String(FASTA.sequence(record)), i,Int(i + parsed_args["win"]))
                        id = String(join([FASTA.identifier(record),i,Int(i + parsed_args["win"])],"_"))
                        rec = FASTA.Record(id,FASTA.description(record),seq)
                        # split each record to a seperate fasta file
                        open(FASTA.Writer,join([id,".fasta"],""), width=60) do w
                            write(w,rec)
                        end
                    end
                end
                close(reader)
            end
end

main()
