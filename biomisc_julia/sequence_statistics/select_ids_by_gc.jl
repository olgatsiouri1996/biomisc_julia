# julia
using FASTX
using BioSequences
# create function for gc content calculation
function gc_content(seq)
    comp = composition(seq)
    gc = comp[DNA_C] + comp[DNA_G] + comp[DNA_S]
    return round(gc * 100 / (comp[DNA_C] + comp[DNA_G] + comp[DNA_S] + comp[DNA_W] + comp[DNA_T] + comp[DNA_A]), digits = 2)
end
# main
print("calculate the %GC content of a multi or single fasta file and output the ids by selecting max and min %GC thresholds\nusage: julia select_header_by_gc.jl input_fasta min_gc max_gc output_txt")
reader = open(FASTA.Reader,ARGS[1])
open(ARGS[4],"a") do io
   for record in reader
        if parse(Int, ARGS[2]) < gc_content(FASTA.sequence(record)) < parse(Int, ARGS[3])
            println(io,FASTA.identifier(record))
        end
    end
    close(reader)
end