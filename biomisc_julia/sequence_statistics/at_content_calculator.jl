# julia
using FASTX
using BioSequences
# create function for at content calculation
function at_content(seq)
    comp = composition(seq)
    at = comp[DNA_A] + comp[DNA_T] + comp[DNA_W]
    return round(at * 100 / (comp[DNA_C] + comp[DNA_G] + comp[DNA_S] + comp[DNA_W] + comp[DNA_T] + comp[DNA_A]), digits = 2)
end
# main
print("calculate the %AT content of a multi or single fasta file and outputs in a tabular format\nusage: julia aa_content_calculator.jl input_fasta output_txt")
reader = open(FASTA.Reader,ARGS[1])
open(ARGS[2],"a") do io
   for record in reader
    println(io,FASTA.identifier(record),"\t",at_content(FASTA.sequence(record)))
    end
end
close(reader)