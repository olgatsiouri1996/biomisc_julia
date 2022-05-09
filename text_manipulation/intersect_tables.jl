# julia
using ArgParse
using Pandas
# input parameters function
function parse_commandline()

    s = ArgParseSettings(description = "merge 2 txt files by column and print the common lines")
    @add_arg_table s begin
        "--tab1"
            help = "input txt file"
        "--tab2"
            help = "txt file to match"
        "--header"
            help = "header name to select data for merge"
        "--out"
            help = "output txt file"
    end
    return parse_args(s)
end

function main()
    parsed_args = parse_commandline()
    println(parsed_args)
# main
    df1 = read_csv(parsed_args["tab1"], sep= "\t")
    df2 = read_csv(parsed_args["tab2"], sep= "\t")
    df_merge_col = merge(df1, df2, on = parsed_args["header"])
    to_csv(df_merge_col, parsed_args["out"], header = true, index = false, sep= "\t", doublequote= false, line_terminator= "\n")
end

main()
