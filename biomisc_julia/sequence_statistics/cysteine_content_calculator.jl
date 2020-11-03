# julia
using FASTX
using BioSequences
# create function for gc content calculation
function cys_content(seq)
    comp = composition(seq)
    return round(comp[AA_C] * 100 / length(seq), digits = 2)
end
# main
print("calculate the %cysteine content of a multi or single fasta file and outputs in a tabular format\nusage: julia cysteine_content_calculator.jl input_fasta output_txt")
reader = open(FASTA.Reader,ARGS[1])
open(ARGS[2],"a") do io
   for record in reader
    println(io,FASTA.identifier(record),"\t",cys_content(FASTA.sequence(record)))
    end
end
close(reader)