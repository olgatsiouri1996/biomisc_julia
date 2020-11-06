# julia
using FASTX
using BioSequences
print("calculate the length of a multi or single fasta file and outputs in a tabular format\nusage: julia fasta_length_calculator.jl input_fasta output_txt")
# main
reader = open(FASTA.Reader,ARGS[1])
open(ARGS[2],"a") do io
   for record in reader
      println(io,FASTA.identifier(record),"\t",length(FASTA.sequence(record)))
   end
end
close(reader)
