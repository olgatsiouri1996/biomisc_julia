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
print("calculate the %AT content of a multi or single fasta file and outputs in a fasta format by selecting max and min %AT thresholds\nusage: julia select_header_by_at.jl input_fasta min_at max_at output_fasta")
reader = open(FASTA.Reader,ARGS[1])
open(ARGS[4],"a") do io
   for record in reader
        if parse(Int, ARGS[2]) < at_content(FASTA.sequence(record)) < parse(Int, ARGS[3])
            println(io, record)
        end
    end
    close(reader)
end