# julia
using FASTX
using BioSequences
# create function for cys content calculation
function cys_content(seq)
    comp = composition(seq)
    return round(comp[AA_C] * 100 / length(seq), digits = 2)
end
# main
print("calculate the %cysteine content of a multi or single fasta file and output a fasta format file with a user specified percentage threshold\nusage: julia select_header_by_cys.jl input_fasta min_cyc max_cys output_fasta")
reader = open(FASTA.Reader,ARGS[1])
open(ARGS[4],"a") do io
   for record in reader
        if parse(Int, ARGS[2]) < cys_content(FASTA.sequence(record)) < parse(Int, ARGS[3])
            println(io, record)
        end
    end
    close(reader)
end
