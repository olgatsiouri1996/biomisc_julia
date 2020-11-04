# julia
using FASTX
using BioSequences
# create function for gc content calculation
function cys_content(seq)
    comp = composition(seq)
    return round(comp[AA_C] * 100 / length(seq), digits = 2)
end
# main
print("calculate the %cysteine content of a multi or single fasta file and output the header in a tabular format with a user specified percentage threshold\nusage: julia select_header_by_cys.jl input_fasta min_cyc max_cys output_txt")
reader = open(FASTA.Reader,ARGS[1])
open(ARGS[4],"a") do io
   for record in reader
        if parse(Int, ARGS[2]) < cys_content(FASTA.sequence(record)) < parse(Int, ARGS[3])
            println(io,FASTA.identifier(record),"\t",FASTA.description(record))
        end
    end
    close(reader)
end
